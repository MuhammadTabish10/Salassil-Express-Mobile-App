// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:salsel_express/config/token_provider.dart';
import 'package:salsel_express/constant/routes.dart';
import 'package:salsel_express/service/login_service.dart';
import 'package:salsel_express/util/custom_toast.dart';
// import 'package:salsel_express/util/custom_toast.dart';
import 'package:salsel_express/util/helper.dart';
import 'package:salsel_express/util/themes.dart';

Widget buildForgotPasswordText() {
  return GestureDetector(
    onTap: () {
      // Add logic for resetting password here
    },
    child: const Text(
      'Forgot Password? Click here to reset',
      style: TextStyle(
        fontSize: 14,
        color: primarySwatch,
      ),
    ),
  );
}

Widget buildPasswordInputField({
  required bool isPasswordVisible,
  required Function togglePasswordVisibility,
  required  TextEditingController controller
}) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12.0),
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.3),
          spreadRadius: 2,
          blurRadius: 5,
          offset: const Offset(0, 3),
        ),
      ],
    ),
    child: TextFormField(
      controller: controller,
      obscureText: !isPasswordVisible,
      decoration: InputDecoration(
        labelText: 'Password',
        prefixIcon: const Icon(Icons.lock, color: primarySwatch),
        suffixIcon: GestureDetector(
          onTap: () {
            togglePasswordVisibility();
          },
          child: Icon(
            isPasswordVisible ? Icons.visibility : Icons.visibility_off,
            color: primarySwatch,
          ),
        ),
        border: InputBorder.none,
      ),
    ),
  );
}

Widget buildEmailInputField(
    String labelText, IconData prefixIcon, TextEditingController controller) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12.0),
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.3),
          spreadRadius: 2,
          blurRadius: 5,
          offset: const Offset(0, 3),
        ),
      ],
    ),
    child: TextFormField(
      controller: controller,
      keyboardType: TextInputType.emailAddress,
      validator: (value) {
        if (!isValidEmail(value!)) {
          return 'Enter a valid email address';
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: labelText,
        prefixIcon: Icon(prefixIcon, color: primarySwatch),
        border: InputBorder.none,
      ),
    ),
  );
}

Widget buildLoginButton(
    BuildContext context,
    TokenProvider tokenProvider,
    TextEditingController emailController,
    TextEditingController passwordController) {
  return ElevatedButton(
    onPressed: () async {
      LoginService result = await login(
          tokenProvider, emailController.text, passwordController.text);

      if (result.success) {
        Navigator.of(context).pushNamedAndRemoveUntil(
          homeRoute,
          (route) => false,
        );
        debugPrint('Login successful');
      } else {
        CustomToast.showAlert(context, result.errorMessage ?? 'Login failed');
        debugPrint('Login failed');
      }
    },
    style: ElevatedButton.styleFrom(
      primary: primarySwatch[500],
      onPrimary: Colors.white,
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
    ),
    child: Container(
      padding: const EdgeInsets.symmetric(
        vertical: 16.0,
        horizontal: 24.0,
      ),
      child: const Center(
        child: Text(
          'Login',
          style: TextStyle(fontSize: 18),
        ),
      ),
    ),
  );
}
