import 'package:delivery_bot/screens/add_order/add_order.dart';
import 'package:delivery_bot/utils/constants.dart';
import 'package:delivery_bot/utils/size_config.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PickUpRecords extends StatefulWidget {

  @override
  _PickUpRecordsState createState() => _PickUpRecordsState();
}

class _PickUpRecordsState extends State<PickUpRecords> {

  List orders = ['1', '2', '3'];

  @override
  void initState() {
    super.initState();
  }

  void deleteConfirmView() {
    Get.generalDialog(
      pageBuilder: (context, __, ___) => AlertDialog(
        contentPadding: EdgeInsets.all(0),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10.0))),
        content: Container(
          width: SizeConfig.blockSizeHorizontal * 80,
          //height: 70,
          child: ListView(
            shrinkWrap: true,
            children: [
              Container(
                margin: EdgeInsets.only(left: 20, right: 20,),
                child: Text(
                  'Are you sure you want to cancel Roger Owen?',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize : SizeConfig.fontSize * 2,
                    color: Colors.black,
                    fontWeight: FontWeight.bold
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 20, right: 20, top: 10),
                height: 1,
                width: SizeConfig.blockSizeHorizontal * 70,
                color: Constants.textFieldTextColor,
              ),

              Container(
                margin: EdgeInsets.only(left: 20, right: 20,),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: (){
                        Get.back();
                      },
                      child: Container(
                        width: SizeConfig.blockSizeHorizontal * 25,
                        height: SizeConfig.safeBlockVertical * 5,
                        margin: EdgeInsets.only(top: 10, bottom: 10),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(
                          child: Text(
                            'No',
                            style: TextStyle(
                              fontSize : SizeConfig.fontSize * 1.8,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: (){
                        setState(() {
                          orders.removeLast();
                          Get.back();
                        });
                      },
                      child: Container(
                        width: SizeConfig.blockSizeHorizontal * 40,
                        height: SizeConfig.safeBlockVertical * 5,
                        margin: EdgeInsets.only(top: 10, bottom: 10),
                        decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(
                          child: Text(
                            'Yes',
                            style: TextStyle(
                              fontSize : SizeConfig.fontSize * 1.8,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      )
    );
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
      body: Container(
        margin: EdgeInsets.only(left: 20, right: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
             Container(
              margin: EdgeInsets.only(bottom: SizeConfig.blockSizeVertical * 2),
               child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: SizeConfig.blockSizeHorizontal * 15,
                    ),
                    Expanded(
                      child: Container(
                        //color: Colors.yellow,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              child: Center(
                                child: Text(
                                  'Jesicca Laren',
                                  style: TextStyle(
                                    fontSize : SizeConfig.fontSize * 2.5,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(top: 10),
                              child: Center(
                                child: Text(
                                  '363 West 21 Street',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize : SizeConfig.fontSize * 2,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    Container(
                      width: SizeConfig.blockSizeHorizontal * 15,
                      child: Icon(
                        Icons.directions,
                        color: Colors.white,
                        size: SizeConfig.blockSizeHorizontal * 15
                      ),
                    ),
                  ],
                ),
             ),

             Container(
               height: 1,
               color: Colors.white,
             ),

             Container(
               margin: EdgeInsets.only(top: SizeConfig.blockSizeVertical * 3),
               child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Container(
                      child: Text(
                        'Pick up :',
                        style: TextStyle(
                          fontSize : SizeConfig.fontSize * 1.8,
                          color: Colors.white,
                          fontWeight: FontWeight.bold
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () async {
                      await Get.to(AddOrder());
                    },
                    child: Container(
                      margin: EdgeInsets.only(top: 10),
                      child: Icon(Icons.add, color: Colors.white,),
                    ),
                  ),
                ],
               ),
             ),

            Container(
              margin: EdgeInsets.all(10),
              //color: Colors.red,
              child:  ListView.builder(
                shrinkWrap: true,
                itemCount: orders.length,
                itemBuilder: (context, index){
                  return orderCell(index);
                }
              )
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        margin: EdgeInsets.only(left: 20, right: 20),
        height: SizeConfig.blockSizeVertical * 20,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
               margin: EdgeInsets.only(top: 10, bottom: 10),
               child: Row(
                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
                 children: [
                    IconButton(
                      icon: Icon(Icons.camera_alt, size: SizeConfig.blockSizeVertical * 5, color: Colors.white), 
                      onPressed: (){}
                    ),
                    IconButton(
                      icon: Icon(Icons.call, size: SizeConfig.blockSizeVertical * 5, color: Colors.white), 
                      onPressed: (){}
                    ),   
                 ],
               ),
             ),

             Container(
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
                          'Picked up 2 items',
                          style: TextStyle(
                            fontSize : SizeConfig.fontSize * 2,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),                              
                  ],
                ),
              )
          ],
        ),
      ),
    );
  }

  Widget orderCell(int index){
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(width: 1, color: Colors.white)
        )
      ),
      height: SizeConfig.blockSizeVertical * 9,
      child: ListTile(
        contentPadding: EdgeInsets.only(left: 5, right: 5),
        title: Text(
          '*Roger Owen',
          style: TextStyle(
            fontSize : SizeConfig.fontSize * 2,
            color: Colors.white,
          ),
        ),
        subtitle: Text(
          '11:30 am - 12:13 pm',
          style: TextStyle(
            fontSize : SizeConfig.fontSize * 1.5,
            color: Colors.white,
          ),
        ),
        trailing: IconButton(
          icon: Icon(Icons.close, color: Colors.red, size: 20,),
          onPressed: (){
            deleteConfirmView();
          }
        ),
      ),
    );
  }
}