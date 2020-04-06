import 'dart:convert'show json;

class DayObject{
  String date;
  int totalConfirmed,confirmed,recovered;

  DayObject({this.totalConfirmed,this.confirmed,this.recovered,this.date});

  factory DayObject.fromJson(Map<String, dynamic> data){
    return DayObject(
        totalConfirmed: int.parse(data['totalconfirmed']),
        confirmed: int.parse(data['dailyconfirmed']),
        recovered: int.parse(data['dailyrecovered']),
        date: data['date'],
    );
  }
}