import 'package:delivery_bot/screens/home_screen/home_screen.dart';
import 'package:delivery_bot/screens/sign_in/sign_in.dart';
import 'package:delivery_bot/services/app_controller.dart';
import 'package:delivery_bot/utils/constants.dart';
import 'package:delivery_bot/utils/size_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

class SignupScreen extends StatefulWidget {
  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {

  TextEditingController firstName = new TextEditingController();
  TextEditingController lastName = new TextEditingController();
  TextEditingController email = new TextEditingController();
  TextEditingController phone = new TextEditingController();
  TextEditingController vehicle = new TextEditingController();
  TextEditingController username = new TextEditingController();
  TextEditingController password = new TextEditingController();
  bool isLoading = false;
  bool stayLogin = true;

  @override
  void initState() {
    super.initState();
  }

  void signUpPressed() async {
    if (firstName.text.isEmpty)
      Constants.showDialog("Please enter first name");
    else if (lastName.text.isEmpty)
      Constants.showDialog("Please enter last name");
    else if (email.text.isEmpty)
      Constants.showDialog("Please enter email address");
    else if (!GetUtils.isEmail(email.text))
      Constants.showDialog("Please enter valid email address");
     else if (phone.text.isEmpty)
      Constants.showDialog("Please enter phone number");
    else if (vehicle.text.isEmpty)
      Constants.showDialog("Please enter vehicle name");
    else if (username.text.isEmpty)
      Constants.showDialog("Please enter user name");
    else if (password.text.isEmpty)
      Constants.showDialog("Please enter password");
    else if (password.text.length < 8)
      Constants.showDialog("Please enter password with minimum 8 charcaters");
    else
    {
      setState(() => isLoading = true);  
      EasyLoading.show(status: 'Please wait', maskType: EasyLoadingMaskType.black,);
      dynamic result = await AppController().signUpUser(firstName.text, lastName.text, email.text, phone.text, vehicle.text, username.text, password.text);
      EasyLoading.dismiss();
      setState(() => isLoading = false); 
      if (result['Status'] == "Success") 
      {
        Get.offAll(LoginScreen());
      }
      else
      {
        Constants.showDialog(result['ErrorMessage']);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      backgroundColor: Constants.appThemeColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: (){
            print('close');
            FocusScopeNode currentFocus = FocusScope.of(context);
            if (!currentFocus.hasPrimaryFocus)
              currentFocus.unfocus();
          },
          child: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
               
                Container(
                  margin: EdgeInsets.only(bottom: SizeConfig.blockSizeVertical * 2),
                  child: Image.asset(
                    'assets/logo.png',
                    height: SizeConfig.blockSizeVertical * 15,
                    width: SizeConfig.blockSizeHorizontal * 100,
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(bottom: SizeConfig.blockSizeVertical * 2),
                  child: Center(
                    child: Text(
                      'Delivery Bot',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize :SizeConfig.fontSize * 3,
                        letterSpacing: 5
                      ),
                    ),
                  ),
                ),

                Container(
                  height: SizeConfig.safeBlockVertical * 6,
                  margin: EdgeInsets.only(left: SizeConfig.blockSizeHorizontal * 10, right: SizeConfig.blockSizeHorizontal * 10, top: SizeConfig.blockSizeVertical * 1),
                  decoration: BoxDecoration(
                    color: Constants.textFieldColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: TextField(
                      textCapitalization: TextCapitalization.sentences,
                      style: TextStyle(fontSize: SizeConfig.fontSize * 2, color: Colors.white),
                      controller: firstName,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                        hintText: 'First name',
                        hintStyle: TextStyle(color: Constants.textFieldTextColor),
                        fillColor: Colors.grey[100],
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),
                Container(
                  height: SizeConfig.safeBlockVertical * 6,
                  margin: EdgeInsets.only(left: SizeConfig.blockSizeHorizontal * 10, right: SizeConfig.blockSizeHorizontal * 10, top: SizeConfig.blockSizeVertical * 2),
                  decoration: BoxDecoration(
                    color: Constants.textFieldColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: TextField(
                      textCapitalization: TextCapitalization.sentences,
                      style: TextStyle(fontSize: SizeConfig.fontSize * 2, color: Colors.white),
                      controller: lastName,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                        hintText: 'Last name',
                        hintStyle: TextStyle(color: Constants.textFieldTextColor),
                        fillColor: Colors.grey[100],
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),

                Container(
                  height: SizeConfig.safeBlockVertical * 6,
                  margin: EdgeInsets.only(left: SizeConfig.blockSizeHorizontal * 10, right: SizeConfig.blockSizeHorizontal * 10, top: SizeConfig.blockSizeVertical * 2),
                  decoration: BoxDecoration(
                    color: Constants.textFieldColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: TextField(
                      textCapitalization: TextCapitalization.sentences,
                      style: TextStyle(fontSize: SizeConfig.fontSize * 2, color: Colors.white),
                      controller: email,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                        hintText: 'Email',
                        hintStyle: TextStyle(color: Constants.textFieldTextColor),
                        fillColor: Colors.grey[100],
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),

                Container(
                  height: SizeConfig.safeBlockVertical * 6,
                  margin: EdgeInsets.only(left: SizeConfig.blockSizeHorizontal * 10, right: SizeConfig.blockSizeHorizontal * 10, top: SizeConfig.blockSizeVertical * 2),
                  decoration: BoxDecoration(
                    color: Constants.textFieldColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: TextField(
                      onChanged: (val) {
                      },
                      style: TextStyle(fontSize: SizeConfig.fontSize * 2, color: Colors.white),
                      controller: phone,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                        hintText: 'Phone',
                        hintStyle: TextStyle(color: Constants.textFieldTextColor),
                        fillColor: Colors.grey[100],
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),
                Container(
                  height: SizeConfig.safeBlockVertical * 6,
                  margin: EdgeInsets.only(left: SizeConfig.blockSizeHorizontal * 10, right: SizeConfig.blockSizeHorizontal * 10, top: SizeConfig.blockSizeVertical * 2),
                  decoration: BoxDecoration(
                    color: Constants.textFieldColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: TextField(
                      textCapitalization: TextCapitalization.sentences,
                      style: TextStyle(fontSize: SizeConfig.fontSize * 2, color: Colors.white),
                      controller: vehicle,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                        hintText: 'Vehicle',
                        hintStyle: TextStyle(color: Constants.textFieldTextColor),
                        fillColor: Colors.grey[100],
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),

                Container(
                  height: 2,
                  margin: EdgeInsets.only(left: SizeConfig.blockSizeHorizontal * 7, right: SizeConfig.blockSizeHorizontal * 7, top: SizeConfig.blockSizeVertical * 2),
                  color: Constants.appOrangeColor,
                ),

                
                Container(
                  height: SizeConfig.safeBlockVertical * 6,
                  margin: EdgeInsets.only(left: SizeConfig.blockSizeHorizontal * 10, right: SizeConfig.blockSizeHorizontal * 10, top: SizeConfig.blockSizeVertical * 2),
                  decoration: BoxDecoration(
                    color: Constants.textFieldColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: TextField(
                      style: TextStyle(fontSize: SizeConfig.fontSize * 2, color: Colors.white),
                      controller: username,
                      //inputFormatters: [WhitelistingTextInputFormatter(RegExp("[a-zA-Z]")),],
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                        //filled: true,
                        hintText: 'Username',
                        hintStyle: TextStyle(color: Constants.textFieldTextColor),
                        fillColor: Colors.grey[100],
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),
                
                Container(
                  height: SizeConfig.safeBlockVertical * 6,
                  margin: EdgeInsets.only(left: SizeConfig.blockSizeHorizontal * 10, right: SizeConfig.blockSizeHorizontal * 10, top: SizeConfig.blockSizeVertical * 2),
                  decoration: BoxDecoration(
                    color: Constants.textFieldColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: TextField(
                      style: TextStyle(fontSize: SizeConfig.fontSize * 2, color: Colors.white),
                      controller: password,
                      obscureText: true,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                        //filled: true,
                        hintText: 'Password',
                        hintStyle: TextStyle(color: Constants.textFieldTextColor),
                        fillColor: Colors.grey[100],
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),

                
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Container(
        height: SizeConfig.blockSizeVertical * 9,
        child: Column(
          children: [
            GestureDetector(
              onTap: (){
                signUpPressed();
              },
              child: Container(
                height: SizeConfig.blockSizeVertical * 6,
                width: SizeConfig.blockSizeHorizontal * 40,
                decoration: BoxDecoration(
                  color: Constants.appOrangeColor,
                  borderRadius: BorderRadius.circular(50)
                ),
                child: Center(
                  child: Text(
                    'Sign Up',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize : SizeConfig.fontSize * 2.2,
                      color: Colors.white,
                      fontWeight: FontWeight.bold
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}