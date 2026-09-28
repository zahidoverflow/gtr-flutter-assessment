import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static const String _tokenKey = 'auth_token';
  static const String _userNameKey = 'user_name';
  static const String _userEmailKey = 'user_email';
  static const String _companyNameKey = 'company_name';
  static const String _userIdKey = 'user_id';
  static const String _comIdKey = 'com_id';

  final SharedPreferences _prefs;

  StorageService(this._prefs);

  static Future<StorageService> init() async {
    final prefs = await SharedPreferences.getInstance();
    return StorageService(prefs);
  }

  // Token management
  Future<bool> saveToken(String token) async => await _prefs.setString(_tokenKey, token);
  String? getToken() => _prefs.getString(_tokenKey);
  bool hasToken() => _prefs.containsKey(_tokenKey) && (_prefs.getString(_tokenKey)?.isNotEmpty ?? false);

  // User details
  Future<void> saveUserData({
    required String userName,
    required String email,
    required String companyName,
    required int userId,
    required int comId,
  }) async {
    await _prefs.setString(_userNameKey, userName);
    await _prefs.setString(_userEmailKey, email);
    await _prefs.setString(_companyNameKey, companyName);
    await _prefs.setInt(_userIdKey, userId);
    await _prefs.setInt(_comIdKey, comId);
  }

  String? getUserName() => _prefs.getString(_userNameKey);
  String? getUserEmail() => _prefs.getString(_userEmailKey);
  String? getCompanyName() => _prefs.getString(_companyNameKey);
  int? getUserId() => _prefs.getInt(_userIdKey);
  int? getComId() => _prefs.getInt(_comIdKey);

  // Clear session on logout
  Future<bool> clearSession() async {
    await _prefs.remove(_tokenKey);
    await _prefs.remove(_userNameKey);
    await _prefs.remove(_userEmailKey);
    await _prefs.remove(_companyNameKey);
    await _prefs.remove(_userIdKey);
    await _prefs.remove(_comIdKey);
    return true;
  }
}
