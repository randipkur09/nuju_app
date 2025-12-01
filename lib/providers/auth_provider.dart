import 'package:flutter/material.dart';
import '../models/user_model.dart';

class AuthProvider extends ChangeNotifier {
  User? _currentUser;
  bool _isLoading = false;
  String? _errorMessage;
  bool _isLoggedIn = false;

  User? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isLoggedIn => _isLoggedIn;
  String? get userRole => _currentUser?.role;

  // Mock user data - Replace dengan API call
  final Map<String, User> _mockUsers = {
    'customer@nuju.com': User(
      id: '1',
      name: 'Pelanggan Demo',
      email: 'customer@nuju.com',
      password: 'password123',
      phone: '081234567890',
      role: 'customer',
      createdAt: DateTime.now(),
    ),
    'barista@nuju.com': User(
      id: '2',
      name: 'Barista Demo',
      email: 'barista@nuju.com',
      password: 'password123',
      phone: '081234567891',
      role: 'barista',
      createdAt: DateTime.now(),
    ),
    'admin@nuju.com': User(
      id: '3',
      name: 'Admin Demo',
      email: 'admin@nuju.com',
      password: 'password123',
      phone: '081234567892',
      role: 'admin',
      createdAt: DateTime.now(),
    ),
  };

  Future<bool> register({
    required String name,
    required String email,
    required String password,
    required String phone,
    required String role,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await Future.delayed(const Duration(seconds: 1));

      if (_mockUsers.containsKey(email)) {
        _errorMessage = 'Email sudah terdaftar';
        _isLoading = false;
        notifyListeners();
        return false;
      }

      final newUser = User(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: name,
        email: email,
        password: password,
        phone: phone,
        role: role,
        createdAt: DateTime.now(),
      );

      _mockUsers[email] = newUser;
      _currentUser = newUser;
      _isLoggedIn = true;
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = 'Gagal mendaftar: ${e.toString()}';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> login({
    required String email,
    required String password,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await Future.delayed(const Duration(seconds: 1));

      final user = _mockUsers[email];
      if (user == null || user.password != password) {
        _errorMessage = 'Email atau password salah';
        _isLoading = false;
        notifyListeners();
        return false;
      }

      _currentUser = user;
      _isLoggedIn = true;
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = 'Gagal login: ${e.toString()}';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<void> logout() async {
    _isLoading = true;
    notifyListeners();

    try {
      await Future.delayed(const Duration(milliseconds: 500));
      _currentUser = null;
      _isLoggedIn = false;
      _errorMessage = null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
