import 'package:easy_splash_screen/easy_splash_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:object_detection/HomeScreen.dart';

class MySplashScreen extends StatefulWidget {
  const MySplashScreen({Key? key}) : super(key: key);

  @override
  State<MySplashScreen> createState() => _MySplashScreenState();
}

class _MySplashScreenState extends State<MySplashScreen> {
  @override
  Widget build(BuildContext context) {
    return EasySplashScreen(
      logo: Image(image: AssetImage('assets/b.jpg'),fit: BoxFit.fitHeight,),
      durationInSeconds: 5,
      loaderColor:Colors.green ,
      showLoader: true,
      navigator: homepage(),
      loadingText: Text('loading..',style: TextStyle(color: Colors.blue,fontSize: 20),),
    );
  }
}
