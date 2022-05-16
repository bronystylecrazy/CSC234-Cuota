import 'package:flutter/material.dart';

class TestScroll extends StatefulWidget {
  const TestScroll({Key? key}) : super(key: key);

  @override
  _TestScrollState createState() => _TestScrollState();
}

class _TestScrollState extends State<TestScroll> {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
      return Row(
        children: <Widget>[
          SizedBox(
              width: constraints.maxWidth,
              child: Scrollbar(
                isAlwaysShown: true,
                controller: ScrollController(),
                child: ListView.builder(
                    controller: ScrollController(),
                    itemCount: 100,
                    itemBuilder: (BuildContext context, int index) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text('Scrollable 1 : Index $index'),
                      );
                    }),
              )),
        ],
      );
    });
  }
}


// body: Container(
//         child: Container(
//           decoration: const BoxDecoration(
//               gradient: LinearGradient(
//                   begin: Alignment.topLeft,
//                   end: Alignment.bottomRight,
//                   stops: [0.1, 0.5, 0.9],
//                   colors: [MyApp.BGMain1, MyApp.BGMain2, MyApp.BGMain3])),
//           child: Stack(children: <Widget>[
//             Positioned(
//                 top: size.width * 0.2,
//                 child: Container(
//                   child: Scrollbar(
//                     isAlwaysShown: true,
//                     controller: ScrollController(),
//                     child: Column(
//                       children: [],
//                     ),
//                   ),
//                 )),
//             Positioned(
//                 bottom: 0,
//                 left: 0,
//                 child: Container(
//                   width: size.width,
//                   height: 80,
//                   child: Stack(
//                     children: [
//                       CustomPaint(
//                         size: Size(size.width, 80),
//                         painter: BNBCustomPainter(),
//                       ),
//                       Center(
//                         heightFactor: 0.6,
//                         child: FloatingActionButton(
//                           onPressed: () {},
//                           backgroundColor: Color.fromARGB(255, 249, 98, 216),
//                           child: const Icon(Icons.rocket_launch),
//                         ),
//                       ),
//                       Container(
//                         width: size.width,
//                         height: 80,
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                           children: [
//                             IconButton(
//                               icon: const Icon(Icons.computer),
//                               onPressed: () {},
//                             ),
//                             Container(
//                               width: size.width * 0.20,
//                             ),
//                             IconButton(
//                               icon: const Icon(Icons.notifications),
//                               onPressed: () {},
//                             ),
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//                 ))
//           ]),
//         ),
//       ),