import 'package:accii/Data/data_sources/FireBaseDS.dart';

class AuthRepository {
  final fbServices fbs = fbServices();

  ///register user
  Future<bool> register(email, pass) async {
    bool regStatus = await fbs.register(email, pass);
    if (regStatus == true) {
      return true;
    } else {
      return false;
    }
  }

  ///signIn user
  Future<bool> login(email, pass) async {
    bool loginStatus = await fbs.login(email, pass);
    if (loginStatus == true) {
      return true;
    } else {
      return false;
    }
  }

  ///signOut user
  Future<void> signOut() {
    return fbs.signout();
  }

  ///check user sign in status
  Future<bool> checkUserSignIn() {
    return fbs.checkUserSignInStatus();
  }
}
