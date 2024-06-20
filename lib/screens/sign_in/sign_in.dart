import 'package:delivery_bot/screens/home_screen/home_screen.dart';
import 'package:delivery_bot/screens/sign_up/sign_up.dart';
import 'package:delivery_bot/services/app_controller.dart';
import 'package:delivery_bot/utils/constants.dart';
import 'package:delivery_bot/utils/size_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  TextEditingController username = new TextEditingController();
  TextEditingController password = new TextEditingController();
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
  }

  void signInPressed() async {
    if (username.text.isEmpty)
      Constants.showDialog("Please enter user name");
    else if (password.text.isEmpty)
      Constants.showDialog("Please enter password");
    else if (password.text.length < 8)
      Constants.showDialog("Please enter password with minimum 8 charcaters");
    else
    {
      setState(() => isLoading = true);  
      EasyLoading.show(status: 'Please wait', maskType: EasyLoadingMaskType.black,);
      dynamic result = await AppController().signInUser(username.text, password.text);
      EasyLoading.dismiss();
      setState(() => isLoading = false); 
      if (result['Status'] == "Success") 
      {
        Get.offAll(HomeScreen());
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
            margin: EdgeInsets.only(top: 0),
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
                        fontSize :SizeConfig.fontSize * 4,
                      ),
                    ),
                  ),
                ),

                
                Container(
                  height: SizeConfig.safeBlockVertical * 6,
                  margin: EdgeInsets.only(left: SizeConfig.blockSizeHorizontal * 8, right: SizeConfig.blockSizeHorizontal * 8, top: SizeConfig.blockSizeVertical * 5),
                  decoration: BoxDecoration(
                    color: Constants.textFieldColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: TextField(
                      style: TextStyle(fontSize: SizeConfig.fontSize * 2, color: Colors.white),
                      controller: username,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 0),
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
                  margin: EdgeInsets.only(left: SizeConfig.blockSizeHorizontal * 8, right: SizeConfig.blockSizeHorizontal * 8, top: SizeConfig.blockSizeVertical * 2),
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
/*                
                Container(
                  width: SizeConfig.blockSizeHorizontal * 100,
                  height: SizeConfig.blockSizeVertical * 5,
                  margin: EdgeInsets.only(left: SizeConfig.blockSizeHorizontal * 8, right: SizeConfig.blockSizeHorizontal * 8,),
                  //color: Colors.red,
                  child: GestureDetector(
                    child: Align(
                      alignment: Alignment.center,
                      child: Text(
                        'Forgot password',
                        style: TextStyle(
                          color: Constants.textFieldTextColor,
                          fontSize :SizeConfig.fontSize * 1.8,
                          fontWeight: FontWeight.bold
                        ),
                      ),
                    ),
                    onTap: (){
                      //Get.to(ForgotPassword());
                    },
                  ),
                ),
*/
                
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Container(
        height: SizeConfig.blockSizeVertical * 15,
        child: Column(
          children: [
            GestureDetector(
              onTap: (){
                signInPressed();
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
                    'Login',
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

            Container(
              width: SizeConfig.blockSizeHorizontal * 100,
              margin: EdgeInsets.only(top: 20, bottom: 15),
              //color: Colors.red,
              child: GestureDetector(
                child: Align(
                  alignment: Alignment.center,
                  child: Text(
                    'Sign Up',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize :SizeConfig.fontSize * 2,
                    ),
                  ),
                ),
                onTap: (){
                  Get.to(SignupScreen());
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}