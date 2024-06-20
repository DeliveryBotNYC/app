import 'package:delivery_bot/services/app_controller.dart';
import 'package:delivery_bot/utils/constants.dart';
import 'package:delivery_bot/utils/size_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
//import 'package:date_range_picker/date_range_picker.dart' as DateRangePicker;
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:intl/intl.dart';

class EarningScreen extends StatefulWidget {
  final AdvancedDrawerController advancedDrawerController;
  final Function menuPressed;
  EarningScreen({this.menuPressed, this.advancedDrawerController});
  
  @override
  _EarningScreenState createState() => _EarningScreenState();
}

class _EarningScreenState extends State<EarningScreen> {
  
  String startDate;
  String endDate;
  String startDateToShow;
  String endDateToShow;
  List months = ['Jan', 'Feb', 'Mar', 'Apr', 'May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'];
  List<DateTime> picked;
  double deliveriesPrHour = 0;
  double rating = 0.0;
  double hoursWorked = 0;
  double hourlyPay = 0;
  double tip = 0.0;
  double payDue = 0;
  
  @override
  void initState() {
    super.initState();
    //Start
    String sMonthName = months[DateTime.now().month-1];
    String sCurrentDate =  DateFormat('dd').format((DateTime.now()).subtract(new Duration(days: 7)));
    startDateToShow = sMonthName + " "+ sCurrentDate;
    startDate = DateFormat('yyyy-MM-dd').format((DateTime.now()).subtract(new Duration(days: 7)));
    //End
    String eMonthName = months[ new DateTime.now().month-1];
    String eCurrentDate = DateFormat('dd').format(DateTime.now());
    endDateToShow = eMonthName + " "+ eCurrentDate;
    endDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
    print(endDateToShow);
    getEarningStats();
  }

  void datePickerDateSelected(){
    print(picked[0]);
    print(picked[1]);
    //Start
    String sMonthName = months[picked[0].month -1];
    String sCurrentDate =  DateFormat('dd').format(picked[0]);
    startDateToShow = sMonthName + " "+ sCurrentDate;
    startDate = DateFormat('yyyy-MM-dd').format(picked[0]);
    //End
    String eMonthName = months[picked[1].month -1];
    String eCurrentDate = DateFormat('dd').format(picked[1]);
    endDateToShow = eMonthName + " "+ eCurrentDate;
    endDate = DateFormat('yyyy-MM-dd').format(picked[1]);
    setState(() {});
    getEarningStats();
  }

  void getEarningStats() async {
    EasyLoading.show(status: 'Please wait', maskType: EasyLoadingMaskType.black,);
    dynamic result = await AppController().getEarningStats(startDate, endDate);
    EasyLoading.dismiss();
    if (result['Status'] == "Success") 
    {
      if(result['DeliveryPrHour'] != null)
      {
        deliveriesPrHour = result['DeliveryPrHour'];
        rating = result['Rating'];
        hoursWorked = result['HoursWorked'];
        hourlyPay = result['HourlyPay'];
        tip = result['Tip'];
        payDue = result['PayDue'];
      }
    }
    else
    {
      Constants.showDialog(result['ErrorMessage']);
    }
    //getRating();
    setState(() {}); 
  }

  void getRating() async {
    EasyLoading.show(status: 'Please wait', maskType: EasyLoadingMaskType.black,);
    dynamic result = await AppController().getRating();
    EasyLoading.dismiss();
    if (result['Status'] == "Success") 
    {
      rating = (result['Rating'] == "null") ? 0.0 : result['Rating'];
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
          'Earnings',
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
            Container(
              height: SizeConfig.blockSizeVertical * 7,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: Constants.textFieldColor
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                    Icon(Icons.arrow_back_ios, color : Colors.white, size: 18),
                    
                    /*GestureDetector(
                      onTap: () async {
                        picked = await DateRangePicker.showDatePicker(
                          context: context,
                          initialFirstDate: (new DateTime.now()).subtract(new Duration(days: 7)),
                          initialLastDate: new DateTime.now(),
                          firstDate: new DateTime(2015),
                          lastDate: new DateTime(DateTime.now().year + 2),
                        );
                        if (picked != null && picked.length == 2) {
                            print(picked);
                            datePickerDateSelected();
                        }
                      },
                      child: Container(
                        margin: EdgeInsets.only(left: 10, right: 10),
                        child: Text(
                          '$startDateToShow - $endDateToShow',
                          style: TextStyle(
                            fontSize : SizeConfig.fontSize * 1.8,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),*/
                    /*
                    Container(
                      child: SfDateRangePicker(
                        onSelectionChanged: _onSelectionChanged,
                        selectionMode: DateRangePickerSelectionMode.range,
                        initialSelectedRange: PickerDateRange(
                          DateTime.now().subtract(const Duration(days: 4)),
                          DateTime.now().add(const Duration(days: 3))
                          ),
                      ),
                    ),
                    */
                    Icon(Icons.arrow_forward_ios, color : Colors.white, size: 18),
                ],
              )
            ),
            Container(
              margin: EdgeInsets.only(top: 15),
              height: SizeConfig.blockSizeVertical * 31,
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
                        'Statistics',
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
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Deliveries per hour',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize : SizeConfig.fontSize * 1.8,
                            color: Colors.white,
                            fontWeight: FontWeight.bold
                          ),
                        ),
                        Text(
                          '${deliveriesPrHour.toStringAsFixed(1)}',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize : SizeConfig.fontSize * 1.8,
                            color: Colors.white,
                            fontWeight: FontWeight.bold
                          ),
                        ),
                      ],
                    ),
                  ),
                   Container(
                     decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: Constants.textFieldColor
                    ),
                    padding: EdgeInsets.all(15),
                    margin: EdgeInsets.only(top: SizeConfig.blockSizeVertical * 1, bottom: SizeConfig.blockSizeVertical * 1, left: 10, right: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Rating',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize : SizeConfig.fontSize * 1.8,
                            color: Colors.white,
                            fontWeight: FontWeight.bold
                          ),
                        ),
                        Text(
                          '${rating.toStringAsFixed(1)} / 5',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize : SizeConfig.fontSize * 1.8,
                            color: Colors.white,
                            fontWeight: FontWeight.bold
                          ),
                        ),
                      ],
                    ),
                  ),
                   Container(
                     decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: Constants.textFieldColor
                    ),
                    padding: EdgeInsets.all(15),
                    margin: EdgeInsets.only(top: SizeConfig.blockSizeVertical * 1, bottom: SizeConfig.blockSizeVertical * 1, left: 10, right: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Hours worked',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize : SizeConfig.fontSize * 1.8,
                            color: Colors.white,
                            fontWeight: FontWeight.bold
                          ),
                        ),
                        Text(
                          '${hoursWorked.toStringAsFixed(1)}',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize : SizeConfig.fontSize * 1.8,
                            color: Colors.white,
                            fontWeight: FontWeight.bold
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            //Earnings
            Container(
              margin: EdgeInsets.only(top: 15),
              height: SizeConfig.blockSizeVertical * 31,
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
                        'Earnings',
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
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Hourly pay',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize : SizeConfig.fontSize * 1.8,
                            color: Colors.white,
                            fontWeight: FontWeight.bold
                          ),
                        ),
                        Text(
                          '\$${hourlyPay.toStringAsFixed(1)}',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize : SizeConfig.fontSize * 1.8,
                            color: Colors.white,
                            fontWeight: FontWeight.bold
                          ),
                        ),
                      ],
                    ),
                  ),
                   Container(
                     decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: Constants.textFieldColor
                    ),
                    padding: EdgeInsets.all(15),
                    margin: EdgeInsets.only(top: SizeConfig.blockSizeVertical * 1, bottom: SizeConfig.blockSizeVertical * 1, left: 10, right: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Tips',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize : SizeConfig.fontSize * 1.8,
                            color: Colors.white,
                            fontWeight: FontWeight.bold
                          ),
                        ),
                        Text(
                          '\$${tip.toStringAsFixed(1)}',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize : SizeConfig.fontSize * 1.8,
                            color: Colors.white,
                            fontWeight: FontWeight.bold
                          ),
                        ),
                      ],
                    ),
                  ),
                   Container(
                     decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: Constants.textFieldColor
                    ),
                    padding: EdgeInsets.all(15),
                    margin: EdgeInsets.only(top: SizeConfig.blockSizeVertical * 1, bottom: SizeConfig.blockSizeVertical * 1, left: 10, right: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Pay due',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize : SizeConfig.fontSize * 1.8,
                            color: Colors.white,
                            fontWeight: FontWeight.bold
                          ),
                        ),
                        Text(
                          '\$${payDue.toStringAsFixed(1)}',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize : SizeConfig.fontSize * 1.8,
                            color: Colors.green,
                            fontWeight: FontWeight.bold
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}