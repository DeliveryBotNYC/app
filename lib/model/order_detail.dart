import 'package:intl/intl.dart';

class OrderDetail{

  int trackingId = 0;
  String name = "";
  String address = "";
  String phone = "";
  String apt = "";
  int items = 0;
  String note = "";
  String readyBy = "";
  String readyByTime = "";
  String deliverBy = "";
  String deliveryByTime = "";
  String status = "";
  String lat = "";
  String lon = "";
  int companyId = 0;
  String companyName = "";

  OrderDetail({this.trackingId, this.name, this.address, this.phone, this.apt, this.items, this.note, this.readyBy, this.deliverBy, this.companyId, this.lat, this.lon, this.status, this.readyByTime, this.deliveryByTime, this.companyName});

  factory OrderDetail.fromJson(Map<String, dynamic> json) {
    OrderDetail user = new OrderDetail(
      trackingId: json['tracking_id'],
      name : json['name'],
      address : json['address'],
      phone : json['phone'],
      apt: json['apt'],
      items : json['items'],
      note : json['note'],
      readyBy : json['ready_by'],
      deliverBy: json['deliver_by'],
      status : json['status'],
      lat : json['lat'],
      lon : json['lon'],
      companyId : json['company_id'],
      companyName: json['company_name'],
    );
    
    return user;
  }

  static String updateDate(String date){
    if(date != null)
    {
      var inputDate = DateTime.parse(date.toString());
      var outputFormat = DateFormat('hh:mm a');
      var outputDate = outputFormat.format(inputDate);
      return outputDate.toString();
    }
    else
      return '';
  }
}

/*
:"tracking_id" -> 353268215
1:"name" -> "test 1"
2:"address" -> "300 East 33 Street, NY"
3:"phone" -> "(928)389-2389"
4:"apt" -> ""
5:"items" -> 1
6:"note" -> ""
7:"ready_by" -> "2021-07-16 16:30:00"
8:"deliver_by" -> "2021-07-16 17:30:00"
9:"status" -> "Scheduled"
10:"lat" -> "40.7431932"
11:"lon" -> "-73.9758303"
12:"company_id" -> 9
*/