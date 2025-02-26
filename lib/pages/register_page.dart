import 'package:flutter/material.dart';
import 'package:food_save/auth/auth_service.dart';
import 'package:food_save/component/my_button.dart';
import 'package:food_save/component/my_textfield.dart';

class RegisterPage extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmpasswordController =
      TextEditingController();
  final void Function()? onTap;
  RegisterPage({super.key, required this.onTap});

  void register(BuildContext context) async {
    final auth = AuthService();
    if (_passwordController.text == _confirmpasswordController.text) {
      try {
        await auth.signUpWithEmailPassword(
            _emailController.text, _passwordController.text);
      } catch (e) {
        showDialog(
            context: context,
            builder: (context) => AlertDialog(
                  title: Text(e.toString()),
                ));
      }
    } else {
      showDialog(
          context: context,
          builder: (context) => const AlertDialog(
                title: Text('Пароли не совпадают!'),
              ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Создать аккаунт',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10),
                    MyTextfield(
                      hintText: "EMAIL",
                      icon: Icon(Icons.mail_outline),
                      controller: _emailController,
                      obsecureText: false,
                    ),
                    MyTextfield(
                      hintText: "Пароль",
                      icon: Icon(Icons.lock),
                      controller: _passwordController,
                      obsecureText: true,
                    ),
                    MyTextfield(
                      hintText: "Пароль",
                      icon: Icon(Icons.lock),
                      controller: _confirmpasswordController,
                      obsecureText: true,
                    ),
                    SizedBox(
                      height: 25,
                    ),
                    MyButton(
                      text: "Регистрироваться",
                      onPressed: () => register(context),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Уже есть аккаунт?'),
                        GestureDetector(
                          onTap: onTap,
                          child: Text(
                            " Войти",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.green),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
