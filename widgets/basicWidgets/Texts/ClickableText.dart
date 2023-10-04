import 'package:flutter/cupertino.dart';

class ClickableText extends StatelessWidget {
  final VoidCallback ontap;
  final String text;
  final Color textcolor;
  final double fontsize;

  const ClickableText({super.key, required this.ontap, required this.text, required this.textcolor, required this.fontsize});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: ontap,
      child: Text(text,style: TextStyle(color: textcolor, fontSize: fontsize,fontWeight: FontWeight.w400)),
    );
  }
}
