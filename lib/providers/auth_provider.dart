import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/user.dart';

/// Local (demo) authentication: there is no backend in this version.
/// - Any valid e-mail + password (6+ chars) can log in.
/// - If an account was created with Sign Up, the password must match.
class AuthProvider extends ChangeNotifier {
  AuthProvider(this._prefs) {
    _load();
  }

  final SharedPreferences _prefs;

  static const _kUser = 'auth_user';
  static const _kPwd = 'auth_pwd';
  static const _kLogged = 'auth_logged_in';
  static const _kGuest = 'auth_guest';

  AppUser? _user;
  bool _loggedIn = false;
  bool _guest = false;

  bool get isAuthenticated => _loggedIn || _guest;
  bool get isGuest => _guest;

  AppUser get currentUser {
    if (_guest) {
      return const AppUser(name: 'Guest', email: 'guest@sportix.app');
    }
    return _user ?? const AppUser(name: 'Athlete', email: '');
  }

  void _load() {
    final raw = _prefs.getString(_kUser);
    if (raw != null) {
      try {
        _user = AppUser.fromJson(jsonDecode(raw) as Map<String, dynamic>);
      } catch (_) {
        _user = null;
      }
    }
    _loggedIn = _prefs.getBool(_kLogged) ?? false;
    _guest = _prefs.getBool(_kGuest) ?? false;
  }

  // ---------- validators (used by the forms) ----------
  static String? validateEmail(String? v) {
    final value = v?.trim() ?? '';
    if (value.isEmpty) return 'Please enter your email';
    final ok = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(value);
    return ok ? null : 'Enter a valid email address';
  }

  static String? validatePassword(String? v) {
    final value = v ?? '';
    if (value.isEmpty) return 'Please enter your password';
    if (value.length < 6) return 'Password must be at least 6 characters';
    return null;
  }

  static String? validateName(String? v) {
    final value = v?.trim() ?? '';
    if (value.isEmpty) return 'Please enter your name';
    if (value.length < 2) return 'Name is too short';
    return null;
  }

  static String? validatePhone(String? v) {
    final value = v?.trim() ?? '';
    if (value.isEmpty) return null; // optional
    final ok = RegExp(r'^\+?[0-9\s\-]{7,15}$').hasMatch(value);
    return ok ? null : 'Enter a valid phone number';
  }

  static String _hash(String s) => s.hashCode.toString();

  static String _nameFromEmail(String email) {
    final local = email.split('@').first;
    if (local.isEmpty) return 'Athlete';
    return local[0].toUpperCase() + local.substring(1);
  }

  /// Returns an error message, or null on success.
  Future<String?> login(String email, String password) async {
    await Future<void>.delayed(const Duration(milliseconds: 600));
    final mail = email.trim();
    final stored = _user;
    final storedPwd = _prefs.getString(_kPwd);

    if (stored != null &&
        stored.email.toLowerCase() == mail.toLowerCase() &&
        storedPwd != null &&
        storedPwd != _hash(password)) {
      return 'Incorrect password. Please try again.';
    }

    if (stored == null || stored.email.toLowerCase() != mail.toLowerCase()) {
      _user = AppUser(name: _nameFromEmail(mail), email: mail);
      await _prefs.remove(_kPwd);
    }
    _loggedIn = true;
    _guest = false;
    await _persist();
    notifyListeners();
    return null;
  }

  Future<String?> signUp(String name, String email, String password) async {
    await Future<void>.delayed(const Duration(milliseconds: 600));
    _user = AppUser(name: name.trim(), email: email.trim());
    await _prefs.setString(_kPwd, _hash(password));
    _loggedIn = true;
    _guest = false;
    await _persist();
    notifyListeners();
    return null;
  }

  Future<void> continueAsGuest() async {
    _guest = true;
    _loggedIn = false;
    await _persist();
    notifyListeners();
  }

  Future<void> logout() async {
    _guest = false;
    _loggedIn = false;
    await _persist();
    notifyListeners();
  }

  Future<void> updateProfile({
    required String name,
    required String email,
    required String phone,
  }) async {
    _user = currentUser.copyWith(
      name: name.trim(),
      email: email.trim(),
      phone: phone.trim(),
    );
    await _persist();
    notifyListeners();
  }

  Future<void> _persist() async {
    if (_user != null) {
      await _prefs.setString(_kUser, jsonEncode(_user!.toJson()));
    }
    await _prefs.setBool(_kLogged, _loggedIn);
    await _prefs.setBool(_kGuest, _guest);
  }
}
