import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../features/countryList/view/home.dart';

class Routes {
  static const String landingscreen = '/home';

  // Declare cameras as a static variable

  // Modify generateRoute method to accept cameras parameter
  static Route<dynamic> generateRoute(
      RouteSettings settings) {
    switch (settings.name) {
      case landingscreen:
        return MaterialPageRoute(builder: (context) => MyHomePage());
      default:
        throw FormatException("Routes not found");
    }
  }
}
