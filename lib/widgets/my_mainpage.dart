/*    파일명: my_mainpage.dart
      파일설명: 메인 화면에서 사용할 MyMainPage 위젯을 정의함
      개발자: 신예나
      개발일: 2020.12. */

import 'package:doorapp/door/controldoor.dart';           // ControlPage() 불러오기
import 'package:doorapp/door/controllist.dart';              // ListPage() 불러오기
import 'package:doorapp/door/moddoor.dart';           // ModDoorPage() 불러오기
import 'package:flutter/material.dart';     
import 'package:fluttertoast/fluttertoast.dart';  // flutter toast 모듈

// ------------------------- 도어락 내역을 호출하는 위젯 -------------------------
class MyMainPage extends StatelessWidget {
  MyMainPage({required this.name, required this.serialno, required this.color, required this.usertype, required this.active}); // MyMainPage 호출시에 필요한 변수
  final String name;
  final String serialno;
  final Color color;
  final String usertype;
  final int active;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        SizedBox(
          height: 30.0,
        ),
        Container(
          color: Colors.grey[200],              // container 배경색
          padding: const EdgeInsets.all(10.0),  // padding 값 상하좌우 10.0
          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween, // widget간 일정한 넓은 간격 유지
                children: <Widget>[
                  TextButton( // flutter flatbutton
                    child: Text(
                      '$name [$serialno]',
                      style: TextStyle(
                        fontSize: 20.0,               // text 폰트 크기
                        fontWeight: FontWeight.bold,  // text 굵게
                      ),
                    ),
                    onPressed: () { // flatbutton click 시에
                      if (usertype == 'main') { // 해당 도어락의 주사용자라면
                        Navigator.push(context,MaterialPageRoute(builder: (_) => ModDoorPage(serialno: serialno))); 
                        // 도어락 수정 화면으로 이동
                      } else { // 해당 도어락의 부사용자라면
                        showToast('도어락 주사용자만 사용할 수 있는 기능입니다.'); // showToast() 호출
                      }
                    },
                  ),
                  IconButton( // 제어내역 아이콘
                    icon: Icon(Icons.list_alt), // 아이콘 종류
                    iconSize: 25.0,             // 아이콘 사이즈
                    onPressed: () {             // IconButton click 시에
                      Navigator.push(context,MaterialPageRoute(builder: (_) => ListPage(serialno: serialno)));
                      // 도어락 제어내역 화면으로 이동
                    },
                  ),
                ],
              ),
              Divider( // 선
                height: 10.0,         // 길이
                color: Colors.black,  // 색상
                thickness: 0.5,       // 두께
                endIndent: 0.0,       // 끝에서부터 떨어진 정도
              ),
              ButtonTheme( // 제어하기 버튼
                minWidth: 300.0,    // 버튼 너비
                height: 100.0,      // 버튼 높이
                buttonColor: color, // 버튼 배경색
                child: ElevatedButton( // flutter raised button
                  child: Text(
                    '제어하기',             // 버튼 내용
                    style: TextStyle(
                      fontSize: 20.0,       // text 폰트 사이즈
                      color: Colors.white,  // text 폰트 색상
                    ),
                  ),
                  onPressed: () { // flatbutton click 시에
                    if (active == 1) { // 도어락이 활성화 응답라면
                      Navigator.push(context,MaterialPageRoute(builder: (_) => ControlPage(serialno: serialno,name: name)));
                      // 도어락 제어 화면으로 이동
                    } else { // 도어락이 비활성화 응답라면
                      showToast('현재 비활성화 된 도어락 입니다.'); // showToast() 호출
                    }
                  },
                ),
              ),
            ],
          ),
        ),
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
