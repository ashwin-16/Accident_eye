import 'dart:developer';
import 'package:accii/Data/models/UserModel.dart';
import 'package:accii/Data/repositories/AuthRepository.dart';
import 'package:accii/Data/repositories/UserRepository.dart';
import 'package:accii/Presentation/views/Auth_pages/RegisterPage.dart';
import 'package:accii/Presentation/views/Main_pages/HomePage.dart';
import 'package:accii/Presentation/widgets/basicWidgets/Buttons/custonButton.dart';
import 'package:accii/Presentation/widgets/basicWidgets/TextFields/customTextField.dart';
import 'package:flutter/material.dart';

import '../../../Config/Utils/NavigationHelper.dart';
import '../../../Config/Utils/UxHelper.dart';
import '../../controllers/Auth_Controller.dart';
import '../../widgets/basicWidgets/Texts/ClickableText.dart';

class ProfileSetupPage extends StatefulWidget {
  @override
  _ProfileSetupPage createState() => _ProfileSetupPage();
}

class _ProfileSetupPage extends State<ProfileSetupPage> {
  final TextEditingController _userName = TextEditingController();
  final TextEditingController _phoneNumber = TextEditingController();
  final TextEditingController _age = TextEditingController();
  final TextEditingController _bloodGroup = TextEditingController();
  final TextEditingController _address = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Let's setup your profile",
                style: TextStyle(
                  color: Colors.black54,
                  fontSize: 24,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w300,
                  letterSpacing: -0.40,
                ),
              ),
              SizedBox(
                height: 25,
              ),
              BasicTextField(
                  controller: _userName,
                  hinttext: 'Full Name',
                  hiddentext: false,
                  suffix: const Icon(Icons.email_outlined),
                  suffixontap: () {}),
              const SizedBox(height: 16.0),
              BasicTextField(
                  controller: _phoneNumber,
                  hinttext: 'Phone Number',
                  hiddentext: false,
                  suffix: const Icon(Icons.remove_red_eye),
                  suffixontap: () {}),
              const SizedBox(height: 16.0),
              BasicTextField(
                  controller: _age,
                  hinttext: 'Age',
                  hiddentext: false,
                  suffix: const Icon(Icons.remove_red_eye),
                  suffixontap: () {}),
              const SizedBox(height: 16.0),
              BasicTextField(
                  controller: _bloodGroup,
                  hinttext: 'Blood Group',
                  hiddentext: false,
                  suffix: const Icon(Icons.remove_red_eye),
                  suffixontap: () {}),
              const SizedBox(height: 16.0),
              BasicTextField(
                  controller: _address,
                  hinttext: 'Address',
                  hiddentext: false,
                  suffix: const Icon(Icons.remove_red_eye),
                  suffixontap: () {}),
              const SizedBox(height: 16.0),
              BasicButton(
                Action_name: 'Create Profile',
                ontap: () {
                  createProfile(_userName.text, _phoneNumber.text, _age.text,
                      _bloodGroup.text, _address.text);
                },
                color: Colors.blue,
                textcolor: Colors.white,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void createProfile(userName, phoneNumber, age, bloodGroup, address) async {
    showProgressbar(context, "Creating profile");
    UserModel userModel = UserModel(
        userName: userName,
        phoneNumber: phoneNumber,
        age: age,
        bloodGroup: bloodGroup,
        address: address);

    bool result = await UserRepository().saveUser(userModel);
    if (result) {
      hideProgressbar(context);
      nextScreenReplace(context, const Homepage());
    } else {
      hideProgressbar(context);
      showSnackbar(
          context, Colors.blue, 'oops! something went wrong...try again');
      log('error');
    }
  }
}
