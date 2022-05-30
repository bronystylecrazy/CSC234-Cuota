import 'package:cuota/feed.dart';
import 'package:cuota/models/Profile.dart';
import 'package:cuota/utils/Dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  static const BGMain1 = Color.fromARGB(255, 37, 73, 121);
  static const BGMain2 = Color.fromARGB(255, 47, 57, 106);
  static const BGMain3 = Color.fromARGB(255, 63, 24, 81);

  MyProfile? user;

  fetchProfile(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString("token") ?? "xxx";

    try {
      var response = await DioManager.dio.get('/auth/me?token=' + token);
      if (response.data["success"]) {
        setState(() {
          user = MyProfile.fromJson(response.data["data"]);
          print(user);
        });
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchProfile(context);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          stops: [0.1, 0.5, 0.9],
          colors: [BGMain1, BGMain2, BGMain3],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: ListView(
          children: getProfile(),
        ),
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
      ),
    );
  }

  List<Widget> getProfile() {
    List<Widget> data = [];

    data.add(
      Container(
        child: Padding(
          padding: const EdgeInsets.only(top: 20),
          child: Column(
            children: [
              Image.network(
                user == null
                    ? DioManager.baseUrl + '/storage/placeholder.jpg'
                    : DioManager.baseUrl + user!.avatarUrl!,
                width: 128,
                height: 128,
              ),
            ],
          ),
        ),
      ),
    );
    data.add(Container(
      child: Padding(
        padding: const EdgeInsets.only(top: 20),
        child: Column(
          children: [
            Text(
              "${user == null ? "" : user!.firstname} ${user == null ? "" : user!.lastname} ",
              style: TextStyle(
                  color: Color.fromARGB(255, 255, 255, 255),
                  fontSize: 25,
                  fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 5,
            ),
            Text(
              "(${user == null ? "" : user!.nickname} )",
              style: TextStyle(
                  color: Color.fromARGB(255, 255, 255, 255),
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    ));
    data.add(
      Container(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 40),
              child: Container(
                width: 150,
                height: 30,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    stops: [0.1, 0.9],
                    colors: [
                      Color.fromARGB(255, 195, 114, 248),
                      Color.fromARGB(255, 249, 98, 216),
                    ],
                  ),
                ),
                child: Text(
                  "Level ${user == null ? "-" : user!.level} ",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Color.fromARGB(255, 255, 255, 255),
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );

    // data.add(
    //   Padding(
    //     padding: const EdgeInsets.only(top: 40),
    //     child: Container(
    //       child: Row(
    //         children: [
    //           Column(
    //             children: [
    //               Text(
    //                 "Followings",
    //                 style: TextStyle(
    //                   color: Color.fromARGB(255, 255, 255, 255),
    //                   fontSize: 20,
    //                 ),
    //               ),
    //               Text(
    //                 "1",
    //                 style: TextStyle(
    //                     color: Color.fromARGB(255, 255, 255, 255),
    //                     fontSize: 20,
    //                     fontWeight: FontWeight.bold),
    //               ),
    //             ],
    //           ),
    //           Column(
    //             children: <Widget>[
    //               Text(
    //                 "Followers",
    //                 style: TextStyle(
    //                   color: Color.fromARGB(255, 255, 255, 255),
    //                   fontSize: 20,
    //                 ),
    //               ),
    //               Text(
    //                 "20",
    //                 style: TextStyle(
    //                     color: Color.fromARGB(255, 255, 255, 255),
    //                     fontSize: 20,
    //                     fontWeight: FontWeight.bold),
    //               ),
    //             ],
    //           ),
    //           const VerticalDivider(
    //             thickness: 5,
    //             indent: 10,
    //             endIndent: 10,
    //             color: Colors.red,
    //           ),
    //           OutlinedButton(
    //             style: ButtonStyle(
    //               overlayColor: MaterialStateProperty.all(
    //                   Color.fromARGB(255, 255, 255, 255)),
    //             ),
    //             onPressed: () {
    //               debugPrint('Received click');
    //             },
    //             child: const Text('edit profile'),
    //           ),
    //         ],
    //       ),
    //     ),
    //   ),
    // );

    return data;
  }
}
