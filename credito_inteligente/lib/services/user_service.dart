import 'dart:convert';

import '../models/user.dart';
import 'package:http/http.dart' as http;

class UserService {
  final String baseUrl = 'http://localhost:8090/api/users';

  Future<List<User>> getAllUsers() async {
    final url = Uri.parse(baseUrl);
    try {
      final response = await http.get(
        url,
        headers: {'content-type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body) as List<dynamic>;
        return jsonData.map((user) => User.fromJson(user)).toList();
      } else if (response.statusCode == 204) {
        return [];
      } else {
        throw Exception(
            'Failed to fetch users data. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to fetch users data. Error: $e');
    }
  }

  Future<User> getUserByEmailAndPassword(String email, String password) async {
    final url = Uri.parse('$baseUrl/login/$email/$password');

    print("URL: $url");

    try {
      final response = await http.get(
        url,
        headers: {'content-type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body) as Map<String, dynamic>;
        return User.fromJson(jsonData);
      } else if (response.statusCode == 404) {
        return User(
          id: 0,
          name: '',
          lastname: '',
          email: '',
          password: '',
        );
      } else {
        throw Exception(
            'Failed to fetch user data. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to fetch user data. Error: $e');
    }
  }

  //create user

  Future<User> createUser(User user) async {
    final url = Uri.parse(baseUrl);

    try {
      final response = await http.post(
        url,
        headers: {'content-type': 'application/json'},
        body: jsonEncode(user.toJson()),
      );

      if (response.statusCode == 201) {
        final jsonData = jsonDecode(response.body) as Map<String, dynamic>;
        return User.fromJson(jsonData);
      } else {
        throw Exception(
            'Failed to create user. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to create user. Error: $e');
    }
  }
}
