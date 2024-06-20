import 'package:delivery_bot/model/app_user.dart';
import 'package:delivery_bot/screens/sign_in/sign_in.dart';
import 'package:delivery_bot/services/app_controller.dart';
import 'package:delivery_bot/utils/constants.dart';
import 'package:delivery_bot/utils/size_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsScreen extends StatefulWidget {

  final AdvancedDrawerController advancedDrawerController;
  final Function menuPressed;
  SettingsScreen({this.menuPressed, this.advancedDrawerController});
  
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  
  TextEditingController firstName = new TextEditingController(text: "");
  TextEditingController lastName = new TextEditingController(text: "");
  TextEditingController email = new TextEditingController(text: "");
  TextEditingController phone = new TextEditingController(text: "");
  TextEditingController password = new TextEditingController(text: "**********");
  TextEditingController vehicle = new TextEditingController(text: "");
  
  @override
  void initState() {
    super.initState();
    getMyProfile();
  }

  void getMyProfile() async {
    EasyLoading.show(status: 'Please wait', maskType: EasyLoadingMaskType.black,);
    dynamic result = await AppController().getProfile();
    EasyLoading.dismiss();
    if (result['Status'] == "Success") 
    {
      firstName = new TextEditingController(text: Constants.appUser.firstName);
      lastName = new TextEditingController(text: Constants.appUser.lastName);
      email = new TextEditingController(text: Constants.appUser.email);
      phone = new TextEditingController(text: Constants.appUser.phone);
      password = new TextEditingController(text: "**********");
      vehicle = new TextEditingController(text: Constants.appUser.vehicle);
    }
    else
    {
      Constants.showDialog(result['ErrorMessage']);
    }
    setState(() {}); 
  }

  void updateProfilePressed() async {
    if(firstName.text.isEmpty)
      Constants.showDialog('Please enter first name');
    else if(lastName.text.isEmpty)
      Constants.showDialog('Please enter last name');
    else if(email.text.isEmpty)
      Constants.showDialog('Please enter email');
    else if(phone.text.isEmpty)
      Constants.showDialog('Please enter phone number');
    else if(vehicle.text.isEmpty)
      Constants.showDialog('Please enter vehicle name');
    else
    {
      EasyLoading.show(status: 'Please wait', maskType: EasyLoadingMaskType.black,);
      dynamic result = await AppController().updateMyProfile(firstName.text, lastName.text, email.text, phone.text, vehicle.text);
      EasyLoading.dismiss();
      if (result['Status'] == "Success") 
      {
        Constants.showDialog("Your profile has been updated succesfully");
      }
      else
      {
        Constants.showDialog(result['ErrorMessage']);
      }
    }
    setState(() {}); 
  }

  
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      backgroundColor: Constants.appThemeColor,      
        appBar: AppBar(
        backgroundColor: Constants.appOrangeColor,
        leading: IconButton(
          onPressed: widget.menuPressed,
          icon: ValueListenableBuilder<AdvancedDrawerValue>(
            valueListenable: widget.advancedDrawerController,
            builder: (context, value, child) {
              return Icon(
                value.visible ? Icons.clear : Icons.menu,
                color: Colors.black,
              );
            },
          ),
        ),
        centerTitle: true,
        title: Text(
          'Settings',
          style: TextStyle(
            fontSize : SizeConfig.fontSize * 2.2,
            color: Colors.black,
          ),
        ),
        actions: [
          IconButton(icon: Icon(Icons.sanitizer, color: Colors.transparent,), onPressed: null)
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                margin: EdgeInsets.only(top: 15),
                //height: SizeConfig.blockSizeVertical * 35,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: Color(0XFF727073)
                ),
                child: Column(
                  children: [
                     Container(
                      margin: EdgeInsets.only(top: SizeConfig.blockSizeVertical * 1, bottom: SizeConfig.blockSizeVertical * 1),
                      child: Center(
                        child: Text(
                          'Update account',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize : SizeConfig.fontSize * 1.8,
                            color: Colors.white,
                            fontWeight: FontWeight.bold
                          ),
                        ),
                      ),
                    ),
                    Container(
                      height: 1,
                      color: Colors.white,
                      width: SizeConfig.safeBlockHorizontal * 50,
                    ),
                    Container(
                       decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: Constants.textFieldColor
                      ),
                      padding: EdgeInsets.all(15),
                      margin: EdgeInsets.only(top: SizeConfig.blockSizeVertical * 2, bottom: SizeConfig.blockSizeVertical * 1, left: 10, right: 10),
                      child: Column(
                        children: [
                          Container(
                            height: SizeConfig.blockSizeVertical * 4,
                            padding: EdgeInsets.only(bottom: SizeConfig.blockSizeVertical * 1),
                            decoration: BoxDecoration(
                              border: Border(
                                bottom: BorderSide(
                                  width: 0.5,
                                  color: Colors.white,
                                )
                              )
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  width: SizeConfig.blockSizeHorizontal * 30,
                                  child: Text(
                                    'First name',
                                    style: TextStyle(
                                      fontSize : SizeConfig.fontSize * 1.6,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: editTitleTextField(firstName, "Enter First Name", true)
                                ),
                              ],
                            ),
                          ),
                          //lastname
                          Container(
                            height: SizeConfig.blockSizeVertical * 5,
                            padding: EdgeInsets.only(bottom: SizeConfig.blockSizeVertical * 1, top: SizeConfig.blockSizeVertical * 1),
                            decoration: BoxDecoration(
                              border: Border(
                                bottom: BorderSide(
                                  width: 0.5,
                                  color: Colors.white,
                                )
                              )
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  width: SizeConfig.blockSizeHorizontal * 30,
                                  child: Text(
                                    'Last name',
                                    style: TextStyle(
                                      fontSize : SizeConfig.fontSize * 1.6,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: editTitleTextField(lastName, "Enter Last Name", true)
                                ),
                              ],
                            ),
                          ),
                          //Email
                          Container(
                            height: SizeConfig.blockSizeVertical * 5,
                            padding: EdgeInsets.only(bottom: SizeConfig.blockSizeVertical * 1, top: SizeConfig.blockSizeVertical * 1),
                            decoration: BoxDecoration(
                              border: Border(
                                bottom: BorderSide(
                                  width: 0.5,
                                  color: Colors.white,
                                )
                              )
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  width: SizeConfig.blockSizeHorizontal * 30,
                                  child: Text(
                                    'Email',
                                    style: TextStyle(
                                      fontSize : SizeConfig.fontSize * 1.6,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: editTitleTextField(email, "Enter Email", true)
                                ),
                              ],
                            ),
                          ),
                          //Phone number
                          Container(
                            height: SizeConfig.blockSizeVertical * 5,
                            padding: EdgeInsets.only(bottom: SizeConfig.blockSizeVertical * 1, top: SizeConfig.blockSizeVertical * 1),
                            decoration: BoxDecoration(
                              border: Border(
                                bottom: BorderSide(
                                  width: 0.5,
                                  color: Colors.white,
                                )
                              )
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  width: SizeConfig.blockSizeHorizontal * 30,
                                  child: Text(
                                    'Phone #',
                                    style: TextStyle(
                                      fontSize : SizeConfig.fontSize * 1.6,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: editTitleTextField(phone, "Enter Phone No." , false)
                                ),
                              ],
                            ),
                          ),
                         
                          //Vehicle
                          Container(
                            height: SizeConfig.blockSizeVertical * 4,
                            padding: EdgeInsets.only(top: SizeConfig.blockSizeVertical * 1),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  width: SizeConfig.blockSizeHorizontal * 30,
                                  child: Text(
                                    'Vehicle',
                                    style: TextStyle(
                                      fontSize : SizeConfig.fontSize * 1.6,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: editTitleTextField(vehicle, "Enter Vehicle Name", true)
                                ),
                              ],
                            ),
                          ),
                     
                        ],
                      ),
                    )
                  ],
                ),
              ),
/*
              //NOTIFICATIONS
               Container(
                margin: EdgeInsets.only(top: 15),
                //height: SizeConfig.blockSizeVertical * 20,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: Color(0XFF727073)
                ),
                child: Column(
                  children: [
                     Container(
                      margin: EdgeInsets.only(top: SizeConfig.blockSizeVertical * 1, bottom: SizeConfig.blockSizeVertical * 1),
                      child: Center(
                        child: Text(
                          'Notification',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize : SizeConfig.fontSize * 1.8,
                            color: Colors.white,
                            fontWeight: FontWeight.bold
                          ),
                        ),
                      ),
                    ),
                    Container(
                      height: 1,
                      color: Colors.white,
                      width: SizeConfig.safeBlockHorizontal * 50,
                    ),
                    Container(
                       decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: Constants.textFieldColor
                      ),
                      padding: EdgeInsets.all(15),
                      margin: EdgeInsets.only(top: SizeConfig.blockSizeVertical * 2, bottom: SizeConfig.blockSizeVertical * 1, left: 10, right: 10),
                      child: Column(
                        children: [
                          Container(
                            height: SizeConfig.blockSizeVertical * 5,
                            padding: EdgeInsets.only(bottom: SizeConfig.blockSizeVertical * 1),
                            decoration: BoxDecoration(
                              border: Border(
                                bottom: BorderSide(
                                  width: 0.5,
                                  color: Colors.white,
                                )
                              )
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  child: Text(
                                    'Task updates',
                                    style: TextStyle(
                                      fontSize : SizeConfig.fontSize * 1.6,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                Container(
                                  child: Icon(Icons.check, color: Colors.blue),
                                ),
                              ],
                            ),
                          ),
                          //lastname
                          Container(
                            height: SizeConfig.blockSizeVertical * 4,
                            padding: EdgeInsets.only(top: SizeConfig.blockSizeVertical * 1),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  child: Text(
                                    'Schedue release',
                                    style: TextStyle(
                                      fontSize : SizeConfig.fontSize * 1.6,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                Container(
                                  child: Icon(Icons.check, color: Colors.blue),
                                ),
                              ],
                            ),
                          ),            
                        ],
                      ),
                    )
                  ],
                ),
              ),
*/
              GestureDetector(
                onTap: (){
                  updateProfilePressed();
                },
                child: Container(
                  margin: EdgeInsets.only(left:  SizeConfig.blockSizeHorizontal * 20, right:  SizeConfig.blockSizeHorizontal * 20, top: SizeConfig.blockSizeVertical * 5),
                  height: SizeConfig.blockSizeVertical * 5,
                  width: SizeConfig.blockSizeHorizontal * 40,
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(10)
                  ),
                  child: Center(
                    child: Text(
                      'Save Changes',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize : SizeConfig.fontSize * 1.8,
                        color: Colors.white,
                        fontWeight: FontWeight.bold
                      ),
                    ),
                  ),
                ),
              ),

              GestureDetector(
                onTap: (){
                  launch('https://docs.google.com/forms/d/e/1FAIpQLSck2gh75l6jnxcxS4UAME35A--mZDlITVtnF8iBwk6xBJ31yg/viewform');
                },
                child: Container(
                  margin: EdgeInsets.only(left:  SizeConfig.blockSizeHorizontal * 20, right:  SizeConfig.blockSizeHorizontal * 20, top: SizeConfig.blockSizeVertical * 6),
                  child: Center(
                    child: Text(
                      'Provide Feedback',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize : SizeConfig.fontSize * 1.8,
                        color: Colors.white,
                        fontWeight: FontWeight.bold
                      ),
                    ),
                  ),
                ),
              ),

              GestureDetector(
                onTap: (){
                  AppUser.deleteUserAndOtherPreferences();
                  Get.offAll(LoginScreen());
                },
                child: Container(
                  margin: EdgeInsets.only(left:  SizeConfig.blockSizeHorizontal * 20, right:  SizeConfig.blockSizeHorizontal * 20, top: SizeConfig.blockSizeVertical * 2),
                  child: Center(
                    child: Text(
                      'Log out',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize : SizeConfig.fontSize * 1.8,
                        color: Colors.blue,
                        fontWeight: FontWeight.bold
                      ),
                    ),
                  ),
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }

  Widget editTitleTextField(TextEditingController controller, String hintText, bool capitalizeFirst) {
    bool isPassword = hintText.toLowerCase().contains('password') ? true : false;
    return Container(
      //color: Colors.blue,
      child: Center(
        child: TextField(
            controller: controller,
            textCapitalization: (capitalizeFirst) ? TextCapitalization.sentences : TextCapitalization.none,
            style: TextStyle(
              fontSize : SizeConfig.fontSize * 1.6,
              color: Colors.white,
            ),
            readOnly: (isPassword) ? true : false,
            obscureText: isPassword,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.symmetric(horizontal: 0, vertical: 10),
              border: InputBorder.none,
              hintText: hintText,
            ),
          ),
      ),
    );
  }
}