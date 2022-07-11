import 'package:cuota/create_event.dart';
import 'package:cuota/eventDetail.dart';
import 'package:cuota/explore.dart';
import 'package:cuota/models/Event.dart';
import 'package:cuota/profile.dart';
import 'package:cuota/utils/Dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'main.dart';

class Feed extends StatefulWidget {
  const Feed({Key? key}) : super(key: key);

  @override
  State<Feed> createState() => _FeedState();
}

class _FeedState extends State<Feed> {
  List<Event> events = [];

  Future<void> fetchData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString("token") ?? "xxx";
    try {
      var response = await DioManager.dio.get('/event?token=' + token);
      print(response.data["data"]);
      List<Event> events = response.data["data"]
          .map<Event>((json) => Event.fromJson(json))
          .toList();
      setState(() {
        this.events = events;
      });
      print(events[0].detail);
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Container(
        decoration: const BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                stops: [0.1, 0.5, 0.9],
                colors: [MyApp.BGMain1, MyApp.BGMain2, MyApp.BGMain3])),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          extendBodyBehindAppBar: true,
          appBar: AppBar(
            title: const Text(MyApp.nameApplication),
            backgroundColor: Colors.transparent,
            elevation: 0.0,
            centerTitle: true,
            leading: IconButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const Profile(),
                    ),
                  );
                },
                icon: const Icon(Icons.account_circle)),
            actions: [
              IconButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const Explore(),
                      ),
                    );
                  },
                  icon: const Icon(Icons.search))
            ],
          ),
          body: ListView(children: getFeed()),
          bottomNavigationBar: BottomNavigationBar(
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.feed),
                label: 'Feed',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.rocket),
                label: 'Host',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.event),
                label: 'Event',
              ),
            ],
            currentIndex: 0,
            selectedItemColor: Colors.amber[800],
            onTap: (e) {
              if (e == 0) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const Feed(),
                  ),
                );
              } else if (e == 1) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const CreateEvent(),
                  ),
                );
              } else if (e == 2) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const Explore(),
                  ),
                );
              }
            },
          ),
        ));
  }

  List<Widget> getFeed() {
    List<Widget> data = [];

    for (var i = 0; i < events.length; i++) {
      data.add(Container(
        margin: const EdgeInsets.only(left: 20, right: 20),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(50), color: Colors.white),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.only(
                left: 40,
                right: 40,
                top: 10,
                bottom: 0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.only(bottom: 30),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.card_travel,
                          size: 40,
                        ),
                        Text(
                          "  ${events[i].subType_name}",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                  ),
                  Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          "100%",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text("Matched")
                      ],
                    ),
                  )
                ],
              ),
            ),
            Column(children: [
              ClipRRect(
                // borderRadius: BorderRadius.circular(20),
                child: Container(
                  child: Align(
                      alignment: Alignment.center,
                      widthFactor: 16 / 16,
                      heightFactor: 9.0 / 16.0,
                      child: Image.network(
                        DioManager.baseUrl + events[i].eventImageUrl,
                        // height: 100,
                      )),
                ),
              )
            ]),
            Container(
                padding: const EdgeInsets.only(
                  left: 40,
                  right: 40,
                  top: 10,
                  bottom: 10,
                ),
                child: Row(
                  children: <Widget>[
                    Expanded(
                        flex: 3,
                        child: Container(
                          child: Image.network(
                            DioManager.baseUrl + events[i].hostAvatarUrl,
                            // height: 100,
                          ),
                        )),
                    Expanded(
                        flex: 7,
                        child: Container(
                          padding: const EdgeInsets.only(left: 5, right: 1),
                          child: Column(children: [
                            Container(
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                      child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                        Text(
                                          "Host",
                                          style: TextStyle(
                                              color: Color.fromARGB(
                                                  255, 204, 204, 204),
                                              fontSize: 10),
                                        ),
                                        Text(
                                          events[i].host.split(" ")[0],
                                          style: TextStyle(
                                              color: Color.fromARGB(
                                                  255, 59, 59, 59),
                                              fontWeight: FontWeight.bold),
                                        )
                                      ])),
                                  ElevatedButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              const EventDetail(),
                                          settings: RouteSettings(
                                            arguments: events[i].id,
                                          ),
                                        ),
                                      );
                                    },
                                    style: ElevatedButton.styleFrom(
                                        primary:
                                            Color.fromARGB(255, 63, 191, 198),
                                        padding: const EdgeInsets.only(
                                            right: 25, left: 25),
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(12))),
                                    child: Text("View"),
                                  )
                                ],
                              ),
                            ),
                            SizedBox(
                              child: Divider(
                                  color: Color.fromARGB(151, 62, 62, 62)),
                            ),
                            Container(
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.people,
                                    color: Color.fromARGB(255, 59, 59, 59),
                                  ),
                                  Text(
                                    "${events[i].joined}/${events[i].maxJoin}",
                                    style: TextStyle(
                                      color: Color.fromARGB(255, 59, 59, 59),
                                    ),
                                  )
                                ],
                              ),
                            )
                          ]),
                        )),
                  ],
                )),
          ],
        ),
      ));

      data.add(
        Divider(
          indent: 20,
          endIndent: 20,
          thickness: 2,
          color: Color.fromARGB(63, 255, 255, 255),
        ),
      );
    }

    return data;
  }
}

class BNBCustomPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;
    Path path = Path()..moveTo(0, 20);
    path.quadraticBezierTo(size.width * 0.20, 0, size.width * 0.35, 0);
    path.quadraticBezierTo(size.width * 0.40, 0, size.width * 0.40, 0);
    path.arcToPoint(Offset(size.width * 0.60, 20),
        radius: Radius.circular(10.0), clockwise: false);
    path.quadraticBezierTo(size.width * 0.60, 0, size.width * 0.65, 0);
    path.quadraticBezierTo(size.width * 0.80, 0, size.width, 20);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
