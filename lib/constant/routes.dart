import 'package:flutter/material.dart';
import 'package:salsel_express/view/home_view.dart';
import 'package:salsel_express/view/login_view.dart';

const String loginRoute = '/login';
const String homeRoute = '/home';

final Map<String, WidgetBuilder> routes = {
  loginRoute: (context) => const LoginView(),
  homeRoute: (context) => const HomeView(),
};
