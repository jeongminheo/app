import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_apk/main.dart';


class SelectScreen extends StatefulWidget {
  final token;
 /*const SelectScreen({Key? key}) : super(key: key);*/
  const SelectScreen(this.token);

  @override
  _SelectScreenState createState() => _SelectScreenState();
}

class _SelectScreenState extends State<SelectScreen> {

 @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('select Screen'),centerTitle:true),
        body:SingleChildScrollView(
        child:Column(
          children: [Text('${widget.token}')],
        ),
      ),
            /*  return DataTable(
                  columns: [DataColumn(label: Text('디바이스ID')),DataColumn(label: Text('날짜')),DataColumn(label: Text('측정치')),],
                  rows: [DataRow(cells:[
              DataCell(Text(docs[index]['deviceId'])),
              DataCell(Text(docs[index]['logDate'])),
              DataCell(Text(docs[index]['score'])),])
                  ]);
                /*Container(
                padding: EdgeInsets.all(8.0),
                child: Text(docs[index]['deviceId'],
                style: TextStyle(fontSize: 20.0),
                ),,
              );*/
            },
          );
        },
      )
*/
    );

  }
}