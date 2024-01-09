import 'package:flutter/material.dart';
import 'package:salsel_express/util/themes.dart';
import 'package:salsel_express/widget/general_widgets.dart';
import 'package:salsel_express/widget/login_widgets.dart';

class LoginView extends StatefulWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  bool _isPasswordVisible = false;
  final TextEditingController _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    double logoSize = MediaQuery.of(context).size.width * 0.6;

    return Scaffold(
      body: Container(
        color: Themes.backgroundColor,
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            buildLogo(logoSize),
            const SizedBox(height: 16.0),
            const Center(
              child: Text(
                'Login to your Account',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ),
            const SizedBox(height: 8.0),
            Center(
              child: buildForgotPasswordText(),
            ),
            const SizedBox(height: 24.0),
            buildEmailInputField('Email', Icons.email, _emailController),
            const SizedBox(height: 16.0),
            buildPasswordInputField(
              isPasswordVisible: _isPasswordVisible,
              togglePasswordVisibility: () {
                setState(() {
                  _isPasswordVisible = !_isPasswordVisible;
                });
              },
            ),
            const SizedBox(height: 32.0),
            buildLoginButton(context, _emailController),
            const SizedBox(height: 16.0),
          ],
        ),
      ),
    );
  }
}
