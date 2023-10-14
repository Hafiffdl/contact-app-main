import 'dart:io';
import 'package:interactive_widget/components/profile_sheet.dart';
import 'package:interactive_widget/constant/constant.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:interactive_widget/helper/database_helper.dart';
import 'package:interactive_widget/models/contact_model.dart';
import 'package:intl/intl.dart';
import 'package:open_file/open_file.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AdvanceForm extends StatefulWidget {
  const AdvanceForm({super.key});

  @override
  State<AdvanceForm> createState() => _AdvanceFormState();
}

class _AdvanceFormState extends State<AdvanceForm> {
  final dbHelper = DatabaseHelper();

  var formKey = GlobalKey<FormState>();

  String? nama = "";
  String? nomor = "";
  String? filePath;
  Color selectedColor = Colors.blue;

  List<ContactModel> dataList = [];

  DateTime? selectedDate = DateTime.now();
  final currentDate = DateTime.now();

  void pickFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ["jpg"],
      allowMultiple: true,
    );
    if (result == null) return;

    List<File> files = result.paths.map((path) => File(path!)).toList();
    List<PlatformFile> platformFiles = result.files;

    for (var i = 0; i < files.length; i++) {
      if (kDebugMode) {
        print(files[i].path);
      }
      if (kDebugMode) {
        print(platformFiles[i].name);
      }
    }

    for (var file in platformFiles) {
      _openFile(file);
    }
  }

  void _openFile(PlatformFile file) {
    OpenFile.open(file.path);
  }

  late SharedPreferences loginData;
  String username = "";

  @override
  void initState() {
    super.initState();
    getAllContacts();
    initial();
  }

  void initial() async {
    loginData = await SharedPreferences.getInstance();
    setState(() {
      username = loginData.getString("username")!;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: secondaryColor,
        title: const Center(child: Text('Contacts')),
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            onPressed: () {
              showModalBottomSheet(
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(20),
                  ),
                ),
                context: context,
                builder: (context) => const ProfileSheet(),
              );
            },
            icon: const Icon(Icons.account_circle),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(5.0),
          child: Column(
            children: <Widget>[
              const Center(child: Icon(Icons.phone, size: 30.0)),
              const SizedBox(height: 15.0,),
              const Text('Create new Contact', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),),
              const SizedBox(height: 5.0),
              const Text('Kumpulan Contact di Flutter Alterra Academy', style: TextStyle(fontSize: 15.0)),

              Container(
                padding: const EdgeInsets.all(8.0),
                margin: const EdgeInsets.all(0),
                child: Column(
                  children: [
                    Form(
                      key: formKey,
                      child: Container(
                        padding: const EdgeInsets.all(5.0),
                        child: Column(
                          children: [
                            TextFormField(
                              decoration: const InputDecoration(
                                filled: true,
                                fillColor: primaryColor,
                                labelText: 'Nama',
                                hintText: 'Masukkan Nama',
                                border: OutlineInputBorder(),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Masukkan Nama anda';
                                }
                                else if (value.trim().split(' ').length < 2) {
                                  return 'Nama harus terdiri minimal 2 kata';
                                }
                                for (var word in value.trim().split(' ')) {
                                  if (!RegExp(r"^[A-Z][a-z]*$").hasMatch(word)) {
                                    return 'Setiap kata harus diawali huruf kapital';
                                  }
                                  if (RegExp(r'[0-9!@#%^&*(),.?":{}|<>]').hasMatch(word)) {
                                    return 'Nama tidak boleh mengandung angka atau karakter khusus';
                                  }
                                }
                                return null;
                              },
                              onSaved: (value) {
                                nama = value;
                              },
                            ),
                            const SizedBox(
                              height: 10.0,
                            ),
                            TextFormField(
                              decoration: const InputDecoration(
                                filled: true,
                                fillColor: primaryColor,
                                labelText: "Nomor",
                                hintText: "+62...",
                                border: OutlineInputBorder(),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Masukkan Nomor Anda";
                                }
                                if (!RegExp(r"^\d+$").hasMatch(value)) {
                                  return "Nomor harus terdiri dari angka saja";
                                }
                                else if (value.length < 8 || value.length > 15) {
                                  return "Nomor harus minimal 8 digit dan maksimal 15 digit";
                                }
                                else if (!value.startsWith("0")) {
                                  return "Nomor harus diawali angka 0";
                                }
                                return null;
                              },
                              onSaved: (value) {
                                nomor = value;
                              },
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text('Date'),
                                    TextButton(
                                      onPressed: () async {
                                        final pickedDate = await showDatePicker(
                                          context: context,
                                          initialDate: DateTime.now(),
                                          firstDate: DateTime(2000),
                                          lastDate: DateTime(currentDate.year + 5),
                                        );

                                        setState(() {
                                          if (pickedDate != null){
                                            selectedDate = pickedDate;
                                          }
                                        });
                                      },
                                      child: const Text("Select Date"),
                                    ),
                                  ],
                                ),
                                Text(
                                  DateFormat("dd/MM/yyyy").format(selectedDate!),
                                ),
                              ],
                            ),
                            Container(
                              width: double.infinity,
                              height: 50.0,
                              margin: const EdgeInsets.only(top: 10),
                              decoration: BoxDecoration(
                                color: selectedColor,
                                shape: BoxShape.rectangle,
                              ),
                            ),
                            ElevatedButton(
                              style: const ButtonStyle(
                                backgroundColor: MaterialStatePropertyAll(primaryColor)),
                              onPressed: () async {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: const Text('Pick your Color'),
                                      content: SingleChildScrollView(
                                        child: BlockPicker(
                                          pickerColor: selectedColor,
                                          onColorChanged: (value) {
                                            setState(() {
                                              selectedColor = value;
                                            });
                                          },
                                        ),
                                      ),
                                      actions: <Widget>[
                                        TextButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: const Text('Save'),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                              child: const Text("Pick Color"),
                            ),
                            // Menampilkan warna yang dipilih
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('Pick File'),
                                Center(
                                  child: ElevatedButton(
                                    style: const ButtonStyle(
                                      backgroundColor: MaterialStatePropertyAll(primaryColor)),
                                    onPressed: () async {
                                      FilePickerResult? result = await FilePicker.platform.pickFiles();
                                      if (result != null) {
                                        setState(() {
                                          filePath = result.files.single.path;
                                        });
                                      }
                                    },
                                    child: const Text("Pick File and Open File "),
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    ElevatedButton(
                                      style: const ButtonStyle(
                                        backgroundColor: MaterialStatePropertyAll(primaryColor)),
                                      onPressed: addContact,
                                      child: const Text('Submit'),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // Tampilkan dataList dalam ListView
              Column(
                children: [
                  const Text(
                    'List Contact',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  ListView.builder(
                    shrinkWrap: true, // saya menambahkan shrinkWrap true agar tidak terjadi konflik scroll
                    physics:const NeverScrollableScrollPhysics(), // Nonaktifkan scrolling ListView
                    itemCount: dataList.length,
                    itemBuilder: (BuildContext context, int index) {
                      final data = dataList[index];
                      final firstName = data.nama?[0] ?? '';

                      return ListTile(
                        title: Text(data.nama ?? ''),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(data.nomor ?? ''),
                            Text('Date: ${DateFormat("dd/MM/yyyy").format(data.selectedDate ?? DateTime.now())}'),
                            Row(
                              children: [
                                const Text('Color: '),
                                Container(
                                  width: 15,
                                  height: 15,
                                  color: data.selectedColor,
                                ),
                              ],
                            ),
                            Text('Path File: ${data.filePath}'),
                          ],
                        ),
                        leading: CircleAvatar(
                          backgroundColor: secondaryColor,
                          child: Text(
                            firstName,
                            style: const TextStyle(
                              color: primaryColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit),
                              onPressed: () {
                                editData(index);
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () {
                                deleteData(index);
                              },
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void addContact() async {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();

      final contactModel = ContactModel(
        nama: nama,
        nomor: nomor,
        selectedDate: selectedDate,
        selectedColor: selectedColor,
        filePath: filePath,
      );

      await dbHelper.insertContact(contactModel);
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Data berhasil disimpan"),
      ));

      getAllContacts();

      setState(() {
        contactModel.id = dataList.length + 1; // dengan id start dari 1
        dataList.add(contactModel);
      });

      formKey.currentState!.reset();
    }
  }

  void getAllContacts() async {
    final contacts = await dbHelper.getContacts(); // mendapatkan contact dari database
    setState(() {
      dataList = contacts;
    });
  }

  void deleteData(int index) async {
    final contactId = dataList[index].id!;
    await dbHelper.deleteContact(contactId); // delete dari database
    setState(() {
      dataList.removeAt(index);
    });
  }

  void editData(int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        String editedName = dataList[index].nama ?? "";
        String editedNomor = dataList[index].nomor ?? "";

        return AlertDialog(
          title: const Text("Edit Contact"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                initialValue: editedName,
                onChanged: (value) {
                  editedName = value;
                },
                decoration: const InputDecoration(labelText: 'Nama'),
              ),
              TextFormField(
                initialValue: editedNomor,
                onChanged: (value) {
                  editedNomor = value;
                },
                decoration: const InputDecoration(labelText: 'Nomor'),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                dataList[index].nama = editedName;
                dataList[index].nomor = editedNomor;

                await dbHelper.updateContact(dataList[index]); // update buat database
                getAllContacts();
                // ignore: use_build_context_synchronously
                Navigator.of(context).pop();
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }
}
