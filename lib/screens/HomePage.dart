import 'package:flutter/material.dart';
import 'package:shoppy/services/firebase_services.dart';
import 'package:shoppy/tabs/home_tab.dart';
import 'package:shoppy/tabs/saved_tab.dart';
import 'package:shoppy/tabs/search_tab.dart';
import 'package:shoppy/widgets/bottom_tabs.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  FirebaseServices _firebaseServices = FirebaseServices();

  PageController? _tabsPageController;
  int _selectedTab = 0;

  @override
  void initState() {
    print("UserId: ${_firebaseServices.getUserId()}");
    _tabsPageController = PageController();
    super.initState();
  }

  @override
  void dispose() {
    _tabsPageController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
              child: PageView(
            controller: _tabsPageController,
            onPageChanged: (num) {
              setState(() {
                _selectedTab = num;
              });
            },
            children: [HomeTab(), SearchTab(), SavedTab()],
          )),
          BottomTabs(
            selectedTab: _selectedTab,
            tabPressed: (num) {
              _tabsPageController!.animateToPage(num,
                  duration: Duration(milliseconds: 300),
                  curve: Curves.easeInOutCubic);
            },
          ),
        ],
      ),
    );
  }
}
