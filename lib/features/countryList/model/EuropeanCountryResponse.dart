// class EuropeanCountryResponse {
//   final String commonName;
//   final String officialName;
//   // final Flag flag;
//   final List<String> capital;
//   final Map<String, String> languages;
//   final int population;
//
//   EuropeanCountryResponse({
//     required this.commonName,
//     required this.officialName,
//     // required this.flag,
//     required this.capital,
//     required this.languages,
//     required this.population, required nativeNames, required flagPng, required flagSvg, required flagAlt,
//   });
//
//   factory EuropeanCountryResponse.fromJson(Map<String, dynamic> json) {
//     return EuropeanCountryResponse(
//       commonName: json['name']['common'],
//       officialName: json['name']['official'],
//       // flag: Flag.fromJson(json['flags']),
//       capital: List<String>.from(json['capital']),
//       languages: Map<String, String>.from(json['languages']),
//       population: json['population'], nativeNames: null, flagPng: null, flagSvg: null, flagAlt: null,
//     );
//   }
//
//   fromJson(json) {}
// }
//
// class Flag {
//   final String png;
//   final String svg;
//   final String alt;
//
//   Flag({
//     required this.png,
//     required this.svg,
//     required this.alt,
//   });
//
//   factory Flag.fromJson(Map<String, dynamic> json) {
//     return Flag(
//       png: json['png'],
//       svg: json['svg'],
//       alt: json['alt'],
//     );
//   }
// }

class EuropeanCountryResponse {
  final String commonName;
  final String officialName;
  final List<String> capital;
  final Map<String, String> languages;
  final int population;
  final Map<String, dynamic> nativeNames;
  final String flagPng;
  final String flagSvg;
  final String flagAlt;

  EuropeanCountryResponse({
    required this.commonName,
    required this.officialName,
    required this.capital,
    required this.languages,
    required this.population,
    required this.nativeNames,
    required this.flagPng,
    required this.flagSvg,
    required this.flagAlt,
  });

  factory EuropeanCountryResponse.fromJson(Map<String, dynamic> json) {
    return EuropeanCountryResponse(
      commonName: json['name']['common'] as String,
      officialName: json['name']['official'] as String,
      capital: List<String>.from(json['capital'] ?? []),
      languages: Map<String, String>.from(json['languages'] ?? {}),
      population: json['population'] as int,
      nativeNames: json['name']['nativeName'] as Map<String, dynamic>,
      flagPng: json['flags']['png'] as String,
      flagSvg: json['flags']['svg'] as String,
      flagAlt: json['flags']['alt'] as String,
    );
  }
}
