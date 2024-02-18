import 'package:salsel_express/model/country.dart';

class City {
  int? id;
  String? name;
  bool? status;
  Country? country;

  City({
    this.id,
    this.name,
    this.status,
    this.country,
  });

  factory City.fromJson(Map<String, dynamic> json) {
    return City(
      id: json['id'],
      name: json['name'],
      status: json['status'],
      country: json['country'] != null ? Country.fromJson(json['country']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'status': status,
      'country': country?.toJson(),
    };
  }
}