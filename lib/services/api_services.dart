import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_application_4/models/transaction.dart';

class ApiService {
  // URL dan token API
  static const String _baseUrl = 'https://api.ynab.com/v1/budgets'; // URL API YNAB
  static const String token = 'yHZTv1LTjoQ74LKrWPywjXmKCP1KIxnA0w7KH9cq3Sc'; // Token API

  // Mendapatkan daftar budget dari API YNAB
  static Future<List<Transaction>> getBudgets() async {
    final response = await http.get(
      Uri.parse(_baseUrl),
      headers: {
        'Authorization': 'Bearer $token', // Menambahkan token ke header
      },
    );
    
    // Mengecek status kode HTTP
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      // Menangani data yang diterima, misalnya memetakan ke dalam model Transaction
      final List<dynamic> budgets = data['data']['budgets']; // Pastikan ini sesuai dengan struktur respons dari API YNAB
      return budgets.map((item) => Transaction.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load data');
    }
  }
}
