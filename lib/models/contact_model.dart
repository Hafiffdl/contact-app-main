import 'package:flutter/material.dart';

class ContactModel {
  int? id;
  String? nama;
  String? nomor;
  DateTime? selectedDate;
  Color? selectedColor;
  String? filePath;

  ContactModel({
    this.id,
    this.nama,
    this.nomor,
    this.selectedDate,
    this.selectedColor,
    this.filePath,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nama': nama,
      'nomor': nomor,
      'selectedDate': selectedDate.toString(),
      'selectedColor': selectedColor?.value.toString(), 
      'filePath': filePath,
    };
  }

  factory ContactModel.fromMap(Map<String, dynamic> map) {
    return ContactModel(
      id: map['id'],
      nama: map['nama'],
      nomor: map['nomor'],
      selectedDate: DateTime.parse(map['selectedDate']),
      selectedColor: Color(int.parse(map['selectedColor'])),
      filePath: map['filePath'],
    );
  }
}
