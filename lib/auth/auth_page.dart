import 'package:flutter/material.dart';
import 'package:todo_uygulama/screen/login_screen.dart';
import 'package:todo_uygulama/screen/signup_screen.dart';

class GirisEkran extends StatefulWidget {
  const GirisEkran({super.key});

  @override
  State<GirisEkran> createState() => _GirisEkranState();
}

class _GirisEkranState extends State<GirisEkran> {
  bool a = true;
  void to() {
    setState(() {
      a = !a;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (a) {
      return LoginScreen(to);
    } else {
      return SignUpScreen(to);
    }
  }
}
