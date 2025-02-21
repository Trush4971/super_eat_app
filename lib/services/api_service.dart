import 'package:http/http.dart' as http;
import 'dart:convert';

class ApiService {
  // search store method（Nominatim API）
  Future<List<dynamic>> searchStores(String query) async {
    // create API request URL
    final url = Uri.parse(
        'https://nominatim.openstreetmap.org/search?q=$query&format=json');

    // send GET request
    final response = await http.get(url);

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load stores');
    }
  }
}
