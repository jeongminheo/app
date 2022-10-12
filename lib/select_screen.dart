import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutterfire_ui/auth.dart';

class SelectScreen extends StatefulWidget {
  const SelectScreen({Key? key}) : super(key: key);

  @override
  _SelectScreenState createState() => _SelectScreenState();
}

class _SelectScreenState extends State<SelectScreen> {
  CollectionReference test=FirebaseFirestore.instance.collection('test');

  @override
  Widget build(BuildContext context) {
    /*DocumentReference data= test.doc['devicdId'];*/
    return Scaffold(
      appBar: AppBar(
        title: Text('select Screen'), centerTitle: true,
        actions: [ IconButton(
            icon: Icon(
              Icons.exit_to_app_sharp,
              color: Colors.white,
            ),
            onPressed: () {
              FirebaseAuth.instance.signOut();
            },
          )
        ],
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('test/test1doc/data').snapshots(),
        builder: (BuildContext context,
            AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot){
         if(snapshot.connectionState == ConnectionState.waiting){
           return Center(
             child:CircularProgressIndicator(),
           );
         }

          final docs= snapshot.data!.docs;
          return ListView.builder(
            itemCount: docs.length ,
            itemBuilder: (context, index){
              return Container(
                padding: EdgeInsets.all(8.0),
                child: Text(docs[index]['deviceId'],
                style: TextStyle(fontSize: 20.0),
                ),
              );
            },
          );
        },
      )
    );
  }
}