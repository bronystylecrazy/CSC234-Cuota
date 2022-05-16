import 'package:http/http.dart' as http;

import 'package:cuota/explore.dart';
import 'package:cuota/main.dart';
import 'package:cuota/models/SubCategory.dart';
import 'package:cuota/utils/Dio.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CreateEvent extends StatefulWidget {
  const CreateEvent({Key? key}) : super(key: key);

  @override
  State<CreateEvent> createState() => _CreateEventState();
}

class _CreateEventState extends State<CreateEvent> {
  String date = "";
  DateTime selectedDate = DateTime.now();
  String gender = 'Male';
  final items = <String>["Male", "Female"];
  int numOfpeople = 1;

  RangeValues ageValues = RangeValues(12, 65);
  int minAge = 12;
  int maxAge = 65;

  final title = TextEditingController();
  final detail = TextEditingController();
  final location = TextEditingController();
  final time = TextEditingController();
  Map<String, List<SubCategory>> results = {};

  List<String> categories =
      ({"Travel": 'hello', "World": 'world'} as Map<String, String>)
          .keys
          .toList();
  String selectedCategory = "Travel";
  String selectedSubCategory = "";

  List<String> eventImagePaths = [];

  List<SubCategory> subCategories = [];

  Future<void> fetchData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString("token") ?? "xxx";
    // print(token);
    try {
      var response = await DioManager.dio.get('/event/category?token=' + token);
      setState(() {
        Map<String, dynamic> r = response.data["data"];
        for (var key in r.keys) {
          results[key] = [SubCategory(id: 0, subType: "--Choose one--")];
          results[key]!.addAll(r[key]
              .map<SubCategory>((json) => SubCategory.fromJson(json))
              .toList());
          subCategories.addAll(r[key]
              .map<SubCategory>((json) => SubCategory.fromJson(json))
              .toList());
        }
        categories = (response.data["data"]).keys.toList() as List<String>;
        selectedCategory = categories[0];
        selectedSubCategory = results[selectedCategory]![0].subType;
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    title.dispose();
    detail.dispose();
    location.dispose();
    time.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchData();
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
              onPressed: () {}, icon: const Icon(Icons.account_circle)),
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
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView(children: Render(context)),
        ),
      ),
    );
  }

  List<Widget> Render(BuildContext context) {
    List<Widget> data = [];
    data.add(Container(
      child: Row(
        children: [
          Icon(
            Icons.picture_in_picture,
            color: Colors.white,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8),
            child: Text(
              "Create an Event",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 24,
              ),
            ),
          )
        ],
      ),
    ));

    data.addAll([
      Padding(
        padding: EdgeInsets.symmetric(vertical: 5.0),
        child: Align(
            child: Text(
              "Category",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
            alignment: Alignment.centerLeft),
      ),
      Container(
        decoration: const BoxDecoration(
          color: Color.fromRGBO(0, 0, 0, .1),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 15.0),
          child: DropdownButton(
            value: selectedCategory,
            icon: const Icon(Icons.keyboard_arrow_down, color: Colors.white),
            style: const TextStyle(color: Colors.white),
            items: categories.map((String item) {
              return DropdownMenuItem(
                value: item,
                child: Text(item),
              );
            }).toList(),
            dropdownColor: const Color.fromARGB(255, 41, 19, 70),
            alignment: Alignment.centerLeft,
            isExpanded: true,
            underline: Container(),
            focusColor: Colors.transparent,
            onChanged: (String? value) {
              setState(() {
                selectedCategory = value!;
                selectedSubCategory = results[selectedCategory]![0].subType;
                print(selectedCategory);
              });
            },
          ),
        ),
      ),
    ]);

    if (results.containsKey(selectedCategory) &&
        results[selectedCategory]!.isNotEmpty) {
      print(selectedCategory);
      print(results[selectedCategory]!.map((e) => e.subType).toList());
      data.addAll([
        Padding(
          padding: EdgeInsets.symmetric(vertical: 5.0),
          child: Align(
              child: Text(
                "# Tags",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              alignment: Alignment.centerLeft),
        ),
        Container(
          decoration: const BoxDecoration(
            color: Color.fromRGBO(0, 0, 0, .1),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 15.0),
            child: DropdownButton(
              value: selectedSubCategory,
              icon: const Icon(Icons.keyboard_arrow_down, color: Colors.white),
              style: const TextStyle(color: Colors.white),
              items: results[selectedCategory]!
                  .map((e) => e.subType)
                  .toList()
                  .map((String item) {
                return DropdownMenuItem(
                  value: item,
                  child: Text(item),
                );
              }).toList(),
              dropdownColor: const Color.fromARGB(255, 41, 19, 70),
              alignment: Alignment.centerLeft,
              isExpanded: true,
              underline: Container(),
              focusColor: Colors.transparent,
              onChanged: (String? value) {
                setState(() {
                  selectedSubCategory = value!;
                  print(selectedSubCategory);
                });
              },
            ),
          ),
        ),
      ]);
    }

    data.add(
      Divider(
        indent: 20,
        endIndent: 20,
        thickness: 2,
        color: Color.fromARGB(63, 255, 255, 255),
      ),
    );

    data.addAll([
      Padding(
        padding: EdgeInsets.symmetric(vertical: 5.0),
        child: Align(
            child: Text(
              "Event Title",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
            alignment: Alignment.centerLeft),
      ),
      TextFormField(
        controller: title,
        maxLines: 1,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          hintText: 'Enter your event',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
            gapPadding: 2,
          ),
          hintStyle: const TextStyle(color: Color.fromARGB(255, 166, 166, 166)),
          fillColor: const Color.fromRGBO(0, 0, 0, .1),
          filled: true,
          focusedBorder: InputBorder.none,
          enabledBorder: InputBorder.none,
          errorBorder: InputBorder.none,
          disabledBorder: InputBorder.none,
        ),
      )
    ]);

    data.addAll([
      Padding(
        padding: EdgeInsets.symmetric(vertical: 5.0),
        child: Align(
            child: Text(
              "Event Description",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
            alignment: Alignment.centerLeft),
      ),
      TextField(
        controller: detail,
        maxLines: 2,
        style: const TextStyle(color: Colors.white),
        keyboardType: TextInputType.multiline,
        minLines: 2,
        decoration: InputDecoration(
          hintText: 'Enter your detail...',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
            gapPadding: 2,
          ),
          hintStyle: const TextStyle(color: Color.fromARGB(255, 166, 166, 166)),
          fillColor: const Color.fromRGBO(0, 0, 0, .1),
          filled: true,
          focusedBorder: InputBorder.none,
          enabledBorder: InputBorder.none,
          errorBorder: InputBorder.none,
          disabledBorder: InputBorder.none,
        ),
      )
    ]);

    data.addAll([
      Padding(
        padding: EdgeInsets.symmetric(vertical: 5.0),
        child: Align(
            child: Text(
              "Location",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
            alignment: Alignment.centerLeft),
      ),
      TextFormField(
        controller: location,
        maxLines: 1,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          hintText: 'Enter your location',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
            gapPadding: 2,
          ),
          hintStyle: const TextStyle(color: Color.fromARGB(255, 166, 166, 166)),
          fillColor: const Color.fromRGBO(0, 0, 0, .1),
          filled: true,
          focusedBorder: InputBorder.none,
          enabledBorder: InputBorder.none,
          errorBorder: InputBorder.none,
          disabledBorder: InputBorder.none,
        ),
      )
    ]);

    data.add(
      Divider(
        indent: 20,
        endIndent: 20,
        thickness: 2,
        color: Color.fromARGB(63, 255, 255, 255),
      ),
    );

    data.addAll([
      const Padding(
        padding: EdgeInsets.symmetric(vertical: 5.0),
        child: Align(
            child: Text(
              "Date & Time",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
            alignment: Alignment.centerLeft),
      ),
      TextFormField(
        maxLines: 1,
        style: const TextStyle(color: Colors.white),
        readOnly: true,
        onTap: () => _selectDate(context),
        controller: time,
        decoration: InputDecoration(
          hintText:
              '${selectedDate.day}/${selectedDate.month}/${selectedDate.year}',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
            gapPadding: 2,
          ),
          hintStyle: const TextStyle(color: Colors.white),
          fillColor: const Color.fromRGBO(0, 0, 0, .1),
          filled: true,
          focusedBorder: InputBorder.none,
          enabledBorder: InputBorder.none,
          errorBorder: InputBorder.none,
          disabledBorder: InputBorder.none,
          suffixIcon:
              const Icon(Icons.keyboard_arrow_down, color: Colors.white),
        ),
      ),
    ]);

    data.addAll([
      const Padding(
        padding: EdgeInsets.symmetric(vertical: 5.0),
        child: Align(
          child: Text(
            "Who are you looking for?",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          alignment: Alignment.centerLeft,
        ),
      ),
      Flexible(
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 5.0),
              child: Align(
                  child: Text(
                    "Gender",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  alignment: Alignment.centerLeft),
            ),
            Container(
              decoration: const BoxDecoration(
                color: Color.fromRGBO(0, 0, 0, .1),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 15.0),
                child: DropdownButton(
                  value: gender,
                  icon: const Icon(Icons.keyboard_arrow_down,
                      color: Colors.white),
                  style: const TextStyle(color: Colors.white),
                  items: items.map((String items) {
                    return DropdownMenuItem(
                      value: items,
                      child: Text(items),
                    );
                  }).toList(),
                  dropdownColor: const Color.fromARGB(255, 41, 19, 70),
                  alignment: Alignment.centerLeft,
                  isExpanded: true,
                  underline: Container(),
                  focusColor: Colors.transparent,
                  onChanged: (String? value) {
                    setState(() {
                      gender = value!;
                    });
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    ]);

    data.addAll([
      SizedBox(height: 20),
      Padding(
        padding: EdgeInsets.symmetric(vertical: 5.0),
        child: Align(
            child: Text(
              "Number of people",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
            alignment: Alignment.centerLeft),
      ),
      Expanded(
        child: Slider(
          value: numOfpeople.toDouble(),
          min: 1.0,
          max: 30,
          divisions: 30,
          activeColor: Colors.blue,
          inactiveColor: Colors.white,
          label: "${numOfpeople} people",
          onChanged: (double newValue) {
            setState(() {
              numOfpeople = newValue.round();
            });
          },
          semanticFormatterCallback: (double newValue) {
            return '${newValue.round()} people';
          },
        ),
      ),
    ]);

    data.addAll([
      Padding(
        padding: EdgeInsets.symmetric(vertical: 5.0),
        child: Align(
            child: Text(
              "Age range",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
            alignment: Alignment.centerLeft),
      ),
      Expanded(
        child: RangeSlider(
          values: ageValues,
          min: minAge.toDouble(),
          max: maxAge.toDouble(),
          divisions: maxAge - minAge,
          activeColor: Colors.blue,
          inactiveColor: Colors.white,
          labels: RangeLabels(
              '${ageValues.start.toInt()}', '${ageValues.end.toInt()}'),
          onChanged: (RangeValues newValue) {
            setState(() {
              ageValues = newValue;
            });
          },
          // semanticFormatterCallback: (double newValue) {
          //   return '${newValue.round()} people';
          // },
        ),
      ),
    ]);

    data.addAll([
      Padding(
        padding: EdgeInsets.symmetric(vertical: 5.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Event Pictures",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
            eventImagePaths.length > 0
                ? SizedBox()
                : IconButton(
                    icon: Icon(Icons.add_a_photo),
                    onPressed: () {
                      _openImagePicker(context);
                    },
                    color: Colors.white,
                  ),
          ],
        ),
      ),
    ]);

    for (var path in eventImagePaths) {
      data.addAll([
        Padding(
          padding: EdgeInsets.symmetric(vertical: 5.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(5),
                  child: Stack(
                    children: [
                      Image.network(
                        path,
                        fit: BoxFit.cover,
                        width: MediaQuery.of(context).size.width * 0.9,
                      ),
                      Positioned(
                        top: 20,
                        right: 0,
                        child: ElevatedButton(
                          child: Icon(
                            Icons.delete,
                            color: Colors.black.withAlpha(180),
                            size: 18,
                          ),
                          style: ElevatedButton.styleFrom(
                            primary: Colors.white.withOpacity(0.5),
                            shape: const CircleBorder(),
                          ),
                          onPressed: () {
                            deleteImageHandler(context, path);
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ]);
    }

    data.addAll([
      SizedBox(
        height: 20,
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
            onPressed: () => createHostHandler(context),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text("Let's host"),
            ),
          )
        ],
      ),
      SizedBox(height: 20)
    ]);

    return data;
  }

  _selectDate(BuildContext context) async {
    final DateTime? selected = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2125),

      // initialDatePickerMode: DatePickerMode.year,
      // initialEntryMode: DatePickerEntryMode.inputOnly
    );

    if (selected != null) {
      setState(() {
        selectedDate = selected;
        print(selectedDate);
      });
    }
  }

  deleteImageHandler(context, path) async {
    var result = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Delete Image"),
        content: Text("Are you sure you want to delete this image?"),
        actions: [
          FlatButton(
            child: Text("Cancel"),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          FlatButton(
            child: Text("Delete"),
            onPressed: () {
              setState(() {
                eventImagePaths.removeAt(eventImagePaths.indexOf(path));
              });
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }

  _openImagePicker(context) async {
    final PickedFile? file =
        await ImagePicker.platform.pickImage(source: ImageSource.gallery);
    // XFile? xfile = await picker..pickImage(source: ImageSource.gallery);
    if (file == null) return;
    setState(() {
      eventImagePaths.add(file.path);
    });
    //  รอทำบน Emu
    // File file = File(xfile.path);
//     var formData = FormData.fromMap({
//       "files": http.MultipartFile.fromBytes(
//         'file', file.fileBytes,
// //  contentType: MediaType('application', 'octet-stream'),
//         filename: file.file.name,
//       ),
//     });

    // var response = await DioManager.dio.post("/storage/", data: formData);
    // print(response);
  }

  createHostHandler(context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString("token") ?? "xxx";
    print(token);
    print(subCategories.map((e) => e.subType));
    print(selectedCategory);
    try {
      var response = await DioManager.dio.post('/event?token=' + token, data: {
        "title": title.text,
        "detail": detail.text,
        "location": location.text,
        "gender": gender,
        "eventDate": selectedDate.toIso8601String(),
        "minAge": ageValues.start.toInt(),
        "maxAge": ageValues.end.toInt(),
        "maxJoin": numOfpeople.toInt(),
        "subType_id": subCategories
            .firstWhere((element) => element.subType == selectedSubCategory)
            .id
      });
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: response.data["success"] ? Text("Success!") : Text("Error!"),
          content: Text(response.data["message"]),
          actions: [
            FlatButton(
              child: Text("OK"),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const Explore(),
                  ),
                );
              },
            ),
          ],
        ),
      );
    } on DioError catch (e) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text("Failed"),
          content: Text(e.message),
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
  }
}
