import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:salsel_express/constant/api_end_points.dart';
import 'package:salsel_express/model/awb.dart';
import 'package:salsel_express/model/city.dart';
import 'package:salsel_express/model/country.dart';
import 'package:salsel_express/model/product_type.dart';
import 'package:salsel_express/model/service_type.dart';

Future<Awb> createAirWayBill(Awb awb, String token) async {
  final Uri uri = Uri.parse(createAwbUrl);

  final response = await http.post(
    uri,
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    },
    body: json.encode(awb.toJson()),
  );

  if (response.statusCode == 200) {
    return Awb.fromJson(json.decode(response.body));
  } else {
    throw Exception('Failed to create AWB: ${response.statusCode}');
  }
}

Future<List<Country>> getCountries(String status, String token) async {
  String apiUrl = getAllCountriesUrl(status);
  final Uri uri = Uri.parse(apiUrl);

  final response = await http.get(
    uri,
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    },
  );

  if (response.statusCode == 200) {
    final List<dynamic> jsonList = json.decode(response.body);
    return jsonList.map((json) => Country.fromJson(json)).toList();
  } else {
    throw Exception('Failed to load Countries');
  }
}

Future<List<City>> getCities(int id, String token) async {
  String apiUrl = getAllCitiesByCountryUrl(id);
  final Uri uri = Uri.parse(apiUrl);

  final response = await http.get(
    uri,
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    },
  );

  if (response.statusCode == 200) {
    final List<dynamic> jsonList = json.decode(response.body);
    return jsonList.map((json) => City.fromJson(json)).toList();
  } else {
    throw Exception('Failed to load Cities');
  }
}

Future<List<Awb>> getAllAwbByAssignedUser(String user, bool status, String token) async {
    String apiUrl = getAwbByAssignedUserUrl(user,status);
    final Uri uri = Uri.parse(apiUrl);

  final response = await http.get(uri,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },);

  if (response.statusCode == 200) {
    final List<dynamic> jsonList = json.decode(response.body);
    return jsonList.map((json) => Awb.fromJson(json)).toList();
  } else {
    throw Exception('Failed to load awbs');
  }
}

Future<Awb> getAwbById(String awbId, String token) async {
  final String apiUrl = getAwbByIdUrl(awbId);
  final Uri uri = Uri.parse(apiUrl);

  final response = await http.get(
    uri,
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    },
  );

  if (response.statusCode == 200) {
    final dynamic jsonData = json.decode(response.body);
    return Awb.fromJson(jsonData);
  } else {
    throw Exception('Failed to load Awb');
  }
}

Future<List<ProductType>> getAllProductType(String status, String token) async {
  String apiUrl = getAllProductTypeUrl(status);
  final Uri uri = Uri.parse(apiUrl);

  final response = await http.get(
    uri,
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    },
  );

  if (response.statusCode == 200) {
    final List<dynamic> jsonList = json.decode(response.body);
    return jsonList.map((json) => ProductType.fromJson(json)).toList();
  } else {
    throw Exception('Failed to load all ProductType');
  }
}

Future<List<ServiceType>> getAllServiceType(int id, String token) async {
  String apiUrl = getAllServiceTypeByProductTypeUrl(id);
  final Uri uri = Uri.parse(apiUrl);

  final response = await http.get(
    uri,
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    },
  );

  if (response.statusCode == 200) {
    final List<dynamic> jsonList = json.decode(response.body);
    return jsonList.map((json) => ServiceType.fromJson(json)).toList();
  } else {
    throw Exception('Failed to load all Service Type');
  }
}