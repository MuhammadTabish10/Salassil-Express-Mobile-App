import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:salsel_express/constant/api_end_points.dart';
import 'package:salsel_express/model/awb.dart';
import 'package:salsel_express/model/product_field_values.dart';

Future<void> updateAwbStatusOnScan(
    int uniqueNumber, String status, String token) async {
  String apiUrl = updateAwbStatusByScanUrl(uniqueNumber, status);
  final Uri uri = Uri.parse(apiUrl);

  final response = await http.put(
    uri,
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    },
  );

  if (response.statusCode == 200) {
    print(response);
  } else {
    throw Exception('Failed to update AWB Status: ${response.statusCode}');
  }
}

Future<List<ProductFieldValues>> getProductFieldValues(
    String status, String token) async {
  String apiUrl = getAllProductFieldValuesByProductFieldUrl(status);
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
    return jsonList.map((json) => ProductFieldValues.fromJson(json)).toList();
  } else {
    throw Exception('Failed to load Awb Status');
  }
}

Future<Awb> getAwbByUniqueNumber(int uniqueNumber, String token) async {
  String apiUrl = getAwbByUniqueNumberUrl(uniqueNumber);
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
    throw Exception('Failed to load Awb by UniqueNumber');
  }
}