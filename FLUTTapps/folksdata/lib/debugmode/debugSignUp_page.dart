import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});
  @override
  State<SignUp> createState() => SignUpState();
}

class SignUpState extends State<SignUp> {
  TextEditingController nameSignup = TextEditingController();
  TextEditingController UsernameSignup = TextEditingController();
  TextEditingController PasswordSignup = TextEditingController();

  late dynamic db = null;
  final List<Map<String, String?>> userIDmap = [];

  void fieldClear() {
    UsernameSignup.text = '';
    PasswordSignup.text = '';
  }

  void save() async {
    String userName = UsernameSignup.text;
    exitingUserCheck(userName);
    await db.insert(
      'user_ID',
      {
        "user_name": UsernameSignup,
        "password": PasswordSignup,
      },
    );
  }

  void exitingUserCheck(String userName) async {
    final database = await openDatabase('folksdata_DB.db');
    String query = 'SELECT user_name FROM user_ID WHERE username = ?';
    final results = await database.execute(
      query,
      [userName],
    );
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign Up'),
      ),
      body: Container(
        padding: const EdgeInsets.all(20),
        width: double.infinity,
        height: double.infinity,
        child: Column(
          children: [
            TextField(
              controller: nameSignup,
              decoration: const InputDecoration(
                label: Text("Your Name"),
              ),
            ),
            TextField(
              controller: UsernameSignup,
              decoration: const InputDecoration(
                label: Text("Username"),
              ),
            ),
            TextField(
              controller: PasswordSignup,
              decoration: const InputDecoration(
                label: Text("Password"),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
              onPressed: () {},
              child: const Text("Sign in"),
            )
          ],
        ),
      ),
    );
  }
}
