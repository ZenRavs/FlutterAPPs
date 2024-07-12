import 'package:flutter/material.dart';
import 'package:input_mahasiswa/login.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: 'https://jqabsztrjezyqwmxooiz.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImpxYWJzenRyamV6eXF3bXhvb2l6Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3MTg5MzE0NTksImV4cCI6MjAzNDUwNzQ1OX0.H0Wlm6x7hdyDcCqvpd-kwQ0lhBev7u_CrhZs2j0h0zQ',
  );
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Login(),
    );
  }
}
