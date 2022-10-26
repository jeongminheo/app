import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
/*import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutterfire_ui/auth.dart';*/
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'select_screen.dart';

/*void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}*/

Future<Post> fetchPost() async {
  final response =
  await http.get(Uri.parse("https://169.254.234.45:8000/user/register"));
  if (response.statusCode == 200) {
    return Post.fromJSon(json.decode(response.body));
  }
  else {
    throw Exception('Failed to load post');
  }
}

class Post{
  final String? Token;
  Post({this.Token});

  factory Post.fromJSon(Map<String,dynamic> json){
    return Post(
      Token: json['Token']
    );
  }

}
void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Future<Post>? post;
  final _formKey = GlobalKey<FormState>();
  String? userId;
  String? userPassword;

  @override
  void initState() {
    super.initState();
    post= fetchPost();
  }

  Future<Post> fetchPost() async{
  Map data={'userId':userId,'userpwd':userPassword};
  var body=json.encode(data);
    final response=
        await http.post(Uri.parse('http://192.168.0.8:8000/user/login'),
            headers:{'Content-Type':'application/json'},body:body);

    if(response.statusCode==200){
      return Post.fromJSon(json.decode(response.body));

    }
    else{ throw Exception('Failed to load sheet');
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
                        FutureBuilder<Post>(
                          future: post,
                          builder: (context,AsyncSnapshot snapshot) {
                            if (snapshot.hasData) {
                              return Text(snapshot.data!.deviceId);
                            } else if (snapshot.hasError) {
                              return Text("${snapshot.error}");
                            }

                            // 기본적으로 로딩 Spinner를 보여줍니다.
                            return CircularProgressIndicator();
                          },
                        );
                      },)
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

/*class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BLUE',
      theme: ThemeData(
          primaryColor: Colors.blue
      ),
      home: MyPage(),
    );
  }
}


class MyPage extends StatelessWidget {
  const MyPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Authentication(),
    );
  }
}


class Authentication extends StatelessWidget {
  const Authentication({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return SignInScreen(
            headerBuilder: (context, constraints, double) {
              return Padding(
                padding: EdgeInsets.all(20),
                child: AspectRatio(
                  aspectRatio: 1,
                  child: Image(
                    image: AssetImage('images/img.png'),
                  ),
                ),
              );
            },
            providerConfigs: [EmailProviderConfiguration()],
          );
        }
        return SelectScreen();
      },
    );
  }
}*/