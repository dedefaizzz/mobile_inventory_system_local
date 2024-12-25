import 'package:flutter/material.dart';
import 'package:mobile_inventory_system/screens/RegisterPage.dart';
import 'package:mobile_inventory_system/widget/button.dart';
import 'package:mobile_inventory_system/widget/textField.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // untuk controller
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
          child: SizedBox(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              width: double.infinity,
              height: height / 2.7,
              child: Image.asset("asset/login.png"),
            ),
            TextFieldInput(
              textEditingController: emailController,
              hintText: "Masukkan Email",
              icon: Icons.email,
            ),
            TextFieldInput(
              textEditingController: passwordController,
              hintText: "Masukkan Password",
              icon: Icons.lock,
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 35),
              child: Align(
                alignment: Alignment.centerRight,
                child: Text(
                  "Forgot Password?",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.blue,
                  ),
                ),
              ),
            ),
            MyButton(onTab: () {}, text: "Log In"),
            SizedBox(height: height / 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Tidak punya akun?",
                  style: TextStyle(fontSize: 16),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const RegisterPage(),
                      ),
                    );
                  },
                  child: const Text(
                    "SignUp",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      )),
    );
  }
}
