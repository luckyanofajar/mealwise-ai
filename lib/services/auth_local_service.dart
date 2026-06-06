import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthLocalService {
  static const String baseUrl = "http://192.168.1.5/mealwise_api";

  Future<Map<String, dynamic>?> login({
    required String username,
    required String password,
  }) async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/login.php"),
        body: {
          'username': username,
          'password': password,
        },
      );

      final data = jsonDecode(response.body);
      
      if (data['success'] == true) {
        // Simpan token ke SharedPreferences
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('local_token', data['token']);
        await prefs.setString('local_user', jsonEncode(data['user']));
        
        return data['user'];
      }
      return null;
    } catch (e) {
      print('Login error: $e');
      return null;
    }
  }

  Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('local_token') != null;
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('local_token');
    await prefs.remove('local_user');
  }
}