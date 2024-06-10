import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:folksdata/home_page.dart';
import 'package:sqflite/sqflite.dart';

class Logins extends StatefulWidget {
  const Logins({super.key});
  @override
  State<Logins> createState() => LoginsState();
}

class LoginsState extends State<Logins> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  final Map<String, String> userIDmap = {
    'user1': 'password1',
    'Zenrav': 'folksdata',
    'Zenravs': 'orka',
  };

  void fieldClear() {
    usernameController.text = '';
    passwordController.text = '';
  }

  void errorPopup(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Invalid'),
          content: Text('Username or password'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Continue'),
            ),
          ],
        );
      },
    );
  }

  Future<void> debugDeleteTable() async {
    final database = await openDatabase('folksdata_DB.db');
    await database.execute('DROP TABLE folks_ID');
  }

  Future<void> debugCreateTable() async {
    final database = await openDatabase('folksdata_DB.db');
    await database.execute(
        'CREATE TABLE folks_ID(id INTEGER PRIMARY KEY, card_num INTEGER, name TEXT, address TEXT, zip INTEGER)');
  }

  @override
  // TODO: implement widget
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("FolksDATA"),
      ),
      body: Container(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: formKey,
          child: Column(
            children: [
              TextFormField(
                controller: usernameController,
                decoration: const InputDecoration(labelText: 'Username'),
              ),
              TextFormField(
                obscureText: true,
                controller: passwordController,
                decoration: const InputDecoration(labelText: 'Password'),
              ),
              SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: () async {
                  final username = usernameController.text;
                  final password = passwordController.text;
                  if (userIDmap.containsKey(username) &&
                      userIDmap[username] == password) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => HomePage(),
                      ),
                    );
                    fieldClear();
                  } else {
                    fieldClear();
                    errorPopup(context);
                    print('Invalid username or passwords');
                  }
                },
                child: const Text('Login'),
              ),
              const SizedBox(
                height: 10,
              ),
              const SizedBox(
                height: 30,
                child: Text("Debug Feature"),
              ),
              ElevatedButton(
                onPressed: () {
                  debugDeleteTable();
                },
                child: const Text("Drop Table"),
              ),
              ElevatedButton(
                onPressed: () {
                  debugCreateTable();
                },
                child: const Text("Create Table"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
