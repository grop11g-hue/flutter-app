import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsProvider extends ChangeNotifier {
  SettingsProvider(this._prefs) {
    _notifications = _prefs.getBool(_kNotif) ?? true;
    _addresses.addAll(_prefs.getStringList(_kAddr) ?? const <String>[]);
  }

  final SharedPreferences _prefs;
  static const _kNotif = 'settings_notifications';
  static const _kAddr = 'settings_addresses';

  bool _notifications = true;
  final List<String> _addresses = [];

  bool get notificationsEnabled => _notifications;
  List<String> get addresses => List.unmodifiable(_addresses);

  void setNotifications(bool value) {
    _notifications = value;
    _prefs.setBool(_kNotif, value);
    notifyListeners();
  }

  void addAddress(String address) {
    _addresses.add(address.trim());
    _prefs.setStringList(_kAddr, _addresses);
    notifyListeners();
  }

  void removeAddress(int index) {
    if (index < 0 || index >= _addresses.length) return;
    _addresses.removeAt(index);
    _prefs.setStringList(_kAddr, _addresses);
    notifyListeners();
  }
}
