import 'dart:convert'show json;

class StateObject{
  String name;
  int active,confirmed,recovered;

  StateObject({this.active,this.confirmed,this.recovered,this.name});

  factory StateObject.fromJson(Map<String, dynamic> data){
    return StateObject(
      active: int.parse(data['active']),
      confirmed: int.parse(data['confirmed']),
      recovered: int.parse(data['recovered']),
      name: data['state']
    );
  }
}