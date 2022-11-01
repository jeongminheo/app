import 'package:vertical_barchart/vertical-barchart.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_apk/register.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:vertical_barchart/vertical-barchartmodel.dart';
import 'package:vertical_barchart/vertical-legend.dart';
import 'select_screen.dart';
import 'package:flutter_apk/select_screen.dart';
import 'register.dart';
import 'package:flutter_apk/main.dart';

class Post {
  final String? L_Id;
  final String? logDate;
  final double? score;
  final String? deviceId_id ;

  Post({this.L_Id,this.logDate,this.score,this.deviceId_id});

  factory Post.fromJson(Map<String,dynamic> json){
    return Post(
        L_Id : json['L_id'],
        logDate : json['logDate'],
        score : json['score'],
        deviceId_id : json['deviceId_id']);
  }
}

Future<List<Post>> fetchPost(token) async{
  Map<dynamic, dynamic> data={'token':token};
  var body=json.encode(data);
  final response=
  await http.post(Uri.parse('http://121.188.98.211:1237/user/giveData'),
      headers:{'Content-Type':'application/json'},body:body);

  if(response.statusCode==200){
    List<dynamic> list = jsonDecode(response.body)['logList'];
    List<Post> userlist= list.map((dynamic e) => Post.fromJson(e)).toList();
    return userlist;
  }
  else{ throw Exception('Failed to load sheet');
  }
}

class SelectScreen extends StatefulWidget {
  final token;
 /*const SelectScreen({Key? key}) : super(key: key);*/
  const SelectScreen(this.token);
  @override
  _SelectScreenState createState() => _SelectScreenState();
}

class _SelectScreenState extends State<SelectScreen> {
  Future<List<Post>>? post;
  final _formKey = GlobalKey<FormState>();
  var userList;
  var token;

  @override
  void didChangeDependencies()  {
    super.didChangeDependencies() ;
    post= fetchPost('${widget.token}');
  }

  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('RESULT', style: TextStyle(color: Colors.white)),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                FutureBuilder<List<Post>>(
                  future: post,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return buildList(snapshot.data);
                    } else if (snapshot.hasError) {
                      return Text("${snapshot.error} 에러!!");
                    }
                    return CircularProgressIndicator();
                  },
                ),
              ],
            ),
          ),
        ));
  }

 Widget buildList(snapshot) {
   return SizedBox(
     height: 1000,
     child: ScrollConfiguration(
       behavior: MyCustomScrollBehavior(),
       child: Container(
               margin: EdgeInsets.symmetric(horizontal: 1),
               height: 1000,
               child: Column(
                 children: [
                   VerticalBarchart(
                   background: Colors.transparent,
                   labelColor: Colors.blueAccent,
                   tooltipColor: Colors.black26,
                   maxX: 20,
                   data: getcount(_getCount(snapshot)), barSize: 25,

                 ),
                   DataTable(
                    columnSpacing: 28.0,
                    columns: _getColumns(),
                    rows: _getRows(snapshot),
                    ),
                 ],
              ),
        ),
      ),
   );
 }
}

class MyCustomScrollBehavior extends MaterialScrollBehavior {
  // Override behavior methods and getters like dragDevices
  @override
  Set<PointerDeviceKind> get dragDevices => {
    PointerDeviceKind.touch,
    PointerDeviceKind.mouse,
    // etc.
  };
}

List<DataColumn> _getColumns() {
  List<DataColumn> datacolumn = [];
  datacolumn.add(DataColumn(label: Text('순번')));
  datacolumn.add(DataColumn(label: Text('날짜')));
  datacolumn.add(DataColumn(label: Text('측정치')));
  return datacolumn;
}

List<DataRow> _getRows(snapshot) {
  List<DataRow> dataRow = [];
  for(var i=0; i<snapshot.length; i++){
    dataRow.add(
        DataRow(cells: [
      DataCell(Text((i+1).toString())),
      DataCell(Text(snapshot[i].logDate.toString())),
      DataCell(Text(snapshot[i].score.toString())),
    ]));
  }
  return dataRow;
}

List<int> _getCount(snapshot){
  List<int> list=[];
  var count1 =0;
  var count2 =0;
  var count3 =0;
  var count4 =0;
  var count5 =0;

  for(var j=0; j<snapshot.length; j++){
    if(0<=snapshot[j].score && snapshot[j].score<=1.5){
      count1++;
    }
    else if(1.5<snapshot[j].score && snapshot[j].score<=2.5){
      count2++;
      }
    else if(2.5<snapshot[j].score && snapshot[j].score<=3.5){
      count3++;
      }
    else if(3.5<snapshot[j].score && snapshot[j].score<=4.5){
      count4++;
      }
    else {
      count5++;
    }
  }

  list.add(count1);
  list.add(count2);
  list.add(count3);
  list.add(count4);
  list.add(count5);

  return list;
}

List<VBarChartModel> getcount(list) {
  List<VBarChartModel> bardata = [];
  bardata.add(VBarChartModel(index:4, label:'4', jumlah:(list[4].toDouble()), tooltip:'${list[4]}개',colors: [Colors.amber, Colors.amber],));
  bardata.add(VBarChartModel(index:3, label:'3', jumlah:(list[3].toDouble()), tooltip:'${list[3]}개',colors: [Colors.amber, Colors.amber],));
  bardata.add(VBarChartModel(index:2, label:'2', jumlah:(list[2].toDouble()), tooltip:'${list[2]}개',colors: [Colors.amber, Colors.amber],));
  bardata.add(VBarChartModel(index:1, label:'1', jumlah:(list[1].toDouble()), tooltip:'${list[1]}개',colors: [Colors.amber, Colors.amber],));
  bardata.add(VBarChartModel(index:0, label:'0', jumlah:(list[0].toDouble()), tooltip:'${list[0]}개',colors: [Colors.amber, Colors.amber],));
  return bardata;
}
