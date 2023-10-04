import 'package:accii/Presentation/views/Main_pages/fragments/OverviewPage.dart';
import 'package:accii/Presentation/views/Main_pages/fragments/ProfilePage.dart';
import 'package:flutter/material.dart';
import '../../widgets/navWidgets/customNavBar.dart';


class Homepage extends StatefulWidget {
  const Homepage({Key? key}) : super(key: key);

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> with WidgetsBindingObserver {

  @override
  void initState() {
    super.initState();
  }



  int _selectedIndex = 0;

  final List<Widget> _fragments = [
     Overview_page(),
    const Profile_page()
  ];

  void _onItemSelected(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: _fragments[_selectedIndex],
      extendBody: true,
      bottomNavigationBar: CustomDotNavigationBar(
        selectedIndex: _selectedIndex,
        onItemSelected: _onItemSelected,
      ),
    );
  }
}
