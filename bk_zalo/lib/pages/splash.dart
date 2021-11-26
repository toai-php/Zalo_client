import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
