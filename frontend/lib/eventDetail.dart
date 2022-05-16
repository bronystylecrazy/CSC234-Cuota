import 'package:cuota/eventDetail2.dart';
import 'package:cuota/feed.dart';
import 'package:flutter/material.dart';

import 'main.dart';

class EventDetail extends StatefulWidget {
  const EventDetail({Key? key}) : super(key: key);

  @override
  State<EventDetail> createState() => _EventDetailState();
}

class _EventDetailState extends State<EventDetail> {
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
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const Feed(),
                  ),
                );
              },
              icon: const Icon(Icons.arrow_back)),
        ),
        body: ListView(children: getEventDetail()),
      ),
    );
  }

  List<Widget> getEventDetail() {
    List<Widget> data = [];

    data.add(Container(
        child: Image.network(
            "https://www.skydiveswitzerland.com/wp-content/uploads/2020/09/skydive-switzerland-interlaken-tandem-skydiving-swiss-alps-3.jpg")));

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
                    "https://scontent.fbkk2-8.fna.fbcdn.net/v/t39.30808-6/274113888_2680294575447332_8346213907255234640_n.jpg?_nc_cat=100&ccb=1-6&_nc_sid=09cbfe&_nc_eui2=AeEIathyyyVSEKPujChL0Mb6UV41UGBt1aNRXjVQYG3Vo9s4qzizMrSLEcRMtKuoXyDY-YBIdGYZNoCFBO0GvVpy&_nc_ohc=o7vIsYFV2WQAX_KieAL&_nc_ht=scontent.fbkk2-8.fna&oh=00_AT9XgFU5Q6JtsPFXuLh0NdRl98oKsqFIl9_Og0Xgj4x-TQ&oe=627F9FA9",
                    width: 70,
                  ),
                ),
                SizedBox(height: 10),
                Text("Athippat",
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold)),
                Text("Chirawongnathiporn",
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold))
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Play Skydiving",
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
                        Text("Switzerland",
                            style:
                                TextStyle(color: Colors.white, fontSize: 20)),
                        Text("Mittelhorn Mountain",
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
          Text("30/30 Joiners",
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold))
        ])));

    data.add(Container(
        child: Column(children: [
      for (var i = 0; i < 6; i++) ...{
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            for (var i = 0; i < 5; i++) ...{
              Container(
                  decoration: BoxDecoration(boxShadow: [
                    BoxShadow(color: Colors.white, spreadRadius: 4),
                  ]),
                  child: Image.network(
                      "https://scontent.fbkk2-4.fna.fbcdn.net/v/t39.30808-6/276312645_4886860208101906_2115892120545147338_n.jpg?_nc_cat=101&ccb=1-6&_nc_sid=09cbfe&_nc_eui2=AeHRYqbj_txL6XEsQCULOpXDWIxeXkPFcvZYjF5eQ8Vy9gcw429wUhLXihTrDnIFjyjUo_KuBA-qGRrRzynbMp5s&_nc_ohc=44-fPBngHwYAX-yY2Yg&_nc_ht=scontent.fbkk2-4.fna&oh=00_AT9KPiETZmF33KKggCPC8Hdotm0fkid0QudnwR3QTgaX0Q&oe=627F19DA",
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
                  Text(
                      "If you want to play skydiving at Switzerland you can click join now!!",
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
                      Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Thursday, 26 May 2022",
                              style: TextStyle(color: Colors.white),
                            ),
                            Text("7.30 PM - 9.30 AM",
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
                            Text("Travel",
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
                      Text("20 - 60+ years old",
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
                      Text("Male & Female",
                          style: TextStyle(color: Colors.white))
                    ],
                  ),
                ],
              ),
            )
          ],
        )));

    data.add(Container(
        padding:
            const EdgeInsets.only(left: 125, right: 125, bottom: 10, top: 10),
        decoration: BoxDecoration(color: Colors.white),
        child: SizedBox(
          width: 30,
          height: 30,
          child: ElevatedButton(
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const EventDetail2(),
                ),
              );
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
                child: const Text(
                  'Join',
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
