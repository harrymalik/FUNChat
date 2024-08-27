//import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:harisfirebase/api/api.dart';
import 'package:harisfirebase/screens/forgot.dart';
import 'package:harisfirebase/screens/signup.dart';

class login extends StatefulWidget {
  const login({super.key});

  @override
  State<login> createState() => _loginState();
}

class _loginState extends State<login> {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

  signin() async {
    await API.auth
        .signInWithEmailAndPassword(email: email.text, password: password.text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            TextField(
              controller: email,
              decoration: const InputDecoration(
                hintText: 'Enter email',
              ),
            ),
            TextField(
              controller: password,
              decoration: const InputDecoration(
                hintText: 'Enter password',
              ),
            ),
            ElevatedButton(onPressed: (() => signin()), child: Text('login')),
            SizedBox(
              height: 30,
            ),
            ElevatedButton(
                onPressed: (() => Get.to(Signup())), child: Text('register')),
            SizedBox(
              height: 30,
            ),
            ElevatedButton(
                onPressed: (() => Get.to(Forgot())),
                child: Text('forgot password'))
          ],
        ),
      ),
    );
  }
}
