import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';
import '../utils/constants.dart';

class AuthService extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  User? get currentUser => _auth.currentUser;
  UserModel? _currentUserData;
  UserModel? get currentUserData => _currentUserData;

  // Listen to auth state changes
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // Get current user data from Firestore
  Future<UserModel?> getCurrentUserData() async {
    if (currentUser == null) return null;
    
    try {
      DocumentSnapshot doc = await _firestore
          .collection(AppConstants.usersCollection)
          .doc(currentUser!.uid)
          .get();
      
      if (doc.exists) {
        _currentUserData = UserModel.fromFirestore(doc);
        notifyListeners();
        return _currentUserData;
      }
    } catch (e) {
      print('Error getting user data: $e');
    }
    return null;
  }

  // Register (Only for customers)
  Future<String?> register({
    required String email,
    required String password,
    required String name,
    String? phoneNumber,
  }) async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Create user document in Firestore
      await _firestore
          .collection(AppConstants.usersCollection)
          .doc(userCredential.user!.uid)
          .set({
        'email': email,
        'name': name,
        'role': AppConstants.roleCustomer,
        'phoneNumber': phoneNumber,
        'createdAt': FieldValue.serverTimestamp(),
      });

      await getCurrentUserData();
      return null; // Success
    } on FirebaseAuthException catch (e) {
      return e.message;
    } catch (e) {
      return e.toString();
    }
  }

  // Login
  Future<String?> login({
    required String email,
    required String password,
  }) async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      await getCurrentUserData();
      return null; // Success
    } on FirebaseAuthException catch (e) {
      return e.message;
    } catch (e) {
      return e.toString();
    }
  }

  // Sign Out
  Future<void> signOut() async {
    await _auth.signOut();
    _currentUserData = null;
    notifyListeners();
  }

  // Create Barista Account (Admin only)
  Future<String?> createBaristaAccount({
    required String email,
    required String password,
    required String name,
    String? phoneNumber,
  }) async {
    try {
      // Verify current user is admin
      if (_currentUserData?.role != AppConstants.roleAdmin) {
        return 'Only admin can create barista accounts';
      }

      final currentAdminEmail = _auth.currentUser?.email;
      
      // Create user in Firebase Auth
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Create user document in Firestore
      await _firestore
          .collection(AppConstants.usersCollection)
          .doc(userCredential.user!.uid)
          .set({
        'email': email,
        'name': name,
        'role': AppConstants.roleBarista,
        'phoneNumber': phoneNumber,
        'createdAt': FieldValue.serverTimestamp(),
        'createdBy': currentUser!.uid,
      });

      await _auth.signOut();
      
      // We can't automatically re-login without the admin's password
      print('[v0] Barista created successfully. Admin needs to login again.');

      return null; // Success
    } on FirebaseAuthException catch (e) {
      return e.message;
    } catch (e) {
      return e.toString();
    }
  }
}
