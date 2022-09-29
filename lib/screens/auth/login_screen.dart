import 'package:dio_test/apis/rest_api.dart';
import 'package:dio_test/apis/rest_api_client.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final RestApi _restApi = RestApi();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('Hello World'),
          MaterialButton(
            onPressed: () {
              print("Clicked");
              _toVerificationScreen();
            },
            child: const Text('Click Me'),
          ),
        ],
      ),
    );
  }

  _toVerificationScreen() async {
    Get.toNamed('VerifyScreen');
    // _restApi.login({'username': 'Bold'}).then((response) {
    //   print("response: $response");
    // });
    //
    // CustomResponse response = await _restApi.login({'username': 'Bold'});
  }
}
