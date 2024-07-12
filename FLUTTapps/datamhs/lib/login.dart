import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:input_mahasiswa/home.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Login extends StatefulWidget {
  const Login({super.key});
  @override
  State<Login> createState() => LoginsState();
}

class LoginsState extends State<Login> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final supabase = Supabase.instance.client;
  List<dynamic> users = [];

  void fieldClear() {
    emailController.clear();
    passwordController.clear();
  }

  void validation(String email, String password) async {
    try {} catch (e) {}
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

  @override
  // TODO: implement widget
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Login | Data Mahasiswa"),
      ),
      body: Container(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: formKey,
          child: Column(
            children: [
              TextFormField(
                controller: emailController,
                decoration: const InputDecoration(labelText: 'Email'),
              ),
              TextFormField(
                obscureText: true,
                controller: passwordController,
                decoration: const InputDecoration(labelText: 'Password'),
              ),
              SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: () async {
                  try {
                    await supabase.auth.signInWithPassword(
                        email: emailController.text,
                        password: passwordController.text);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Home(),
                      ),
                    );
                  } on AuthException catch (error) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Invalid identity!'),
                      ),
                    );
                  } catch (e) {}
                  fieldClear();
                },
                child: const Text('Login'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
