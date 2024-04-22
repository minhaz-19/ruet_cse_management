
import 'package:flutter/material.dart';
import 'package:ruet_cse_management/schedule/routine_home_pages.dart';

class routine extends StatefulWidget {
  const routine({super.key});

  @override
  State<routine> createState() => _routineState();
}

class _routineState extends State<routine> {
  Future<bool> _onWillPop() async {
    return (_selectedIndex == 0 ? true : set_index_to_zero());
  }

  bool set_index_to_zero() {
    setState(() {
      _selectedIndex = 0;
    });
    return false;
  }

  int _selectedIndex = 0;

  static List<Widget> _widgetOptions = <Widget>[
    first_year_home_page(),
    second_year_home_page(),
    third_year_home_page(),
    fourth_year_home_page()
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        body: Center(
          child: _widgetOptions.elementAt(_selectedIndex),
        ),
        bottomNavigationBar: BottomNavigationBar(
          unselectedIconTheme: IconThemeData(
            color: Colors.blueGrey,
          ),
          selectedIconTheme: IconThemeData(
            color: Colors.redAccent,
          ),
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: ImageIcon(
                AssetImage('images/1.png'),
              ),
              label: 'First Year',
            ),
            BottomNavigationBarItem(
              icon: ImageIcon(
                AssetImage('images/2.png'),
              ),
              label: 'Second Year',
            ),
            BottomNavigationBarItem(
              icon: ImageIcon(
                AssetImage('images/3.png'),
              ),
              label: 'Third Year',
            ),
            BottomNavigationBarItem(
              icon: ImageIcon(
                AssetImage('images/4.png'),
              ),
              label: 'Fourth Year',
            ),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.black,
          onTap: _onItemTapped,
        ),
      ),
    );
  }
}
