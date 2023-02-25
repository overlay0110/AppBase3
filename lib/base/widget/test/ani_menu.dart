import 'package:flutter/material.dart';

class aniMenus extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('animation menu Example')),
        body : Center(
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              children: [
                Container(
                  height: 20,
                ),
                ElevatedButton(
                  child: Text( 'custom test1' ),
                  onPressed: () => {
                    Navigator.pushNamed(context, 'test_animation')
                  },
                ),
                SizedBox(height: 20.0,),
                ElevatedButton(
                  child: Text( 'custom test2' ),
                  onPressed: () => {
                    Navigator.pushNamed(context, 'ani_test2')
                  },
                ),
                SizedBox(height: 20.0,),
                ElevatedButton(
                  child: Text( 'Implicit animations' ),
                  onPressed: () => {
                    Navigator.pushNamed(context, 'ani_test5')
                  },
                ),
                SizedBox(height: 20.0,),
                ElevatedButton(
                  child: Text( 'Hero animation' ),
                  onPressed: () => {
                    Navigator.pushNamed(context, 'ani_test4')
                  },
                ),
                SizedBox(height: 20.0,),
                ElevatedButton(
                  child: Text( 'Staggered animation' ),
                  onPressed: () => {
                    Navigator.pushNamed(context, 'ani_test3')
                  },
                ),
                SizedBox(height: 20.0,),
                ElevatedButton(
                  child: Text( 'json lottie animation' ),
                  onPressed: () => {
                    Navigator.pushNamed(context, 'ani_test6')
                  },
                ),
                SizedBox(height: 20.0,),
                ElevatedButton(
                  child: Text( 'scroll animation' ),
                  onPressed: () => {
                    Navigator.pushNamed(context, 'ani_test_scroll')
                  },
                ),
              ],
            ),
          ),
        )
    );
  }
}