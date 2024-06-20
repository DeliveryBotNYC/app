import 'package:delivery_bot/screens/earning_screen/earning_screen.dart';
import 'package:delivery_bot/screens/schedule_screen/schedule_screen.dart';
import 'package:delivery_bot/screens/settings/settings.dart';
import 'package:delivery_bot/screens/tasks_list/tasks_list.dart';
import 'package:delivery_bot/utils/constants.dart';
import 'package:delivery_bot/utils/drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';

class HomeScreen extends StatefulWidget {

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  bool riderStatus = false;
  final _advancedDrawerController = AdvancedDrawerController();
  int selectedScreen =0;
  List screenLists;

  @override
  void initState() {
    super.initState();
    screenLists =[
      TaskList(advancedDrawerController: _advancedDrawerController, menuPressed: _handleMenuButtonPressed,),
      ScheduleScreen(advancedDrawerController: _advancedDrawerController, menuPressed: _handleMenuButtonPressed,),
      EarningScreen(advancedDrawerController: _advancedDrawerController, menuPressed: _handleMenuButtonPressed,),
      SettingsScreen(advancedDrawerController: _advancedDrawerController, menuPressed: _handleMenuButtonPressed,),
    ];
  }

  void _handleMenuButtonPressed() {
    // NOTICE: Manage Advanced Drawer state through the Controller.
    // _advancedDrawerController.value = AdvancedDrawerValue.visible();
    _advancedDrawerController.showDrawer();
  }

  void changeScreen(int screenIndex){
    setState(() {
      selectedScreen = screenIndex;
      _advancedDrawerController.hideDrawer();
    });
  }

  @override
  Widget build(BuildContext context) {
    return AdvancedDrawer(
      openRatio: 0.5,
      backdropColor: Constants.appOrangeColor,
      controller: _advancedDrawerController,
      animationCurve: Curves.easeInOut,
      animationDuration: const Duration(milliseconds: 300),
      childDecoration: const BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(16)),
      ),
      child: screenLists[selectedScreen],
      drawer: HomeDrawer(menuItemSelected: changeScreen,)
    );
  }
}