import 'package:delivery_bot/services/app_controller.dart';
import 'package:delivery_bot/utils/constants.dart';
import 'package:delivery_bot/utils/size_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

class AddOrder extends StatefulWidget {
  @override
  _AddOrderState createState() => _AddOrderState();
}

class _AddOrderState extends State<AddOrder> {

  TextEditingController name = TextEditingController();
  TextEditingController phone = TextEditingController();
  TextEditingController address = TextEditingController();
  TextEditingController apt = TextEditingController();
  TextEditingController items = TextEditingController();
  TextEditingController notes = TextEditingController();
  
  void createOrderPressed() async {
    if (name.text.isEmpty)
      Constants.showDialog("Please enter customer name");
    else if (phone.text.isEmpty)
      Constants.showDialog("Please enter customer phone");
    else if (address.text.isEmpty)
      Constants.showDialog("Please enter customer address");
    else if (items.text.isEmpty)
      Constants.showDialog("Please enter total number of items");
    else
    {
      EasyLoading.show(status: 'Please wait', maskType: EasyLoadingMaskType.black,);
      dynamic result = await AppController().createOrder(name.text, phone.text, address.text, apt.text, items.text, notes.text, 9);
      EasyLoading.dismiss();
      setState(() {}); 
      if (result['Status'] == "Success") 
      {
        //Constants.showDialog('Order placed successfully');
        Get.back();
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
        child: Container(
          margin: EdgeInsets.only(left: 20, right: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                alignment: Alignment.center,
                child: Text(
                  'Add 0rder',
                  style: TextStyle(
                    fontSize : SizeConfig.fontSize * 2.7,
                    color: Colors.white,
                    fontWeight: FontWeight.bold
                  ),
                ),
              ),
              Container(
                alignment: Alignment.center,
                margin: EdgeInsets.only(top: 5, bottom: SizeConfig.blockSizeVertical * 2),
                child: Text(
                  'The Mini Rose',
                  style: TextStyle(
                    fontSize : SizeConfig.fontSize * 2.2,
                    color: Colors.white,
                  ),
                ),
              ),

              Container(
                 height: 1,
                 color: Colors.white,
               ),
              
              Container(
                margin: EdgeInsets.only(left: SizeConfig.blockSizeHorizontal * 8, right: SizeConfig.blockSizeHorizontal * 8, top: SizeConfig.blockSizeVertical * 4),
                child: Text(
                  'Customer name *',
                  style: TextStyle(
                    fontSize : SizeConfig.fontSize * 1.8,
                    color: Colors.white,
                  ),
                ),
              ),
              Container(
                height: SizeConfig.safeBlockVertical * 6,
                margin: EdgeInsets.only(left: SizeConfig.blockSizeHorizontal * 8, right: SizeConfig.blockSizeHorizontal * 8, top: SizeConfig.blockSizeVertical * 1.5),
                decoration: BoxDecoration(
                  color: Constants.textFieldColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: TextField(
                    controller: name,
                    style: TextStyle(fontSize: SizeConfig.fontSize * 2, color: Colors.white),
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                      hintStyle: TextStyle(color: Constants.textFieldTextColor),
                      fillColor: Colors.grey[100],
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ),

              Container(
                margin: EdgeInsets.only(left: SizeConfig.blockSizeHorizontal * 8, right: SizeConfig.blockSizeHorizontal * 8, top: SizeConfig.blockSizeVertical * 2),
                child: Text(
                  'Phone # *',
                  style: TextStyle(
                    fontSize : SizeConfig.fontSize * 1.8,
                    color: Colors.white,
                  ),
                ),
              ),
              Container(
                height: SizeConfig.safeBlockVertical * 6,
                margin: EdgeInsets.only(left: SizeConfig.blockSizeHorizontal * 8, right: SizeConfig.blockSizeHorizontal * 8, top: SizeConfig.blockSizeVertical * 1.5),
                decoration: BoxDecoration(
                  color: Constants.textFieldColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: TextField(
                    controller: phone,
                    style: TextStyle(fontSize: SizeConfig.fontSize * 2, color: Colors.white),
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                      hintText: '',
                      hintStyle: TextStyle(color: Constants.textFieldTextColor),
                      fillColor: Colors.grey[100],
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ),

              Container(
                margin: EdgeInsets.only(left: SizeConfig.blockSizeHorizontal * 8, right: SizeConfig.blockSizeHorizontal * 8, top: SizeConfig.blockSizeVertical * 2),
                child: Text(
                  'Address *',
                  style: TextStyle(
                    fontSize : SizeConfig.fontSize * 1.8,
                    color: Colors.white,
                  ),
                ),
              ),
              Container(
                height: SizeConfig.safeBlockVertical * 6,
                margin: EdgeInsets.only(left: SizeConfig.blockSizeHorizontal * 8, right: SizeConfig.blockSizeHorizontal * 8, top: SizeConfig.blockSizeVertical * 1.5),
                decoration: BoxDecoration(
                  color: Constants.textFieldColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: TextField(
                    controller: address,
                    style: TextStyle(fontSize: SizeConfig.fontSize * 2, color: Colors.white),
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                      hintText: '',
                      hintStyle: TextStyle(color: Constants.textFieldTextColor),
                      fillColor: Colors.grey[100],
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ),

              Container(
                margin: EdgeInsets.only(left: SizeConfig.blockSizeHorizontal * 8, right: SizeConfig.blockSizeHorizontal * 8, ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: SizeConfig.blockSizeHorizontal * 31,
                      margin: EdgeInsets.only(top: SizeConfig.blockSizeVertical * 2),
                      child: Text(
                        'Apt',
                        style: TextStyle(
                          fontSize : SizeConfig.fontSize * 1.8,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    Container(
                      width: SizeConfig.blockSizeHorizontal * 31,
                      margin: EdgeInsets.only(top: SizeConfig.blockSizeVertical * 2),
                      child: Text(
                        'No. of items *',
                        style: TextStyle(
                          fontSize : SizeConfig.fontSize * 1.8,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),


              Container(
                margin: EdgeInsets.only(left: SizeConfig.blockSizeHorizontal * 8, right: SizeConfig.blockSizeHorizontal * 8, ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                   Container(
                      height: SizeConfig.safeBlockVertical * 6,
                      width: SizeConfig.blockSizeHorizontal * 31,
                      margin: EdgeInsets.only(top: SizeConfig.blockSizeVertical * 2),
                      decoration: BoxDecoration(
                        color: Constants.textFieldColor,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                        child: TextField(
                          controller: apt,
                          keyboardType: TextInputType.number,
                          style: TextStyle(fontSize: SizeConfig.fontSize * 2, color: Colors.white),
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                            hintStyle: TextStyle(color: Constants.textFieldTextColor),
                            fillColor: Colors.grey[100],
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      height: SizeConfig.safeBlockVertical * 6,
                      width: SizeConfig.blockSizeHorizontal * 31,
                      margin: EdgeInsets.only(top: SizeConfig.blockSizeVertical * 2),
                      decoration: BoxDecoration(
                        color: Constants.textFieldColor,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                        child: TextField(
                          controller: items,
                          keyboardType: TextInputType.number,
                          style: TextStyle(fontSize: SizeConfig.fontSize * 2, color: Colors.white),
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 0),
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

              Container(
                margin: EdgeInsets.only(left: SizeConfig.blockSizeHorizontal * 8, right: SizeConfig.blockSizeHorizontal * 8, top: SizeConfig.blockSizeVertical * 2),
                child: Text(
                  'Notes',
                  style: TextStyle(
                    fontSize : SizeConfig.fontSize * 1.8,
                    color: Colors.white,
                  ),
                ),
              ),
              Container(
                height: SizeConfig.safeBlockVertical * 6,
                margin: EdgeInsets.only(left: SizeConfig.blockSizeHorizontal * 8, right: SizeConfig.blockSizeHorizontal * 8, top: SizeConfig.blockSizeVertical * 1.5),
                decoration: BoxDecoration(
                  color: Constants.textFieldColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: TextField(
                    controller: notes,
                    style: TextStyle(fontSize: SizeConfig.fontSize * 2, color: Colors.white),
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                      hintText: '',
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
       bottomNavigationBar: Container(
        margin: EdgeInsets.only(left: 20, right: 20),
        height: SizeConfig.blockSizeVertical * 11,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            GestureDetector(
              onTap: createOrderPressed,
              child: Container(
                 margin: EdgeInsets.only(top: 10, bottom: 20),
                 child: Row(
                   mainAxisAlignment: MainAxisAlignment.center,
                   children: [
                      Container(
                        width: SizeConfig.blockSizeHorizontal * 90,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Constants.textFieldColor
                        ),
                        padding: EdgeInsets.symmetric(horizontal: 0, vertical: 15),
                        child: Center(
                          child: Text(
                            'Add 0rder',
                            style: TextStyle(
                              fontSize : SizeConfig.fontSize * 2,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),                              
                    ],
                  ),
                ),
             )
          ],
        ),
      ),
    );
  }
}