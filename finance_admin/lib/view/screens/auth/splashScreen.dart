
import 'package:finance_admin/view/screens/auth/loginScreen.dart';
import 'package:finance_admin/view/screens/dashboard.dart';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:employee_management_ad/screen/login_screen.dart';




class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    checkUserStatus();
  }

  Future<void> checkUserStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String userId = prefs.getString('userId') ?? '';
    String token = prefs.getString('token') ?? '';

    if (userId.isNotEmpty && token.isNotEmpty) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => HomeScreen(),
        ),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => LoginScreen(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Text("oiuytui"),
          Center(
            child: CircularProgressIndicator(),
          ),
        ],
      ),
    );
  }
}
