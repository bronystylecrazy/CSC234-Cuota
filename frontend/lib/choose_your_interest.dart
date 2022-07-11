import 'package:cuota/feed.dart';
import 'package:cuota/main.dart';
import 'package:cuota/utils/Dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChooseYourInterest extends StatefulWidget {
  const ChooseYourInterest({Key? key}) : super(key: key);

  @override
  State<ChooseYourInterest> createState() => _ChooseYourInterestState();
}

class _ChooseYourInterestState extends State<ChooseYourInterest> {
  var categories;
  var ids = [];

  void _getCategories() async {
    final response = await DioManager.dio.get("/event/category");
    if (response.data["success"]) {
      setState(() {
        categories = response.data["data"];
        print(categories);
      });
    }
  }

  void _finishSignIn(BuildContext context) async {
    print("calling!");
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final response = await DioManager.dio.post(
          "/auth/update-interest?token=${prefs.get('token')}",
          data: {"interests": "[${ids.join(",")}]"});
      if (response.data["success"]) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => Feed(),
          ),
        );
      } else {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(response.data["message"]),
            actions: [
              FlatButton(
                child: Text("OK"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
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
    _getCategories();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          stops: [0.1, 0.5, 0.9],
          colors: [MyApp.BGMain1, MyApp.BGMain2, MyApp.BGMain3],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          title: const Text("Choose Your Interest"),
          centerTitle: true,
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: Text(""),
        ),
        body: categories != null
            ? ListView(
                children: [
                  ...categories.keys
                      .map(
                        (cat) => Column(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(.5),
                              ),
                              child: Center(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    cat,
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              height: 120,
                              child: ListView(
                                scrollDirection: Axis.horizontal,
                                shrinkWrap: true,
                                children: [
                                  Center(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: (categories[cat]
                                              as List<dynamic>)
                                          .map(
                                            (c) => Container(
                                              decoration:
                                                  BoxDecoration(boxShadow: [
                                                BoxShadow(
                                                    color: Color.fromARGB(
                                                            255, 37, 37, 37)
                                                        .withOpacity(0),
                                                    spreadRadius: 2,
                                                    blurRadius: 3,
                                                    offset: Offset(0, 3))
                                              ]),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: InkWell(
                                                  onTap: () {
                                                    setState(() {
                                                      if (ids
                                                          .contains(c['id'])) {
                                                        ids.remove(c["id"]);
                                                        print('found!');
                                                      } else {
                                                        ids.add(c["id"]);
                                                        print("not found!");
                                                      }
                                                      print(ids);
                                                    });
                                                  },
                                                  child: ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                    child: Image(
                                                      height: 100,
                                                      color: Colors.white
                                                          .withOpacity(
                                                              ids.contains(
                                                                      c['id'])
                                                                  ? 1
                                                                  : 0.5),
                                                      colorBlendMode:
                                                          BlendMode.modulate,
                                                      image: NetworkImage(
                                                          "https://fakeimg.pl/512x512/?text=${c['subType']}"),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          )
                                          .toList(),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      )
                      .toList(),
                  Center(
                    child: ElevatedButton(
                      onPressed: () {
                        if (ids.length == 0) {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title:
                                  Text("Please select at least one interest"),
                              actions: [
                                FlatButton(
                                  child: Text("OK"),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                )
                              ],
                            ),
                          );
                        } else {
                          _finishSignIn(context);
                        }
                      },
                      style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(Colors
                              .blueAccent
                              .withOpacity(ids.length > 0 ? 1 : 0.5))),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "Finish Signing In",
                          style: TextStyle(fontSize: 24),
                        ),
                      ),
                    ),
                  )
                ],
              )
            : Center(
                child: CircularProgressIndicator(),
              ),
      ),
    );
  }
}
