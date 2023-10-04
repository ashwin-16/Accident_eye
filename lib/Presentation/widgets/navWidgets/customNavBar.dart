import 'package:flutter/material.dart';
import 'package:dot_navigation_bar/dot_navigation_bar.dart';

class CustomDotNavigationBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemSelected;

  const CustomDotNavigationBar({
    Key? key,
    required this.selectedIndex,
    required this.onItemSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: DotNavigationBar(
        margin: const EdgeInsets.only(left: 10, right: 10),
        currentIndex: selectedIndex,
        backgroundColor: const Color(0xFF00D1FF),
        dotIndicatorColor: Colors.blueGrey,
        unselectedItemColor: Colors.black,
        splashBorderRadius: 50,
        onTap: onItemSelected,
        items: [
          DotNavigationBarItem(
            icon: const Icon(Icons.home_filled),
            selectedColor: const Color(0xff73544C),
          ),
          DotNavigationBarItem(
            icon: const Icon(Icons.person),
            selectedColor: const Color(0xff73544C),
          ),
        ],
      ),
    );
  }
}
