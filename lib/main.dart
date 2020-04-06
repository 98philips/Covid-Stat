import 'dart:convert'show json;

import 'package:covidstat/day_object.dart';
import 'package:covidstat/state_object.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Covid Statistics',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  final String  dataURL= "https://api.covid19india.org/data.json";
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  List<StateObject> stateList;
  List<DayObject> dayList;
  int _selectedIndex;

  @override
  void initState() {
    super.initState();
    _selectedIndex = 0;
    stateList = [];
    dayList = [];
    getData();
  }

  getData() async{
    var response;
    try{
      response = await http.get(widget.dataURL);
      if (response.statusCode == 200) {
        Map<String, dynamic> responseBody = json.decode(response.body);
        List<dynamic> stateValues = responseBody['statewise'];
        List<dynamic> dayValues = responseBody['cases_time_series'];
        print(stateValues.toString());
        for(dynamic i in stateValues){
          setState(() {
            stateList.add(StateObject.fromJson(i));
          });
        }
        for(dynamic i in dayValues.reversed){
          setState(() {
            dayList.add(DayObject.fromJson(i));
          });
        }
      }
    }catch(e){
      print(e.toString());
    }
  }

  Widget dayTile(DayObject dayObject){
    return Card(
        elevation: 0,
        child: Padding(
          padding: EdgeInsets.all(16),
          child:Row(
            children: <Widget>[
              Expanded(
                flex: 1,
                child: Align(
                    alignment: Alignment.centerLeft,
                    child:Text(dayObject.date)),
              ),

              Expanded(
                flex: 1,
                child:Align(
                  alignment: Alignment.centerRight,
                  child:Text(
                      dayObject.confirmed.toString()
                  ),),),
              Expanded(
                flex: 1,
                child:Align(
                  alignment: Alignment.centerRight,
                  child:Text(
                      dayObject.recovered.toString()
                  ),),),
              Expanded(
                flex: 1,
                child:Align(
                  alignment: Alignment.centerRight,
                  child:Text(
                      dayObject.totalConfirmed.toString()
                  ),),),
            ],
          ),
        ));
  }

  Widget stateTile(StateObject stateObject){
    return Card(
      elevation: 0,
      child: Padding(
        padding: EdgeInsets.all(16),
        child:Row(
        children: <Widget>[
          Expanded(
            flex: 1,
            child: Align(
              alignment: Alignment.centerLeft,
                child:Text(stateObject.name)),
          ),

          Expanded(
            flex: 1,
            child:Align(
              alignment: Alignment.centerRight,
              child:Text(
            stateObject.confirmed.toString()
          ),),),
          Expanded(
            flex: 1,
            child:Align(
              alignment: Alignment.centerRight,
              child:Text(
                  stateObject.active.toString()
              ),),),
          Expanded(
            flex: 1,
            child:Align(
              alignment: Alignment.centerRight,
              child:Text(
                  stateObject.recovered.toString()
              ),),),
        ],
      ),
    ));
  }



  @override
  Widget build(BuildContext context) {
    List<Widget> _pages = [
      Column(
        children: <Widget>[
          Card(
            child:Padding(
              padding: EdgeInsets.all(16) ,
                child:Row(
              children: <Widget>[
                Expanded(
                  flex: 1,
                  child:Align(alignment: Alignment.centerLeft,
                        child: Text("Name",
                        style: TextStyle(fontWeight: FontWeight.bold),),),),
                Expanded(
                  flex: 1,
                  child: Align(alignment: Alignment.centerRight,
                    child: Text("Confirmed",
                      style: TextStyle(fontWeight: FontWeight.bold),),),),
                Expanded(
                  flex: 1,
                  child: Align(alignment: Alignment.centerRight,
                    child: Text("Active",
                      style: TextStyle(fontWeight: FontWeight.bold),),),),
                Expanded(
                  flex: 1,
                  child: Align(alignment: Alignment.centerRight,
                    child: Text("Recovered",
                      style: TextStyle(fontWeight: FontWeight.bold),),),),
              ],
            )
          ),),
          Expanded(
            child:RefreshIndicator(
              onRefresh: (){
                return getData();
              },
              child:  ListView.builder(
              itemCount: stateList.length,
                itemBuilder: (BuildContext context, int index){
                  return stateTile(stateList[index]);
                }
            ),
          )),
        ],
      ),
      Column(
        children: <Widget>[
          Card(
            child:Padding(
                padding: EdgeInsets.all(16) ,
                child:Row(
                  children: <Widget>[
                    Expanded(
                      flex: 1,
                      child:Align(alignment: Alignment.centerLeft,
                        child: Text("Date",
                          style: TextStyle(fontWeight: FontWeight.bold),),),),
                    Expanded(
                      flex: 1,
                      child: Align(alignment: Alignment.centerRight,
                        child: Text("Confirmed",
                          style: TextStyle(fontWeight: FontWeight.bold),),),),
                    Expanded(
                      flex: 1,
                      child: Align(alignment: Alignment.centerRight,
                        child: Text("Recovered",
                          style: TextStyle(fontWeight: FontWeight.bold),),),),
                    Expanded(
                      flex: 1,
                      child: Align(alignment: Alignment.centerRight,
                        child: Text("Total Confirmed",
                          style: TextStyle(fontWeight: FontWeight.bold),),),),
                  ],
                )
            ),),
          Expanded(
            child:RefreshIndicator(
            onRefresh: (){
              return getData();
            },
            child: ListView.builder(
                itemCount: dayList.length,
                itemBuilder: (BuildContext context, int index){
                  return dayTile(dayList[index]);
                }
            ),
          ),)
        ],
      ),
    ];
    return Scaffold(
      body: SafeArea(
        child: _pages[_selectedIndex],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            title: Text("States"),
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.view_day),
              title: Text("Days"),
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: (int index){
          setState(() {
            _selectedIndex = index;
          });
        },
      ),

    );
  }
}
