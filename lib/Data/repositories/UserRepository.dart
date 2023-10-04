import 'package:accii/Data/data_sources/FireBaseDS.dart';
import '../models/UserModel.dart';

class UserRepository {
  /// Save UserData
  Future<bool> saveUser(UserModel user) async {
    try {
      final userData = {
        'userName': user.userName,
        'phoneNumber': user.phoneNumber,
        'age': user.age,
        'bloodGroup': user.bloodGroup,
        'address': user.address,
      };
      bool profileStatus = await fbServices().saveuser(userData);

      if (profileStatus) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }
}
