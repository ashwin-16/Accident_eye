import 'package:accii/Data/repositories/AuthRepository.dart';
import 'package:accii/Presentation/controllers/Auth_Controller.dart';
import 'package:accii/Presentation/widgets/basicWidgets/Buttons/custonButton.dart';
import 'package:flutter/material.dart';

import '../../../../Config/Utils/NavigationHelper.dart';

class Profile_page extends StatelessWidget {
  const Profile_page({super.key});

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      backgroundColor: Colors.white12,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Profile Page",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w400,
                color: Colors.white, // Change the color here to your desired color
              ),
            ),

            const SizedBox(height: 10),
            BasicButton(Action_name: 'Logout', ontap: (){
              AuthRepository().signOut();
              nextScreenReplace(context,const AuthChecker());
            }, color: Colors.blue, textcolor: Colors.white)
          ],
        ),
      ),
    );
  }
}
