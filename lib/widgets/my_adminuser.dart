/*    파일명: my_adminuser.dart
      파일설명: 사용자 관리 화면에서 사용할 MyAdminUser 위젯을 정의함
      개발자: 신예나
      개발일: 2020.12. */

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:doorapp/admin/adminuser.dart';         // AdminUserPage() 불러오기
import 'package:flutter/material.dart';          
import 'package:http/http.dart' as http;          // http 모듈
import 'dart:convert';                            // JSON 파싱
import 'package:fluttertoast/fluttertoast.dart';  // flutter toast 모듈

var baseUrl = dotenv.env['BASE_URL'];
// ------------------------- 서버에 도어락 사용자 내역을 요청하는 함수 -------------------------
Future<http.Response> createUser(String uid, String serialno, context) async {
  final http.Response res = await http.put(Uri.parse('$baseUrl/adminuser'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode({
      'uid': uid,
      'serialno': serialno,
    }), //http put 요청
  );

  if (res.statusCode == 200) { // http put에서 받은 응답코드가 200이면
    showToast('삭제되었습니다.'); // showToast 호출
    Navigator.push(context,MaterialPageRoute(builder: (_) => AdminUserPage(serialno: serialno)));
    // 사용자 관리 화면으로 이동
  } else {
    showToast('알 수 없는 오류가 발생하였습니다.'); // showToast 호출
  }

  return jsonDecode(res.body);
}

// ------------------------- 도어락 사용자 내역을 호출하는 위젯 -------------------------
class MyAdminUser extends StatelessWidget {
  MyAdminUser({required this.name, required this.uid, required this.icon, required this.serialno}); // MyAdminUser 호출시에 필요한 변수
  final String name;
  final String uid;
  final Icon icon;
  final String serialno;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround, // widget간 일정한 보통 간격 유지
      children: <Widget>[
        Text(
          '$name',        
          style: TextStyle(fontSize: 15.0), // text 폰트 크기
        ),
        Text(
          '$uid',
          style: TextStyle(fontSize: 15.0), // text 폰트 크기
        ),
        IconButton(
          icon: icon,         // IconButton의 아이콘
          onPressed: () {     // IconButton click 시에 
            deleteDialog(name, uid, serialno, context); // deleteDialog()
          },
        ),
      ],
    );
  }
}

// ------------------------- 사용자 삭제시에 필요한 Dialog를 구현하는 함수 -------------------------
Future<void> deleteDialog(name, uid, serialno, context) async {
  return showDialog<void>(
      context: context,
      barrierDismissible: true, // dialog를 제외한 다른 화면 터치 하면 dialog 닫힘
      builder: (BuildContext context) {
        return AlertDialog( // flutter dialog
          shape: RoundedRectangleBorder( // dialog 모양
            borderRadius: BorderRadius.circular(10.0),
          ),
          content: Text(
            '"$name($uid)"님을 삭제하시겠습니까?',
          ),
          actions: <Widget>[
            TextButton( // 예 버튼
                child: Text('예'),                      // flatbutton 내용
                onPressed: () {                         // flatbutton click 시에
                  createUser(uid, serialno, context);   // http put으로 data 전송
                }),
            TextButton( // 아니오 버튼
              child: Text('아니오'),                    // flatbutton 내용
              onPressed: () {                           // flatbutton click 시에
                Navigator.pop(context);                 // dialog 닫음
              },
            ),
          ],
        );
      });
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
