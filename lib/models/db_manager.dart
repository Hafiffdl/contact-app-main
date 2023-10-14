import 'package:flutter/material.dart';
import 'package:interactive_widget/helper/database_helper.dart';
import 'package:interactive_widget/models/contact_model.dart'; 

class DBManager with ChangeNotifier {
  List<ContactModel> contactModels = [];
  late DatabaseHelper _databaseHelper;

  List<ContactModel> get contacts => contactModels;

  DBManager() {
    _databaseHelper = DatabaseHelper();
    getAllContacts();
  }

  void getAllContacts() async {
    contactModels = await _databaseHelper.getContacts();
    notifyListeners();
  }

  void addContact(ContactModel contactModel) async {
    await _databaseHelper.insertContact(contactModel);
    getAllContacts();
  }

  void updateContact(ContactModel contactModel) async {
    await _databaseHelper.updateContact(contactModel);
    getAllContacts();
  }

  void deleteContact(int id) async {
    await _databaseHelper.deleteContact(id);
    getAllContacts();
  }

  Future<ContactModel> getContactById(int id) async {
    return await _databaseHelper.getContactById(id);
  }

}
