/*    파일명: regdoor.dart
      파일설명: 도어락의 기기를 등록하는 화면
      개발자: 신예나
      개발일: 2020.12. */

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:doorapp/screens/drawer.dart';            // myDrawer() 불러오기
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';  // flutter toast 모듈
import 'package:http/http.dart' as http;          // http 모듈
import 'dart:convert';                            // JSON 파싱

var baseUrl = dotenv.env['BASE_URL'];
// ------------------------- 서버에 도어락 등록을 요청 -------------------------
Future<http.Response> createDoorlock(
    String serialno, String name, String uid, context) async {
  final http.Response res = await http.post(Uri.parse('$baseUrl/regdoor'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      'serialno': serialno,
      'name': name,
      'uid': uid,
    }), //http post 요청
  );

  if (res.statusCode == 200) { // http post에서 받은 응답코드가 200이면
    showToast('도어락이 등록되었습니다.');      
    Navigator.pushNamed(context, '/main'); // 메인화면으로 이동
  } else if (res.statusCode == 461) { // http post에서 받은 응답코드가 461이면
    showToast('존재하지 않는 아이디입니다.');  
  } else if (res.statusCode == 466) { // http post에서 받은 응답코드가 466이면
    showToast('존재하는 도어락입니다.');       
  } else {
    showToast('알 수 없는 오류가 발생하였습니다.');
  }

  return jsonDecode(res.body);
}

// ------------------------- 도어락 등록 화면 -------------------------
class RegDoorPage extends StatefulWidget {
  final String serialno;
  RegDoorPage({required this.serialno}); // RegDoorPage는 반드시 serialno 값을 받아와야 함

  @override
  _RegDoorPageState createState() => _RegDoorPageState();
}

class _RegDoorPageState extends State<RegDoorPage> {
  final TextEditingController name = TextEditingController(); // Text field를 제어할 controller 정의
  final TextEditingController uid = TextEditingController();  // Text field를 제어할 controller 정의

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('도어락 등록'),  // title 내용
        centerTitle: true,          // title을 가운데로 설정
      ),
      endDrawer: myDrawer(context), // drawer.dart 의 myDrawer() 사용
      body: SingleChildScrollView(  // 스크롤을 가능하게 함
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(30.0),  // padding 값 상하좌우 30.0
            child: Column(
              children: <Widget>[
                Form(
                  child: Theme( // Form decoration
                    data: ThemeData(
                      inputDecorationTheme: InputDecorationTheme( 
                        labelStyle: TextStyle(fontSize: 15.0), // Text field의 label text 폰트 크기
                      ),
                    ),
                    child: Column(
                      children: <Widget>[
                        TextField(
                          readOnly: true,                    // 수정할 수 없음
                          maxLength: 6,                      // 최대 글자 수
                          controller: TextEditingController( // Text field의 data를 제어
                            text: '${widget.serialno}'
                          ),  
                          decoration: InputDecoration(       // Text field의 label text 내용
                            labelText: '시리얼번호',          
                          ),
                        ),
                        SizedBox(
                          height: 20.0,
                        ),
                        TextField(
                          maxLength: 20,                    // 최대 글자 수
                          controller: name,                 // Text field의 data를 제어
                          decoration: InputDecoration(      // Text field의 label text 내용
                            labelText: '도어락 이름',
                          ),
                          keyboardType: TextInputType.text, // Text field의 data의 형식
                        ),
                        SizedBox(
                          height: 20.0,
                        ),
                        TextField(
                          maxLength: 20,                              // 최대 글자 수
                          controller: uid,                            // Text field의 data를 제어
                          decoration: InputDecoration(                // Text field의 label text 내용
                            labelText: '도어락 주사용자',
                          ),
                          keyboardType: TextInputType.emailAddress,   // Text field의 data의 형식
                        ),
                        SizedBox(
                          height: 70.0,
                        ),
                      ],
                    ),
                  ),
                ),
                ButtonTheme( // 등록하기 버튼
                  height: 50.0,                   // 버튼 높이
                  minWidth: 350.0,                // 버튼 너비
                  buttonColor: Colors.grey[600],  // 버튼 배경색
                  shape: RoundedRectangleBorder(  // 버튼 모양
                    borderRadius: BorderRadius.all(
                      Radius.circular(5.0),
                    ),
                  ),
                  child: ElevatedButton( // flutter raised button
                    child: Text(
                      '등록하기',             // 버튼 내용
                      style: TextStyle(
                        color: Colors.white,  // text 폰트 색상
                        fontSize: 15.0,       // text 폰트 크기
                      ),
                    ),
                    onPressed: () {
                      if (name.text == '') { // text field name의 값이 없으면
                        showToast('도어락 이름을 입력하시오.');
                      } else if (uid.text == '') { // text field uid의 값이 없으면
                        showToast('도어락 주사용자를 입력하시오.');
                      } else {
                        setState(() {
                          createDoorlock(widget.serialno, name.text, uid.text, context); // http post로 data 전송
                        });
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
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
