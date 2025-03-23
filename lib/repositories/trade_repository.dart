// lib/repositories/sport_repository.dart
import 'dart:convert';

import 'package:http/http.dart' as http;

class TradeRepository {
  final String baseUrl = 'http://188.242.219.244:61753';

  Future<String?> updateTrade({
    required String coinName,
    required String orderType,
    required double leverage,
  }) async {
    final body = {
      "trade_pair": {
        "trade_pair_id": "${coinName}USD",
        "trade_pair": "$coinName/USD",
        "fees": 0.001,
        "min_leverage": 0.01,
        "max_leverage": 0.5,
        "trade_pair_category": "crypto"
      },
      "order_type": orderType,
      "leverage": leverage,
      "api_key": "tunv"
    };

    final response = await http.post(
      Uri.parse('$baseUrl/api/receive-signal'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(body),
    );
    print("====> response: ${response.body}");
    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception('Failed to update trade');
    }
  }
}
