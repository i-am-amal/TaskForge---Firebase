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
    SharedPreferences _pref = await SharedPreferences.getInstance();
    token = await _pref.getString('token');
    name = await _pref.getString('name');
    email = await _pref.getString('email');
    uid = await _pref.getString('uid');

    setState(() {});
  }

  @override
  void initState() {
    getData();

    var d = Duration(seconds: 5);
    Future.delayed(d, () {
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
