import 'dart:convert';
import 'package:salsel_express/config/token_provider.dart';
import 'package:http/http.dart' as http;
import 'package:salsel_express/constant/api_end_points.dart';

class LoginService {
  final bool success;
  final String? errorMessage;

  LoginService(this.success, {this.errorMessage});  
}

Future<LoginService> login(TokenProvider tokenProvider, String email, String password) async {
  try {
    final response = await http.post(
      Uri.parse(loginUrl),
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'email': email,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      // Login successful, extract user token from the response
      final Map<String, dynamic> responseData = json.decode(response.body);
      String token = responseData['jwt'].toString();

      // Use the TokenProvider to store the token
      tokenProvider.setToken(token);
      return LoginService(true);

    } else {
      // Login failed, handle the error
      final Map<String, dynamic> errorData = json.decode(response.body);
      if (errorData.containsKey('phone')) {
        final String emailError = errorData['email'].toString();
        return LoginService(false, errorMessage: emailError);
      } else if (errorData.containsKey('password')) {
        final String passwordError = errorData['password'].toString();
        return LoginService(false, errorMessage: passwordError);
      } else {
        final String errorMessage = errorData['error'].toString();
        return LoginService(false, errorMessage: errorMessage);
      }
    }
  } catch (error) {
    return LoginService(false, errorMessage: 'Network or API error');
  }
}
