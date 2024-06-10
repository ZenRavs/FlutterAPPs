import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:folksdata/debugmode/debugSignUp_page.dart';
import 'package:sqflite/sqflite.dart';

import '../home_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
  @override
  State<LoginPage> createState() => LoginsState();
}

class LoginsState extends State<LoginPage> {
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

  void errorPopup(
    BuildContext context,
  ) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Invalid'),
          content: const Text('content'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Continue'),
            ),
          ],
        );
      },
    );
  }

  Future<void> debugDropTable() async {
    final database = await openDatabase('folksdata_DB.db');
    database.execute('DROP TABLE folks_ID');
    database.execute('DROP TABLE user_ID');
  }

  Future<void> debugCreateTable() async {
    final database = await openDatabase('folksdata_DB.db');
    await database.execute(
        'CREATE TABLE folks_ID(id INTEGER PRIMARY KEY, card_num INTEGER, name TEXT, address TEXT, zip INTEGER)');
    await database.execute(
        'CREATE TABLE user_ID(id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, user_name TEXT, password TEXT)');
  }

  Future<void> popUpMenu(String menu) async {
    if (menu == 'create') {
      try {
        await debugCreateTable();
        // Fluttertoast.showToast(
        //   msg: "Table created succesfully!",
        //   toastLength: Toast.LENGTH_SHORT,
        //   gravity: ToastGravity.BOTTOM,
        // );
      } catch (e) {
        return print("error: $e");
      }
    } else if (menu == 'drop') {
      try {
        await debugDropTable();
        // Fluttertoast.showToast(
        //   msg: "Table dropped succesfully!",
        //   toastLength: Toast.LENGTH_SHORT,
        //   gravity: ToastGravity.BOTTOM,
        // );
      } catch (e) {
        return print("error: $e");
      }
    }
  }

  @override
  // TODO: implement widget
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          PopupMenuButton<String>(
            onSelected: popUpMenu,
            icon: const Icon(Icons.more_vert),
            itemBuilder: (BuildContext context) => [
              const PopupMenuItem(
                value: 'create',
                child: Text('Create Table'),
              ),
              const PopupMenuItem(
                value: 'drop',
                child: Text('Delete Table'),
              ),
            ],
          ),
        ],
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
              const SizedBox(height: 20.0),
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
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const SignUp(),
                    ),
                  );
                },
                child: const Text('Sign Up'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
