import 'package:flutter/material.dart';


void main() => runApp(MyApp());

const double smallIconSize = 24.0;
const double largeIconSize = 196.0;

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.grey,
      ),
      home: Scaffold(
        body: Container(
          color: Colors.black,
          child: Center(
            child: Explicit(),
          ),
        ),
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}

class Explicit extends StatefulWidget {
  @override
  _ExplicitState createState() => _ExplicitState();
}

class _ExplicitState extends State<Explicit>
    with TickerProviderStateMixin {
  AnimationController _repeatingAnimationShort;
  AnimationController _repeatingAnimationLong;
  AnimationController _loopingAnimationShort;
  AnimationController _loopingAnimationLong;

  Animatable<double> _scaleCurve;
  Animatable<Offset> _slideCurve;
  Animatable<Offset> _reverseSlide;
  Animatable<double> _scaleCurveSlow;

  @override
  void initState() {
    super.initState();

    _repeatingAnimationShort = AnimationController(
      duration: const Duration(milliseconds: 3600),
      vsync: this,
    )..repeat();

    _repeatingAnimationLong = AnimationController(
      duration: const Duration(seconds: 15),
      vsync: this,
    )..repeat();

    _loopingAnimationShort = AnimationController(
      duration: const Duration(milliseconds: 3600),
      vsync: this,
    )
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _loopingAnimationShort.reverse();
        } else if (status == AnimationStatus.dismissed) {
          _loopingAnimationShort.forward();
        }
      })
      ..forward();

    _loopingAnimationLong = AnimationController(
      duration: const Duration(seconds: 30),
      vsync: this,
    )
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _loopingAnimationLong.reverse();
        } else if (status == AnimationStatus.dismissed) {
          _loopingAnimationLong.forward();
        }
      })
      ..forward();
  }

  @override
  Widget build(BuildContext context) {
    setAnimatables();

    return Stack(
      children: <Widget>[
        Align(
          alignment: Alignment.center,
          child: RotationTransition(
            turns: _repeatingAnimationLong,
            child: GalaxyWay(),
          ),
        ),


        Align(
          alignment: Alignment.center,
          child: ScaleTransition(
            scale: _loopingAnimationShort.drive(_scaleCurve),
            child: RotationTransition(
              turns: _repeatingAnimationShort,
              child: Text(
                "🚀",
                style: TextStyle(fontSize: largeIconSize),
              ),
            ),
          ),
        ),



        Align(
          alignment: Alignment.bottomLeft,
          child: SlideTransition(
            position: _loopingAnimationShort.drive(_slideCurve),
            child: RotationTransition(
              turns: _repeatingAnimationShort,
              child: Icon(
                Icons.star_half,
                color: Colors.white,
                size: smallIconSize,
              ),
            ),
          ),
        ),


        Align(
          alignment: Alignment.bottomLeft,
          child: SlideTransition(
            position: _loopingAnimationShort.drive(_reverseSlide),
            child: RotationTransition(
              turns: _repeatingAnimationShort,
              child: Icon(
                Icons.star,
                color: Colors.white,
                size: smallIconSize,
              ),
            ),
          ),
        ),
//
        Align(
          alignment: Alignment(0.75, 0),
          child: RotationTransition(
            turns: _repeatingAnimationLong,
            alignment: Alignment(-10, 0),
            child: RotationTransition(
                turns: _repeatingAnimationShort,
                child: Container(
                    height: 30,
                    child: Image.asset('assets/earth.jpeg',))
            ),
          ),
        ),


        Align(
          alignment: Alignment.bottomLeft,
          child: TimerStopper(
            controllers: [
              _repeatingAnimationLong,
              _repeatingAnimationShort,
              _loopingAnimationShort,
              _loopingAnimationLong,
            ],
          ),
        ),


        Align(
          alignment: Alignment.bottomRight,
          child: Flying(
            controllers: [
              _loopingAnimationShort,
            ],
          ),
        ),
      ],
    );
  }


  void setAnimatables() {
    double deviceHeight = MediaQuery.of(context).size.height;
    double deviceWidth = MediaQuery.of(context).size.width;

    _scaleCurve = CurveTween(
      curve: Curves.easeIn,
    );

    _scaleCurveSlow = Tween<double>(
      begin: 0,
      end: 5,
    );

    _slideCurve = Tween<Offset>(
      begin: Offset(-2, 2),
      end: Offset(
          deviceWidth / smallIconSize, -1 * deviceHeight / smallIconSize),
    );

    _reverseSlide = Tween<Offset>(
      begin: Offset(deviceWidth / smallIconSize, 2),
      end: Offset(-2, -1 * deviceHeight / smallIconSize),
    );
  }
}


class TimerStopper extends StatelessWidget {
  final List<AnimationController> controllers;

  const TimerStopper({Key key, this.controllers}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        controllers.forEach((controller) {
          if (controller.isAnimating) {
            controller.stop();
          } else {
            controller.repeat();
          }
        });
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.transparent,
        ),
        width: MediaQuery
            .of(context)
            .size
            .width,
        height: MediaQuery
            .of(context)
            .size
            .height,      ),
    );
  }
}


class Flying extends StatelessWidget {
  final List<AnimationController> controllers;

  const Flying({Key key, this.controllers}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        controllers.forEach((controller) {
          controller.fling();
        });
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.transparent,
        ),
        width: 100,
        height: 100,
      ),
    );
  }
}

class GalaxyWay extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        height: 300,
        child: Image.asset('assets/sun.jpg',));
  }
}
