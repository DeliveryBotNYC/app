import 'package:delivery_bot/model/app_user.dart';
import 'package:delivery_bot/screens/home_screen/home_screen.dart';
import 'package:delivery_bot/screens/location_permission/location_permission.dart';
import 'package:delivery_bot/screens/sign_in/sign_in.dart';
import 'package:delivery_bot/utils/constants.dart';
import 'package:delivery_bot/utils/size_config.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> { @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 2), () {
      Get.offAll(LocationPermissonScreen());//checkIfUserLoggedIn();
    });
  }

   void checkIfUserLoggedIn() async {
    Constants.appUser = await AppUser.getUserDetail();
    if (Constants.appUser.userName.isNotEmpty)
    {
      Get.offAll(HomeScreen());
    }
    else
    {
      Get.offAll(LoginScreen());
    }
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      backgroundColor: Constants.appThemeColor,
      body:  Container(
        width: SizeConfig.blockSizeHorizontal * 100,
        height: SizeConfig.blockSizeVertical * 100,
      ),
    );
  }
}