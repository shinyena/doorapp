/*    파일명: my_controllist.dart
      파일설명: 도어락 제어내역 화면에서 사용할 MyList 위젯을 정의함
      개발자: 신예나
      개발일: 2020.12. */

import 'package:flutter/material.dart';

// ------------------------- 도어락 사용 내역을 호출하는 위젯 -------------------------
class MyList extends StatelessWidget {
  MyList({required this.name, required this.state, required this.time}); // MyList 호출시에 필요한 변수
  final String name;
  final String state;
  final String time;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          child: Text(
            '$name 님이 잠금을 $state 하였습니다.\n$time',
            style: TextStyle(fontSize: 15.0), // text 폰트 크기
          ),
          padding: EdgeInsets.all(10.0),    // padding 값 상하좌우 10.0
          width: 300,                       // container 너비
          decoration: BoxDecoration(
            color: Colors.grey[300],        // container 배경색
            borderRadius: BorderRadius.all( // container 모양
              Radius.circular(10.0),
            ),
          ),
        ),
        SizedBox(
          height: 10.0,
        ),
      ],
    );
  }
}
