import 'dart:convert';
import 'package:http/http.dart' as http;

import '../features/countryList/model/EuropeanCountryResponse.dart';

class ApiService {
  final String apiUrl = 'https://restcountries.com/v3.1/region/europe?fields=name,capital,flags,region,languages,population';

  Future<List<EuropeanCountryResponse>> getEuropeanCountries() async {
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((json) => EuropeanCountryResponse.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load data');
    }
  }
}
