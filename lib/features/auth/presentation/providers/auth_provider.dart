import 'package:api_app/features/auth/domain/entities/user.dart';
import 'package:api_app/features/auth/domain/usecases/login_usecase.dart';
import 'package:flutter/material.dart';

class AuthProvider extends ChangeNotifier {
  final LoginUsecase loginUsecase;

  AuthProvider({required this.loginUsecase});

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  User? _currentUser;
  User? get currentUser => _currentUser;
  Future<bool> login(String username, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    try {
      final user = await loginUsecase(username, password);
      _currentUser = user;
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      notifyListeners();
      return false;
    }
  }
}
