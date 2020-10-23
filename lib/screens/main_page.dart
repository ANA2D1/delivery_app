import 'package:delivery_app/screens/google_sign_in.dart';
import 'package:delivery_app/screens/home_page.dart';
import 'package:delivery_app/screens/map_page.dart';
import 'package:delivery_app/screens/new_order_chat_page.dart';
import 'package:delivery_app/screens/orders_page.dart';
import 'package:delivery_app/screens/partner_pages/partner_order_list_page.dart';
import 'package:flutter/material.dart';

class MainPage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<MainPage> {
  int _currenPageIndex = 0;

  final _menuItems = [
    BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: "Home"),
    BottomNavigationBarItem(
        icon: Icon(Icons.shopping_bag_outlined), label: "Orders"),
    BottomNavigationBarItem(
        icon: Icon(Icons.notification_important_outlined),
        label: "Notifications"),
    BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
  ];
  void _menuTap(index) {
    if (_currenPageIndex != index) {
      setState(() {
        _currenPageIndex = index;
      });
    }
  }

  List<Widget> _pages = [
    HomePage(),
    OrdersPage(),
    PartnerOrderList(),
    SignInDemo()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currenPageIndex],
      floatingActionButton: FloatingActionButton(
        heroTag: "new order",
        child: Icon(Icons.add),
        onPressed: () => Navigator.of(context)
            .push(MaterialPageRoute(builder: (_) => NewOrderChatPage())),
      ),
      // floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomNavigationBar(
        elevation: 5.0,
        selectedItemColor: Colors.red,
        unselectedItemColor: Colors.grey,
        currentIndex: _currenPageIndex,
        items: _menuItems,
        onTap: _menuTap,
      ),
    );
  }
}
