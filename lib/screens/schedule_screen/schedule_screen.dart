import 'package:delivery_bot/services/app_controller.dart';
import 'package:delivery_bot/utils/constants.dart';
import 'package:delivery_bot/utils/size_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class ScheduleScreen extends StatefulWidget {
  final AdvancedDrawerController advancedDrawerController;
  final Function menuPressed;
  ScheduleScreen({this.menuPressed, this.advancedDrawerController});
  
  @override
  _ScheduleScreenState createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {

  List schedule = [];
  bool riderStatus = false;
  List days = ['Monday', 'Tuesday', 'Wednesday', 'Thursday','Friday', 'Saturday', 'Sunday'];
  List date = ['05/17', '05/18', '05/19', '05/20','05/21', '05/22', '05/23'];
  List<Color> colors = [ Colors.grey[500], Colors.grey[500],  Colors.green, Colors.green , Colors.red, Colors.red, Colors.red];
 
  @override
  void initState() {
    super.initState();
    getSchedule();
  }

  void getSchedule() async {
    EasyLoading.show(status: 'Please wait', maskType: EasyLoadingMaskType.black,);
    dynamic result = await AppController().getSchedule();
    EasyLoading.dismiss();
    if (result['Status'] == "Success") 
    {
      schedule = result['Results'];
    }
    else
    {
      Constants.showDialog(result['ErrorMessage']);
    }
    setState(() {}); 
  }

  
  void confrimSchduleDate(String day, String date) {
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
                  'Are you sure you want to schedule $day?',
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
                          Get.back();
                          scheduleForDay(date);
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
  
  void scheduleForDay(String date) async {
    EasyLoading.show(status: 'Please wait', maskType: EasyLoadingMaskType.black,);
    dynamic result = await AppController().scheduleForDate(date);
    EasyLoading.dismiss();
    if (result['Status'] == "Success") 
    {
      getSchedule();
    }
    else
    {
      Constants.showDialog(result['ErrorMessage']);
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
          'Schedule',
          style: TextStyle(
            fontSize : SizeConfig.fontSize * 2.2,
            color: Colors.black,
          ),
        ),
        actions: [
          IconButton(icon: Icon(Icons.sanitizer, color: Colors.transparent,), onPressed: null)
        ],
      ),
      body: Container(
        margin: EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            /*
            Container(
              height: SizeConfig.blockSizeVertical * 7,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Constants.textFieldColor
              ),
              child: Center(
                child: Text(
                  'May 17 - May 23',
                  style: TextStyle(
                    fontSize : SizeConfig.fontSize * 1.8,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            */
            Expanded(
              child: Container(
                child:  ListView.builder(
                  shrinkWrap: true,
                  itemCount: schedule.length,
                  itemBuilder: (context, index){
                    return dateCell(schedule[index]);
                  }
                )
              ),
            )    ],
        ),
      ),
    );
  }

  Widget dateCell(Map status){

    DateTime date = new DateFormat("yyyy-MM-dd").parse(status['date']);
    return GestureDetector(
      onTap: (){
        if(status['status'].contains('taken_by_you')){
          Constants.showDialog("You are already schedules for this date");
        }
        else if(status['status'].contains('available')){
          confrimSchduleDate(DateFormat('EEEE').format(date), status['date']);
        }
        else{
          print('Do nothing');
        }
      },
      child: Container(
        margin: EdgeInsets.only(top: 15),
        height: SizeConfig.blockSizeVertical * 9,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: getColor(status['status'])
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              child: Text(
                '${DateFormat('EEEE').format(date)}',
                style: TextStyle(
                  fontSize : SizeConfig.fontSize * 2,
                  color: Colors.white,
                ),
              ),
            ),
            Container(
              child: Text(
                '${status['date']}',
                style: TextStyle(
                    fontSize : SizeConfig.fontSize * 1.7,
                    color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color getColor(String statusText){
    if(statusText.contains('taken_by_you'))
      return Colors.grey[500];
    else if(statusText.contains('available'))
      return Colors.green;
    else
      return Colors.red;
  }
}