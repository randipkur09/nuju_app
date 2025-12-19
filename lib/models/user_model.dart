import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String id;
  final String email;
  final String name;
  final String role;
  final String? phoneNumber;
  final DateTime createdAt;
  final String? createdBy; // For barista accounts

  UserModel({
    required this.id,
    required this.email,
    required this.name,
    required this.role,
    this.phoneNumber,
    required this.createdAt,
    this.createdBy,
  });

  factory UserModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return UserModel(
      id: doc.id,
      email: data['email'] ?? '',
      name: data['name'] ?? '',
      role: data['role'] ?? 'customer',
      phoneNumber: data['phoneNumber'],
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      createdBy: data['createdBy'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'name': name,
      'role': role,
      'phoneNumber': phoneNumber,
      'createdAt': Timestamp.fromDate(createdAt),
      'createdBy': createdBy,
    };
  }
}
