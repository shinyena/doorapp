/*    파일명: controllist.dart
      파일설명: 도어락 사용 내역을 열람하는 화면
      개발자: 신예나
      개발일: 2020.12. */

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:doorapp/screens/drawer.dart'; // myDrawer() 불러오기
import 'package:doorapp/widgets/my_controllist.dart'; // MyList() 불러오기
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http; // http 모듈
import 'dart:convert'; // JSON 파싱

var baseUrl = dotenv.env['BASE_URL'];

// ------------------------- 도어락 제어 내역 화면 -------------------------
class ListPage extends StatelessWidget {
  ListPage({required this.serialno}); // ListPage는 반드시 serialno 값을 받아와야 함
  final String serialno;

  Future fetch() async {
    var res = await http
        .get(Uri.parse('$baseUrl/list/?serialno=$serialno')); //http get 요청
    return json.decode(res.body);
  }

  late String state;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('제어 내역 열람'),
        centerTitle: true, // title을 가운데로 설정
      ),
      endDrawer: myDrawer(context), // drawer.dart 의 myDrawer() 사용
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(20.0), // padding 값 상하좌우 20.0
          child: FutureBuilder(
              future: this.fetch(),
              builder: (context, AsyncSnapshot snap) {
                snap.data ?? const CircularProgressIndicator();
                return ListView.builder(
                    itemCount: snap.data.length,
                    itemBuilder: (BuildContext context, int index) {
                      if (snap.data[index]['details'].toString() == 'lock') {
                        // http get으로 받아온 도어락 제어내용이 lock 이면
                        state = '설정';
                      } else if (snap.data[index]['details'].toString() ==
                          'unlock') {
                        // http get으로 받아온 도어락 제어내용이 unlock 이면
                        state = '해제';
                      }
                      return MyList(
                        name: snap.data[index]['name'].toString(),
                        // http get으로 사용자 이름 받아옴
                        state: state,
                        time: snap.data[index]['use_date']
                            .toString(), // http get으로 도어락 제어일시 받아옴
                      );
                    });
              }),
        ),
      ),
    );
  }
}
