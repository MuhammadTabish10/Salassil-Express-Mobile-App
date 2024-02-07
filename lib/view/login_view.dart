import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:salsel_express/config/token_provider.dart';
import 'package:salsel_express/service/login_service.dart';
import 'package:salsel_express/util/themes.dart';
import 'package:salsel_express/widget/general_widgets.dart';
import 'package:salsel_express/widget/login_widgets.dart';

class LoginView extends StatefulWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> with TickerProviderStateMixin {
  bool _isPasswordVisible = false;
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;
  late Future<LoginService> _loginFuture;

  @override
  void initState() {
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _loginFuture = Future.value(LoginService(false));
    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    TokenProvider tokenProvider = Provider.of<TokenProvider>(context, listen: false);
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
              controller: _passwordController,
            ),
            const SizedBox(height: 32.0),
            buildLoginButton(context, _loginFuture, tokenProvider, _emailController, _passwordController),
            const SizedBox(height: 16.0),
          ],
        ),
      ),
    );
  }
}
