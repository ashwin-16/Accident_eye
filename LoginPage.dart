// ignore_for_file: library_private_types_in_public_api, use_build_context_synchronously

import 'dart:developer';
import 'package:accii/Config/keyConstants.dart';
import 'package:accii/Data/repositories/AuthRepository.dart';
import 'package:accii/Presentation/views/Auth_pages/RegisterPage.dart';
import 'package:accii/Presentation/views/Main_pages/HospitalMonitor.dart';
import 'package:accii/Presentation/views/Main_pages/IdRecall.dart';
import 'package:accii/Presentation/widgets/basicWidgets/Buttons/customButton.dart';
import 'package:accii/Presentation/widgets/basicWidgets/TextFields/customTextField.dart';
import 'package:flutter/material.dart';

import '../../../Config/Utils/NavigationHelper.dart';
import '../../../Config/Utils/UxHelper.dart';
import '../../controllers/Auth_Controller.dart';
import '../../widgets/basicWidgets/Texts/clickableText.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade300,
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 150),
                Image.asset('assets/images/acci_bg.png',scale: 2,),
                const Text(
                  'Hey there, welcome back',
                  style: TextStyle(
                    color: Colors.black54,
                    fontSize: 24,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w300,
                    letterSpacing: -0.40,
                  ),
                ),
                const SizedBox(height: 25,),
                BasicTextField(controller: _emailController, hinttext: 'Email', hiddentext: false, suffix: const Icon(Icons.email_outlined), suffixontap: (){}),
                const SizedBox(height: 16.0),
                BasicTextField(controller: _passController, hinttext: 'password', hiddentext: false, suffix: const Icon(Icons.remove_red_eye), suffixontap: (){}),
                const SizedBox(height: 16.0),
                BasicButton(Action_name: 'Login', ontap: () {
                    roleSelect(_emailController.text.trim(), _passController.text.trim());
                }, color: Colors.blue, textcolor: Colors.white,),
                const SizedBox(height: 20),
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Center(child: Text('New user? ',style: TextStyle(fontSize: 13,color: Colors.black),)),
                      const SizedBox(width: 2),
                      Center(child: ClickableText(ontap: switchPage, text: 'Create an account', textcolor: Colors.blueAccent, fontsize: 15))
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  ///for new-user
  void switchPage(){
    nextScreenReplace(context, const RegisterPage());
  }

  void login(email,pass) async{
    showProgressbar(context, "Checking credentials");
    bool result = await AuthRepository().login(email, pass);

    if(result){
      hideProgressbar(context);
      nextScreenReplace(context,const IdRecall());
    }
    else{
      hideProgressbar(context);
      showSnackbar(context, Colors.blue, 'oops! something went wrong...try again');
      log('error');
    }
  }

  void roleSelect(email,pass) async{
    if(email == Constants().hMail && pass == Constants().hPass){
      showProgressbar(context, "Checking credentials");
      bool result = await AuthRepository().login(email, pass);

      if(result){
        hideProgressbar(context);
        nextScreenReplace(context,const HospitalMonitorModel());
      }
      else{
        hideProgressbar(context);
        showSnackbar(context, Colors.blue, 'oops! something went wrong...try again');
        log('error');
      }
    }
    else{
      login(email, pass);
    }
  }
}

