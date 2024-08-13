import 'package:finance_admin/view/screens/dashboard.dart';
import 'package:finance_admin/view/widgets/toaster.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  bool _loading = false;

  Future<void> _login() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _loading = true;
      });

      var headers = {'Content-Type': 'application/json'};
      var request = http.Request(
        'POST',
        Uri.parse('http://localhost:5000/v1/auth/login'),
      );
      request.body = json.encode({
        "EmailId": _emailController.text,
        "Password": _passwordController.text,
      });
      request.headers.addAll(headers);

      try {
        http.StreamedResponse response = await request.send();

        String responseBodyString = await response.stream.bytesToString();

        if (response.statusCode == 200 || response.statusCode == 201) {
          Map<String, dynamic> responseBody = json.decode(responseBodyString);
          String userId = responseBody['userId'];
          String token = responseBody['token'];

          SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setString('userId', userId);
          prefs.setString('token', token);

          showToast("Login successful!", Colors.green);
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const HomeScreen(),
            ),
          );
        } else {
          showToast('Login failed. ${response.reasonPhrase}', Colors.red);
        }
      } catch (e) {
        showToast("Error during login: $e", Colors.red);
      } finally {
        setState(() {
          _loading = false;
        });
      }
    }
  }

  Widget buildTextFieldWithIcon({
    required TextEditingController controller,
    required String hintText,
    required bool isRequired,
  }) {
    return Container(
      height: 50,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: const Color.fromARGB(255, 240, 239, 239),
      ),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          isDense: true,
          border: InputBorder.none,
          focusedBorder: InputBorder.none,
          enabledBorder: InputBorder.none,
          errorBorder: InputBorder.none,
          disabledBorder: InputBorder.none,
          contentPadding: const EdgeInsets.all(16),
          hintText: hintText,
          suffixIcon: isRequired
              ? const Icon(
                  Icons.star,
                  color: Colors.red,
                  size: 8.0,
                )
              : null,
        ),
        validator: (value) {
          if (isRequired && (value == null || value.isEmpty)) {
            return 'This field is required';
          }
          return null;
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return Scaffold(
      body: Center(
        child: Material(
          elevation: 10,
          borderRadius: BorderRadius.circular(30),
          child: Container(
            height: size.height * .6,
            // width: size.width * .4,
            width: 400,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.blueGrey[100]),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: size.width * .02),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // SizedBox(height: 20),
                    const Text(
                      "Login",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 33,
                      ),
                    ),
                    const SizedBox(height: 40),
                    buildTextFieldWithIcon(
                      controller: _emailController,
                      hintText: 'Email',
                      isRequired: true,
                    ),
                    const SizedBox(height: 20),
                    buildTextFieldWithIcon(
                      controller: _passwordController,
                      hintText: 'Password',
                      isRequired: true,
                    ),
                    const SizedBox(height: 40),
                    SizedBox(
                      width: size.width * .5,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: _loading ? null : _login,
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              const Color.fromARGB(255, 61, 124, 251),
                        ),
                        child: _loading
                            ? const CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Color.fromARGB(255, 61, 124, 251),
                                ),
                              )
                            : const Text(
                                'Login',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                      ),
                    ),
                    // const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
