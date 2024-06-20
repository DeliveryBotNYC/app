import 'package:delivery_bot/screens/add_order/add_order.dart';
import 'package:delivery_bot/utils/constants.dart';
import 'package:delivery_bot/utils/size_config.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeDrawer extends StatefulWidget {
  
  final Function menuItemSelected;
  HomeDrawer({this.menuItemSelected});

  @override
  _HomeDrawerState createState() => _HomeDrawerState();
}

class _HomeDrawerState extends State<HomeDrawer> {
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return SafeArea(
      child: Container(
        color: Constants.appOrangeColor,
        child: ListTileTheme(
          textColor: Colors.white,
          iconColor: Colors.white,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Container(
                margin: EdgeInsets.only(top: 40, bottom: 24.0,),
                child: Image.asset(
                  'assets/logo.png',
                  height: SizeConfig.blockSizeVertical * 15,
                  width: SizeConfig.blockSizeHorizontal * 35,
                ),
              ),

              Container(
                height: 2,
                width: SizeConfig.safeBlockHorizontal * 45,
                color: Colors.white,
                margin: EdgeInsets.only(bottom: 20.0,),
              ),
              ListTile(
                onTap: () {
                  widget.menuItemSelected(0);
                },
                leading: Icon(Icons.list_alt_outlined),
                title: Text('Tasks'),
              ),                           
              ListTile(
                onTap: () {
                  widget.menuItemSelected(1);
                },
                leading: Icon(Icons.alarm),
                title: Text('Schedule'),
              ),
              ListTile(
                onTap: () {
                  widget.menuItemSelected(2);
                },
                leading: Icon(Icons.attach_money_outlined),
                title: Text('Earnings'),
              ),
              ListTile(
                onTap: () {
                  widget.menuItemSelected(3);
                },
                leading: Icon(Icons.settings),
                title: Text('Settings'),
              ),
              Spacer(),
              ListTile(
                onTap: () {
                  Get.to(AddOrder());
                },
                leading: Icon(Icons.settings, color: Colors.transparent,),
                title: Text('Add Order', style: TextStyle(color: Colors.transparent),),
              ),
            ],
          ),
        ),
      ),
    );
  }
}