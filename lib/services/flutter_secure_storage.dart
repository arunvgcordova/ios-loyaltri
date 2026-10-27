import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';

import '../models/punch_type_model.dart';
import '../models/user_api_model.dart';
import '../models/user_profile_api_model.dart';

class SecureStorageUtils {
  final _getIt = GetIt.instance;
  static const FlutterSecureStorage _storage = FlutterSecureStorage(
    aOptions: AndroidOptions(
      encryptedSharedPreferences: true,
      resetOnError: true,
    ),
    iOptions: IOSOptions(
      accessibility: KeychainAccessibility.first_unlock,
    ),
  );

  Future<void> initialize() async {
    _getIt.registerSingleton<SecureStorageUtils>(this);
  }

  Future<void> _safeWrite(String key, String value) async {
    try {
      await _storage.write(key: key, value: value);
    } catch (e) {
      try {
        await _storage.deleteAll();
        await _storage.write(key: key, value: value);
      } catch (_) {}
    }
  }

  Future<String?> _safeRead(String key) async {
    try {
      return await _storage.read(key: key);
    } catch (e) {
      try {
        await _storage.deleteAll();
      } catch (_) {}
      return null;
    }
  }

  Future<void> _safeDelete(String key) async {
    try {
      await _storage.delete(key: key);
    } catch (e) {
      try {
        await _storage.deleteAll();
      } catch (_) {}
    }
  }

  // General helpers to replace direct SharedPreferences usages across the app
  Future<String?> getString(String key) async {
    return await _safeRead(key);
  }

  Future<void> setString(String key, String value) async {
    await _safeWrite(key, value);
  }

  Future<void> remove(String key) async {
    await _safeDelete(key);
  }

  Future<bool> setRememberMe(LoginCredentials loginData) async {
    Map<String, dynamic> jsonMap = loginData.toJson(loginData);
    await _safeWrite("login", json.encode(jsonMap));
    return true;
  }

  Future<LoginCredentials?> getRememberMe() async {
    String? result = await _safeRead("login");
    if (result != null) {
      Map<String, dynamic> jsonData = json.decode(result);
      return LoginCredentials.fromJson(jsonData);
    }
    return null;
  }

  Future<LoginCredentials?> deleteRememberMe() async {
    await _safeDelete("login");
    return null;
  }

  Future<bool> setUserData(Map<String, dynamic> jsonMap) async {
    await _safeWrite("userData", json.encode(jsonMap));
    return true;
  }

  Future<UserAPI?> getUserData() async {
    String? result = await _safeRead("userData");
    if (result != null) {
      Map<String, dynamic> jsonData = json.decode(result);
      return UserAPI.fromJson(jsonData);
    }
    return null;
  }

  Future<bool> removeUserData() async {
    await _safeDelete("userData");
    return true;
  }

  Future<bool> setSplash() async {
    await _safeWrite("login_splash", "true");
    return true;
  }

  Future<bool?> getSplash() async {
    String? val = await _safeRead("login_splash");
    if (val == null) return null;
    return val == "true";
  }

  Future<bool> setFace(String user) async {
    await _safeWrite("faceData", user);
    return true;
  }

  Future<String?> getFace() async {
    return await _safeRead("faceData");
  }

  Future<bool> setProfileData(Map<String, dynamic> jsonMap) async {
    await _safeWrite("profileData", json.encode(jsonMap));
    return true;
  }

  Future<UserProfileApiModel?> getProfileData() async {
    String? result = await _safeRead("profileData");
    if (result != null) {
      Map<String, dynamic> jsonData = json.decode(result);
      return UserProfileApiModel.fromJson(jsonData);
    }
    return null;
  }

  Future<bool> removeProfileData() async {
    await _safeDelete("profileData");
    return true;
  }

  Future<bool> setPunchTypeData(Map<String, dynamic> jsonMap) async {
    await _safeWrite("punchTypeData", json.encode(jsonMap));
    return true;
  }

  Future<PunchTypeModel?> getPunchTypeData() async {
    String? result = await _safeRead("punchTypeData");
    if (result != null) {
      Map<String, dynamic> jsonData = json.decode(result);
      return PunchTypeModel.fromJson(jsonData);
    }
    return null;
  }

  Future<bool> removePunchTypeData() async {
    await _safeDelete("punchTypeData");
    return true;
  }

  Future<bool> setErrorOccurs(String error) async {
    await _safeWrite("errorSave", error);
    return true;
  }

  Future<String?> getErrorOccurs() async {
    return await _safeRead("errorSave");
  }

  Future<bool> removeErrorOccurs() async {
    await _safeDelete("errorSave");
    return true;
  }
}