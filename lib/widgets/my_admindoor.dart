/*    파일명: my_admindoor.dart
      파일설명: 도어락 관리 화면에서 사용할 MyAdminDoor 위젯 정의함
      개발자: 신예나
      개발일: 2020.12. */
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:doorapp/admin/adminuser.dart';         // AdminUserPage() 불러오기
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';  // flutter toast 모듈
import 'package:http/http.dart' as http;          // http 모듈
import 'dart:convert';                            // JSON 파싱

var baseUrl = dotenv.env['BASE_URL'];
// ------------------------- 서버에 도어락 내역을 요청하는 함수 -------------------------
Future<http.Response> createDoorlock(String serialno, int active) async {
  final http.Response res = await http.post(Uri.parse('$baseUrl/admindoor'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode({
      'serialno': serialno,
      'active': active,      
    }), //http post 요청
  );

  return jsonDecode(res.body);
}

// ------------------------- 도어락 내역을 호출하는 위젯 -------------------------
class MyAdminDoor extends StatefulWidget {

  MyAdminDoor({required this.name, required this.serialno, required this.checked}); // MyAdminDoor 호출시에 필요한 변수
  final String name;
  final String serialno;
  bool checked;

  @override
  _MyAdminDoorState createState() => _MyAdminDoorState();
}

class _MyAdminDoorState extends State<MyAdminDoor> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        TextButton( // flutter flatbutton
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (_) => AdminUserPage(serialno: widget.serialno) )); 
            // 사용자 관리 화면으로 이동
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween, // widget간 일정한 넓은 간격 유지
            children: <Widget>[
              Text(
                '${widget.name} [${widget.serialno}]',
                style: TextStyle(fontSize: 15.0), // text 폰트 크기
              ),
              SizedBox(        // flutter switch의 크기를 조정하기 위해 SizedBox를 사용함
                width: 70.0,   // flutter switch 높이
                child: Switch( // flutter switch
                  value: widget.checked, // flutter switch 의 value
                  onChanged: (value) {
                    if (widget.checked == false) {                                // checked 값이 false이면
                      showToast('"${widget.name}" 도어락이 활성화 되었습니다.');   // showToast() 호출
                      setState(() {
                        widget.checked = true;                                    // checked 값을 true로 변경
                        createDoorlock(widget.serialno, 1);                       // http post로 data 전송
                      });
                    } else if (widget.checked == true) {                          // checked 값이 true이면
                      showToast('"${widget.name}" 도어락이 비활성화 되었습니다.');  // showToast() 호출
                      setState(() {
                        widget.checked = false;                                   // checked 값을 false로 변경
                        createDoorlock(widget.serialno, 0);                       // http post로 data 전송
                      });
                    }
                  },
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 20.0,
        )
      ],
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
