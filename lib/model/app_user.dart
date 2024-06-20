import 'package:shared_preferences/shared_preferences.dart';

class AppUser {
  String userId = "";
  String userName = "";
  String firstName = "";
  String lastName = "";
  String email = "";
  String phone = "";
  String vehicle = "";

  AppUser({this.userId, this.userName, this.firstName, this.lastName, this.email, this.phone, this.vehicle});

  factory AppUser.fromJson(Map<String, dynamic> json) {
    AppUser user = new AppUser(
      userId: json['userId'],
      userName : json['userName'],
      phone : json['phoneNumber'],
      email : json['email'],
    );
    return user;
  }

  Future saveUserDetails() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("UserId", this.userId);
    prefs.setString("UserName", this.userName);
    prefs.setString("UserPhoneNumber", this.phone);
    prefs.setString("UserEmail", this.email);
    prefs.setString("UserFirstName", this.firstName);
    prefs.setString("UserLastName", this.lastName);
    prefs.setString("UserVehicle", this.vehicle);

  }

  static Future<AppUser> getUserDetail() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    AppUser user = new AppUser();
    user.userId = prefs.getString("UserId") ?? "";
    user.userName = prefs.getString("UserName") ?? "";
    user.phone = prefs.getString("UserPhoneNumber") ?? "";
    user.email = prefs.getString("UserEmail") ?? "";
    user.firstName = prefs.getString("UserFirstName") ?? "";
    user.lastName = prefs.getString("UserLastName") ?? "";
    user.vehicle = prefs.getString("UserVehicle") ?? "";
    return user;
  }

  static Future deleteUserAndOtherPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }
}
