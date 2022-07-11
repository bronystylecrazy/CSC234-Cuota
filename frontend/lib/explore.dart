import 'package:cuota/create_event.dart';
import 'package:cuota/feed.dart';
import 'package:cuota/models/Event.dart';
import 'package:cuota/profile.dart';
import 'package:cuota/utils/Dio.dart';
import 'package:cuota/widgets/explore/subtype.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'main.dart';

class Explore extends StatefulWidget {
  const Explore({Key? key}) : super(key: key);

  @override
  State<Explore> createState() => _ExploreState();
}

class _ExploreState extends State<Explore> {
  Map<String, dynamic> explores = {};

  List<Event> events = [];
  Map<String, Event?> randoms = {};

  String? selectedCategory = "-";

  Future<void> fetchData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString("token") ?? "xxx";
    try {
      var response = await DioManager.dio.get('/event/explore?token=' + token);
      var response2 = await DioManager.dio.get('/event?token=' + token);
      var response3 =
          await DioManager.dio.get('/event/explore/random?token=' + token);
      setState(() {
        this.events = events;
      });
      // print(events[0].detail);
      setState(() {
        explores = response.data["data"];
        randoms = response3.data["data"];
        for (var category in response3.data["data"].keys) {
          selectedCategory = category;
          print("SelectedCategoruy " + selectedCategory!);
          randoms[category] = Event.fromJson(response3.data["data"][category]);
        }
        events = events = response2.data["data"]
            .map<Event>((json) => Event.fromJson(json))
            .toList();
      });
    } catch (e) {
      // print(e);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    (() async {
      await fetchData();
      var categories = explores.keys;
      setState(() {
        selectedCategory = categories.first;
      });
    })();
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
          title: const Text(MyApp.nameApplication),
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          centerTitle: true,
          leading: IconButton(
              onPressed: () {
                Navigator.push(
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
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const Feed(),
                    ),
                  );
                },
                icon: const Icon(Icons.computer))
          ],
        ),
        body: ListView(children: getExplore(selectedCategory)),
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

  List<Widget> getExplore(cate) {
    List<Widget> data = [];
    var categories = explores.keys;

    /* Cetagory */

    data.add(Container(
      margin: const EdgeInsets.only(left: 20, right: 20),
      child: Text(
        "What's your interest...   $cate?",
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
    ));
    data.add(Container(
      child: Column(
        children: [
          SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: categories
                .map(
                  (c) => Container(
                    decoration: BoxDecoration(boxShadow: [
                      BoxShadow(
                          color:
                              Color.fromARGB(255, 37, 37, 37).withOpacity(0.1),
                          spreadRadius: 2,
                          blurRadius: 3,
                          offset: Offset(0, 3))
                    ]),
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          selectedCategory = c;
                          print(selectedCategory);
                        });
                      },
                      child: Image(
                        height: 100,
                        color: Colors.white
                            .withOpacity(selectedCategory == c ? 1 : 0.5),
                        colorBlendMode: BlendMode.modulate,
                        image: NetworkImage(
                            "https://fakeimg.pl/512x512/?text=${c}"),
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
          SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const CreateEvent(),
                        settings: RouteSettings(arguments: selectedCategory)),
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text("Let's create an event"),
                ),
              )
            ],
          ),
          SizedBox(height: 20)
        ],
      ),
    ));

    /* ---------------------------------------------------------------------------- */

    data.add(
      Divider(
        indent: 20,
        endIndent: 20,
        thickness: 2,
        color: Color.fromARGB(63, 255, 255, 255),
      ),
    );

    for (var category in categories) {
      if (category == selectedCategory) {
        /* Main Type */
        data.add(Container(
          margin: const EdgeInsets.only(left: 20, right: 20),
          child: Row(
            children: [
              Icon(
                Icons.card_travel,
                color: Colors.white,
              ),
              Text(
                category,
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              )
            ],
          ),
        ));
        if (randoms[category] != null) {
          data.add(Container(
            margin: const EdgeInsets.all(20),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                color: Color.fromARGB(255, 251, 251, 251)),
            child: Column(
              children: [
                Column(children: [
                  ClipRRect(
                      borderRadius: BorderRadius.only(
                          topLeft: const Radius.circular(30),
                          topRight: const Radius.circular(30)),
                      child: ClipRRect(
                        // borderRadius: BorderRadius.circular(20),
                        child: Container(
                          child: Align(
                              alignment: Alignment.center,
                              widthFactor: 1,
                              heightFactor: .4,
                              child: Image.network(
                                DioManager.baseUrl +
                                    randoms[category]!.eventImageUrl,
                              )),
                        ),
                      ))
                ]),
                Container(
                    padding: const EdgeInsets.only(
                      left: 40,
                      right: 40,
                      top: 5,
                      bottom: 15,
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Expanded(
                            flex: 2,
                            child: Container(
                              child: Image(
                                width: 30,
                                height: 30,
                                image: NetworkImage(DioManager.baseUrl +
                                    "/storage/placeholder.jpg"),
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
                                              randoms[category]!.host,
                                              style: TextStyle(
                                                  color: Color.fromARGB(
                                                      255, 59, 59, 59),
                                                  fontWeight: FontWeight.bold),
                                            )
                                          ])),
                                      ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                            primary: Color.fromARGB(
                                                255, 255, 255, 255),
                                            padding: const EdgeInsets.only(
                                                right: 25, left: 25),
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(12))),
                                        onPressed: () => {},
                                        child: Text(
                                          "Let's join",
                                          style: TextStyle(
                                              color: Color.fromARGB(
                                                  255, 63, 191, 198)),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ]),
                            )),
                      ],
                    )),
              ],
            ),
          ));
        }
        /* ---------------------------------------------------------------------------- */

        // data.add(
        //   Divider(
        //     indent: 20,
        //     endIndent: 20,
        //     thickness: 2,
        //     color: Color.fromARGB(63, 255, 255, 255),
        //   ),
        // );s
        var subcategories = explores[category].keys;

        for (var subcategory in subcategories) {
          var events = (explores[category][subcategory] as List<dynamic>)
              .map((e) => Event.fromJson(e))
              .toList();

          data.add(
            Container(
                margin: const EdgeInsets.only(left: 20, right: 20),
                child: Text(
                  "#${subcategory}",
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                )),
          );
          data.add(Container(
            margin: const EdgeInsets.only(top: 5, left: 20, bottom: 10),
            child: Text(
              "${events.length} events",
              style: TextStyle(color: Colors.grey),
            ),
          ));

          for (int i = 0; i < events.length; i += 2) {
            if (i < events.length) {
              final leftEvent = SubType(event: events[i]);

              final rightEvent = i + 1 >= events.length
                  ? SizedBox(
                      width: 150,
                    )
                  : SubType(event: events[i + 1]);

              data.add(Padding(
                padding: const EdgeInsets.only(left: 20, right: 20),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [leftEvent, rightEvent],
                    ),
                  ],
                ),
              ));
            }
          }
        }
        data.add(
          Divider(
            indent: 20,
            endIndent: 20,
            thickness: 2,
            color: Color.fromARGB(63, 255, 255, 255),
          ),
        );
      }
    }
    // return data;

    return data;
  }
}
