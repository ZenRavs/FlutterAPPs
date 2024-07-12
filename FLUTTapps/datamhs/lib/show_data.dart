import 'package:flutter/material.dart';
import 'package:input_mahasiswa/home.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ShowData extends StatefulWidget {
  const ShowData({super.key});
  @override
  State<ShowData> createState() => ShowDataState();
}

class ShowDataState extends State<ShowData> {
  TextEditingController nimController = TextEditingController();
  TextEditingController namaController = TextEditingController();
  TextEditingController jurusanController = TextEditingController();
  TextEditingController statusController = TextEditingController();
  final supabase = Supabase.instance.client;
  List<dynamic> mahasiswa = [];

  @override
  void initState() {
    super.initState();
    retrieve();
  }

  void retrieve() async {
    try {
      final response = await supabase.from('mahasiswa').select('*');
      setState(() {
        this.mahasiswa = response;
      });
    } on Exception catch (e) {
      print('Retrieve Failed! error: $e');
    }
  }

  void edit(id) async {
    final response =
        await supabase.from('mahasiswa').select('*').eq('id', id).single();
    nimController.text = response['nim'].toString();
    namaController.text = response['nama'].toString();
    jurusanController.text = response['jurusan'].toString();
    statusController.text = response['status'].toString();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Edit Data'),
        content: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: nimController,
                decoration: InputDecoration(labelText: 'NIM'),
              ),
              TextField(
                controller: namaController,
                decoration: InputDecoration(labelText: 'Nama'),
              ),
              TextField(
                controller: jurusanController,
                decoration: InputDecoration(labelText: 'Jurusan'),
              ),
              TextField(
                controller: statusController,
                decoration: InputDecoration(labelText: 'Status'),
              ),
            ],
          ),
        ),
        actions: [
          ElevatedButton(
            onPressed: () async {
              // Perform update operation with updated values
              await supabase.from('mahasiswa').update({
                'nim': nimController.text,
                'nama': namaController.text,
                'jurusan': jurusanController.text,
                'status': statusController.text,
              }).eq('id', id);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Succes.'),
                ),
              );
              controllerClear();
              retrieve();
              Navigator.of(context).pop(); // Close the dialog
            },
            child: Text('Simpan'),
          ),
        ],
      ),
    );
  }

  void deleteRow(id) async {
    try {
      await supabase.from('mahasiswa').delete().eq('id', id);
      retrieve();
    } on Exception catch (e) {
      print('Delete Failed! error: $e');
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
        title: Text("View Data"),
      ),
      floatingActionButton: Stack(
        children: [
          Positioned(
            right: 10,
            bottom: 10,
            child: FloatingActionButton(
              onPressed: () {
                retrieve();
              },
              child: Icon(Icons.refresh),
            ),
          )
        ],
      ),
      body: Container(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                    columns: [
                      DataColumn(
                        label: Text('ID Data'),
                      ),
                      DataColumn(
                        label: Text('NIM'),
                      ),
                      DataColumn(
                        label: Text('Nama'),
                      ),
                      DataColumn(
                        label: Text('Jurusan'),
                      ),
                      DataColumn(
                        label: Text('Time Insert'),
                      ),
                      DataColumn(
                        label: Text('Status'),
                      ),
                      DataColumn(
                        label: Text('Action'),
                      ),
                    ],
                    rows: mahasiswa
                        .map(
                          (e) => DataRow(
                            cells: [
                              DataCell(
                                Text(
                                  e['id'].toString(),
                                ),
                              ),
                              DataCell(
                                Text(
                                  e['nim'].toString(),
                                ),
                              ),
                              DataCell(
                                Text(
                                  e['nama'].toString(),
                                ),
                              ),
                              DataCell(
                                Text(
                                  e['jurusan'].toString(),
                                ),
                              ),
                              DataCell(
                                Text(
                                  e['created_at'].toString(),
                                ),
                              ),
                              DataCell(
                                Text(
                                  e['status'].toString(),
                                ),
                              ),
                              DataCell(
                                Row(
                                  children: [
                                    IconButton(
                                      onPressed: () {
                                        edit(e['id']);
                                      },
                                      icon: Icon(Icons.edit),
                                    ),
                                    IconButton(
                                      onPressed: () {
                                        deleteRow(e['id']);
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          const SnackBar(
                                            content: Text('Deleted.'),
                                          ),
                                        );
                                      },
                                      icon: Icon(Icons.delete),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        )
                        .toList(),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 40,
            ),
          ],
        ),
      ),
    );
  }
}
