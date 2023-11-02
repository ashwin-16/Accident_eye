import 'dart:developer';

import 'package:accii/Config/Utils/NavigationHelper.dart';
import 'package:accii/Config/Utils/UxHelper.dart';
import 'package:accii/Data/repositories/AuthRepository.dart';
import 'package:accii/Presentation/views/Auth_pages/LoginPage.dart';
import 'package:accii/Presentation/views/Auth_pages/ProfileSetupPage.dart';
import 'package:accii/Presentation/widgets/basicWidgets/Buttons/customButton.dart';
import 'package:accii/Presentation/widgets/basicWidgets/TextFields/customTextField.dart';
import 'package:accii/Presentation/widgets/basicWidgets/Texts/clickableText.dart';
import 'package:flutter/material.dart';


class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade300,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/images/acci_bg.png',scale: 2,),
              const Text(
                'Create an account',
                style: TextStyle(
                  color: Colors.black54,
                  fontSize: 24,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w300,
                  letterSpacing: -0.40,
                ),
              ),
              const SizedBox(height: 25,),
              BasicTextField(
                  controller: _emailController,
                  hinttext: 'Email',
                  hiddentext: false,
                  suffix: const Icon(Icons.email_outlined),
                  suffixontap: () {}),
              const SizedBox(height: 15.0),
              BasicTextField(
                  controller: _passController,
                  hinttext: 'password',
                  hiddentext: false,
                  suffix: const Icon(Icons.remove_red_eye),
                  suffixontap: () {}),
              const SizedBox(height: 16.0),
              BasicButton(
                Action_name: 'Create account',
                ontap: () {
                  register(_emailController.text.trim(), _passController.text.trim());
                },
                color: Colors.blue,
                textcolor: Colors.white,
              ),
              const SizedBox(height: 20.0),
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Center(
                        child: Text(
                      'Already have an account? ',
                      style: TextStyle(fontSize: 13, color: Colors.black),
                    )),
                    const SizedBox(width: 2),
                    Center(
                        child: ClickableText(
                            ontap: switchPage,
                            text: 'Click here to login',
                            textcolor: Colors.blueAccent,
                            fontsize: 15))
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  ///for returning-user
  void switchPage() {
    nextScreenReplace(context, LoginPage());
  }

  void register(email, pass) async {
    showProgressbar(context, "Please wait, while we're finishing up");
    bool result = await AuthRepository().register(email, pass);
    if (result) {
      hideProgressbar(context);
      nextScreenReplace(context, ProfileSetupPage());
    } else {
      hideProgressbar(context);
      showSnackbar(context, Colors.blue, 'oops! something went wrong...try again');
      log('error');
    }
  }
}
