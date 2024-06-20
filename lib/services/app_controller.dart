import 'dart:convert';
import 'dart:io';
import 'package:delivery_bot/model/app_user.dart';
import 'package:delivery_bot/model/order_detail.dart';
import 'package:delivery_bot/utils/constants.dart';
import 'package:http/http.dart';
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:async/async.dart';

class AppController {

  //SIGN UP
  Future signUpUser(String firstName, String lastName, String email, String mobile, String vehicle, String userName, String password) async {
    try {
      String url = Constants.signUpUrl;
      print(url);

      Map<String, String> headers = {"Content-type": "application/json"};
      String json = '{ "fname": "$firstName", "lname": "$lastName", "email": "$email", "phone": "$mobile", "v_model": "$vehicle", "username": "$userName", "password": "$password"}';      
      Response response = await post("https://portal.deliverybotnyc.com/api/signup.php" ,headers: headers, body: json);
      Map data = jsonDecode(response.body);
      if (data['status'] != "error") {
        print(response.body);
        Map finalResponse = <dynamic, dynamic>{}; //empty map
        finalResponse['Status'] = "Success";
        return finalResponse;
      } else {
        Map finalResponse = <dynamic, dynamic>{}; //empty map
        finalResponse['Error'] = "Error";
        finalResponse['ErrorMessage'] = data["message"];
        return finalResponse;
      }
    } catch (e) {
      print(e.toString());
      return setUpFailure();
    }
  }

  //SIGN IN
  Future signInUser(String userName, String password) async {
    try {
      String url = Constants.loginUrl;
      print(url);
      Map<String, String> headers = {"Content-type": "application/json"};
      String json = '{ "username": "$userName", "password": "$password"}';        
      Response response = await post(url, headers : headers, body: json);
      Map data = jsonDecode(response.body);
      if (data['status'] != "error") {
        print(response.body);
        //SAVE USER AND TOKEN NOW
        String token = data['token'];
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString('token', token); 
        Constants.appUser = AppUser();
        Constants.appUser.userName = userName;
        await Constants.appUser.saveUserDetails();
        Map finalResponse = <dynamic, dynamic>{}; //empty map
        finalResponse['Status'] = "Success";
        return finalResponse;
      } else {
        Map data = jsonDecode(response.body);
        Map finalResponse = <dynamic, dynamic>{}; //empty map
        finalResponse['Error'] = "Error";
        finalResponse['ErrorMessage'] = data["message"];
        return finalResponse;
      }
    } catch (e) {
      print(e.toString());
      return setUpFailure();
    }
  }

  //GET PROFILE
  Future getProfile() async {
    try {
      String url = Constants.myProfile;
      print(url);
      Map<String, String> headers = await setHeaders();
      Response response = await get( url,headers: headers);
      Map data = jsonDecode(response.body);
      if (data['status'] != "error") 
      {
        Map userData = data['results'];
        Constants.appUser.firstName = userData["fname"];
        Constants.appUser.lastName = userData["lname"];
        Constants.appUser.email = userData["email"];
        Constants.appUser.phone = userData["phone"];
        Constants.appUser.vehicle = userData["v_model"];
        await Constants.appUser.saveUserDetails();
        Map finalResponse = <dynamic, dynamic>{}; //empty map
        finalResponse['Status'] = "Success";
        return finalResponse;
      } 
      else 
      {
        Map finalResponse = <dynamic, dynamic>{}; //empty map
        finalResponse['Error'] = "Error";
        finalResponse['ErrorMessage'] = data["message"];
        return finalResponse;
      }
    } catch (e) {
      print(e.toString());
      return setUpFailure();
    }
  }

  //UPDATE PROFILE
  Future updateMyProfile(String firstName, String lastName, String email, String mobile, String vehicle) async {
    try {
      String url = Constants.updateMyProfile;
      print(url);
      Map<String, String> headers = await setHeaders();
      String json = '{ "fname": "$firstName", "lname": "$lastName", "email": "$email", "phone": "$mobile", "v_model": "$vehicle"}';      
      Response response = await post( url, headers: headers, body: json);
      Map data = jsonDecode(response.body);
      if (data['status'] != "error") 
      {
        Constants.appUser.firstName = firstName;
        Constants.appUser.lastName = lastName;
        Constants.appUser.email = email;
        Constants.appUser.phone = mobile;
        Constants.appUser.vehicle = vehicle;
        await Constants.appUser.saveUserDetails();
        Map finalResponse = <dynamic, dynamic>{}; //empty map
        finalResponse['Status'] = "Success";
        return finalResponse;
      } 
      else 
      {
        Map finalResponse = <dynamic, dynamic>{}; //empty map
        finalResponse['Error'] = "Error";
        finalResponse['ErrorMessage'] = data["message"];
        return finalResponse;
      }
    } catch (e) {
      print(e.toString());
      return setUpFailure();
    }
  }

  //UPDATE DRIVER STATUS
  Future updateDriverOnlineStatus(bool status) async {
    try {
      String url = Constants.updatDriverOnlineStatus;
      print(url);
      int driverStatus = (status) ? 1 : 0;
      Map<String, String> headers = await setHeaders();  
      String json = '{"action": "update_driver_online_status", "status": $driverStatus}';      
      Response response = await post( url, headers: headers, body: json);
      Map data = jsonDecode(response.body);
      if (data['status'] != "error") 
      {
        Map finalResponse = <dynamic, dynamic>{}; //empty map
        finalResponse['Status'] = "Success";
        return finalResponse;
      } 
      else 
      {
        Map finalResponse = <dynamic, dynamic>{}; //empty map
        finalResponse['Error'] = "Error";
        finalResponse['ErrorMessage'] = data["message"];
        return finalResponse;
      }
    } catch (e) {
      print(e.toString());
      return setUpFailure();
    }
  }

  //UPDATE DRIVER STATUS
  Future updateDriverLocation(double latitude, double longitude) async {
    try {
      String url = Constants.updatDriverOnlineStatus;
      print(url);
      Map<String, String> headers = await setHeaders();  
      String json = '{"action": "update_driver_location", "lat": "${latitude.toString()}" , "lng": "${longitude.toString()}"}';      
      Response response = await post( url, headers: headers, body: json);
      Map data = jsonDecode(response.body);
      if (data['status'] != "error") 
      {
        Map finalResponse = <dynamic, dynamic>{}; //empty map
        finalResponse['Status'] = "Success";
        return finalResponse;
      } 
      else 
      {
        Map finalResponse = <dynamic, dynamic>{}; //empty map
        finalResponse['Error'] = "Error";
        finalResponse['ErrorMessage'] = data["message"];
        return finalResponse;
      }
    } catch (e) {
      print(e.toString());
      return setUpFailure();
    }
  }


  //GET PROFILE
  Future getSchedule() async {
    try {
      String url = Constants.getSchedule;
      print(url);
      Map<String, String> headers = await setHeaders();
      Response response = await get( url, headers: headers);
      Map data = jsonDecode(response.body);
      if (data['status'] != "error") 
      {
        Map finalResponse = <dynamic, dynamic>{}; //empty map
        finalResponse['Status'] = "Success";
        finalResponse['Results'] =  data['schedule'];
        return finalResponse;
      } 
      else 
      {
        Map finalResponse = <dynamic, dynamic>{}; //empty map
        finalResponse['Error'] = "Error";
        finalResponse['ErrorMessage'] = data["message"];
        return finalResponse;
      }
    } catch (e) {
      print(e.toString());
      return setUpFailure();
    }
  }

  //GET ORDERS
  Future getOrders(List taskList) async {
    try {
      String url = Constants.getOrders;
      print(url);
      Map<String, String> headers = await setHeaders();
      Response response = await get( url,headers: headers);
      Map data = jsonDecode(response.body);
      if (data['status'] != "error") {
        print(response.body);
        for(int i=0; i < data['results'].length ; i ++){
          OrderDetail oD = OrderDetail.fromJson(data['results'][i]);
          oD.readyByTime = OrderDetail.updateDate(oD.readyBy);
          oD.deliveryByTime = OrderDetail.updateDate(oD.deliverBy);
          taskList.add(oD);
        }
        Map finalResponse = <dynamic, dynamic>{}; //empty map
        finalResponse['Status'] = "Success";
        return finalResponse;
      } 
      else {
        Map finalResponse = <dynamic, dynamic>{}; //empty map
        finalResponse['Error'] = "Error";
        finalResponse['ErrorMessage'] = data["message"];
        return finalResponse;
      }
    } catch (e) {
      print(e.toString());
      return setUpFailure();
    }
  }

  Future getOrderProofRequirements(String companyID) async {
    try {
      String url = Constants.getOrderProofRequirements;
      url = url.replaceFirst("{companyId}", companyID);
      print(url);
      Map<String, String> headers = await setHeaders();
      Response response = await get( url,headers: headers);
      Map data = jsonDecode(response.body);
      if (data['status'] != "error") 
      {
        Map companyPrefrences = data['prefrences'];
        Map finalResponse = <dynamic, dynamic>{}; //empty map
        finalResponse['Status'] = "Success";
        finalResponse['CompanyPrefrences'] = companyPrefrences;
        return finalResponse;
      } 
      else 
      {
        Map finalResponse = <dynamic, dynamic>{}; //empty map
        finalResponse['Error'] = "Error";
        finalResponse['ErrorMessage'] = data["message"];
        return finalResponse;
      }
    } catch (e) {
      print(e.toString());
      return setUpFailure();
    }
  }

  
  Future getOrderUploadedProofs(String trackingId) async {
    try {
      String url = Constants.getOrderUploadedProofs;
      url = url.replaceFirst("{tracking_id}", trackingId);
      print(url);
      Map<String, String> headers = await setHeaders();
      Response response = await get( url,headers: headers);
      Map data = jsonDecode(response.body);
      if (data['status'] != "error") 
      {
        List proofsUploaded = data['prefrences'];
        Map finalResponse = <dynamic, dynamic>{}; //empty map
        finalResponse['Status'] = "Success";
        finalResponse['ProofsUploaded'] = proofsUploaded;
        return finalResponse;
      } 
      else 
      {
        Map finalResponse = <dynamic, dynamic>{}; //empty map
        finalResponse['Error'] = "Error";
        finalResponse['ErrorMessage'] = data["message"];
        return finalResponse;
      }
    } catch (e) {
      print(e.toString());
      return setUpFailure();
    }
  }

  Future uploadPictureProofForOrder(OrderDetail orderDetail, File image) async {
    try {
      var stream = new ByteStream(DelegatingStream.typed(image.openRead()));
      var length = await image.length(); //imageFile is your image file
      Map<String, String> headers = await setHeaders();
      var uri = Uri.parse(Constants.uploadOrderProof);    
      var request = new MultipartRequest("POST", uri);
      var multipartFileSign = new MultipartFile('file', stream, length, filename: basename(image.path));
      request.files.add(multipartFileSign);
      request.headers.addAll(headers);
      request.fields['tracking_id'] = '${orderDetail.trackingId}';
      request.fields['preference_type'] = 'picture';
      // send
      var response = await request.send();
      print(response.statusCode);
      String responseData = await utf8.decoder.bind(response.stream).join();
      print(responseData);
      Map data = jsonDecode(responseData);
      if (data['status'] != "error") 
      {
        Map finalResponse = <dynamic, dynamic>{}; //empty map
        finalResponse['Status'] = "Success";
        return finalResponse;
      } 
      else 
      {
        Map finalResponse = <dynamic, dynamic>{}; //empty map
        finalResponse['Error'] = "Error";
        finalResponse['ErrorMessage'] = data["message"];
        return finalResponse;
      }
    } catch (e) {
      print(e.toString());
      Constants.showDialog("Cannot connect to server. Please try again later");      
      return setUpFailure();
    }
  }

   Future uploadSignatureProofForOrder(OrderDetail orderDetail, File image) async {
    try {
      var stream = new ByteStream(DelegatingStream.typed(image.openRead()));
      var length = await image.length(); //imageFile is your image file
      Map<String, String> headers = await setHeaders();
      var uri = Uri.parse(Constants.uploadOrderProof);    
      var request = new MultipartRequest("POST", uri);
      var multipartFileSign = new MultipartFile('file', stream, length, filename: basename(image.path));
      request.files.add(multipartFileSign);
      request.headers.addAll(headers);
      request.fields['tracking_id'] = '${orderDetail.trackingId}';
      request.fields['preference_type'] = 'signature';
      var response = await request.send();
      String responseData = await utf8.decoder.bind(response.stream).join();
      print(responseData);
      Map data = jsonDecode(responseData);
      if (data['status'] != "error") 
      {
        Map finalResponse = <dynamic, dynamic>{}; //empty map
        finalResponse['Status'] = "Success";
        return finalResponse;
      } 
      else 
      {
        Map finalResponse = <dynamic, dynamic>{}; //empty map
        finalResponse['Error'] = "Error";
        finalResponse['ErrorMessage'] = data["message"];
        return finalResponse;
      }
    } catch (e) {
      print(e.toString());
      Constants.showDialog("Cannot connect to server. Please try again later");      
      return setUpFailure();
    }
  }

  Future uploadVideoProofForOrder(OrderDetail orderDetail, File image) async {
    try {
      var stream = new ByteStream(DelegatingStream.typed(image.openRead()));
      var length = await image.length(); //imageFile is your image file
      Map<String, String> headers = await setHeaders();
      var uri = Uri.parse(Constants.uploadOrderProof);    
      var request = new MultipartRequest("POST", uri);
      var multipartFileSign = new MultipartFile('file', stream, length, filename: basename(image.path));
      request.files.add(multipartFileSign);
      request.headers.addAll(headers);
      request.fields['tracking_id'] = '${orderDetail.trackingId}';
      request.fields['preference_type'] = 'video';
      // send
      var response = await request.send();
      print(response.statusCode);
      String responseData = await utf8.decoder.bind(response.stream).join();
      print(responseData);
      Map data = jsonDecode(responseData);
      if (data['status'] != "error") 
      {
        Map finalResponse = <dynamic, dynamic>{}; //empty map
        finalResponse['Status'] = "Success";
        return finalResponse;
      } 
      else 
      {
        Map finalResponse = <dynamic, dynamic>{}; //empty map
        finalResponse['Error'] = "Error";
        finalResponse['ErrorMessage'] = data["message"];
        return finalResponse;
      }
    } catch (e) {
      print(e.toString());
      Constants.showDialog("Cannot connect to server. Please try again later");      
      return setUpFailure();
    }
  }

  Future uploadUserProofForOrder(OrderDetail orderDetail, String userType, String userName) async {
   try {
      Map<String, String> headers = await setHeaders();
      var uri = Uri.parse(Constants.uploadOrderProof);    
      var request = new MultipartRequest("POST", uri);
      request.headers.addAll(headers);
      request.fields['tracking_id'] = '${orderDetail.trackingId}';
      request.fields['preference_type'] = 'recipient_name';
      request.fields['recipient_info'] = '$userType - $userName';
      // send
      var response = await request.send();
      print(response.statusCode);
      String responseData = await utf8.decoder.bind(response.stream).join();
      print(responseData);
      Map data = jsonDecode(responseData);
      if (data['status'] != "error") 
      {
        Map finalResponse = <dynamic, dynamic>{}; //empty map
        finalResponse['Status'] = "Success";
        return finalResponse;
      } 
      else 
      {
        Map finalResponse = <dynamic, dynamic>{}; //empty map
        finalResponse['Error'] = "Error";
        finalResponse['ErrorMessage'] = data["message"];
        return finalResponse;
      }
    } catch (e) {
      print(e.toString());
      return setUpFailure();
    }
  }

  //UPDATE ORDER STATUS
  Future updateOrderStatus(OrderDetail oD) async {
    try {
      String url = Constants.updateOrderStatus;
      print(url);
      Map<String, String> headers = await setHeaders();  
      String json = '{"action": "update_order_status", "tracking_id": "${oD.trackingId}", "status": "Delivered"}';      
      Response response = await post( url, headers: headers, body: json);
      Map data = jsonDecode(response.body);
      if (data['status'] != "error") 
      {
        Map finalResponse = <dynamic, dynamic>{}; //empty map
        finalResponse['Status'] = "Success";
        return finalResponse;
      } 
      else 
      {
        Map finalResponse = <dynamic, dynamic>{}; //empty map
        finalResponse['Error'] = "Error";
        finalResponse['ErrorMessage'] = data["message"];
        return finalResponse;
      }
    } catch (e) {
      print(e.toString());
      return setUpFailure();
    }
  }

  Future getEarningStats(String startDate, String endDate) async {
    try {
      String url = Constants.getEarningStats;
      print(url);
      Map<String, String> headers = await setHeaders();  
      String json = '{"action": "get_stats", "date_1": "$startDate", "date_2": "$endDate"}';      
      Response response = await post( url, headers: headers, body: json);
      Map data = jsonDecode(response.body);
      if (data['status'] != "error") 
      {
        Map finalResponse = <dynamic, dynamic>{}; //empty map
        finalResponse['Status'] = "Success";
        if(data['results'] != '')
        {
          double rating = (data['results']['rating']['average_rating'] == null) ? 0.0 : double.parse(data['results']['rating']['average_rating']);
          int deliveryCount = data['results']['delivery_count'];
          int secondsOnline = (data['results']['seconds_available'] == null) ? 0 : int.parse(data['results']['seconds_available']);
          double tip = (data['results']['tips'] == null) ? 0.0 : data['results']['tips'];
          double hourlyRate = data['results']['hourly_rate'].toDouble();
          
          double totalHours = (secondsOnline == 0) ? 0.0 : secondsOnline/ 3600;
          double deliveryPrHour = (totalHours == 0) ? 0.0 : deliveryCount/totalHours;
          double hourlyPay = (deliveryPrHour == 0) ? 0.0 : totalHours * hourlyRate;
          double payDue = (hourlyPay == 0) ? 0.0 : hourlyPay + tip;

          finalResponse['DeliveryPrHour'] =  deliveryPrHour;
          finalResponse['Rating'] =  rating;
          finalResponse['HoursWorked'] =  totalHours;
          finalResponse['Tip'] =  tip;
          finalResponse['HourlyPay'] =  hourlyPay;
          finalResponse['PayDue'] =  payDue;
        }
        return finalResponse;
      } 
      else 
      {
        Map finalResponse = <dynamic, dynamic>{}; //empty map
        finalResponse['Error'] = "Error";
        finalResponse['ErrorMessage'] = data["message"];
        return finalResponse;
      }
    } catch (e) {
      print(e.toString());
      return setUpFailure();
    }
  }

   Future getRating() async {
    try {
      String url = Constants.getRating;
      print(url);
      Map<String, String> headers = await setHeaders();  
      Response response = await get( url, headers: headers);
      Map data = jsonDecode(response.body);
      if (data['status'] != "error") 
      {
        Map finalResponse = <dynamic, dynamic>{}; //empty map
        finalResponse['Status'] = "Success";
        finalResponse['Rating'] = double.parse(data['rating']['average_rating']);
        return finalResponse;
      } 
      else 
      {
        Map finalResponse = <dynamic, dynamic>{}; //empty map
        finalResponse['Error'] = "Error";
        finalResponse['ErrorMessage'] = data["message"];
        return finalResponse;
      }
    } catch (e) {
      print(e.toString());
      return setUpFailure();
    }
  }

  Future scheduleForDate(String dateScheduleOn) async {
    try {
      String url = Constants.scheduleForDay;
      print(url);
      Map<String, String> headers = await setHeaders();  
      String json = '{"action": "schedule", "date": "$dateScheduleOn"}';      
      Response response = await post( url, headers: headers, body: json);
      Map data = jsonDecode(response.body);
      if (data['status'] != "error") 
      {
        Map finalResponse = <dynamic, dynamic>{}; //empty map
        finalResponse['Status'] = "Success";
        return finalResponse;
      } 
      else 
      {
        Map finalResponse = <dynamic, dynamic>{}; //empty map
        finalResponse['Error'] = "Error";
        finalResponse['ErrorMessage'] = data["message"];
        return finalResponse;
      }
    } catch (e) {
      print(e.toString());
      return setUpFailure();
    }
  }

  Future createOrder(String name, String phone, String address, String apt, String items, String note, int companyId ) async {
    try {
      String url = Constants.scheduleForDay;
      print(url);
      Map<String, String> headers = await setHeaders();  
      String json = '{"action": "create_order", "name": "$name", "phone": "$phone", "address": "$address", "apt": "$apt", "items": "$items", "note": "$note", "company_id": $companyId }';      
      Response response = await post( url, headers: headers, body: json);
      Map data = jsonDecode(response.body);
      if (data['status'] != "error") 
      {
        Map finalResponse = <dynamic, dynamic>{}; //empty map
        finalResponse['Status'] = "Success";
        return finalResponse;
      } 
      else 
      {
        Map finalResponse = <dynamic, dynamic>{}; //empty map
        finalResponse['Error'] = "Error";
        finalResponse['ErrorMessage'] = data["message"];
        return finalResponse;
      }
    } catch (e) {
      print(e.toString());
      return setUpFailure();
    }
  }



  Future<Map<String, String>> setHeaders() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String userToken = prefs.getString('token');
    userToken = "Bearer " + userToken;
    Map<String, String> headers = {"Authorization" : userToken, "Content-type": "application/json"};
    return headers;
  }
  
  Map setUpFailure() {
    Map finalResponse = <dynamic, dynamic>{}; //empty map
    finalResponse['Status'] = "Error";
    finalResponse['ErrorMessage'] = "Cannot connect to server. Please try again later";
    return finalResponse;
  }
}
