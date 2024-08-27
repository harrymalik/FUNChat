import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:harisfirebase/api/api.dart';
import 'package:harisfirebase/screens/homepage.dart';
import 'package:harisfirebase/wrapper.dart';

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

  Signup() async {
    await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email.text, password: password.text);

    await API.createUser().then((value) {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (_) => const Homepage()));
    });

    Get.offAll(wrapper());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Signup')),
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
            ElevatedButton(onPressed: (() => Signup()), child: Text('Signup'))
          ],
        ),
      ),
    );
  }
}
