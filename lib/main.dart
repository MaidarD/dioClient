import 'package:dio_test/apis/rest_api_client.dart';
import 'package:dio_test/screens/auth/login_screen.dart';
import 'package:dio_test/screens/home/home_screen.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:dio_test/utils/routes.dart';

void main() {
  RestApiClient.init(baseUrl: '');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      initialRoute: loginRoute,
      routes: <String, WidgetBuilder>{
        homeRoute: (context) => const HomeScreen(),
        loginRoute: (context) => const LoginScreen(),
      },
    );
  }
}