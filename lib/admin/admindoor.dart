/*    파일명: admindoor.dart
      파일설명: 도어락의 활성화 여부를 관리하는 도어락 관리 화면
      개발자: 신예나
      개발일: 2020.12. */

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:doorapp/screens/drawer.dart';
import 'package:doorapp/widgets/my_admindoor.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http; // http 모듈
import 'dart:convert'; // JSON 파싱

var baseUrl = dotenv.env['BASE_URL'];

// ------------------------- 도어락 관리 화면 -------------------------
class AdminDoorPage extends StatefulWidget {
  @override
  _AdminDoorPageState createState() => _AdminDoorPageState();
}

class _AdminDoorPageState extends State<AdminDoorPage> {
  // ------------------------- 서버에 도어락 내역을 요청하는 함수 -------------------------
  Future fetch() async {
    var res = await http.get(Uri.parse('$baseUrl/admindoor')); //http get 요청
    return json.decode(res.body);
  }

  late String _name;
  late String _serialno;
  late bool _checked;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('도어락 관리'), // title 내용
        centerTitle: true, // title을 가운데로 설정
      ),
      endDrawer: myDrawer(context), // drawer.dart 의 myDrawer() 사용
      body: Padding(
        padding: const EdgeInsets.all(30.0), // padding 값 상하좌우 30.0
        child: FutureBuilder(
            future: this.fetch(),
            builder: (context, AsyncSnapshot snap) {
              if (!snap.hasData) {
                // http get에서 받아온 data가 없으면
                return const CircularProgressIndicator();
              }
              else {
                return ListView.builder(
                    itemCount: snap.data.length, // http get으로 받아온 data 개수
                    itemBuilder: (BuildContext context, int index) {
                      if (snap.data[index]['active'] == 1) {
                        // http get으로 받아온 도어락 활성화 응답가 1이면
                        _checked = true;
                      }
                      if (snap.data[index]['active'] == 0) {
                        // http get으로 받아온 도어락 활성화 응답가 0이면
                        _checked = false;
                      }
                      _name = snap.data[index]['name']
                          .toString(); // http get으로 도어락 이름 받아옴
                      _serialno = snap.data[index]['serialno']
                          .toString(); // http get으로 도어락 시리얼 넘버 받아옴
                      return MyAdminDoor(
                        name: _name,
                        serialno: _serialno,
                        checked: _checked,
                      );
                    });
              }
            }),
      ),
    );
  }
}
