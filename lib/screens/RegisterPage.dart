import 'package:flutter/material.dart';
import 'package:mobile_inventory_system/screens/HomePage.dart';
import 'package:mobile_inventory_system/screens/LoginPage.dart';
import 'package:mobile_inventory_system/services/auth.dart';
import 'package:mobile_inventory_system/widget/button.dart';
import 'package:mobile_inventory_system/widget/snackbar.dart';
import 'package:mobile_inventory_system/widget/textField.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  // untuk controller
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  bool isLoading = false;

  void signUpUser() async {
    String res = await AuthService().signUpUser(
      email: emailController.text,
      password: passwordController.text,
      name: nameController.text,
    );

    // jika register berhasil berhasil, user ditambahin & pindah screen
    if (res == "Berhasil") {
      setState(() {
        isLoading = true;
      });
      // navigasi ke login
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const HomePage(),
        ),
      );
    } else {
      setState(() {
        isLoading = false;
      });
      // jika error
      showSnackBar(context, res);
    }
  }

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
              child: Image.asset("asset/registered.png"),
            ),
            TextFieldInput(
              textEditingController: nameController,
              hintText: "Masukkan Nama",
              icon: Icons.person,
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
            MyButton(onTab: signUpUser, text: "Sign Up"),
            SizedBox(height: height / 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Sudah punya akun?",
                  style: TextStyle(fontSize: 16),
                ),
                GestureDetector(
                  onTap: () {
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const LoginPage(),
                          ),
                        );
                      },
                    );
                  },
                  child: const Text(
                    "Login",
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
