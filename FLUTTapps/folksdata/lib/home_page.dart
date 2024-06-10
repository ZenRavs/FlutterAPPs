import 'dart:core';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  final formKey = GlobalKey<FormState>();
  TextEditingController idController = TextEditingController();
  TextEditingController cardNumController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController bDateController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController zipController = TextEditingController();

  DateTime? _selectedDate;
  String _formattedDate = '';

  late dynamic db = null;
  List<Map<String, Object?>> folksIDmap = [];

  @override
  void initState() {
    super.initState();
    //setupDatabase();
  }

  void save() async {
    await db.insert(
      'folks_ID',
      {
        "id": idController.text,
        "card_num": cardNumController.text,
        "name": nameController.text,
        "address": addressController.text,
        "zip": zipController.text
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    fieldClear();
    retrieve();
  }

  void confirmDelete(BuildContext context, id) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm'),
          content: const Text('Delete?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                // ScaffoldMessenger.of(context).showSnackBar(
                //   const SnackBar(
                //     content: Text('Deleted!'),
                //   ),
                // );
                delete(id);
              },
              child: Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  void retrieve() async {
    final List<Map<String, Object?>> folksIDmap = await db.query('folks_ID');
    setState(
      () {
        this.folksIDmap = folksIDmap;
      },
    );
  }

  void delete(id) async {
    await db.delete(
      'folks_ID',
      where: 'id = ?',
      whereArgs: [id],
    );
    retrieve();
  }

  void fieldClear() {
    cardNumController.text = '';
    nameController.text = '';
    addressController.text = '';
    zipController.text = '';
  }

  Future<DateTime?> selectDate(BuildContext context) async {
    final now = DateTime.now();
    final initialDate = now.subtract(Duration(days: 30));
    final lastDate = now.add(Duration(days: 30));

    final pickedDate = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: initialDate,
      lastDate: lastDate,
    );

    if (pickedDate != null) {
      return pickedDate;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: formKey,
      appBar: AppBar(
        title: const Text("FolksDATA"),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Container(
          padding: const EdgeInsets.all(20),
          width: double.infinity,
          height: double.infinity,
          child: Column(
            children: [
              TextField(
                controller: idController,
                keyboardType: const TextInputType.numberWithOptions(),
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                decoration: const InputDecoration(
                  label: Text("ID"),
                ),
              ),
              TextField(
                keyboardType: const TextInputType.numberWithOptions(),
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                controller: cardNumController,
                decoration: const InputDecoration(
                  label: Text("Card Number"),
                ),
              ),
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  label: Text("Name"),
                ),
              ),
              TextField(
                controller: addressController,
                decoration: const InputDecoration(
                  label: Text("Address"),
                ),
              ),
              TextField(
                keyboardType: const TextInputType.numberWithOptions(),
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                controller: zipController,
                decoration: const InputDecoration(
                  label: Text("Zip Code"),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              ElevatedButton(
                onPressed: () {
                  save();
                },
                child: const Text("Save"),
              ),
              const SizedBox(
                height: 20,
              ),
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                      columns: const [
                        DataColumn(
                          label: Text('ID'),
                        ),
                        DataColumn(
                          label: Text('Card Number'),
                        ),
                        DataColumn(
                          label: Text('Name'),
                        ),
                        DataColumn(
                          label: Text('Address'),
                        ),
                        DataColumn(
                          label: Text('Zip Code'),
                        ),
                        DataColumn(
                          label: Text("Actions"),
                        ),
                      ],
                      rows: folksIDmap
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
                                    e['card_num'].toString(),
                                  ),
                                ),
                                DataCell(
                                  Text(
                                    e['name'].toString(),
                                  ),
                                ),
                                DataCell(
                                  Text(
                                    e['address'].toString(),
                                  ),
                                ),
                                DataCell(
                                  Text(
                                    e['zip'].toString(),
                                  ),
                                ),
                                DataCell(
                                  IconButton(
                                    onPressed: () =>
                                        confirmDelete(context, e['id']),
                                    icon: const Icon(Icons.delete),
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
            ],
          ),
        ),
      ),
    );
  }
}
