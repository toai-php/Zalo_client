import 'dart:convert';

import 'package:bk_zalo/components/size_config.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class Loading extends StatefulWidget {
  const Loading({Key? key}) : super(key: key);

  @override
  _LoadingState createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {
  AssetImage img = const AssetImage("assets/images/loading.png");

  void changeState() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('user_token') ?? "";
    if (token != "") {
      final uri = Uri.http("192.168.1.12:3000", "/it4788/getuser");
      final response = await http.get(uri,
          headers: {'token': token}).timeout(const Duration(seconds: 10));
      if (response.statusCode == 200 || response.statusCode == 400) {
        Map<String, dynamic> res = json.decode(response.body);
        Map<String, dynamic> data = res['data'];
        await prefs.setString('name', data['name']);
        await prefs.setInt('id', data['id'] ?? 0);
        await prefs.setString('avtlink',
            data['avtlink'] ?? "http://192.168.1.12:3000/img/default.jpg");
      }
      Navigator.pushReplacementNamed(context, '/home');
    } else {
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  @override
  void initState() {
    super.initState();
    changeState();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: img,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
