import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:salsel_express/constant/api_end_points.dart';
import 'package:salsel_express/model/ticket.dart';

Future<List<Ticket>> getTickets(String status, String token) async {
    String apiUrl = getAllTicketsUrl(status);
    final Uri uri = Uri.parse(apiUrl);

  final response = await http.get(uri,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },);

  if (response.statusCode == 200) {
    final List<dynamic> jsonList = json.decode(response.body);
    return jsonList.map((json) => Ticket.fromJson(json)).toList();
  } else {
    throw Exception('Failed to load tickets');
  }
}
