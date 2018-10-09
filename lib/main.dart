import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mega_test/theme.dart';
import 'package:mega_test/view/contact.dart';
import 'package:flutter/animation.dart';


void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Mega Demo',
      debugShowCheckedModeBanner: false,
      theme: appTheme,
      home: new MyHomePage(title: 'Mega Demo'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin  {

  Animation<double> animation;
  AnimationController controller;
  AnimationController controllerIni;
  Animation<double> transitionTween;
  var borderRadius;
  int stateAnimation = 0;

  @override
  void initState() {
    super.initState();

    controllerIni = new AnimationController(duration: const Duration(milliseconds: 2000), vsync: this);

    animation = Tween(begin: -250.0, end: 0.0).animate(CurvedAnimation(parent: controllerIni, curve: Curves.linear,))
      ..addListener(() {
        setState(() {
        });
      });


    new Timer(
      const Duration(milliseconds: 2000), () {controllerIni.forward();}
    );


    animation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
          animSecond();
      }
    });
  }


  void animSecond(){
    controller = new AnimationController(duration: const Duration(milliseconds: 3000), vsync: this);

    transitionTween = Tween<double>(begin: 80.0, end: 400.0,).animate(
      CurvedAnimation(parent: controller, curve: Curves.ease,)..addListener(() {
        setState(() {
        });
      })
    );

    borderRadius = BorderRadiusTween(begin: BorderRadius.circular(75.0), end: BorderRadius.circular(2.0),).animate(
      CurvedAnimation(parent: controller, curve: Curves.ease,)..addListener(() {
        setState(() {
        });
      })
    );

    controller.forward();
    stateAnimation = 1;


    transitionTween.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        stateAnimation = 2;
      }
    });


  }




  @override
  void dispose() {
    controller.dispose();
    controllerIni.dispose();
    super.dispose();
  }



  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: AppColors.colorPrimary,
      bottomNavigationBar: stateAnimation == 2
        ? new Container(
        margin: EdgeInsets.symmetric(vertical: 50.0, horizontal: 100.0),
        height: 40.0,
        decoration: new BoxDecoration(
          color: AppColors.colorSecondary,
          borderRadius: BorderRadius.circular(20.0), border: Border.all(width: 2.0)),
        child: new FlatButton(
          padding: const EdgeInsets.all(0.0),
          onPressed: () {
            Navigator.push(context,
              new MaterialPageRoute(
                builder: (context) => new ContactPage()));
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              new Icon(Icons.edit, size: 20.0,),
              SizedBox(width: 8.0),
              new Text('Cadastro', style: TextStyle(color: Colors.black, fontSize: 20.0, fontWeight: FontWeight.bold),),
            ],
          )
        ),
      )
      : new Container(
        margin: EdgeInsets.symmetric(vertical: 50.0),
        height: 40.0,),
      body: new Center(
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[


            stateAnimation == 2 ?
            //Line 1
            new Container(
              height: 40.0,
              decoration: new BoxDecoration(
                color: AppColors.colorSecondary, border: Border.all(width: 1.0)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    new FloatingActionButton(
                      elevation: 4.0,
                      backgroundColor: AppColors.colorSecondary,
                      mini: true,
                      onPressed: (){
                        Navigator.push(context,
                          new MaterialPageRoute(
                            builder: (context) => new MyHomePage()));
                      },
                      child: new Icon(Icons.settings_backup_restore, size: 30.0, color: Colors.black,),
                    ),

                    new Text('Teste Cadastro de Usuário', style: TextStyle(color: Colors.black, fontSize: 22.0, fontWeight: FontWeight.w600,),),

                    SizedBox(width: 30.0),

                  ],
                )
            ) : new Container(height: 40.0,),

            SizedBox(height: 80.0),


            //Line 2
            new Transform(
              transform: Matrix4.translationValues(0.0, animation.value != null ? animation.value : 0.0, 0.0),
              child: new Container(
                width: transitionTween != null ? transitionTween.value : 60.0,
                height: transitionTween != null ? transitionTween.value/1.5 : 60.0,
                decoration: BoxDecoration(
                  color: AppColors.myWhite,
                  borderRadius: borderRadius != null ? borderRadius.value : BorderRadius.circular(75.0),
                  border: Border.all(width: 2.0)
                ),
                child: stateAnimation != 0
                  ? new Image(image: AssetImage('assets/images/MegaLOGO.png'))
                  : new Image(image: AssetImage('assets/images/icone-mega.png')),
              ),
            ),


          ],
        ),
      ),

    );
  }
}
