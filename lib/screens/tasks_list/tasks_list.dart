import 'package:delivery_bot/model/order_detail.dart';
import 'package:delivery_bot/screens/task_detail/task_detail.dart';
import 'package:delivery_bot/services/app_controller.dart';
import 'package:delivery_bot/utils/constants.dart';
import 'package:delivery_bot/utils/size_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:get/get.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class TaskList extends StatefulWidget {
  final AdvancedDrawerController advancedDrawerController;
  final Function menuPressed;
  TaskList({this.menuPressed, this.advancedDrawerController});

  @override
  _TaskListState createState() => _TaskListState();
}

class _TaskListState extends State<TaskList> {
  List tasks = [];

  @override
  void initState() {
    super.initState();
    Constants.startTimer();
    Constants.loadOrdersFunction = getAllOrders;
    if (Constants.isUserOnline) getAllOrders();
  }

  Future<void> getAllOrders() async {
    tasks.clear();
    EasyLoading.show(
      status: 'Please wait',
      maskType: EasyLoadingMaskType.black,
    );
    dynamic result = await AppController().getOrders(tasks);
    EasyLoading.dismiss();
    setState(() {});
    if (result['Status'] == "Success") {
    } else {
      Constants.showDialog(result['ErrorMessage']);
    }
  }

  Future<void> getAllOrdersAfterMarkDelivered() async {
    tasks.clear();
    EasyLoading.show(
      status: 'Please wait',
      maskType: EasyLoadingMaskType.black,
    );
    dynamic result = await AppController().getOrders(tasks);
    EasyLoading.dismiss();
    setState(() {});
    if (result['Status'] == "Success") {
      if (tasks.length > 0)
        Get.to(TaskDetail(
          allTasksList: tasks,
          selectedTaskIndex: 0,
          taskDetail: tasks[0],
        ));
    } else {
      Constants.showDialog(result['ErrorMessage']);
    }
  }

  void updateDriverStatus() async {
    EasyLoading.show(
      status: 'Please wait',
      maskType: EasyLoadingMaskType.black,
    );
    dynamic result =
        await AppController().updateDriverOnlineStatus(Constants.isUserOnline);
    EasyLoading.dismiss();
    setState(() {});
    if (result['Status'] == "Success") {
      if (Constants.isUserOnline) {
        //went online
        getAllOrders();
      } else {
        tasks.clear();
      }
    } else {
      Constants.isUserOnline = false;
      tasks.clear();
      Constants.showDialog(result['ErrorMessage']);
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
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
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              margin: EdgeInsets.only(right: 10),
              child: Text(
                'Offline',
                style: TextStyle(
                  fontSize: SizeConfig.fontSize * 1.6,
                  color: Colors.white,
                ),
              ),
            ),
            Container(
              width: 60,
              child: FlutterSwitch(
                inactiveColor: Colors.grey.withOpacity(0.3),
                activeColor: Color(0xFFB2d235),
                value: Constants.isUserOnline,
                onToggle: (val) {
                  Constants.isUserOnline = val;
                  updateDriverStatus();
                },
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: 10),
              child: Text(
                'Online',
                style: TextStyle(
                  fontSize: SizeConfig.fontSize * 1.6,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
        actions: [
          if (Constants.isUserOnline)
            IconButton(
                icon: Icon(
                  Icons.refresh,
                  color: Colors.white,
                ),
                onPressed: getAllOrders),
          if (!Constants.isUserOnline)
            IconButton(
                icon: Icon(
                  Icons.refresh,
                  color: Colors.transparent,
                ),
                onPressed: null)
        ],
      ),
      body: Container(
          margin: EdgeInsets.all(10),
          //color: Colors.red,
          child: (tasks.length == 0)
              ? Center(
                  child: Text(
                    (Constants.isUserOnline)
                        ? 'Searching for orders...'
                        : "Go online to receive orders & hourly pay",
                    style: TextStyle(
                      fontSize: SizeConfig.fontSize * 2.3,
                      color: Colors.white,
                    ),
                  ),
                )
              : RefreshIndicator(
                  onRefresh: getAllOrders,
                  child: ListView.builder(
                      itemCount: tasks.length,
                      itemBuilder: (context, index) {
                        return taskCell(tasks[index], index);
                      }),
                )),
    );
  }

  Widget taskCell(OrderDetail oD, int index) {
    return GestureDetector(
      onTap: () async {
        dynamic result = await Get.to(TaskDetail(
          taskDetail: oD,
          allTasksList: tasks,
          selectedTaskIndex: index,
        ));
        if (result != null) {
          getAllOrdersAfterMarkDelivered();
          /*
          setState(() {
            if(tasks.length >0 )
              Get.to(TaskDetail(allTasksList: tasks, selectedTaskIndex: 0, taskDetail: tasks[0],));
          });
          */
        }
      },
      child: Container(
          margin: EdgeInsets.only(top: 20),
          height: SizeConfig.blockSizeVertical * 13,
          width: SizeConfig.blockSizeVertical * 10,
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Constants.textFieldColor,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                child: Center(
                  child: FaIcon(
                    FontAwesomeIcons.home,
                    color: Colors.white,
                    size: 36,
                  ),
                ),
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
                            '${oD.address}',
                            style: TextStyle(
                              fontFamily: 'Arial',
                              fontWeight: FontWeight.w700,
                              fontSize: SizeConfig.fontSize * 2.5,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 10),
                        child: Center(
                          child: Text(
                            '${oD.name}',
                            style: TextStyle(
                              fontFamily: 'Arial',
                              fontSize: SizeConfig.fontSize * 2.5,
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
                child: Center(
                  child: Text(
                    (!Constants.isUserOnline)
                        ? oD.readyByTime
                        : oD.deliveryByTime,
                    style: TextStyle(
                      fontFamily: 'Arial',
                      fontSize: SizeConfig.fontSize * 2,
                      color: Color(0xFFB2d235),
                    ),
                  ),
                ),
              )
            ],
          )),
    );
  }
}
