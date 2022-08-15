/*    파일명: blelist.dart
      파일설명: 스마트폰과 연결가능한 블루투스 기기 목록을 호출하는 화면
      개발자: 신예나
      개발일: 2020.12. */

import 'package:doorapp/screens/drawer.dart';            // myDrawer() 불러오기
import 'package:doorapp/door/regdoor.dart';           // RegDoorPage() 불러오기
import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';  // flutter bluetooth 모듈
import 'package:fluttertoast/fluttertoast.dart';  // flutter toast 모듈


class BleListPage extends StatefulWidget {
  final FlutterBlue flutterBlue = FlutterBlue.instance;
  final List<BluetoothDevice> devicesList = <BluetoothDevice>[]; // 연결 가능한 device 목록

  @override
  _BleListPageState createState() => _BleListPageState();
}

// ------------------------- 블루투스 기기를 devicelist에 추가하는 함수 -------------------------
class _BleListPageState extends State<BleListPage> {
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

  // ------------------------- 블루투스 기기 목록 화면 -------------------------
  ListView _buildListViewOfDevices() {
    List<Container> containers = <Container>[];
    for (BluetoothDevice device in widget.devicesList) { // devicelist에 존재하는 device
      containers.add(
        Container(
          height: 50, // container 높이
          child: Row(
            children: <Widget>[
              Expanded(
                child: Column(
                  children: <Widget>[ 
                    Text(device.name == '' ? '(unknown device)' : device.name), // device name
                    Text(device.id.toString()),                                 // device id
                  ],
                ),
              ),
              TextButton( // 연결 버튼
              style: TextButton.styleFrom(
                primary: Colors.blue), // 버튼 배경색
                child: Text(        // 버튼 내용
                  'Connect',
                  style: TextStyle(color: Colors.white), // text 폰트 색상
                ),
                onPressed: () {
                  Navigator.push(context,MaterialPageRoute(builder: (_) => RegDoorPage(serialno: device.name),),);
                  // 도어락 등록 화면으로 이동
                },
              ),
            ],
          ),
        ),
      );
    }
    return ListView(
      padding: const EdgeInsets.all(8), // padding 값 상하좌우 8.0
      children: <Widget>[
        ...containers,
      ],
    );
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text('도어락 등록'), // title 내용
          centerTitle: true,          // title을 가운데로 설정
        ),
        endDrawer: myDrawer(context), // drawer.dart 의 myDrawer() 사용
        body: _buildListViewOfDevices(),
      );
}

// ------------------------- 사용자에게 알림 전송시 사용할 Flutter Toast를 구현하는 함수 -------------------------
void showToast(String message) {
  Fluttertoast.showToast( // flutter toast
    msg: message,                       // toast 내용
    backgroundColor: Colors.white,      // toast 배경색
    toastLength: Toast.LENGTH_SHORT,    // toast 실행시간
    gravity: ToastGravity.BOTTOM,       // toast 위치
  );
}

