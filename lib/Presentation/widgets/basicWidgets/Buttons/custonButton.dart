import 'package:flutter/material.dart';

class BasicButton extends StatelessWidget {
  final String Action_name;
  final VoidCallback? ontap;
  final Color color;
  final Color textcolor;

  const BasicButton({Key? key, required this.Action_name, required this.ontap, required this.color, required this.textcolor});

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: ontap,
      padding: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(100),
      ),
      splashColor: Colors.blue,
      child: Ink(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100),
          color: color,
        ),
        child: Container(
          width: MediaQuery.of(context).size.width * 0.85,
          height: 50,
          alignment: Alignment.center,
          child: Text(
            Action_name,
            style:  TextStyle(
              fontSize: 16,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w700,
              color: textcolor
            ),
          ),
        ),
      ), // Set the desired splash color here
    );
  }
}
