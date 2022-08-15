/*    파일명: drawer.dart
      파일설명: 모바일 앱 메뉴 화면
      개발자: 신예나
      개발일: 2020.12. */

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart'; // flutter toast 모듈

// ------------------------- 모바일 앱 메뉴를 구현하는 위젯 -------------------------
Drawer myDrawer(BuildContext context) {
  return Drawer( // flutter drawer
    child: ListView(
      children: <Widget>[
        UserAccountsDrawerHeader( // 계정 이름          
          accountName: Text( 
            '',
            style: TextStyle(
              color: Colors.black,  // text 폰트 색상
              fontSize: 20.0,       // text 폰트 크기
            ),
          ),
          accountEmail: Text( // 계정 이메일
            '',
            style: TextStyle(
              color: Colors.black,  // text 폰트 색상
              fontSize: 15.0,       // text 폰트 크기
            ),
          ),
          decoration: BoxDecoration( // DrawerHeader decoration
            color: Colors.grey[400], // DrawerHeader 영역 배경색
          ),
        ),
        ListTile( // 메뉴1
          title: Text(
            '도어락 목록',                     // 메뉴1
            style: TextStyle(fontSize: 15.0), // 메뉴1 폰트 크기
          ),
          onTap: () {                               // 메뉴1 click 시에
            Navigator.pushNamed(context, '/main');  // 메인화면으로 이동
          },
        ),
        ListTile( // 메뉴2
          title: Text(
            '도어락 등록',                     // 메뉴2 내용
            style: TextStyle(fontSize: 15.0), // 메뉴2 폰트 크기
          ),
          onTap: () {                                 // 메뉴2 click 시에
            Navigator.pushNamed(context, '/bleList'); // 도어락 등록(블루투스 목록) 화면으로 이동
          },
        ),
        ListTile( // 메뉴3
          title: Text(
            '도어락 관리',                     // 메뉴3 내용
            style: TextStyle(fontSize: 15.0), // 메뉴3 폰트 크기
          ),
          onTap: () {                                   // 메뉴3 click 시에
            Navigator.pushNamed(context, '/adminDoor'); // 도어락 관리 화면으로 이동
          },
        ),
        SizedBox(
          height: 200.0, // 높이 200.0 만큼 띄움
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(8.0, 0.0, 8.0, 0.0), // 패딩값 설정
          child: ButtonTheme(                 // 버튼 모양
            height: 40.0,                     // 버튼 높이
            buttonColor: Colors.grey[400],    // 버튼 색
            shape: RoundedRectangleBorder(    // 버튼 모양
              borderRadius: BorderRadius.all(
                Radius.circular(5.0),
              ),
            ), 
            child: ElevatedButton( // flutter raised button
              child: Text(              // 버튼 내용
                '회원정보수정',
                style: TextStyle(
                  color: Colors.white,  // text 색
                  fontSize: 15.0,       // text 폰트 크기
                ),
              ),
              onPressed: () {
                Navigator.pushNamed(context, '/modUser'); // 사용자 정보 변경 화면으로 이동
              },
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(8.0, 0.0, 8.0, 0.0), // 패딩값 설정
          child: ButtonTheme( // 로그아웃 버튼
            height: 40.0,                   // 버튼 높이
            buttonColor: Colors.grey,       // 버튼 색
            shape: RoundedRectangleBorder(  // 버튼 모양
              borderRadius: BorderRadius.all(
                Radius.circular(5.0),
              ),
            ),  
            child: ElevatedButton( // flutter raised button
              child: Text(              // 버튼 내용
                '로그아웃',
                style: TextStyle(
                  color: Colors.white,  // text 색
                  fontSize: 15.0,       // text 폰트 크기
                ),
              ),
              onPressed: () { // raised button click 시에
                showToast('로그아웃 되었습니다.');        // flutter toast() 호출
                Navigator.pushNamed(context, '/login');  // 로그인 화면으로 이동
              },
            ),
          ),
        ),
      ],
    ),
  );
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
