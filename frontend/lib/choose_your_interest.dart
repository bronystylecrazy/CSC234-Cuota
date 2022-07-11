import 'package:cuota/main.dart';
import 'package:cuota/utils/Dio.dart';
import 'package:flutter/material.dart';

class ChooseYourInterest extends StatefulWidget {
  const ChooseYourInterest({Key? key}) : super(key: key);

  @override
  State<ChooseYourInterest> createState() => _ChooseYourInterestState();
}

class _ChooseYourInterestState extends State<ChooseYourInterest> {
  var categories;

  void _getCategories() async {
    final response = await DioManager.dio.get("/event/category");
    if (response.data["success"]) {
      setState(() {
        categories = response.data["data"];
        print(categories);
      });
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
                            Container(
                              height: 120,
                              child: ListView(
                                scrollDirection: Axis.horizontal,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: (categories[cat] as List<dynamic>)
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
                                                onTap: () {},
                                                child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  child: Image(
                                                    height: 100,
                                                    color: Colors.white
                                                        .withOpacity(0.5),
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
                                ],
                              ),
                            ),
                          ],
                        ),
                      )
                      .toList(),
                ],
              )
            : Text("Loading..."),
      ),
    );
  }
}
