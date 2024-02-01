// ignore_for_file: use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:salsel_express/config/token_provider.dart';
import 'package:salsel_express/constant/routes.dart';
import 'package:salsel_express/util/themes.dart';
import 'package:salsel_express/view/login_view.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => TokenProvider(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Salassil Express',
      theme: appTheme,
      debugShowCheckedModeBanner: false,
      home: const LoginView(),
      routes: routes,
      initialRoute: '/login',
    );
  }
}
