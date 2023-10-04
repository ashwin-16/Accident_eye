import 'package:accii/Presentation/views/Auth_pages/LoginPage.dart';
import 'package:accii/Presentation/views/Main_pages/HomePage.dart';
import 'package:flutter/material.dart';

import '../../Config/Utils/NavigationHelper.dart';
import '../../Data/repositories/AuthRepository.dart';

class AuthChecker extends StatefulWidget {
  const AuthChecker({Key? key}) : super(key: key);
  @override
  State<AuthChecker> createState() => _AuthCheckerState();
}

class _AuthCheckerState extends State<AuthChecker> {
  final AuthRepository _authRepository = AuthRepository();

  @override
  void initState() {
    super.initState();
    _checkUserAuthentication();
  }

  Future<void> _checkUserAuthentication() async {
    final user = await _authRepository.checkUserSignIn();
    if (user) {
      nextScreenReplace(context, const Homepage());
    } else {
      nextScreenReplace(context, LoginPage());
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
