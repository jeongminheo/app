import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_apk/register.dart';
import 'package:get/get.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'select_screen.dart';
import 'package:flutter_apk/select_screen.dart';
import 'register.dart';



class Post {
  final bool? success;
  final String? token;

  Post({this.success,this.token});

  factory Post.fromJson(Map<dynamic,dynamic> json){
    return Post(
        success : json['success'],
        token : json['token'] );
  }

  Map <dynamic, dynamic> toJson() =>
      {
        'success':success,
        'token':token,
      };

  }



void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  Widget build(BuildContext context){return MaterialApp(
    title:'BULE',
    home: new Homescreen(),);
  }

}

class Homescreen extends StatefulWidget{

  @override
  Homescreen({Key? key}) : super(key: key);


  _HomescreenState createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen> {
  Future<List<dynamic>>? post;
  final _formKey = GlobalKey<FormState>();
  String? userId;
  String? userPassword;
  var userList;
  var token;

  @override
  void didChangeDependencies()  {
    super.didChangeDependencies() ;
    post= fetchPost();
  }

  Future<List<dynamic>> fetchPost() async{
  Map data={'userId':userId,'userpwd':userPassword};
  var body=json.encode(data);
    final response=
        await http.post(Uri.parse('http://121.188.98.211:1237/user/login'),
            headers:{'Content-Type':'application/json'},body:body);

    if(response.statusCode==200){
      Map parsed = jsonDecode(response.body);
      var user = Post.fromJson(parsed);
       List<String> list =['${user.success}','${user.token}'];
      return await list;
    }

    else{ throw Exception('Failed to load sheet');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
        title: Text('Login'),),
    body:SingleChildScrollView(
      child: Column(
        children: <Widget>[
          Padding(padding: EdgeInsets.only(top:50)),
          Center(
             child:  Image(
          image: AssetImage('images/img.png'),
          width: 170.0,
          height:190.0,
             ),
          ),
      Form(
          child: Theme(
          data:ThemeData(primaryColor: Colors.blue,
          inputDecorationTheme: InputDecorationTheme(
            labelStyle: TextStyle(
              color: Colors.blue,
              fontSize:15.0,)
          )
          ),
          child:Container(
            padding: EdgeInsets.all(40.0),
            child:Column(
              children:<Widget>[
                TextFormField(
                  key: ValueKey(0),
                  validator: (value){
                    if(value!.isEmpty || value.length<4){
                      return 'email must be at least 4 characters';
                    }
                  },
                  onSaved: (value){
                  userId= value;
                },
                  onChanged:(value) {
                    userId = value;
                  },
                  decoration: InputDecoration(
                    labelText:'Enter Email'
                  ),
                  keyboardType: TextInputType.emailAddress,
                ),
                TextFormField(
                  key: ValueKey(1),
                  validator: (value){
                  if(value!.isEmpty || value.length<6){
                    return 'password must be at least 6 characters';
                  }
                },
                  onSaved: (value){
                    userPassword= value;
                  },
                  onChanged:(value) {
                    userPassword= value;
                  },
                  decoration: InputDecoration(
                      labelText:'Enter Password'
                  ),
                  keyboardType: TextInputType.text,
                  obscureText: true,
                ),
              SizedBox(height: 40.0),
             ElevatedButton(
                      child: Icon(Icons.arrow_forward, color: Colors.white,),
                      onPressed:(){
                        List<dynamic> list =[];
                        fetchPost().then((value) {
                          setState(() {
                            userList = value;
                          });
                          var token = userList[1];
                          if(userList[0]=='true'){
                            Navigator.push(context,MaterialPageRoute(builder: (BuildContext context)=> SelectScreen(token)));
                            ;
                          }
                          else{Fluttertoast.showToast(msg: 'error');}
                        });
                      }
             ),
                ElevatedButton(
                  child: const Text('Sign Up'),
                  onPressed:(){
                    Navigator.push(context,MaterialPageRoute(builder: (BuildContext context)=> Signup()));
                      },
                    )
          ]
          ),
               ),
            )
          )
    ],
      )

      ),
      );
}
}
