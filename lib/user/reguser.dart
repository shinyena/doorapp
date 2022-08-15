/*    파일명: reguser.dart
      파일설명: 사용자 회원 가입 화면
      개발자: 신예나
      개발일: 2020.12. */

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';  // flutter toast 모듈
import 'package:http/http.dart' as http;          // http 모듈
import 'dart:convert';                            // JSON 파싱

var baseUrl = dotenv.env['BASE_URL'];
// ------------------------- 서버에 사용자 등록을 요청 -------------------------
Future<http.Response> createUser(
    String uid, String pass, String name, String phone, context) async {
  final http.Response res = await http.post(Uri.parse('$baseUrl/reguser'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode({
      'uid': uid,
      'pass': pass,
      'name': name,
      'phone': phone,
    }), //http post 요청
  );

  if (res.statusCode == 200) { // http post에서 받은 응답코드가 200이면
    showToast('회원가입을 완료하였습니다.');
    Navigator.pushNamed(context, '/login'); // 로그인 화면으로 이동
  } else if (res.statusCode == 460) { // http post에서 받은 응답코드가 460이면
    showToast('이미 존재하는 아이디입니다.');
  } else {
    showToast('알 수 없는 오류가 발생하였습니다.');
  }

  return jsonDecode(res.body);
}

// ------------------------- 사용자 회원 가입 화면 -------------------------
class RegUserPage extends StatefulWidget {
  @override
  _RegUserPageState createState() => _RegUserPageState();
}

class _RegUserPageState extends State<RegUserPage> {
  final TextEditingController uid = TextEditingController();    // Text field를 제어할 controller 정의
  final TextEditingController pass1 = TextEditingController();  // Text field를 제어할 controller 정의
  final TextEditingController pass2 = TextEditingController();  // Text field를 제어할 controller 정의
  final TextEditingController name = TextEditingController();   // Text field를 제어할 controller 정의
  final TextEditingController phone = TextEditingController();  // Text field를 제어할 controller 정의

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('회원가입'), // title 내용
        centerTitle: true,      // title을 가운데로 설정
      ),
      body: Builder(builder: (context) {
        return SingleChildScrollView( // 스크롤을 가능하게 함
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(30.0), // padding 값 상하좌우 30.0
              child: Column(
                children: <Widget>[
                  Form(
                    child: Theme( // Form decoration
                      data: ThemeData(
                        inputDecorationTheme: InputDecorationTheme(
                          labelStyle: TextStyle(
                            fontSize: 15.0, // Text field의 label text 폰트 크기
                          ),
                        ),
                      ),
                      child: Column(
                        children: <Widget>[
                          TextField(
                            maxLength: 20,                            // 최대 글자 수
                            controller: uid,                          // Text field의 data를 제어
                            decoration: InputDecoration(
                              labelText: '아이디',                     // Text field의 label text 내용
                              hintText: '아이디를 입력하시오.',         // Text field의 hint text 내용
                            ),
                            keyboardType: TextInputType.emailAddress, // Text field의 data의 형식
                          ),
                          SizedBox(
                            height: 5.0,
                          ),
                          TextField(
                            maxLength: 20,                        // 최대 글자 수
                            controller: pass1,                    // Text field의 data를 제어
                            decoration: InputDecoration(
                              labelText: '패스워드',              // Text field의 label text 내용
                              hintText: '패스워드를 입력하시오.',  // Text field의 hint text 내용
                            ),
                            keyboardType: TextInputType.text,     // Text field의 data의 형식
                            obscureText: true,                    // Text field의 data를 숨기기
                          ),
                          SizedBox(
                            height: 5.0,
                          ),
                          TextField(
                            maxLength: 20,                                // 최대 글자 수
                            controller: pass2,                            // Text field의 data를 제어
                            decoration: InputDecoration(
                              labelText: '패스워드 확인',                  // Text field의 label text 내용
                              hintText: '패스워드를 한 번 더 입력하시오.',  // Text field의 hint text 내용
                            ),
                            keyboardType: TextInputType.text,             // Text field의 data의 형식
                            obscureText: true,                            // Text field의 data를 숨기기
                          ),
                          SizedBox(
                            height: 5.0,
                          ),
                          TextField(
                            maxLength: 20,                      // 최대 글자 수
                            controller: name,                   // Text field의 data를 제어
                            decoration: InputDecoration(
                              labelText: '이름',                // Text field의 label text 내용
                              hintText: '이름을 입력하시오.',    // Text field의 hint text 내용
                            ),
                            keyboardType: TextInputType.text,   // Text field의 data의 형식
                          ),
                          SizedBox(
                            height: 5.0,
                          ),
                          TextField(
                            maxLength: 11,                            // 최대 글자 수
                            controller: phone,                        // Text field의 data를 제어
                            decoration: InputDecoration(
                              labelText: '휴대폰 번호',                // Text field의 label text 내용
                              hintText: '휴대폰 번호를 입력하시오.',    // Text field의 hint text 내용
                            ),
                            keyboardType: TextInputType.phone,        // Text field의 data의 형식
                          ),
                          SizedBox(
                            height: 60.0,
                          ),
                        ],
                      ),
                    ),
                  ),
                  ButtonTheme( // 가입하기 버튼
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
                        '가입하기',             // 버튼 내용
                        style: TextStyle(
                          color: Colors.white,  // text 폰트 색상
                          fontSize: 15.0,       // text 폰트 크기
                        ),
                      ),
                      onPressed: () { // raised button click 시에
                        if (uid.text == '') { // text field uid의 값이 없으면
                          showToast('아이디를 입력하시오.');
                        } else if (pass1.text == '') { // text field pass1의 값이 없으면
                          showToast('패스워드를 입력하시오.');
                        } else if (pass2.text == '') { // text field pass2의 값이 없으면
                          showToast('패스워드를 한번더 입력하시오.');
                        } else if (name.text == '') { // text field name의 값이 없으면
                          showToast('이름을 입력하시오.');
                        } else if (phone.text == '') { // text field phone의 값이 없으면
                          showToast('휴대폰 번호를 입력하시오.');
                        } else {
                          if (pass1.text == pass2.text) { // text field pass1의 값과 text field pass2의 값이 같다면
                            setState(() {
                              createUser(uid.text, pass1.text, name.text, phone.text, context); // http post로 data 전송
                            });
                          } else {
                            showToast('패스워드가 일치하지 않습니다.'); // showToast() 호출
                          }
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }),
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
