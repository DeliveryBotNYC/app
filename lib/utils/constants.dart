import 'dart:async';

import 'package:delivery_bot/model/app_user.dart';
import 'package:delivery_bot/services/app_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:location/location.dart';

class Constants {
  static final Constants _singleton = new Constants._internal();
  static String appName = "Delivery Bot";
  static AppUser appUser;
  static bool isUserOnline = false;
  static bool isFirstTimeAppLaunched = true;
  static Function callBackFunction;
  static Function loadOrdersFunction;
  static LocationData userLocation;
  //COLORS
  static Color appThemeColor = Color(0xFF2e3842);
  static Color appOrangeColor = Color(0xFFefa138);
  static Color textFieldColor = Color(0xFF424953);
  static Color textFieldTextColor = Color(0xFF8f9399);
  //APIS
  static String baseUrl = "https://portal.deliverybotnyc.com/api/";
  static String loginUrl = baseUrl + "login.php";
  static String signUpUrl = baseUrl + "signup.php";
  static String getOrders =
      baseUrl + "auth.php?action=get_orders&status=Scheduled";
  static String myProfile = baseUrl + "auth.php?action=get_profile";
  static String updateMyProfile = baseUrl + "update_profile.php";
  static String getOrderProofRequirements =
      baseUrl + "auth.php?action=get_delivery_proof&company_id={companyId}";
  static String getOrderUploadedProofs =
      baseUrl + "/auth.php?action=get_order_proof&tracking_id={tracking_id}";
  static String uploadOrderProof = baseUrl + "/uploads.php";
  static String getSchedule = baseUrl + "auth.php?action=get_schedule";
  static String updateOrderStatus = baseUrl + "updates.php";
  static String updatDriverOnlineStatus = baseUrl + "updates.php";
  static String getEarningStats = baseUrl + "updates.php";
  static String getRating = baseUrl + "auth.php?action=get_rating";
  static String scheduleForDay = baseUrl + "updates.php";
  static String createOrder = baseUrl + "updates.php";

  static Timer _timer;
  static Location location = new Location();

  factory Constants() {
    return _singleton;
  }

  Constants._internal();

  static void showDialog(String message) {
    Get.generalDialog(
        pageBuilder: (context, __, ___) => AlertDialog(
              title: Text(appName),
              content: Text(message),
              actions: [
                FlatButton(
                    onPressed: () {
                      Get.back();
                    },
                    child: Text('OK'))
              ],
            ));
  }

  static void startTimer() {
    if (_timer == null) {
      const oneSec = const Duration(seconds: 30);
      _timer = new Timer.periodic(
          oneSec, (Timer timer) => {updateLocationOnServer()});
    }
  }

  static void updateLocationOnServer() async {
    if (Constants.isUserOnline) {
      userLocation = await location.getLocation();
      print(userLocation.latitude);
      print(userLocation.longitude);
      await AppController()
          .updateDriverLocation(userLocation.latitude, userLocation.longitude);
      if (loadOrdersFunction != null) await loadOrdersFunction();
    }
  }
}
