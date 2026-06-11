import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  static const String baseUrl = "http://10.0.2.2:3000/api";
  static const int timeout = 10; // seconds

  static void _checkResponse(http.Response response) {
    if (response.statusCode == 401) {
      throw Exception('Non autorisé - Token expiré');
    }
    if (response.statusCode != 200 && response.statusCode != 201) {
      final errorBody = jsonDecode(response.body);
      throw Exception(errorBody['message'] ?? 'Erreur serveur');
    }
  }

  // LOGIN
  static Future<Map<String, dynamic>> login(
      String email, String password) async {
    try {
      final response = await http
          .post(
            Uri.parse('$baseUrl/auth/login'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({
              "email": email,
              "password": password,
            }),
          )
          .timeout(Duration(seconds: timeout));

      if (response.statusCode != 200) {
        final errorBody = jsonDecode(response.body);
        throw Exception(errorBody['message'] ?? 'Erreur login');
      }

      return jsonDecode(response.body);
    } on Exception {
      rethrow;
    }
  }

  // 🔐 récupérer token
  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  // 🔹 GET PRODUCTS
  static Future<List<dynamic>> getProducts() async {
    final token = await getToken();

    final response = await http
        .get(
          Uri.parse('$baseUrl/products'),
          headers: {
            'Authorization': 'Bearer $token',
          },
        )
        .timeout(Duration(seconds: timeout));

    _checkResponse(response);
    return jsonDecode(response.body);
  }

  // 🔹 ADD PRODUCT
  static Future<Map<String, dynamic>> addProduct(
      Map<String, dynamic> data) async {
    final token = await getToken();

    final response = await http
        .post(
          Uri.parse('$baseUrl/products'),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
          body: jsonEncode(data),
        )
        .timeout(Duration(seconds: timeout));

    _checkResponse(response);
    return jsonDecode(response.body);
  }

  // 🔹 UPDATE PRODUCT
  static Future<Map<String, dynamic>> updateProduct(
      int id, Map<String, dynamic> data) async {
    final token = await getToken();

    final response = await http
        .put(
          Uri.parse('$baseUrl/products/$id'),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
          body: jsonEncode(data),
        )
        .timeout(Duration(seconds: timeout));

    _checkResponse(response);
    return jsonDecode(response.body);
  }

  // 🔹 DELETE PRODUCT
  static Future<Map<String, dynamic>> deleteProduct(int id) async {
    final token = await getToken();

    final response = await http
        .delete(
          Uri.parse('$baseUrl/products/$id'),
          headers: {
            'Authorization': 'Bearer $token',
          },
        )
        .timeout(Duration(seconds: timeout));

    _checkResponse(response);
    return jsonDecode(response.body);
  }

  // 🔹 SEARCH
  static Future<List<dynamic>> searchProducts(String name) async {
    final token = await getToken();

    final response = await http
        .get(
          Uri.parse('$baseUrl/products/search?name=$name'),
          headers: {
            'Authorization': 'Bearer $token',
          },
        )
        .timeout(Duration(seconds: timeout));

    _checkResponse(response);
    return jsonDecode(response.body);
  }

  // 🔹 GET CATEGORIES
  static Future<List<dynamic>> getCategories() async {
    final token = await getToken();

    final response = await http
        .get(
          Uri.parse('$baseUrl/categories'),
          headers: {
            'Authorization': 'Bearer $token',
          },
        )
        .timeout(Duration(seconds: timeout));

    _checkResponse(response);
    return jsonDecode(response.body);
  }

  // 🔹 ADD CATEGORY
  static Future<Map<String, dynamic>> addCategory(String name) async {
    final token = await getToken();

    final response = await http
        .post(
          Uri.parse('$baseUrl/categories'),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
          body: jsonEncode({'name': name}),
        )
        .timeout(Duration(seconds: timeout));

    _checkResponse(response);
    return jsonDecode(response.body);
  }

  // 🔹 DELETE CATEGORY
  static Future<Map<String, dynamic>> deleteCategory(int id) async {
    final token = await getToken();

    final response = await http
        .delete(
          Uri.parse('$baseUrl/categories/$id'),
          headers: {
            'Authorization': 'Bearer $token',
          },
        )
        .timeout(Duration(seconds: timeout));

    _checkResponse(response);
    return jsonDecode(response.body);
  }
}