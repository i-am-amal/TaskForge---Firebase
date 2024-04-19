import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  String? name;
  String? email;
  String? uid;
  String? token;

  getData() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    token = pref.getString('token');
    name = pref.getString('name');
    email = pref.getString('email');
    uid = pref.getString('uid');
    setState(() {});
  }

  @override
  void initState() {
    getData();
    Future.delayed(const Duration(seconds: 5), () {
    checkLoginStatus();
    });
    super.initState();
  }

  Future<void> checkLoginStatus() async {
    if (token == null) {
      Navigator.pushNamed(context, "/");
    } else {
      Navigator.pushNamed(context, "/home");
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text(
          'TaskForge',
          style: TextStyle(
              fontSize: 25, fontStyle: FontStyle.italic, color: Colors.white),
        ),
      ),
    );
  }
}
