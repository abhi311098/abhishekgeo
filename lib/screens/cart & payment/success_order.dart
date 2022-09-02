import 'package:flutter/material.dart';
import 'package:geomedipath/screens/navigation/home.dart';
import 'package:lottie/lottie.dart';

class SuccessOrder extends StatefulWidget {
  SuccessOrder({Key key});

  @override
  _SuccessOrderState createState() => _SuccessOrderState();
}

class _SuccessOrderState extends State<SuccessOrder>
    with SingleTickerProviderStateMixin {
  AnimationController controller;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller =
        AnimationController(vsync: this);
    controller.addStatusListener((status) async {
      if (status == AnimationStatus.completed) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => Home(),
          ),
        );
      }
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Lottie.asset("assets/animation/done.json",
            repeat: false, controller: controller, onLoaded: (com) {
              controller.duration = com.duration;
              controller.forward();
            }),
      ),
    );
  }
}
