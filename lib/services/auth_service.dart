import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
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
      final doc = await _firestore
          .collection(AppConstants.usersCollection)
          .doc(currentUser!.uid)
          .get();

      if (doc.exists) {
        _currentUserData = UserModel.fromFirestore(doc);
        notifyListeners();
        return _currentUserData;
      }
    } catch (e) {
      debugPrint('Error getting user data: $e');
    }
    return null;
  }

  // Helper: get role dari Firestore (biar gak tergantung _currentUserData yang kadang null)
  Future<String?> _getRoleFromFirestore(String uid) async {
    try {
      final doc = await _firestore
          .collection(AppConstants.usersCollection)
          .doc(uid)
          .get();

      if (!doc.exists) return null;
      final data = doc.data() as Map<String, dynamic>?;
      return data?['role']?.toString();
    } catch (e) {
      debugPrint('Error fetching role: $e');
      return null;
    }
  }

  // Helper: secondary auth supaya admin tidak ketendang saat create user baru
  Future<FirebaseAuth> _getSecondaryAuth() async {
    FirebaseApp secondaryApp;

    try {
      secondaryApp = Firebase.app('secondary');
    } catch (_) {
      final primaryOptions = Firebase.app().options;
      secondaryApp = await Firebase.initializeApp(
        name: 'secondary',
        options: primaryOptions,
      );
    }

    return FirebaseAuth.instanceFor(app: secondaryApp);
  }

  // Register (Only for customers)
  Future<String?> register({
    required String email,
    required String password,
    required String name,
    String? phoneNumber,
  }) async {
    try {
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

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
      return null;
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
      return null;
    } on FirebaseAuthException catch (e) {
      return e.message;
    } catch (e) {
      return e.toString();
    }
  }

  // Sign In with Google


  // Sign Out
  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      debugPrint('Error signing out: $e');
    }
    _currentUserData = null;
    notifyListeners();
  }

  // ✅ Create Barista Account (Admin only) - FIXED (tidak logout, firestore masuk)
  Future<String?> createBaristaAccount({
    required String email,
    required String password,
    required String name,
    String? phoneNumber,
  }) async {
    FirebaseAuth? secondaryAuth;
    User? createdBaristaUser;

    try {
      final adminUser = _auth.currentUser;
      if (adminUser == null) return 'User not logged in';

      final adminUid = adminUser.uid;

      // ✅ cek admin dari firestore
      final roleRaw = await _getRoleFromFirestore(adminUid);
      final role = (roleRaw ?? '').toLowerCase();
      final adminRoleConst = AppConstants.roleAdmin.toLowerCase();

      if (role != adminRoleConst) {
        return 'Only admin can create barista accounts';
      }

      // ✅ buat barista pakai secondary auth biar admin TIDAK pindah akun
      secondaryAuth = await _getSecondaryAuth();

      final cred = await secondaryAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      createdBaristaUser = cred.user;
      if (createdBaristaUser == null) {
        return 'Failed to create barista user';
      }

      final baristaUid = createdBaristaUser.uid;

      // ✅ tulis firestore pakai admin (karena admin masih login di main auth)
      await _firestore
          .collection(AppConstants.usersCollection)
          .doc(baristaUid)
          .set({
        'email': email,
        'name': name,
        'role': AppConstants.roleBarista,
        'phoneNumber': phoneNumber,
        'createdAt': FieldValue.serverTimestamp(),
        'createdBy': adminUid,
      });

      // ✅ logout secondary saja (bukan logout admin)
      await secondaryAuth.signOut();

      // refresh user data admin tetap
      await getCurrentUserData();

      return null; // Success
    } on FirebaseAuthException catch (e) {
      // rollback kalau auth barista sudah kebuat tapi firestore gagal/terhenti
      if (createdBaristaUser != null) {
        try {
          await createdBaristaUser.delete();
        } catch (_) {}
      }
      return e.message;
    } catch (e) {
      // rollback juga
      if (createdBaristaUser != null) {
        try {
          await createdBaristaUser.delete();
        } catch (_) {}
      }
      // pastikan secondary signout
      try {
        await secondaryAuth?.signOut();
      } catch (_) {}

      return e.toString();
    }
  }
}
