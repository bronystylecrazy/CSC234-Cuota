import 'package:cuota/eventDetail.dart';
import 'package:cuota/utils/Dio.dart';
import 'package:flutter/material.dart';
import '../../models/Event.dart';

class SubType extends StatefulWidget {
  SubType({Key? key, required this.event}) : super(key: key);
  Event event;
  @override
  State<SubType> createState() => SubTypeState(event: event);
}

class SubTypeState extends State<SubType> {
  SubTypeState({required this.event});
  Event event;
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      child: ClipRRect(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(color: Colors.white),
              child: Column(
                children: [
                  ClipRRect(
                    child: Container(
                      child: Align(
                          alignment: Alignment.center,
                          widthFactor: 1,
                          heightFactor: .6,
                          child: Image.network(
                            DioManager.baseUrl + event.eventImageUrl,
                            width: 220,
                          )),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(5),
                    child: Row(
                      children: [
                        Image(
                            width: 50,
                            image: NetworkImage(
                              DioManager.baseUrl + event.hostAvatarUrl,
                            )),
                        SizedBox(
                          width: 5,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Host",
                                style: TextStyle(
                                    color: Color.fromARGB(255, 204, 204, 204),
                                    fontSize: 10)),
                            Text(
                              event.host,
                              style: TextStyle(fontWeight: FontWeight.bold),
                            )
                          ],
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
            Text(
              event.title,
              style: TextStyle(
                  color: Color.fromARGB(255, 63, 192, 198),
                  fontWeight: FontWeight.bold,
                  fontSize: 20),
            ),
            Row(
              children: [
                Text(
                  "${event.eventDate.day} May ${event.eventDate.year}",
                  style: TextStyle(color: Colors.white, fontSize: 10),
                ),
                SizedBox(width: 10),
                Row(
                  children: [
                    Icon(
                      Icons.people,
                      color: Colors.white,
                      size: 10,
                    ),
                    Text(
                      " ${event.joined}/${event.maxJoin}",
                      style: TextStyle(color: Colors.white, fontSize: 10),
                    )
                  ],
                )
              ],
            ),
            SizedBox(height: 5),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  primary: Color.fromARGB(255, 255, 255, 255),
                  padding: const EdgeInsets.only(right: 25, left: 25),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12))),
              onPressed: () => {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const EventDetail(),
                  ),
                )
              },
              child: Text(
                "View",
                style: TextStyle(color: Color.fromARGB(255, 63, 191, 198)),
              ),
            ),
            SizedBox(height: 10)
          ],
        ),
      ),
    );
  }
}
