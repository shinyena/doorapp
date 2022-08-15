/*    파일명: loginpage.dart
      파일설명: 사용자 로그인 화면
      개발자: 신예나
      개발일: 2020.12. */

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart'; // flutter toast 모듈
import 'package:http/http.dart' as http; // http 모듈
import 'dart:convert'; // JSON 파싱

var baseUrl = dotenv.env['BASE_URL'];
// ------------------------- 서버에 로그인 정보를 전송하는 함수 -------------------------
Future<http.Response> createLogin(String uid, String pass, context) async {
  final http.Response res = await http.post(Uri.parse('$baseUrl/login'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode({
      'uid': uid,
      'pass': pass,
    }), //http post 요청
  );

  if (res.statusCode == 200) { // http post에서 받은 응답코드가 200이면
    showToast('로그인에 성공하였습니다.');
    Navigator.pushNamed(context, '/main');
  } else if (res.statusCode == 461) { // http post에서 받은 응답코드가 461이면
    showToast('존재하지 않는 아이디입니다.');
  } else if (res.statusCode == 462) { // http post에서 받은 응답코드가 462이면
    showToast('탈퇴한 회원입니다.');
  } else if (res.statusCode == 463) { // http post에서 받은 응답코드가 463이면
    showToast('패스워드가 일치하지 않습니다.');
  } else {
    showToast('알 수 없는 오류가 발생하였습니다.');
  }

  return jsonDecode(res.body);
}

// ------------------------- 로그인 화면 -------------------------
class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController uid = TextEditingController(); // Text field를 제어할 controller 정의
  final TextEditingController pass = TextEditingController(); // Text field를 제어할 controller 정의

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('로그인'),  // title 내용
        centerTitle: true,      // title을 가운데로 설정
      ),
      body: Center(
        child: SingleChildScrollView( // 스크롤을 가능하게 함
          child: Column(
            children: <Widget>[
              Center(
                child: Image(
                  image: AssetImage('assets/images/gachon.png'),  // image 삽입
                  width: 300.0,                           // image 크기
                ),
              ),
              Padding(
                padding: EdgeInsets.all(30.0), // padding 값 상하좌우 30.0
                child: Form(
                  child: Theme( // Form decoration
                    data: ThemeData(
                      inputDecorationTheme: InputDecorationTheme(
                        labelStyle: TextStyle(fontSize: 15.0), // Text field의 label text 폰트 크기
                      ),
                    ),
                    child: Column(
                      children: <Widget>[
                        TextField(
                          controller: uid,                                    // Text field의 data를 제어
                          decoration: InputDecoration(labelText: '아이디'),   // Text field의 label text 내용
                          keyboardType: TextInputType.emailAddress,           // Text field의 data의 형식
                        ),
                        TextField(
                          controller: pass,                                   // Text field의 data를 제어
                          decoration: InputDecoration(labelText: '패스워드'), // Text field의 label text 내용
                          keyboardType: TextInputType.text,                   // Text field의 data의 형식
                          obscureText: true,                                  // Text field의 data를 숨기기
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 15.0,
              ),
              ButtonTheme( // 로그인 버튼
                height: 45.0,                     // 버튼 높이
                minWidth: 350.0,                  // 버튼 너비
                buttonColor: Colors.grey[700],    // 버튼 배경색
                shape: RoundedRectangleBorder(    // 버튼 모양
                  borderRadius: BorderRadius.all(
                    Radius.circular(5.0),
                  ),
                ),
                child: ElevatedButton( // flutter raise button
                  child: Text(              // 버튼 내용
                    '로그인',             
                    style: TextStyle(
                      color: Colors.white,  // text 폰트 색상
                      fontSize: 15.0,       // text 폰트 크기
                    ),
                  ),
                  onPressed: () {
                    if (uid.text == '') { // text field uid의 값이 없으면
                      showToast('아이디를 입력하시오!');
                    } else if (pass.text == '') { // text field pass의 값이 없으면
                      showToast('비밀번호를 입력하시오!');
                    } else {
                      setState(() {
                        createLogin(uid.text, pass.text, context); // http post로 data 전송
                      });
                    }
                  },
                ),
              ),
              SizedBox(
                height: 10.0,
              ),
              ButtonTheme( // 회원가입 버튼
                height: 45.0, // 버튼 높이
                minWidth: 350.0, // 버튼 너비
                buttonColor: Colors.grey[800], // 버튼 배경색
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(4.0),),), // 버튼 모양
                child: ElevatedButton( // flutter raised button
                  child: Text(
                    '회원가입', // text 내용
                    style: TextStyle(
                      color: Colors.white, // text 폰트 색상
                      fontSize: 15.0,      // text 폰트 크기
                    ),
                  ),
                  onPressed: () { // button click 시에
                    Navigator.pushNamed(context, '/regUser'); // 회원가입 화면으로 이동
                  },
                ),
              ),
            ],
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
