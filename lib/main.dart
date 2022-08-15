/*    파일명: main.dart
      파일설명: 모바일 앱 실행 시 최초로 실행되는 메인 화면 (로그인 화면으로 이동)
      개발자: 신예나
      개발일: 2020.12. */

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:doorapp/screens/loginpage.dart';
import 'package:doorapp/user/reguser.dart';
import 'package:doorapp/user/moduser.dart';
import 'package:doorapp/screens/mainpage.dart';
import 'package:doorapp/ble/blelist.dart';
import 'package:doorapp/admin/admindoor.dart';

void main() async {
    await dotenv.load(fileName: 'assets/config/.env');
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'doorlock app',
      theme: ThemeData(
        primaryColor: Colors.white,
      ),
      debugShowCheckedModeBanner: false,  // debug banner 표시하지 않음
      initialRoute: '/login',             // 처음 시작 화면은 LoginPage
      routes: {
        '/login' : (context) => LoginPage(),          // loginpage.dart의 LoginPage로 이동
        '/regUser' : (context) => RegUserPage(),      // reguser.dart의 RegUserPage로 이동
        '/modUser' : (context) => ModUserPage(),      // moduser.dart의 ModUserPage로 이동
        '/main' : (context) => MainPage(),            // mainpage.dart의 MainPage로 이동
        '/bleList' : (context) => BleListPage(),      // blelist.dart의 BleListPage로 이동
        '/adminDoor' : (context) => AdminDoorPage(),  // admindoor.dart의 AdminDoorPage로 이동
      },
    );
  }
}
