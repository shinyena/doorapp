/*    파일명: moddoor.dart
      파일설명: 도어락 정보를 변경하는 화면
      개발자: 신예나
      개발일: 2020.12. */

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:doorapp/screens/drawer.dart';            // myDrawer() 불러오기
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';  // flutter toast 모듈
import 'package:http/http.dart' as http;          // http 모듈
import 'dart:convert';                            // JSON 파싱

var baseUrl = dotenv.env['BASE_URL'];
// ------------------------- 서버에 도어락 정보 변경을 요청하는 함수 -------------------------
Future<http.Response> modifyDoor(
    String serialno, String name, String lastuid, String uid, context) async {
  final http.Response res = await http.put(Uri.parse('$baseUrl/moddoor'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode({
      'serialno': serialno,
      'name': name,
      'lastuid': lastuid,
      'uid': uid,
    }), //http put 요청
  ); 

  if (res.statusCode == 200) { // http put에서 받은 응답코드가 200이면
    showToast('도어락 정보를 변경하였습니다.');
    Navigator.pushNamed(context, '/main');
  } else if (res.statusCode == 461) { // http put에서 받은 응답코드가 461이면
    showToast('존재하지 않는 아이디입니다.');
  } else {
    showToast('알 수 없는 오류가 발생하였습니다.');
  }

  return jsonDecode(res.body);
}

// ------------------------- 서버에 도어락 삭제를 요청하는 함수 -------------------------
Future<http.Response> deleteDoor(String serialno, context) async {
  final http.Response res = await http.put(Uri.parse('$baseUrl/deletedoor'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode({
      'serialno': serialno,
    }), //http put 요청
  );

  if (res.statusCode == 200) { // http put에서 받은 응답코드가 200이면
    showToast('도어락을 삭제하였습니다.');
    Navigator.pushNamed(context, '/main');
  } else {
    showToast('알 수 없는 오류가 발생하였습니다.');
  }

  return jsonDecode(res.body);
}

// ------------------------- 도어락 정보변경 화면 -------------------------
class ModDoorPage extends StatelessWidget {
  final String serialno;
  ModDoorPage({required this.serialno}); // ModDoorPage는 반드시 serialno 값을 받아와야 함

  Future fetch() async {
    var res = await http.get(Uri.parse('$baseUrl/moddoor/?serialno=$serialno')); // http get 요청
    return json.decode(res.body);
  }

  TextEditingController name = TextEditingController(); // Text field를 제어할 controller 정의
  TextEditingController uid = TextEditingController();  // Text field를 제어할 controller 정의
  late String lastuid;
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('도어락 정보변경'),
        centerTitle: true, // title을 가운데로 설정
      ),
      endDrawer: myDrawer(context), // drawer.dart 의 myDrawer() 사용
      body: FutureBuilder(
          future: this.fetch(),
          builder: (context, AsyncSnapshot snap) {
            name = TextEditingController(text: snap.data['name'].toString()); // http get으로 사용자 이름 받아옴
            uid = TextEditingController(text: snap.data['uid'].toString());   // http get으로 사용자 아이디 받아옴
            lastuid =  snap.data['uid'].toString();
            return SingleChildScrollView( // 스크롤을 가능하게 함
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(30.0), // padding 값 상하좌우 20.0
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
                                readOnly: true,                                       // 수정할 수 없음
                                maxLength: 6,                                         // 최대 글자 수
                                controller: TextEditingController(text: serialno),    // Text field의 data를 제어
                                decoration: InputDecoration(labelText: '시리얼번호'),  // Text field의 label text 내용
                              ),
                              SizedBox(
                                height: 20.0,
                              ),
                              TextField(
                                maxLength: 20,                                          // 최대 글자 수
                                controller: name,                                       // Text field의 data를 제어
                                decoration: InputDecoration(labelText: '도어락 이름'),   // Text field의 label text 내용
                                keyboardType: TextInputType.text,                       // Text field의 data의 형식
                              ),
                              SizedBox(
                                height: 20.0,
                              ),
                              TextField(
                                maxLength: 20,                                              // 최대 글자 수
                                controller: uid,                                            // Text field의 data를 제어
                                decoration: InputDecoration(labelText: '도어락 주사용자'),   // Text field의 label text 내용
                                keyboardType: TextInputType.text,                           // Text field의 data의 형식
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 280.0,
                      ),
                      ButtonTheme( // 삭제하기 버튼
                        height: 50.0,                     // 버튼 높이
                        minWidth: 350.0,                  // 버튼 너비
                        buttonColor: Colors.grey,         // 버튼 배경색
                        shape: RoundedRectangleBorder(    // 버튼 모양
                          borderRadius: BorderRadius.all(
                            Radius.circular(5.0),
                          ),
                        ),
                        child: ElevatedButton( // flutter raised button
                          child: Text( // 버튼 내용
                            '삭제하기',
                            style: TextStyle(
                              color: Colors.white, // text 폰트 색상
                              fontSize: 15.0,      // text 폰트 크기
                            ),
                          ),
                          onPressed: () { // rasied button click 시에
                            deleteDialog(context, serialno); // deleteDialog() 호출
                          },
                        ),
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      ButtonTheme(
                        height: 50.0,                   // 버튼 높이
                        minWidth: 350.0,                // 버튼 너비
                        buttonColor: Colors.grey[600],  // 버튼 배경색
                        shape: RoundedRectangleBorder(  // 버튼 모양
                          borderRadius: BorderRadius.all(
                            Radius.circular(5.0),
                          ),
                        ),
                        child: ElevatedButton( // flutter raised button
                          child: Text( // 버튼 내용
                            '변경하기',
                            style: TextStyle(
                              color: Colors.white, // text 폰트 색상
                              fontSize: 15.0,      // text 폰트 크기
                            ),
                          ),
                          onPressed: () { // raised button click 시에
                            if (name.text == '') { // text field name의 값이 없으면
                              showToast('도어락 이름을 입력하시오.');
                            } else if (uid.text == '') { // text field uid의 값이 없으면
                              showToast('도어락 주사용자를 입력하시오.');
                            } else {
                              modifyDoor(serialno, name.text, lastuid, uid.text, context); // http put으로 data 전송
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

// ------------------------- 도어락 삭제시에 필요한 Dialog를 구현하는 함수 -------------------------
Future<void> deleteDialog(context, serialno) async {
  return showDialog<void>(
      context: context,
      barrierDismissible: true, // dialog를 제외한 다른 화면 터치 하면 dialog 닫힘
      builder: (BuildContext context) {
        return AlertDialog( // flutter dialog
          shape: RoundedRectangleBorder( // dialog 모양
            borderRadius: BorderRadius.circular(10.0),
          ),
          content: Text( // dialog 내용
            '도어락을 삭제하시겠습니까?', 
          ),
          actions: <Widget>[
            TextButton( // 예 버튼
              child: Text('예'),                // flatbutton 내용
              onPressed: () {                   // flatbutton click 시에
                deleteDoor(serialno, context);  // http put으로 data 전송
              },
            ),
            TextButton( // 아니오 버튼
              child: Text('아니오'),            // flatbutton 내용
              onPressed: () {                   // flatbutton click 시에
                Navigator.pop(context);         // dialog 닫음
              },
            ),
          ],
        );
      });
}
