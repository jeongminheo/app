import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';
import 'select_screen.dart';


class Post{
  final String? Token;
  Post({this.Token});

  factory Post.fromJSon(Map<String,dynamic> json){
    return Post(
        Token: json['Token']
    );
  }

}
class Signup extends StatefulWidget {
  const Signup({Key? key}) : super(key: key);

  @override
  _SignupState createState() => _SignupState();
}
class _SignupState extends State<Signup> {
  Future<Post>? post;
  final _formKey = GlobalKey<FormState>();
  String? userId;
  String? userPassword;
  String? userName;
  String? deviceId;

  @override
  void  didChangeDependencies()  {
    super.didChangeDependencies() ;
    print('called');
    post= fetchPost();
  }

  Future<Post> fetchPost() async{
    Map data={'userId':userId,'userpwd':userPassword,'userName':userName,'deviceId':deviceId};
    var body=json.encode(data);
    http.Response response=
    await http.post(Uri.parse('http://121.188.98.211:1237/user/register'),
        headers:{'Content-Type':'application/json'},body:body);

    if(response.statusCode==200) {
      var resSignup = json.decode(response.body);
      if (resSignup['success'] == true) {
        Fluttertoast.showToast(msg: 'signup sucessful');
      }
      return Post.fromJSon(json.decode(response.body));
    }
    else {
      print('Failed to load sheet');
      throw Exception('Failed to load sheet');
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fetch Data Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text('Signup'),),
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
                              TextFormField( //email 버튼
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
                                key: ValueKey(1), //pwd 버튼
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
                              TextFormField(
                                key: ValueKey(2), //pwd 버튼
                                validator: (value){
                                  if(value!.isEmpty || value.length<5){
                                    return 'Name must be at least 4 characters';
                                  }
                                },
                                onSaved: (value){
                                  userName= value;
                                },
                                onChanged:(value) {
                                  userName= value;
                                },
                                decoration: InputDecoration(
                                    labelText:'Enter username'
                                ),
                                keyboardType: TextInputType.text,
                              ),
                              TextFormField(
                                key: ValueKey(3), //pwd 버튼
                                validator: (value){
                                  if(value!.isEmpty || value.length<7){
                                    return 'deviceId must be at least 6 characters';
                                  }
                                },
                                onSaved: (value){
                                  deviceId= value;
                                },
                                onChanged:(value) {
                                  deviceId= value;
                                },
                                decoration: InputDecoration(
                                    labelText:'Enter deviceId'
                                ),
                                keyboardType: TextInputType.text,
                              ),
                              SizedBox(height: 40.0),

                              ElevatedButton(
                                child: Icon(Icons.arrow_forward, color: Colors.white,),
                                onPressed:(){
                                  fetchPost();
                                    }
                                  ),
                                  /*Navigator.pop(context);*/
                            ]
                        ),
                      ),
                    )
                )
              ],
            )

        ),
      ),
    );

  }
}

