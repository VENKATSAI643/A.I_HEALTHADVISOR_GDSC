import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/HomePage.dart';
import 'package:http/http.dart' as http;

import '../../../components/already_have_an_account_acheck.dart';
import '../../../constants.dart';
import '../../Signup/components/signup_form.dart';

class LoginForm extends StatelessWidget {
  LoginForm({
    Key? key,
  }) : super(key: key);

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Column(
        children: [
          TextFormField(
            controller: emailController,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            cursorColor: kPrimaryColor,
            decoration: InputDecoration(
              hintText: "Your email",
              prefixIcon: Padding(
                padding: EdgeInsets.all(defaultPadding),
                child: Icon(Icons.person),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: defaultPadding),
            child: TextFormField(
              controller: passwordController,
              textInputAction: TextInputAction.done,
              obscureText: true,
              cursorColor: kPrimaryColor,
              decoration: InputDecoration(
                hintText: "Your password",
                prefixIcon: Padding(
                  padding: EdgeInsets.all(defaultPadding),
                  child: Icon(Icons.lock),
                ),
              ),
            ),
          ),
          const SizedBox(height: defaultPadding),
          ElevatedButton(
            onPressed: () {
              _performLogin(context);
            },
            child: Text(
              "Login".toUpperCase(),
            ),
          ),
          const SizedBox(height: defaultPadding),
          AlreadyHaveAnAccountCheck(
            press: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return const SignUpScreen();
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  void _performLogin(BuildContext context) async {
    // Get form data here
    final Map<String, dynamic> requestData = {
      'email': emailController.text,
      'password': passwordController.text,
    };

    final Uri apiUrl = Uri.parse(
        'https://r8kx87dz-3001.inc1.devtunnels.ms/FindUser'); // Replace with your API endpoint

    try {
      final response = await http.post(
        apiUrl,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(requestData),
      );

      if (response.statusCode == 200) {
        // Successful login, handle the response here
        print('Login successful! Response: ${response.body}');
        Navigator.push(context, MaterialPageRoute(
          builder: (context) {
            // Replace 'YourNextScreen()' with the widget for the next screen
            return HomePage();
          },
        ));
      } else {
        // Handle unsuccessful login
        print('Login failed! Response: ${response.body}');
      }
    } catch (error) {
      // Handle network errors
      print('Error during login: $error');
    }
  }
}

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign Up'),
      ),
      body: Center(
        child: Text('Sign Up Screen'),
      ),
    );
  }
}

class AlreadyHaveAnAccountCheck extends StatelessWidget {
  final Function press;

  const AlreadyHaveAnAccountCheck({
    Key? key,
    required this.press,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          "Don't have an account? ",
          style: TextStyle(color: kPrimaryColor),
        ),
        GestureDetector(
          onTap: () {
            press();
          },
          child: Text(
            "Sign Up",
            style: TextStyle(
              color: kPrimaryColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        )
      ],
    );
  }
}

const double defaultPadding = 16.0;
const Color kPrimaryColor = Colors.blue; // Change this to your primary color

void main() {
  runApp(
    MaterialApp(
      home: Scaffold(
        body: LoginForm(),
      ),
    ),
  );
}
