import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  static const String baseUrl = "http://10.0.2.2:3000/api";

  // LOGIN
  static Future<Map<String, dynamic>> login(
      String email, String password) async {

    final response = await http.post(
      Uri.parse('$baseUrl/auth/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        "email": email,
        "password": password,
      }),
    );

    return jsonDecode(response.body);
  }

  // 🔐 récupérer token
  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  // 🔹 GET PRODUCTS
  static Future<List<dynamic>> getProducts() async {
    final token = await getToken();

    final response = await http.get(
      Uri.parse('$baseUrl/products'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    return jsonDecode(response.body);
  }

  // 🔹 ADD PRODUCT
  static Future addProduct(Map<String, dynamic> data) async {
    final token = await getToken();

    final response = await http.post(
      Uri.parse('$baseUrl/products'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(data),
    );

    return jsonDecode(response.body);
  }

  // 🔹 UPDATE PRODUCT
static Future updateProduct(int id, Map<String, dynamic> data) async {
  final token = await getToken();

  final response = await http.put(
    Uri.parse('$baseUrl/products/$id'),
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    },
    body: jsonEncode(data),
  );

  return jsonDecode(response.body);
}

// 🔹 DELETE PRODUCT
static Future deleteProduct(int id) async {
  final token = await getToken();

  final response = await http.delete(
    Uri.parse('$baseUrl/products/$id'),
    headers: {
      'Authorization': 'Bearer $token',
    },
  );

  return jsonDecode(response.body);
}

// 🔹 SEARCH
static Future<List<dynamic>> searchProducts(String name) async {
  final token = await getToken();

  final response = await http.get(
    Uri.parse('$baseUrl/products/search?name=$name'),
    headers: {
      'Authorization': 'Bearer $token',
    },
  );

  return jsonDecode(response.body);
}

// 🔹 GET CATEGORIES
static Future<List<dynamic>> getCategories() async {
  final token = await getToken();

  final response = await http.get(
    Uri.parse('$baseUrl/categories'),
    headers: {
      'Authorization': 'Bearer $token',
    },
  );

  return jsonDecode(response.body);
}


}