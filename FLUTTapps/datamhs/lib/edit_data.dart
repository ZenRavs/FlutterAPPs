import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class EditData extends StatefulWidget {
  const EditData({super.key});
  @override
  State<EditData> createState() => EditState();
}

class EditState extends State<EditData> {
  TextEditingController nimController = TextEditingController();
  TextEditingController namaController = TextEditingController();
  TextEditingController jurusanController = TextEditingController();
  TextEditingController statusController = TextEditingController();
  List<dynamic> mahasiswa = [];
  final supabase = Supabase.instance.client;
  void initState() {
    super.initState();
  }

  void retrieve() async {
    try {
      final response = await supabase.from('mahasiswa').select('*');
      setState(() {
        mahasiswa = response;
      });
    } catch (e) {}
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Error! $e'),
      ),
    );
  }

  void controllerClear() {
    nimController.clear();
    namaController.clear();
    jurusanController.clear();
    statusController.clear();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }
}
