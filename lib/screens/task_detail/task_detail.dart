import 'dart:io';
import 'package:delivery_bot/model/order_detail.dart';
import 'package:delivery_bot/screens/pickup_records/pickup_records.dart';
import 'package:delivery_bot/screens/take_signature/take_signature.dart';
import 'package:delivery_bot/services/app_controller.dart';
import 'package:delivery_bot/utils/constants.dart';
import 'package:delivery_bot/utils/size_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class TaskDetail extends StatefulWidget {
  final List allTasksList;
  final int selectedTaskIndex;
  final OrderDetail taskDetail;
  TaskDetail({this.taskDetail, this.allTasksList, this.selectedTaskIndex});

  @override
  _TaskDetailState createState() => _TaskDetailState();
}

class _TaskDetailState extends State<TaskDetail> {
  Map companyProofPrefences;
  File _image;
  final picker = ImagePicker();
  bool isLoading = false;
  bool isPhotoUploaded = false;
  bool isSignatureUploaded = false;
  bool isVideoUploaded = false;
  bool isRecipientUploaded = false;
  bool markDeliveredAllowed = false;
  String recipientInfo = "";

  @override
  void initState() {
    super.initState();
    getOrderProofRequirements();
  }

  void getOrderProofRequirements() async {
    EasyLoading.show(
      status: 'Please wait',
      maskType: EasyLoadingMaskType.black,
    );
    dynamic result = await AppController()
        .getOrderProofRequirements(widget.taskDetail.companyId.toString());
    EasyLoading.dismiss();
    setState(() {});
    if (result['Status'] == "Success") {
      companyProofPrefences = result['CompanyPrefrences'];
      getOrderUploadedProofs();
    } else {
      Constants.showDialog(result['ErrorMessage']);
    }
    setState(() {});
  }

  void getOrderUploadedProofs() async {
    EasyLoading.show(
      status: 'Please wait',
      maskType: EasyLoadingMaskType.black,
    );
    dynamic result = await AppController()
        .getOrderUploadedProofs(widget.taskDetail.trackingId.toString());
    EasyLoading.dismiss();
    setState(() {});
    if (result['Status'] == "Success") {
      for (int i = 0; i < result['ProofsUploaded'].length; i++) {
        if (result['ProofsUploaded'][i]['preference_type'] == "video")
          isVideoUploaded = true;
        else if (result['ProofsUploaded'][i]['preference_type'] == "picture")
          isPhotoUploaded = true;
        else if (result['ProofsUploaded'][i]['preference_type'] == "signature")
          isSignatureUploaded = true;
        else {
          recipientInfo = result['ProofsUploaded'][i]['recipient_info'];
          isRecipientUploaded = true;
        }
      }
    } else {
      Constants.showDialog(result['ErrorMessage']);
    }
    setState(() {});
  }

  Future openMap() async {
    String googleUrl =
        'https://www.google.com/maps/search/?api=1&query=${widget.taskDetail.lat},${widget.taskDetail.lon}';
    if (await canLaunch(googleUrl)) {
      await launch(googleUrl);
    } else {
      Constants.showDialog(
          'Please install Google maps application to get directions');
    }
  }

  Future openPhone() async {
    String phoneUrl = 'tel://${widget.taskDetail.phone}';
    if (await canLaunch(phoneUrl)) {
      await launch(phoneUrl);
    }
  }

  ///////// PICTURE RELATED \\\\\\\\\\\\\\
  void showPhotoSelectionDialog() {
    Get.generalDialog(
        pageBuilder: (context, __, ___) => AlertDialog(
              title: Text('Upload Photo'),
              content: Text("Please select where you want to select photo"),
              actions: [
                FlatButton(
                    onPressed: () {
                      Get.back();
                      pickFromGallery();
                    },
                    child: Text('Gallery')),
                FlatButton(
                    onPressed: () {
                      Get.back();
                      pickFromCamera();
                    },
                    child: Text('Camera'))
              ],
            ));
  }

  void pickFromGallery() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      _image = File(pickedFile.path);
      setState(() {
        uploadPictureProofForOrder();
      });
    }
  }

  void pickFromCamera() async {
    final pickedFile = await picker.getImage(source: ImageSource.camera);
    if (pickedFile != null) {
      _image = File(pickedFile.path);
      setState(() {
        uploadPictureProofForOrder();
      });
    }
  }

  void uploadPictureProofForOrder() async {
    EasyLoading.show(
      status: 'Please wait',
      maskType: EasyLoadingMaskType.black,
    );
    dynamic result = await AppController()
        .uploadPictureProofForOrder(widget.taskDetail, _image);
    EasyLoading.dismiss();
    if (result['Status'] == "Success") {
      isPhotoUploaded = true;
    } else {
      Constants.showDialog(result['ErrorMessage']);
    }
    setState(() {});
  }

  ///////// VIDEO RELATED \\\\\\\\\\\\\\
  void showVideoSelectionDialog() {
    Get.generalDialog(
        pageBuilder: (context, __, ___) => AlertDialog(
              title: Text('Upload Video'),
              content: Text("Please select where you want to select video"),
              actions: [
                FlatButton(
                    onPressed: () {
                      Get.back();
                      pickVideoFromGallery();
                    },
                    child: Text('Gallery')),
                FlatButton(
                    onPressed: () {
                      Get.back();
                      pickVideoFromCamera();
                    },
                    child: Text('Camera'))
              ],
            ));
  }

  void pickVideoFromGallery() async {
    final pickedFile = await picker.getVideo(source: ImageSource.gallery);
    if (pickedFile != null) {
      _image = File(pickedFile.path);
      setState(() {
        uploadVideoProofForOrder();
      });
    }
  }

  void pickVideoFromCamera() async {
    final pickedFile = await picker.getVideo(source: ImageSource.camera);
    if (pickedFile != null) {
      _image = File(pickedFile.path);
      setState(() {
        uploadVideoProofForOrder();
      });
    }
  }

  void uploadVideoProofForOrder() async {
    EasyLoading.show(
      status: 'Please wait',
      maskType: EasyLoadingMaskType.black,
    );
    dynamic result = await AppController()
        .uploadVideoProofForOrder(widget.taskDetail, _image);
    EasyLoading.dismiss();
    if (result['Status'] == "Success") {
      isVideoUploaded = true;
    } else {
      Constants.showDialog(result['ErrorMessage']);
    }
    setState(() {});
  }

  /////////// NAME RELATED \\\\\\\\\\\\\
  void addNameView(String userType) {
    String userName = "";
    Get.generalDialog(
        pageBuilder: (context, __, ___) => AlertDialog(
              contentPadding: EdgeInsets.all(0),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0))),
              content: Container(
                width: 300,
                //height: 70,
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    Container(
                      margin: EdgeInsets.only(
                        left: 20,
                        right: 20,
                      ),
                      height: 30,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(),
                          Text(
                            'Name',
                            style: TextStyle(
                                fontSize: SizeConfig.fontSize * 2,
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                          ),
                          GestureDetector(
                              onTap: () {
                                Get.back();
                              },
                              child: Icon(Icons.close,
                                  color: Constants.appOrangeColor)),
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 20, right: 20, top: 10),
                      height: 1,
                      width: 250,
                      color: Constants.textFieldTextColor,
                    ),
                    Container(
                      height: SizeConfig.safeBlockVertical * 6,
                      margin: EdgeInsets.only(top: 10, left: 20, right: 20),
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                        child: TextField(
                          onChanged: (val) {
                            userName = val;
                          },
                          style: TextStyle(
                              fontSize: SizeConfig.fontSize * 2,
                              color: Colors.black),
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 20, vertical: 0),
                            hintText: 'Enter Name',
                            hintStyle:
                                TextStyle(color: Constants.textFieldTextColor),
                            fillColor: Colors.grey[100],
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        if (userName.length == 0)
                          Constants.showDialog('Please enter name to submit');
                        else {
                          Get.back();
                          uploadUserNameProofForOrder(userType, userName);
                        }
                      },
                      child: Container(
                        height: SizeConfig.safeBlockVertical * 5,
                        margin: EdgeInsets.only(
                            top: 10, left: 70, right: 70, bottom: 10),
                        decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(
                          child: Text(
                            'Submit',
                            style: TextStyle(
                              fontSize: SizeConfig.fontSize * 1.8,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ));
  }

  void uploadUserNameProofForOrder(String userType, String userName) async {
    EasyLoading.show(
      status: 'Please wait',
      maskType: EasyLoadingMaskType.black,
    );
    dynamic result = await AppController()
        .uploadUserProofForOrder(widget.taskDetail, userType, userName);
    EasyLoading.dismiss();
    if (result['Status'] == "Success") {
      isRecipientUploaded = true;
      recipientInfo = userType + " - " + userName;
    } else {
      Constants.showDialog(result['ErrorMessage']);
    }
    setState(() {});
  }

  void updateOrderStatus() async {
    EasyLoading.show(
      status: 'Please wait',
      maskType: EasyLoadingMaskType.black,
    );
    dynamic result = await AppController().updateOrderStatus(widget.taskDetail);
    EasyLoading.dismiss();
    setState(() {});
    if (result['Status'] == "Success") {
      widget.allTasksList.removeAt(widget.selectedTaskIndex);
      Navigator.of(context).pop('true');
    } else {
      Constants.showDialog(result['ErrorMessage']);
    }
    setState(() {});
  }

  Color getColorForRecipientButton(String buttonTextName) {
    if (isRecipientUploaded) {
      if (recipientInfo.toLowerCase().contains(buttonTextName.toLowerCase()))
        return Colors.green;
      else
        return Constants.textFieldColor;
    } else
      return Constants.textFieldColor;
  }

  bool isMarkDeliveredAllowed() {
    bool allowed = false;

    if (companyProofPrefences['picture'] == "1" && isPhotoUploaded)
      allowed = true;
    else if (companyProofPrefences['picture'] == "0" && !isPhotoUploaded)
      allowed = true;
    else
      allowed = false;

    if (companyProofPrefences['video'] == "1" && isVideoUploaded)
      allowed = true;
    else if (companyProofPrefences['video'] == "0" && !isVideoUploaded)
      allowed = true;
    else
      allowed = false;

    if (companyProofPrefences['signature'] == "1" && isSignatureUploaded)
      allowed = true;
    else if (companyProofPrefences['signature'] == "0" && !isSignatureUploaded)
      allowed = true;
    else
      allowed = false;

    if (companyProofPrefences['recipient_name'] == "1" && isRecipientUploaded)
      allowed = true;
    else if (companyProofPrefences['recipient_name'] == "0" &&
        !isRecipientUploaded)
      allowed = true;
    else
      allowed = false;

    return allowed;
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
        child: (companyProofPrefences == null)
            ? Container()
            : Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    margin: EdgeInsets.only(bottom: 20),
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
                                      '${widget.taskDetail.name}',
                                      style: TextStyle(
                                          fontSize: SizeConfig.fontSize * 2.5,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(top: 10),
                                  child: Center(
                                    child: Text(
                                      '${widget.taskDetail.address}',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: SizeConfig.fontSize * 2,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: openMap,
                          child: Container(
                            width: SizeConfig.blockSizeHorizontal * 15,
                            child: Icon(Icons.directions,
                                color: Colors.white,
                                size: SizeConfig.blockSizeHorizontal * 15),
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
                    margin:
                        EdgeInsets.only(top: SizeConfig.blockSizeVertical * 3),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Container(
                            child: Text(
                              'Deliver by :',
                              style: TextStyle(
                                  fontSize: SizeConfig.fontSize * 1.8,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            margin: EdgeInsets.only(top: 10),
                            child: Text(
                              '${widget.taskDetail.deliveryByTime}',
                              style: TextStyle(
                                  fontSize: SizeConfig.fontSize * 1.8,
                                  color: Colors.green,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),

                  //Company
                  Container(
                    margin:
                        EdgeInsets.only(top: SizeConfig.blockSizeVertical * 3),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Container(
                            child: Text(
                              'Company :',
                              style: TextStyle(
                                  fontSize: SizeConfig.fontSize * 1.8,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            margin: EdgeInsets.only(top: 10),
                            child: Text(
                              '${widget.taskDetail.companyName}',
                              style: TextStyle(
                                  fontSize: SizeConfig.fontSize * 1.8,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),

                  //ITEMS COUNT
                  Container(
                    margin:
                        EdgeInsets.only(top: SizeConfig.blockSizeVertical * 3),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Container(
                            child: Text(
                              'No. if items :',
                              style: TextStyle(
                                  fontSize: SizeConfig.fontSize * 1.8,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            margin: EdgeInsets.only(top: 10),
                            child: Text(
                              '${widget.taskDetail.items}',
                              style: TextStyle(
                                  fontSize: SizeConfig.fontSize * 1.8,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),

                  //Company
                  Container(
                    margin:
                        EdgeInsets.only(top: SizeConfig.blockSizeVertical * 3),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Container(
                            child: Text(
                              'Note :',
                              style: TextStyle(
                                  fontSize: SizeConfig.fontSize * 1.8,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            margin: EdgeInsets.only(top: 10),
                            child: Text(
                              '${(widget.taskDetail.note.length == 0) ? '-' : widget.taskDetail.note}',
                              style: TextStyle(
                                  fontSize: SizeConfig.fontSize * 1.8,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),

                  Expanded(
                    child: Container(
                        //color: Colors.redAccent,
                        ),
                  ),

                  Container(
                    margin: EdgeInsets.only(top: 10, bottom: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            if (companyProofPrefences["picture"] != "0")
                              IconButton(
                                icon: Icon(Icons.camera_alt,
                                    size: SizeConfig.blockSizeVertical * 5,
                                    color: (isPhotoUploaded)
                                        ? Colors.green
                                        : Colors.white),
                                onPressed: (isPhotoUploaded == false)
                                    ? showPhotoSelectionDialog
                                    : null,
                              ),
                            if (companyProofPrefences["picture"] != "0")
                              SizedBox(
                                width: 10,
                              ),
                            if (companyProofPrefences["signature"] != "0")
                              IconButton(
                                icon: Icon(Icons.sticky_note_2_sharp,
                                    size: SizeConfig.blockSizeVertical * 5,
                                    color: (isSignatureUploaded)
                                        ? Colors.green
                                        : Colors.white),
                                onPressed: (isSignatureUploaded == false)
                                    ? () async {
                                        dynamic result =
                                            await Get.to(TakeSignature(
                                          taskDetail: widget.taskDetail,
                                        ));
                                        if (result != null) {
                                          setState(() {
                                            isSignatureUploaded = true;
                                          });
                                        }
                                      }
                                    : null,
                              ),
                            if (companyProofPrefences["video"] != "0")
                              SizedBox(
                                width: 10,
                              ),
                            if (companyProofPrefences["video"] != "0")
                              //add here
                              IconButton(
                                icon: FaIcon(FontAwesomeIcons.video,
                                    size: SizeConfig.blockSizeVertical * 5,
                                    color: (isVideoUploaded)
                                        ? Colors.green
                                        : Colors.white),
                                onPressed: (isVideoUploaded == false)
                                    ? showVideoSelectionDialog
                                    : null,
                              ),
                          ],
                        ),
                        Row(
                          children: [
                            IconButton(
                                icon: Icon(Icons.call,
                                    size: SizeConfig.blockSizeVertical * 5,
                                    color: Colors.white),
                                onPressed: () {
                                  openPhone();
                                }),
                          ],
                        )
                      ],
                    ),
                  ),

                  if (companyProofPrefences["recipient_name"] != "0")
                    Container(
                      margin: EdgeInsets.only(top: 10, bottom: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                            onTap: () {
                              //Get.to(PickUpRecords());
                              addNameView("Doorman");
                            },
                            child: Container(
                              width: SizeConfig.blockSizeHorizontal * 38,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: getColorForRecipientButton("Doorman")),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 0,
                                  vertical: SizeConfig.blockSizeVertical * 1),
                              child: Center(
                                child: Text(
                                  'Doorman',
                                  style: TextStyle(
                                    fontSize: SizeConfig.fontSize * 2.3,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              uploadUserNameProofForOrder("Customer", "");
                            },
                            child: Container(
                              width: SizeConfig.blockSizeHorizontal * 38,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color:
                                      getColorForRecipientButton("Customer")),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 0,
                                  vertical: SizeConfig.blockSizeVertical * 1),
                              child: Center(
                                child: Text(
                                  'Customer',
                                  style: TextStyle(
                                    fontSize: SizeConfig.fontSize * 2.3,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                  if (companyProofPrefences["recipient_name"] != "0")
                    Container(
                      margin: EdgeInsets.only(top: 10, bottom: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                            onTap: () {
                              addNameView("Package room");
                            },
                            child: Container(
                              width: SizeConfig.blockSizeHorizontal * 38,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: getColorForRecipientButton(
                                      "Package room")),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 0,
                                  vertical: SizeConfig.blockSizeVertical * 1),
                              child: Center(
                                child: Text(
                                  'Package room',
                                  style: TextStyle(
                                    fontSize: SizeConfig.fontSize * 2,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              addNameView("Receptionist");
                            },
                            child: Container(
                              width: SizeConfig.blockSizeHorizontal * 38,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: getColorForRecipientButton(
                                      "Receptionist")),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 0,
                                  vertical: SizeConfig.blockSizeVertical * 1),
                              child: Center(
                                child: Text(
                                  'Receptionist',
                                  style: TextStyle(
                                    fontSize: SizeConfig.fontSize * 2.3,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                  //Order Delivered
                  Container(
                    margin: EdgeInsets.only(top: 0, bottom: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: () {
                            //if(isMarkDeliveredAllowed())
                            updateOrderStatus();
                          },
                          child: Container(
                            width: SizeConfig.blockSizeHorizontal * 90,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: (isMarkDeliveredAllowed())
                                    ? Constants.textFieldColor
                                    : Colors.grey.withOpacity(0.6)),
                            padding: EdgeInsets.symmetric(
                                horizontal: 0,
                                vertical: SizeConfig.blockSizeVertical * 1.5),
                            child: Center(
                              child: Text(
                                'Mark Delivered',
                                style: TextStyle(
                                  fontSize: SizeConfig.fontSize * 2,
                                  color: Colors.white,
                                ),
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
}
