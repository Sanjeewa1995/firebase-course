import 'package:flutter/material.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:firebase_auth/firebase_auth.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Home()
    );
  }
}
class Home extends StatefulWidget {
  Home({Key key}) : super(key: key);

  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  FirebaseUser myUser;
  bool isLogged = false;
  var facebookLogin = FacebookLogin();

  Future loginWithFb() async {
    try {
      var result = await facebookLogin.logIn(['email']);

      if(result.status==FacebookLoginStatus.loggedIn){
        final AuthCredential credential = FacebookAuthProvider.getCredential(
          accessToken: result.accessToken.token
        );

        final FirebaseUser user = (await FirebaseAuth.instance.signInWithCredential(credential)).user;
        return user;
      }else {
        return null;
      }
    }catch (e){print(e.message);}
  }

  void logIn () async{
    loginWithFb().then((responce){
    if(responce != null){
      myUser = responce;
      isLogged = true;
      setState(() { });
    }
    });
  }
Future<void> logOut () async{
    await FirebaseAuth.instance.signOut().then((responce){
      isLogged = false;
      setState(() { });
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:Text('Fb Auth')
      ),
      body: Center(
        child:isLogged ?Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(myUser.displayName),
            Image.network(myUser.photoUrl),
            RaisedButton(onPressed: (){
              logOut();
            },
            child: Text('Log Out'),
            )
          ],
        ):
        RaisedButton(
          onPressed:(){
            logIn();
          },
          child:Text('Login With Fb')
        )
      ),
    );
  }
}

