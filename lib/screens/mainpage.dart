/*    파일명: mainpage.dart
      파일설명: 사용자가 제어 가능한 모든 도어락을 열람할 수 있는 메인 화면
      개발자: 신예나
      개발일: 2020.12. */
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'drawer.dart';          // myDrawer() 불러오기
import '../widgets/my_mainpage.dart';     // MyMainPage() 불러오기
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;        // http 모듈
import 'dart:convert';                          // JSON 파싱

var baseUrl = dotenv.env['BASE_URL'];
// ------------------------- 메인 화면 (도어락 열람 화면) -------------------------
class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  Future fetch() async {
    var res = await http.get(Uri.parse('$baseUrl/main/')); // http get 요청
    return json.decode(res.body);
  }

  late Color color;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('메인화면'), // title 내용
        centerTitle: true,      // title을 가운데로 설정
      ),
      endDrawer: myDrawer(context), // drawer.dart 의 myDrawer() 사용
      body: Padding(
        padding: const EdgeInsets.fromLTRB(50.0, 0.0, 50.0, 0.0), // padding 값
        child: Center(
          child: FutureBuilder(
            future: this.fetch(),
            builder: (context, AsyncSnapshot snap) {
              if (!snap.hasData) // http get에서 받아온 data가 없으면
                return CircularProgressIndicator();
              return ListView.builder(
                itemCount: snap.data.length, // http get으로 받아온 data 개수
                itemBuilder: (BuildContext context, int index) {
                  if (snap.data[index]['active'] == 1) { // http get으로 받아온 도어락 활성화 응답가 1 이면
                    if (snap.data[index]['usertype'] == 'main') { // http get으로 받아온 사용자 종류가 main 이면
                      color = Color(0XFF20517C); 
                    } else { // http get으로 받아온 사용자 종류가 sub 이면
                      color = Colors.green;
                    }
                  } else { // http get으로 받아온 도어락 활성화 응답가 0 이면
                    color = Colors.grey;
                  }
                  return MyMainPage(
                    name: snap.data[index]['name'].toString(),            // http get으로 도어락 이름 받아옴
                    serialno: snap.data[index]['serialno'].toString(),    // http get으로 도어락 시리얼 넘버 받아옴
                    color: color,
                    usertype: snap.data[index]['usertype'].toString(),    // http get으로 사용자 종류 받아옴
                    active: snap.data[index]['active'],                   // http get으로 도어락 활성화 응답 받아옴
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
