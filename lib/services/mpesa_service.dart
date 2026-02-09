import 'package:http/http.dart' as http;
import 'dart:convert';

class MpesaService {
  // Replace with your Node.js backend URL
  static const String baseUrl = 'YOUR_BACKEND_URL';
  
  Future<Map<String, dynamic>?> initiateSTKPush({
    required String phoneNumber,
    required double amount,
    required String orderId,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/mpesa/stkpush'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'phoneNumber': phoneNumber,
          'amount': amount,
          'orderId': orderId,
        }),
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        print('STK Push failed: ${response.body}');
        return null;
      }
    } catch (e) {
      print('Error initiating STK push: $e');
      return null;
    }
  }

  Future<Map<String, dynamic>?> checkTransactionStatus(String checkoutRequestId) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/mpesa/query'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'checkoutRequestId': checkoutRequestId,
        }),
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        return null;
      }
    } catch (e) {
      print('Error checking transaction status: $e');
      return null;
    }
  }
}