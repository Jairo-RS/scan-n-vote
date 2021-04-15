import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:scan_n_vote/components/backdrop.dart';
import 'package:scan_n_vote/screens/voting/voting_screen.dart';

class MotionsBody extends StatefulWidget {
  @override
  _MotionsBodyState createState() => _MotionsBodyState();
}

class _MotionsBodyState extends State<MotionsBody> {
  var pastMotions = const [];

  Future loadPastMotions() async {
    var content = await rootBundle.loadString('assets/json/past_motions.json');
    var collection = json.decode(content);

    setState(() {
      pastMotions = collection;
    });
  }

  @override
  void initState() {
    loadPastMotions();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //Used for total height and width of the screen
    Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: Backdrop(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              height: size.height * 0.1,
            ),
            Text(
              'Motions',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 40,
              ),
            ),
            SizedBox(
              height: size.height * 0.05,
            ),
            Container(
              width: size.width * 0.8,
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: Offset(0, 3), //Position of shadow
                  )
                ],
              ),
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      'Current Motion\n',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: Colors.blue,
                          onPrimary: Colors.white,
                        ),
                        child: Padding(
                          padding: EdgeInsets.only(left: 20, right: 20),
                          child: Text(
                            'Vote',
                            style: TextStyle(
                              fontSize: 16,
                            ),
                          ),
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) {
                                return VotingScreen();
                              },
                            ),
                          );
                        },
                      ),
                      SizedBox(
                        width: size.width * 0.1,
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: Colors.green,
                          onPrimary: Colors.white,
                        ),
                        child: Padding(
                          padding: EdgeInsets.only(left: 20, right: 20),
                          child: Text(
                            'Results',
                            style: TextStyle(
                              fontSize: 16,
                            ),
                          ),
                        ),
                        onPressed: () {},
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(
              height: size.height * 0.05,
            ),
            Text(
              'Past Motions',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 26,
              ),
            ),
            SizedBox(
              height: size.height * 0.05,
            ),
            Expanded(
              child: ListView.separated(
                // reverse: true,
                itemCount: pastMotions.length,
                separatorBuilder: (BuildContext context, int index) {
                  return SizedBox(
                    height: size.height * 0.03,
                  );
                },
                itemBuilder: (BuildContext context, int index) {
                  var motion = pastMotions[index];
                  // List<String> amendments = motions[index];
                  return Padding(
                    padding: EdgeInsets.only(left: 30, right: 30),
                    child: Container(
                      width: size.width * 0.8,
                      padding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 5,
                            blurRadius: 7,
                            offset: Offset(0, 3), //Position of shadow
                          )
                        ],
                      ),
                      child: Column(
                        children: [
                          Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                              "Motion:\n" + motion["past motion"] + "\n",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "Amendments:\n" +
                                  motion["amendments"].toString() +
                                  "\n",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ),
                          Align(
                            alignment: Alignment.bottomLeft,
                            child: Text(
                              "Results: " + motion["result"],
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ],
                      ),
                      // child: ListTile(
                      //   trailing: Text("Result:\n" + motion["past motion"]),
                      //   title: Text("Motion:\n" + motion["past motion"]),
                      //   subtitle: Text(
                      //       "Amendments:\n" + motion["amendments"].toString()),
                      // ),
                    ),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
