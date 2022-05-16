import 'package:cuota/login.dart';
import 'package:flutter/material.dart';

import 'main.dart';

class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final _formKey = GlobalKey<FormState>();
  var showPassword = false;
  String gender = 'Male';
  final items = <String>["Male", "Female", "Other"];

  String date = "";
  DateTime selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            stops: [0.1, 0.5, 0.9],
            colors: [MyApp.BGMain1, MyApp.BGMain2, MyApp.BGMain3],
          ),
        ),
        child: ListView(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const Center(
                  child: Text(
                    "Sign Up",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 30,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 5.0),
                        child: Align(
                            child: Text(
                              "Username",
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
                        decoration: InputDecoration(
                          hintText: 'Enter your username',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                            gapPadding: 2,
                          ),
                          hintStyle: const TextStyle(
                              color: Color.fromARGB(255, 166, 166, 166)),
                          fillColor: const Color.fromRGBO(0, 0, 0, .1),
                          filled: true,
                          focusedBorder: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          errorBorder: InputBorder.none,
                          disabledBorder: InputBorder.none,
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 5.0),
                        child: Align(
                            child: Text(
                              "Password",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                            alignment: Alignment.centerLeft),
                      ),
                      TextFormField(
                        style: const TextStyle(color: Colors.white),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your password';
                          }
                          return null;
                        },
                        maxLines: 1,
                        obscureText: showPassword,
                        decoration: InputDecoration(
                          hintStyle: const TextStyle(
                              color: Color.fromARGB(255, 166, 166, 166)),
                          hintText: 'Enter your password',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                          fillColor: const Color.fromRGBO(0, 0, 0, .1),
                          filled: true,
                          focusedBorder: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          errorBorder: InputBorder.none,
                          disabledBorder: InputBorder.none,
                          suffixIcon: Align(
                            widthFactor: 1.0,
                            heightFactor: 1.0,
                            child: IconButton(
                              onPressed: () {
                                setState(() {
                                  showPassword = !showPassword;
                                });
                              },
                              icon: Icon(
                                showPassword
                                    ? Icons.remove_red_eye_outlined
                                    : Icons.remove_red_eye,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 5.0),
                        child: Align(
                            child: Text(
                              "Confirm Password",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                            alignment: Alignment.centerLeft),
                      ),
                      TextFormField(
                        style: const TextStyle(color: Colors.white),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your password';
                          }
                          return null;
                        },
                        maxLines: 1,
                        obscureText: showPassword,
                        decoration: InputDecoration(
                          hintStyle: const TextStyle(
                              color: Color.fromARGB(255, 166, 166, 166)),
                          hintText: 'Confirm your password',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                          fillColor: const Color.fromRGBO(0, 0, 0, .1),
                          filled: true,
                          focusedBorder: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          errorBorder: InputBorder.none,
                          disabledBorder: InputBorder.none,
                          suffixIcon: Align(
                            widthFactor: 1.0,
                            heightFactor: 1.0,
                            child: IconButton(
                              onPressed: () {
                                setState(() {
                                  showPassword = !showPassword;
                                });
                              },
                              icon: Icon(
                                showPassword
                                    ? Icons.remove_red_eye_outlined
                                    : Icons.remove_red_eye,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            child: Column(
                              children: [
                                const Padding(
                                  padding: EdgeInsets.symmetric(vertical: 5.0),
                                  child: Align(
                                      child: Text(
                                        "Firstname",
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.white,
                                        ),
                                      ),
                                      alignment: Alignment.centerLeft),
                                ),
                                TextFormField(
                                  style: const TextStyle(color: Colors.white),
                                  maxLines: 1,
                                  decoration: InputDecoration(
                                    hintStyle: const TextStyle(
                                        color:
                                            Color.fromARGB(255, 166, 166, 166)),
                                    hintText: 'Firstname',
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    fillColor:
                                        const Color.fromRGBO(0, 0, 0, .1),
                                    filled: true,
                                    focusedBorder: InputBorder.none,
                                    enabledBorder: InputBorder.none,
                                    errorBorder: InputBorder.none,
                                    disabledBorder: InputBorder.none,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            width: 10.0,
                          ),
                          Flexible(
                            child: Column(
                              children: [
                                const Padding(
                                  padding: EdgeInsets.symmetric(vertical: 5.0),
                                  child: Align(
                                      child: Text(
                                        "Lastname",
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.white,
                                        ),
                                      ),
                                      alignment: Alignment.centerLeft),
                                ),
                                TextFormField(
                                  style: const TextStyle(color: Colors.white),
                                  maxLines: 1,
                                  decoration: InputDecoration(
                                    hintStyle: const TextStyle(
                                        color:
                                            Color.fromARGB(255, 166, 166, 166)),
                                    hintText: 'Lastname',
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    fillColor:
                                        const Color.fromRGBO(0, 0, 0, .1),
                                    filled: true,
                                    focusedBorder: InputBorder.none,
                                    enabledBorder: InputBorder.none,
                                    errorBorder: InputBorder.none,
                                    disabledBorder: InputBorder.none,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            child: Column(
                              children: [
                                const Padding(
                                  padding: EdgeInsets.symmetric(vertical: 5.0),
                                  child: Align(
                                      child: Text(
                                        "Nickname",
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.white,
                                        ),
                                      ),
                                      alignment: Alignment.centerLeft),
                                ),
                                TextFormField(
                                  style: const TextStyle(color: Colors.white),
                                  maxLines: 1,
                                  decoration: InputDecoration(
                                    hintStyle: const TextStyle(
                                        color:
                                            Color.fromARGB(255, 166, 166, 166)),
                                    hintText: 'Nickname',
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    fillColor:
                                        const Color.fromRGBO(0, 0, 0, .1),
                                    filled: true,
                                    focusedBorder: InputBorder.none,
                                    enabledBorder: InputBorder.none,
                                    errorBorder: InputBorder.none,
                                    disabledBorder: InputBorder.none,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            width: 10.0,
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
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 15.0),
                                    child: DropdownButton(
                                      value: gender,
                                      icon: const Icon(
                                          Icons.keyboard_arrow_down,
                                          color: Colors.white),
                                      style:
                                          const TextStyle(color: Colors.white),
                                      items: items.map((String items) {
                                        return DropdownMenuItem(
                                          value: items,
                                          child: Text(items),
                                        );
                                      }).toList(),
                                      dropdownColor:
                                          const Color.fromARGB(255, 41, 19, 70),
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
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 5.0),
                        child: Align(
                            child: Text(
                              "Birthdate",
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
                          suffixIcon: const Icon(Icons.keyboard_arrow_down,
                              color: Colors.white),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      ElevatedButton(
                        onPressed: () {},
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
                            borderRadius:
                                BorderRadius.all(Radius.circular(80.0)),
                          ),
                          child: Container(
                            constraints: const BoxConstraints(
                              minWidth: 88.0,
                              minHeight: 50,
                            ), // min sizes for Material buttons
                            alignment: Alignment.center,
                            child: const Text(
                              'Sign Up',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'Already account? ',
                            style: TextStyle(
                              color: Color.fromARGB(255, 166, 166, 166),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const Login(),
                                ),
                              );
                            },
                            child: const Text(
                              'Sign in',
                              style: TextStyle(
                                color: Color.fromARGB(255, 249, 98, 216),
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  _selectDate(BuildContext context) async {
    final DateTime? selected = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2010),
      lastDate: DateTime(2025),
      initialDatePickerMode: DatePickerMode.year,
      // initialEntryMode: DatePickerEntryMode.inputOnly
    );

    if (selected != null && selected != selectedDate) {
      setState(() {
        selectedDate = selected;
      });
    }
  }
}
