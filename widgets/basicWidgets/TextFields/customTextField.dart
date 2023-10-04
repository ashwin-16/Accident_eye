import 'package:flutter/material.dart';

class BasicTextField extends StatefulWidget {

  final TextEditingController controller;
  final String hinttext;
  final bool hiddentext;
  final Widget suffix;
  final VoidCallback suffixontap;

  const BasicTextField({super.key,required this.controller,
    required this.hinttext,required this.hiddentext, required this.suffix, required this.suffixontap});

  @override
  State<BasicTextField> createState() => _BasicTextFieldState();
}

class _BasicTextFieldState extends State<BasicTextField> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width:  (MediaQuery.of(context).size.width)* .85,
        child: TextField(
          style: const TextStyle(color: Colors.white), // Set input text color here
          controller: widget.controller,
          obscureText: widget.hiddentext,
          decoration: InputDecoration(
            labelStyle: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w300,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: const BorderSide(color: Colors.grey, width: 1),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: const BorderSide(color: Colors.white, width: 0),
            ),
            fillColor: Colors.grey.shade900,
            filled: true,
            hintText: widget.hinttext,
            hintStyle: TextStyle(color: Colors.grey[500]),
            suffixIcon: GestureDetector(
              onTap: widget.suffixontap,
              child: widget.suffix,
            ),
          ),
        ),
      ),
    );
  }
}
