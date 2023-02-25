import 'package:flutter/material.dart';

// https://docs.flutter.dev/development/ui/animations/tutorial

class AnimationTest extends StatefulWidget{
  @override
  State createState() => AnimationTestState();
}

class AnimationTestState extends State<AnimationTest> with SingleTickerProviderStateMixin{
  late Animation<double> animation;
  late AnimationController controller;
  var check1 = false;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(duration: const Duration(seconds: 2), vsync: this);
    animation = Tween<double>(begin: 0, end: 100).animate(controller)
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          controller.reverse();
        } else if (status == AnimationStatus.dismissed) {
          controller.forward();
        }
      })
      ..addStatusListener((status) {});
    // ..addListener(() {
      //   setState(() {
      //     // The state that has changed here is the animation object’s value.
      //   });
      // });
    controller.forward();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('StatefulWidget Example'),),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 20,
            ),
            ElevatedButton(
              child: Text('test'),
              onPressed: _onClick,
            ),
            const SizedBox(height: 20.0,),
            // const Text(
            //   'Step 1',
            //   style: TextStyle(fontFamily: 'PyeongChangPeace', fontWeight: FontWeight.w700, fontSize: 30),
            // ),
            // const SizedBox(height: 20.0,),
            // Container(
            //   margin: const EdgeInsets.symmetric(vertical: 10),
            //   height: animation_s1.value,
            //   width: animation_s1.value,
            //   child: const FlutterLogo(),
            // ),
            // const SizedBox(height: 20.0,),
            // ElevatedButton(
            //   child: Text('step1_btn'),
            //   onPressed: () {
            //     if(!check1){
            //       controller_s1.reverse();
            //       check1=true;
            //     }
            //     else{
            //       controller_s1.forward();
            //       check1=false;
            //     }
            //   },
            // ),
            // const SizedBox(height: 20.0,),
            const Text(
              'Step 1',
              style: TextStyle(fontFamily: 'PyeongChangPeace', fontWeight: FontWeight.w700, fontSize: 30),
            ),
            const SizedBox(height: 20.0,),
            AnimatedLogo(animation: animation),
            const SizedBox(height: 20.0,),
            const Text(
              'Step 2',
              style: TextStyle(fontFamily: 'PyeongChangPeace', fontWeight: FontWeight.w700, fontSize: 30),
            ),
            GrowTransition(
              animation: animation,
              child: const LogoWidget(),
            ),
          ],
        ),
      ),
    );
  }

  void _onClick(){
    //print('_onClick');

    setState(() {
    });
  }
}

class AnimatedLogo extends AnimatedWidget {
  const AnimatedLogo({super.key, required Animation<double> animation})
      : super(listenable: animation);

  @override
  Widget build(BuildContext context) {
    final animation = listenable as Animation<double>;
    return Center(
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 10),
        height: animation.value,
        width: animation.value,
        child: const FlutterLogo(),
      ),
    );
  }
}


class LogoWidget extends StatelessWidget {
  const LogoWidget({super.key});

  // Leave out the height and width so it fills the animating parent
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: const FlutterLogo(),
    );
  }
}


class GrowTransition extends StatelessWidget {
  const GrowTransition(
      {required this.child, required this.animation, super.key});

  final Widget child;
  final Animation<double> animation;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AnimatedBuilder(
        animation: animation,
        builder: (context, child) {
          return SizedBox(
            height: animation.value,
            width: animation.value,
            child: child,
          );
        },
        child: child,
      ),
    );
  }
}