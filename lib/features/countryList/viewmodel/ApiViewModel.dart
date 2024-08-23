import 'package:flutter/cupertino.dart';


import '../../../services/ApiService.dart';
import '../model/EuropeanCountryResponse.dart';

class ApiViewModel extends ChangeNotifier {
  ApiService _apiService =new ApiService();
  List<EuropeanCountryResponse> _data = [];
  bool _isLoading = false;

  List<EuropeanCountryResponse> get data => _data;
  bool get isLoading => _isLoading;

  Future<void> fetchData() async {
    _isLoading = true;
    notifyListeners();

    try {
      _data = await _apiService.getEuropeanCountries();
    } catch (e) {
      // Handle error
    }

    _isLoading = false;
    notifyListeners();
  }

  void sortCountriesAlphabetically() {
    _data.sort((a, b) => a.commonName.compareTo(b.commonName));
    notifyListeners();
  }

  void sortCountriesByCapital() {
    _data.sort((a, b) => a.capital.join(', ').compareTo(b.capital.join(', ')));
    notifyListeners();
  }

  void sortCountriesByPopulation() {
    _data.sort((a, b) => a.population.compareTo(b.population));
    notifyListeners();
  }
}
