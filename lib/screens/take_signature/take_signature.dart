import 'dart:io';
import 'dart:typed_data';
import 'package:delivery_bot/model/order_detail.dart';
import 'package:delivery_bot/services/app_controller.dart';
import 'package:delivery_bot/utils/constants.dart';
import 'package:delivery_bot/utils/size_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:screenshot/screenshot.dart';
import 'package:signature/signature.dart';
import 'package:path_provider/path_provider.dart';

class TakeSignature extends StatefulWidget {
  final OrderDetail taskDetail;
  TakeSignature({this.taskDetail});
  
  @override
  _TakeSignatureState createState() => _TakeSignatureState();
}

class _TakeSignatureState extends State<TakeSignature> {

  ScreenshotController screenshotController = ScreenshotController(); 
  final SignatureController _controller = SignatureController(
    penStrokeWidth: 5,
    penColor: Colors.black,
    exportBackgroundColor: Colors.white,
  );

  @override
  void initState() {
    super.initState();
    _controller.addListener(() => print("Value changed"));
  }
  
  void uploadPictureProofForOrder(File imageFile) async {
    EasyLoading.show(status: 'Please wait', maskType: EasyLoadingMaskType.black,);
    dynamic result = await AppController().uploadSignatureProofForOrder(widget.taskDetail, imageFile);
    EasyLoading.dismiss();
    if (result['Status'] == "Success") 
    { 
      Navigator.of(context).pop(true);
    }
    else
    {
      Constants.showDialog(result['ErrorMessage']);
    }
    setState((){});
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      backgroundColor: Constants.appThemeColor,
      appBar: AppBar(
        backgroundColor: Constants.appOrangeColor,
        centerTitle: true,
        iconTheme: IconThemeData(
          color: Colors.black
        ),
        title: Text(
          'Signature',
          style: TextStyle(
            fontSize : SizeConfig.fontSize * 2.2,
            color: Colors.black,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.delete, color: Colors.black,),
            onPressed: (){
              setState(() => _controller.clear());
            }
          )
        ],
      ),
      body: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              height: SizeConfig.blockSizeVertical * 75,
              margin: EdgeInsets.all(20),
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20)
              ),
              child: Screenshot(
              controller: screenshotController,
                child: Signature(
                  height: SizeConfig.blockSizeVertical * 70,
                  controller: _controller,
                  backgroundColor: Colors.white,
                ),
              ),
            ),
            //OK AND CLEAR BUTTONS
            GestureDetector(
              onTap: () async {                      
                final directory = (await getExternalStorageDirectory()).path; //from path_provide package
                String fileName = "signature";
                screenshotController.capture().then((Uint8List image) async {
                  File file = new File('$directory/$fileName.png');
                  await file.writeAsBytes(image);
                  uploadPictureProofForOrder(file);
                }).catchError((onError) {
                    print(onError);
                });
              },
              child: Container(
                height: SizeConfig.blockSizeVertical * 7,
                margin: EdgeInsets.only(bottom: 20, left: SizeConfig.blockSizeHorizontal * 20, right: SizeConfig.blockSizeHorizontal * 20),
                decoration: BoxDecoration(
                  color: Constants.appOrangeColor,
                  borderRadius: BorderRadius.circular(100),
                ),
                child: Center(
                  child: Text(
                    'Submit',
                    style: TextStyle(
                      fontSize : SizeConfig.fontSize * 2.2,
                      color: Colors.white,
                    ),
                  ),
                )
              ),
            ),
          ],
        ),
      ),
    );
  }
}