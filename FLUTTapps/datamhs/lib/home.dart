import 'package:flutter/material.dart';
import 'package:input_mahasiswa/show_data.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Home extends StatefulWidget {
  const Home({super.key});
  @override
  State<Home> createState() => HomeState();
}

class HomeState extends State<Home> {
  TextEditingController nimController = TextEditingController();
  TextEditingController namaController = TextEditingController();
  TextEditingController jurusanController = TextEditingController();
  TextEditingController statusController = TextEditingController();
  late String jurusanToNim;
  final supabase = Supabase.instance.client;
  @override
  void initState() {
    super.initState();
  }

  void save() async {
    try {
      final response = await supabase.from('mahasiswa').insert(
        {
          'nim': jurusanToNim,
          'nama': namaController.text,
          'jurusan': jurusanController.text,
          'status': statusController.text
        },
      );
      controllerClear();
    } on Exception catch (e) {
      print('Insert Failed! error: $e');
    }
  }

  void controllerClear() {
    nimController.clear();
    namaController.clear();
    jurusanController.clear();
    statusController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Data Mahasiswa"),
      ),
      body: Container(
        padding: EdgeInsets.all(20),
        width: double.infinity,
        height: double.infinity,
        child: Column(
          children: [
            TextField(
              controller: nimController,
              decoration: const InputDecoration(
                label: Text("NIM"),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            TextField(
              controller: namaController,
              decoration: const InputDecoration(
                label: Text("Nama Mahasiswa"),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            TextField(
              controller: jurusanController,
              decoration: const InputDecoration(
                label: Text("Jurusan"),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            TextField(
              controller: statusController,
              decoration: const InputDecoration(
                label: Text("Status Studi"),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              children: [
                ElevatedButton(
                  onPressed: () {
                    if (nimController.text.isEmpty ||
                        namaController.text.isEmpty ||
                        jurusanController.text.isEmpty ||
                        statusController.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('All field must be filled.'),
                        ),
                      );
                    } else {
                      String nim = nimController.text;
                      String jurusan = jurusanController.text;
                      if (jurusan == 'SI') {
                        jurusanToNim = 'A12.$nim';
                        save();
                      } else if (jurusan == 'TI') {
                        jurusanToNim = 'A11.$nim';
                        save();
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Jurusan not available.'),
                          ),
                        );
                      }
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Saved!'),
                        ),
                      );
                    }
                  },
                  child: Text("Save"),
                ),
                const SizedBox(
                  width: 20,
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ShowData(),
                      ),
                    );
                  },
                  child: Text("View Data"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
