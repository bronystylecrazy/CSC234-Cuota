import 'package:cuota/create_event.dart';
import 'package:cuota/explore.dart';
import 'package:cuota/feed.dart';
import 'package:cuota/models/Event.dart';
import 'package:cuota/models/User.dart';
import 'package:cuota/utils/Dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'main.dart';

class EventDetail extends StatefulWidget {
  const EventDetail({Key? key}) : super(key: key);

  @override
  State<EventDetail> createState() => _EventDetailState();
}

class _EventDetailState extends State<EventDetail> {
  Event? event;
  List<User> joiners = [];
  bool joined = false;
  List<String> months = [
    'Janduary',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December'
  ];
  List<String> days = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday'
  ];

  fetchEvent(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString("token") ?? "xxx";
    var eventId = ModalRoute.of(context)!.settings.arguments as int;

    try {
      var response = await DioManager.dio.get('/feed/$eventId?token=' + token);
      var response2 =
          await DioManager.dio.get('/feed/joiners/$eventId?token=' + token);
      print(response.data["data"]);
      print(response2.data["data"]);
      Event event = Event.fromJson(response.data["data"]);

      setState(() {
        this.event = event;
        this.joined = response2.data["joined"];

        for (var user in response2.data["data"]) {
          joiners.add(User.fromJson(user));
        }

        // joiners = response2.data["data"]
        //     .map((json) => User.fromJson(json))
        //     .toList() as List<User>;
        print(joiners);
      });
      print(event.detail);
    } catch (e) {
      print(e);
    }
  }

  joinEvent(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString("token") ?? "xxx";
    var eventId = ModalRoute.of(context)!.settings.arguments as int;

    try {
      var response =
          await DioManager.dio.post('/feed/join/$eventId?token=' + token);
      print(response.data["data"]);

      if (response.data["success"]) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text("Joining Event"),
            content: Text(response.data["message"]),
            actions: [
              FlatButton(
                child: Text("OK"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
        fetchEvent(context);
        setState(() {
          joined = true;
        });
      } else {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text("Joining Event failed"),
            content: Text(response.data["message"]),
            actions: [
              FlatButton(
                child: Text("OK"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
    fetchEvent(context);
  }

  @override
  Widget build(BuildContext context) {
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
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          centerTitle: true,
          leading: IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const Feed(),
                  ),
                );
              },
              icon: const Icon(Icons.arrow_back)),
        ),
        body: ListView(children: getEventDetail()),
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
          currentIndex: 2,
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
      ),
    );
  }

  List<Widget> getEventDetail() {
    List<Widget> data = [];

    data.add(
      Container(
        child: Image.network(
          event == null
              ? DioManager.baseUrl + '/storage/placeholder_bg.jpg'
              : DioManager.baseUrl + event!.eventImageUrl,
        ),
      ),
    );

    data.add(Container(
        margin: const EdgeInsets.only(left: 20, right: 20, top: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text("Host",
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold)),
                SizedBox(height: 10),
                Container(
                  decoration: BoxDecoration(boxShadow: [
                    BoxShadow(color: Colors.white, spreadRadius: 4),
                  ]),
                  child: Image.network(
                    event == null
                        ? DioManager.baseUrl + '/storage/placeholder.jpg'
                        : DioManager.baseUrl + event!.hostAvatarUrl,
                    width: 70,
                  ),
                ),
                SizedBox(height: 10),
                Text(event == null ? "" : event!.host,
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold)),
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(event == null ? "" : event!.title,
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 30)),
                Row(
                  children: [
                    Icon(
                      Icons.location_on,
                      color: Colors.white,
                      size: 40,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(event == null ? "" : event!.location,
                            style:
                                TextStyle(color: Colors.white, fontSize: 20)),
                        Text("location of the event",
                            style: TextStyle(color: Colors.white, fontSize: 15))
                      ],
                    )
                  ],
                )
              ],
            )
          ],
        )));

    data.add(
      Divider(
        indent: 20,
        endIndent: 20,
        thickness: 2,
        color: Color.fromARGB(63, 255, 255, 255),
      ),
    );

    data.add(Container(
        margin: const EdgeInsets.only(left: 20, right: 20, bottom: 20, top: 10),
        child: Row(children: [
          Icon(
            Icons.people,
            color: Colors.white,
          ),
          SizedBox(width: 5),
          Text(
              "${event == null ? 0 : event!.joined}/${event == null ? 30 : event!.maxJoin} Joiners",
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold))
        ])));

    data.add(Container(
        child: Column(children: [
      for (var i = 0; i < 1; i++) ...{
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            for (var i = 0; i < joiners.length; i++) ...{
              Container(
                  decoration: BoxDecoration(boxShadow: [
                    BoxShadow(color: Colors.white, spreadRadius: 4),
                  ]),
                  child: Image.network(
                      event == null
                          ? DioManager.baseUrl + '/storage/placeholder_bg.jpg'
                          : DioManager.baseUrl + joiners[i].avatarUrl!,
                      width: 50))
            }
          ],
        ),
        SizedBox(height: 20)
      }
    ])));

    data.add(
      Divider(
        indent: 20,
        endIndent: 20,
        thickness: 2,
        color: Color.fromARGB(63, 255, 255, 255),
      ),
    );

    data.add(Container(
        margin: const EdgeInsets.only(left: 20, right: 20, bottom: 20, top: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Event Detail",
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 20)),
            Container(
              margin: const EdgeInsets.only(left: 10, top: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(event == null ? "" : event!.detail,
                      style: TextStyle(color: Colors.white, fontSize: 15)),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      Icon(
                        Icons.calendar_month,
                        color: Colors.white,
                        size: 40,
                      ),
                      SizedBox(width: 10),
                      event == null
                          ? Column()
                          : Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                  Text(
                                    "${days[event!.eventDate.weekday - 1]}, ${event!.eventDate.day} ${months[event!.eventDate.month - 1]} ${event!.eventDate.year}",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  Text("${event!.eventDate.toLocal()}",
                                      style: TextStyle(color: Colors.white))
                                ])
                    ],
                  ),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      Icon(
                        Icons.card_travel,
                        color: Colors.white,
                        size: 40,
                      ),
                      SizedBox(width: 10),
                      Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("95% Matched",
                                style: TextStyle(color: Colors.white)),
                            Text(event == null ? "" : event!.subType_name,
                                style: TextStyle(color: Colors.white))
                          ])
                    ],
                  ),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      Text(
                        "AGE",
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 20),
                      ),
                      SizedBox(width: 10),
                      Text(
                          "${event == null ? 18 : event!.minAge} - ${event == null ? 65 : event!.maxAge} years old",
                          style: TextStyle(color: Colors.white))
                    ],
                  ),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      Icon(
                        Icons.transgender,
                        color: Colors.white,
                        size: 40,
                      ),
                      SizedBox(width: 10),
                      Text(
                          event == null
                              ? "Male & Female"
                              : event!.gender.toUpperCase(),
                          style: TextStyle(color: Colors.white))
                    ],
                  ),
                ],
              ),
            )
          ],
        )));

    if (joined) {
      data.add(Container(
        decoration: BoxDecoration(color: Color.fromARGB(255, 63, 192, 198)),
        child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          Text(
            "You have already joined this event!",
            style: TextStyle(color: Colors.white),
          )
        ]),
      ));
    }

    data.add(Container(
        padding:
            const EdgeInsets.only(left: 125, right: 125, bottom: 10, top: 10),
        decoration: BoxDecoration(color: Colors.white),
        child: SizedBox(
          width: 30,
          height: 30,
          child: ElevatedButton(
            onPressed: () {
              joinEvent(context);
              // Navigator.pushReplacement(
              //   context,
              //   MaterialPageRoute(
              //     builder: (context) => const EventDetail2(),
              //   ),
              // );
            },
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(80.0),
              ),
              padding: const EdgeInsets.all(0.0),
            ),
            child: Ink(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  stops: [0.1, 0.9],
                  colors: [
                    Color.fromARGB(255, 249, 98, 216),
                    Color.fromARGB(255, 195, 114, 248)
                  ],
                ),
                borderRadius: BorderRadius.all(Radius.circular(80.0)),
              ),
              child: Container(
                constraints: const BoxConstraints(
                  minHeight: 50,
                ), // min sizes for Material buttons
                alignment: Alignment.center,
                child: Text(
                  (joined ? 'Joined' : 'Join'),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        )));

    return data;
  }
}
