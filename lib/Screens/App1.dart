import 'package:flutter/material.dart';

class ResponsiveLayoutBuilder extends StatefulWidget {
  const ResponsiveLayoutBuilder({Key? key}) : super(key: key);

  @override
  _ResponsiveLayoutBuilderState createState() => _ResponsiveLayoutBuilderState();
}

class _ResponsiveLayoutBuilderState extends State<ResponsiveLayoutBuilder> {
  Widget drawSquare() {
    return Container(
      height: 100,
      width: 100,
      color: Colors.red,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          return Center(child: aspectRatioTest());
          // if (constraints.maxWidth > 600) {
          //   print(constraints.minWidth);
          //   print(constraints.maxWidth);
          //   return _buildWideContainers();
          // } else {
          //   print(constraints.minWidth);
          //   print(constraints.maxWidth);
          //   return _buildNormalContainer();
          // }
        },
      ),
    );
  }
}

Widget _buildNormalContainer() {
  return Container(
    child: Container(
      height: 100.0,
      width: 100.0,
      color: Colors.red,
    ),
  );
}

Widget _buildWideContainers() {
  return Container(
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Container(
          height: 100.0,
          width: 100.0,
          color: Colors.red,
        ),
        Container(
          height: 100.0,
          width: 100.0,
          color: Colors.yellow,
        ),
      ],
    ),
  );
}

Widget aspectRatioTest() {
  // return Container(
  //   color: Colors.blue,
  //   height: 600,
  //   width: double.infinity,
  //   // alignment: Alignment.center,
  //   // width: double.infinity,
  //   // height: 100.0,
  //   child: FittedBox(
  //     fit: BoxFit.contain,
  //     child: Container(
  //       width: 300,
  //       color: Colors.green,
  //     ),
  //   ),
  // );
  return Container(
    
    color: Colors.blue,
    height: 900,
    width: 300,
    child: FittedBox(
      fit: BoxFit.cover,
      child: Container(height: 500, width: 200, color: Colors.green),
    ),
  );
}
