/*    파일명: controldoor.dart
      파일설명: 블루투스로 연결된 도어락을 제어하는 화면
      개발자: 신예나
      개발일: 2020.12. */

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:doorapp/screens/drawer.dart';            // myDrawer() 불러오기
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';  // flutter toast 모듈
import 'package:http/http.dart' as http;          // http 모듈
import 'dart:convert';                            // JSON 파싱
import 'package:flutter_blue/flutter_blue.dart';  // flutter bluetooth 모듈

var baseUrl = dotenv.env['BASE_URL'];
Future<http.Response> createLog(String serialno, String details) async {
  final http.Response res = await http.post(Uri.parse('$baseUrl/control'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode({'serialno': serialno, 'details': details}),
  ); //http post 요청

  return jsonDecode(res.body);
}

class ControlPage extends StatefulWidget {
  final String serialno;
  final String name;
  ControlPage({required this.serialno, required this.name}); // ControlPage는 반드시 serialno 값과 name 값을 받아와야 함

  final FlutterBlue flutterBlue = FlutterBlue.instance;
  final List<BluetoothDevice> devicesList = <BluetoothDevice>[]; // 연결 가능한 device 목록

  @override
  _ControlPageState createState() => _ControlPageState();
}

class _ControlPageState extends State<ControlPage> {
  String state = "unlock"; // 현재 도어락 잠금상태 

  late BluetoothDevice _connectedDevice; // 현재 연결된 device
  late List<BluetoothService> _services; // 현재 연결된 device의 service

  // ------------------------- 블루투스 기기를 devicelist에 추가하는 함수 -------------------------
  _addDeviceTolist(final BluetoothDevice device) { // devicelist에 device 추가
    if (!widget.devicesList.contains(device)) { // devicelist에 해당 device가 없다면
      setState(() {
        widget.devicesList.add(device); // devicelist에 device 추가
      });
    }
  }

  // ------------------------- 연결 가능한 기기를 scan 하는 함수 -------------------------
  @override
  void initState() {
    super.initState();
    widget.flutterBlue.connectedDevices
        .asStream()
        .listen((List<BluetoothDevice> devices) {
      for (BluetoothDevice device in devices) {
        _addDeviceTolist(device); // 연결된 device를 _addDeviceTolist()로 전송
      }
    });
    widget.flutterBlue.scanResults.listen((List<ScanResult> results) {
      for (ScanResult result in results) {
        _addDeviceTolist(result.device); // scan 결과를 _addDeviceTolist()로 전송
      }
    });
    widget.flutterBlue.startScan(); // ble scan을 시작한다
  }

  bleConnect(device) async { // 연결을 시도하는 ble device가 존재하면
    widget.flutterBlue.stopScan(); // ble scan을 멈춘다
    try {
      await device.connect(); // ble device와 연결
    } catch (e) {
      if (e.hashCode != 'already_connected') { // 이미 연결된 device일 경우
        throw e;
      }
    } finally {
      _services = await device.discoverServices(); // 연결된 device의 service 정의
    }
    setState(() {
      _connectedDevice = device; // 연결된 device 정의
    });
  }

  // ------------------------- 디바이스를 연결하는 함수 -------------------------
  _buildListViewOfDevices() {
    for (BluetoothDevice device in widget.devicesList) {
      if (device.name == widget.serialno) { // 연결된 디바이스 이름과 도어락 시리얼 넘버가 같으면
        bleConnect(device); // ble 통신 연결 요청
      } else {
        showToast('${widget.serialno}을 찾지 못했습니다. 블루투스 연결을 확인하세요');
      }
    }
  }

  // ------------------------- 디바이스 연결 후에 도어락 제어 화면을 출력하는 함수 -------------------------
  _buildConnectDeviceView() {
    for (BluetoothService service in _services) {
      for (BluetoothCharacteristic characteristic in service.characteristics) {
        if (characteristic.properties.write) { // ble write 요청이 존재하면
          return Container(
            child: Column(children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(50.0), // padding 값 상하좌우 50.0
                child: Text( 
                  '${widget.name} [${widget.serialno}]',
                  style: TextStyle(
                    fontSize: 30.0,               // text 폰트 크기
                    fontWeight: FontWeight.bold,  // text 폰트 굵기
                  ),
                ),
              ),
              SizedBox(
                height: 30.0,
              ),
              Padding(
                padding: const EdgeInsets.all(40.0), // padding 값 상하좌우 40.0
                child: Center(
                  child: TextButton( // 도어락 열림 및 잠금 버튼
                    child: Image(
                      image: AssetImage('assets/images/$state.png'),  // 이미지 삽입
                    ),
                    onPressed: () {
                      if (state == 'unlock') { // 현재 state가 열림이면
                        createLog(widget.serialno, 'lock'); // post로 data 전송
                        showToast('도어락이 열렸습니다.');
                        setState(() {
                          state = 'lock'; // 현재 state를 잠금으로 변경
                        });
                        characteristic.write(utf8.encode('1')); // ble write 요청 (data 1 전송)
                      } else if (state == 'lock') { // 현재 state가 잠금이면
                        createLog(widget.serialno, 'unlock'); // post로 data 전송
                        showToast('도어락이 잠겼습니다.');
                        setState(() {
                          state = 'unlock'; // 현재 state를 열림으로 변경
                        });
                        characteristic.write(utf8.encode('0')); // ble write 요청 (data 0 전송)
                      }
                    },
                  ),
                ),
              ),
            ]),
          );
        }
      }
    }
  }

 // ------------------------- 연결 유무에 따른 화면을 출력하는 함수 -------------------------
  Widget _buildView() {
    if (_connectedDevice != null) { // 연결된 device가 없으면
      return _buildConnectDeviceView(); // ble 연결 시도 또는 연결된 device가 없음을 알림
    }
    return _buildListViewOfDevices(); // 도어락 제어 화면 출력
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('도어락 제어'),  // title 내용
        centerTitle: true,          // title을 가운데로 설정
      ),
      endDrawer: myDrawer(context), // drawer.dart 의 myDrawer() 사용
      body: _buildView(),
  
    );
  }
}

// ------------------------- 사용자에게 알림 전송시 사용할 Flutter Toast를 구현하는 함수 -------------------------
void showToast(String message) {
  Fluttertoast.showToast(
    msg: message,
    backgroundColor: Colors.white,
    toastLength: Toast.LENGTH_SHORT,
    gravity: ToastGravity.BOTTOM,
  );
}
