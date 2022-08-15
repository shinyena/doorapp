/*    파일명: adminuser.dart
      파일설명: 각 도어락별 사용자를 추가 또는 삭제하는 사용자 관리 화면
      개발자: 신예나
      개발일: 2020.12. */

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:doorapp/screens/drawer.dart';            // myDrawer() 불러오기
import 'package:flutter/material.dart';
import 'package:doorapp/widgets//my_adminuser.dart';      // MyAdminUser() 불러오기
import 'package:http/http.dart' as http;          // http 모듈
import 'dart:convert';                            // JSON 파싱
import 'package:fluttertoast/fluttertoast.dart';  // flutter toast 모듈

var baseUrl = dotenv.env['BASE_URL'];
// ------------------------- 서버에 사용자 추가를 요청하는 함수 -------------------------
Future<http.Response> createUser(String serialno, String uid, context) async {
  final http.Response res = await http.post(
    Uri.parse('$baseUrl/adminuser'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode({
      'serialno': serialno,
      'uid': uid,
    }), //http post 요청
  );

  if (res.statusCode == 200) { // http post에서 받은 응답코드가 200이면
    showToast('사용자가 등록되었습니다.');
    Navigator.push(context,MaterialPageRoute(builder: (_) => AdminUserPage(serialno: serialno))); // AdminUserPage로 이동
  } else if (res.statusCode == 461) { // http post에서 받은 응답코드가 461이면
    showToast('존재하지 않는 아이디입니다.');
  } else if (res.statusCode == 460) { // http post에서 받은 응답코드가 460이면
    showToast('이미 존재하는 사용자입니다.');
  } else {
    showToast('알 수 없는 오류가 발생하였습니다.');
  }

  return jsonDecode(res.body);
}

// ------------------------- 사용자 관리 화면 -------------------------
class AdminUserPage extends StatefulWidget {
  final String serialno;
  AdminUserPage({required this.serialno}); // AdminUserPage는 반드시 serialno 값을 받아와야 함
  @override
  _AdminUserPageState createState() => _AdminUserPageState();
}

class _AdminUserPageState extends State<AdminUserPage> {
  Future fetch(String serialno) async {
    var res = await http.get(Uri.parse('$baseUrl/adminuser/?serialno=$serialno')); // http get 요청
    return json.decode(res.body);
  }

  late Icon _icon;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('사용자 관리'),    // title 내용
        centerTitle: true,            // title을 가운데로 설정
      ),
      endDrawer: myDrawer(context),   // drawer.dart 의 myDrawer() 사용
      body: Padding(
        padding: const EdgeInsets.all(20.0), // padding 값 상하좌우 20.0
        child: FutureBuilder(
          future: this.fetch(widget.serialno),
          builder: (context, AsyncSnapshot snap) {
            if (!snap.hasData) // http get에서 받아온 data가 없으면
              return CircularProgressIndicator();
            return ListView.builder(
              itemCount: snap.data.length, // http get으로 받아온 data 개수
              itemBuilder: (BuildContext context, int index) {
                if (snap.data[index]['usertype'].toString() == 'main') { // http get으로 받아온 사용자 종류가 main 이면
                  _icon = Icon(null);
                } else { // http get으로 받아온 사용자 종류가 sub 이면
                  _icon = Icon(Icons.delete);
                }
                return MyAdminUser(
                  name: snap.data[index]['name'].toString(),  // http get으로 사용자 이름 받아옴
                  uid: snap.data[index]['uid'].toString(),    // http get으로 사용자 아이디 받아옴
                  icon: _icon,
                  serialno: widget.serialno,
                );
              },
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton( // 사용자 추가 버튼
        child: Icon(Icons.add), // 아이콘 종류
        onPressed: () {
          addDialog(context, widget.serialno); // addDialog() 호출
        },
      ),
    );
  }
}

// ------------------------- 사용자 추가시에 필요한 Dialog를 구현하는 함수 -------------------------
Future<void> addDialog(context, serialno) async {
  final TextEditingController uid = TextEditingController(); // Text field를 제어할 controller 정의
  return showDialog<void>(
      context: context,
      barrierDismissible: true, // dialog를 제외한 다른 화면 터치 하면 dialog 닫힘
      builder: (BuildContext context) {
        return AlertDialog(// flutter dialog
          shape: RoundedRectangleBorder(// dialog 모양
            borderRadius: BorderRadius.circular(10.0),
          ),
          title: Text(// dialog 제목
            '사용자 등록',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: Theme( // dialog decoration
            data: ThemeData(
              inputDecorationTheme: InputDecorationTheme(labelStyle: TextStyle(fontSize: 15.0)), // Text field의 폰트 사이즈를 15.0으로 설정
            ),
            child: TextField( // dialog 내용
              controller: uid,                                            // Text field의 data를 제어
              autofocus: true,                                            // dialog가 열리면 자동으로 포커스 부여
              decoration: InputDecoration(labelText: '사용자 아이디'),     // Text field의 label text 설정
              keyboardType: TextInputType.emailAddress,                   // Text field의 data의 형식을 email address로 설정
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('등록하기'),
              onPressed: () {
                createUser(serialno, uid.text, context); // http post로 data 전송
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
