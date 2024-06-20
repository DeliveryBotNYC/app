import 'dart:async';
import 'dart:io';
import 'package:delivery_bot/model/app_user.dart';
import 'package:delivery_bot/screens/home_screen/home_screen.dart';
import 'package:delivery_bot/screens/sign_in/sign_in.dart';
import 'package:delivery_bot/utils/constants.dart';
import 'package:delivery_bot/utils/size_config.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:location/location.dart';
import 'package:location_permissions/location_permissions.dart' as PL;


class LocationPermissonScreen extends StatefulWidget {
  @override
  _LocationPermissonScreenState createState() => _LocationPermissonScreenState();
}

class _LocationPermissonScreenState extends State<LocationPermissonScreen> {

  bool showLoading = true;
  //******* LOCATION *******\\
  Location location = new Location();
  LocationData _locationData;
  bool isPermissionGiven = false;
  bool isGPSOpen = false;
  Timer _timer;
  
  @override
  void initState() {
    super.initState();
    if(Platform.isAndroid)
      switchOnAndroidLocationPressed();
    else
      switchOnIOSLocationPressed();
  }

  @override
  void dispose() {
    if(_timer != null)
      _timer.cancel();
    super.dispose();
  }

  //****************************** LOCATION RELATED ********************************/

  void switchOnAndroidLocationPressed()async{
    PL.PermissionStatus permissionStatus = await PL.LocationPermissions().requestPermissions();
    if(permissionStatus == PL.PermissionStatus.denied)
    {
      PL.PermissionStatus permission = await PL.LocationPermissions().requestPermissions();
      if (permission == PL.PermissionStatus.restricted) {
        showAlertDialog('Location Disabled', 'You have disabled location use for the app so please go to application settings and allow location use to continue');
        setState(() {
          showLoading = false;
        });
        return;
      }
      if (permission == PL.PermissionStatus.denied) {
        setState(() {
          showLoading = false;
        });
        return;
      }
      if (permission == PL.PermissionStatus.granted) {
         setState(() {
          showLoading = true;
          isPermissionGiven = true;
        });
      }
    }

    if(permissionStatus == PL.PermissionStatus.granted)
      isPermissionGiven = true;

  
    //Service Check
    PL.ServiceStatus serviceStatus = await PL.LocationPermissions().checkServiceStatus();
    if (serviceStatus == PL.ServiceStatus.disabled)
    {
      Constants.showDialog('Please turn on your gps to continue');
      startTimer();
      setState(() {
        showLoading = false;
      });
      return;
    }
    else
    {
      isGPSOpen = true;
    }


    if(isGPSOpen && isPermissionGiven)
    {
      if(_timer != null)
        _timer.cancel();
  
      _locationData = await location.getLocation();
      print(_locationData.latitude);
      print(_locationData.longitude);
      setUpUserLocation(_locationData);
    }

    setState(() { });
  }
  
  void switchOnIOSLocationPressed()async{
    
    LocationPermission permission = await Geolocator.requestPermission();
    print('**************');
    print(permission.toString());

    PL.PermissionStatus permissionStatus = await PL.LocationPermissions().checkPermissionStatus();
    print('********* $permissionStatus');
    if(permissionStatus == PL.PermissionStatus.denied || permissionStatus == PL.PermissionStatus.restricted)
    {
      PL.PermissionStatus permission = await PL.LocationPermissions().requestPermissions();
      if (permission == PL.PermissionStatus.restricted) {
        showAlertDialog('Location Disabled', 'You have disabled location use for the app so please go to application settings and allow location use to continue');
        setState(() {
          showLoading = false;
          Geolocator.openAppSettings();
        });
        return;
      }
      if (permission == PL.PermissionStatus.denied) {
        setState(() {
          showLoading = false;
        });
        return;
      }
      if (permission == PL.PermissionStatus.granted) {
         setState(() {
          showLoading = true;
          isPermissionGiven = true;
        });
      }
    }
    
    _locationData = await location.getLocation();
    print(_locationData.latitude);
    print(_locationData.longitude);
    setUpUserLocation(_locationData);

    setState(() { });
  }

  void startTimer() {
    if(_timer == null)
    {
      const oneSec = const Duration(seconds: 1);
      _timer = new Timer.periodic(
        oneSec,
        (Timer timer) => setState(
          () {
            checkForGPS();
          },
        ),
      );  
    }
  }

  void checkForGPS()async{
    PL.ServiceStatus serviceStatus = await PL.LocationPermissions().checkServiceStatus();
    if (serviceStatus == PL.ServiceStatus.enabled)
    {
      isGPSOpen = true;
      if(_timer != null)
        _timer.cancel();
    
      _locationData = await location.getLocation();
      print(_locationData.latitude);
      print(_locationData.longitude);
      setUpUserLocation(_locationData);
    }
  }

  Future<void> setUpUserLocation(LocationData loc) async {
    Constants.userLocation = loc;
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
  
  //****************************** UTIL ********************************\\
  void showAlertDialog(String title , String message) {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text(title),
          content: new Text(message),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }


  @override
  Widget build(BuildContext context) {

    SizeConfig().init(context);
    double unitHeightValue = MediaQuery.of(context).size.height * 0.01;

    return new WillPopScope(
      onWillPop: () async {
        return false;
      },
      child : Scaffold(
        backgroundColor: Constants.appThemeColor,
        body: (showLoading) ? Container(
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(
                  valueColor: new AlwaysStoppedAnimation<Color>(Constants.appThemeColor),
                ),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Text(
                    "Finding Your Location",
                     style: TextStyle(
                      fontSize: 2 * unitHeightValue,
                      color: Colors.white, 
                      fontWeight: FontWeight.bold
                    ),
                  ),
                ),

              ],
            ),
          ),
        ) : Container(
          child: Column(
            children: [
              Container(
                height: SizeConfig.blockSizeVertical *80,
                width: SizeConfig.blockSizeHorizontal *100,
                //color: Colors.red,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Location Disabled", style: TextStyle(fontSize: 2.3 * unitHeightValue, color: Colors.white, fontWeight: FontWeight.bold),),
                    SizedBox(
                      height: SizeConfig.blockSizeVertical *5,
                    ),
                    Text(
                      "Delivery bot works better when we\ncan detect your location", 
                      style: TextStyle(fontSize: 2 * unitHeightValue, color: Colors.white, fontWeight: FontWeight.w300),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(
                      height: SizeConfig.blockSizeVertical *5,
                    ),
                    Icon(Icons.location_off, color: Colors.white, size: SizeConfig.blockSizeVertical *20,)
                  ],
                ),
              ),
              Container(
                height: SizeConfig.blockSizeVertical *10,
                width: SizeConfig.blockSizeHorizontal *100,
                margin: EdgeInsets.symmetric(horizontal: SizeConfig.blockSizeHorizontal *20),
               // color: Colors.black,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    FlatButton(
                      color: Constants.appOrangeColor,
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: new Text("ENABLE", style: TextStyle(fontSize: 2 * unitHeightValue, color: Colors.white, fontWeight: FontWeight.bold),),
                      ),
                      onPressed: (){
                        if(Platform.isAndroid)
                          switchOnAndroidLocationPressed();
                        else
                          switchOnIOSLocationPressed();
                      },
                      shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(30.0)
                      )
                    ),
          
                  ],
                ),
              )

            ],
          ),
        ),
      ),
    );
  }
}