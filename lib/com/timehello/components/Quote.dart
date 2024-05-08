import 'dart:convert';

import 'package:http/http.dart' as http;

class Quote {
  final String text;
  final String author;

  Quote({required this.text, required this.author});

  factory Quote.fromJson(Map<String, dynamic> json) {
    return Quote(text: json['quote'], author: json['author']);
  }
}

class QuoteApi {
  static const String baseUrl = 'https://quotes.rest/qod?category=management';

  static Future<List<Quote>> getQuotes(int count) async {
    final response = await http.get(Uri.parse('$baseUrl&limit=$count'));
    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      final quotesJson = json['contents']['quotes'] as List<dynamic>;
      return quotesJson.map((json) => Quote.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load quotes');
    }
  }
}
