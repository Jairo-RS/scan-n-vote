import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:scan_n_vote/components/backdrop.dart';
import 'package:scan_n_vote/models/past_motions.dart';
import 'package:scan_n_vote/screens/home_page/home_screen.dart';
import 'package:scan_n_vote/screens/voting/voting_screen.dart';

class MotionsBody extends StatefulWidget {
  @override
  _MotionsBodyState createState() => _MotionsBodyState();
}

//
class _MotionsBodyState extends State<MotionsBody> {
  var currentMotion = const [
    {
      "Current Motion",
    },
  ];
  var pastMotions = const [];

  Future loadPastMotions() async {
    String content =
        await rootBundle.loadString('assets/json/past_motions.json');
    List collection = json.decode(content);
    List<PastMotions> _pastmotions =
        collection.map((json) => PastMotions.fromJson(json)).toList();

    setState(() {
      pastMotions = _pastmotions;
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
    final ScrollController _scrollController = ScrollController();
    return WillPopScope(
      //when back button is pressed return to desired screen
      onWillPop: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) {
            return HomeScreen();
          },
        ),
      ),
      child: SafeArea(
        child: Scaffold(
          extendBodyBehindAppBar: true,
          appBar: AppBar(
            leading: IconButton(
              icon: Icon(
                Icons.arrow_back,
              ),
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return HomeScreen();
                  },
                ),
              ),
            ),
            backgroundColor: Colors.transparent,
            elevation: 0,
            iconTheme: IconThemeData(color: Colors.black),
          ),
          body: Backdrop(
            // child: SingleChildScrollView(
            // child: Column(
            //   children: <Widget>[
            //     Expanded(
            child: ListView(
              // shrinkWrap: true,
              children: <Widget>[
                // Column(
                //   mainAxisAlignment: MainAxisAlignment.start,
                //   children: <Widget>[
                //     SizedBox(
                //       height: size.height * 0.1,
                //     ),
                Center(
                  child: Text(
                    'Motions',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 40,
                    ),
                  ),
                ),
                SizedBox(
                  height: size.height * 0.05,
                ),
                Padding(
                  padding: EdgeInsets.only(left: 25, right: 25),
                  child: Container(
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
                            currentMotion.toString() + '\n',
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
                ),
                SizedBox(
                  height: size.height * 0.05,
                ),
                Center(
                  child: Text(
                    'Past Motions',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 30,
                    ),
                  ),
                ),
                SizedBox(
                  height: size.height * 0.05,
                ),
                // Expanded(
                // // child:
                // Container(
                //   height: size.height,
                // child: Scrollbar(
                // isAlwaysShown: true,
                // controller: _scrollController,
                // child:
                Padding(
                  padding: EdgeInsets.only(left: 20, right: 20),
                  child: Container(
                    height: 600,
                    child: ListView.separated(
                      controller: _scrollController,
                      // physics: ClampingScrollPhysics(),
                      // shrinkWrap: true,
                      // reverse: true,
                      itemCount: pastMotions.length,
                      separatorBuilder: (BuildContext context, int index) {
                        return SizedBox(
                          height: size.height * 0.03,
                        );
                      },
                      itemBuilder: (BuildContext context, int index) {
                        PastMotions motion = pastMotions[index];
                        if (motion.allAmendments == null) {
                          motion.allAmendments = "No amendments have been made";
                        }
                        // var amendments = motion["amendments"].toString();
                        // var amendmentss = json.decode(amendments);
                        // List<String> amendments = motions[index];
                        return Padding(
                          padding: EdgeInsets.only(left: 5, right: 5),
                          child: Container(
                            width: size.width * 0.8,
                            padding: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 20),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.5),
                                  spreadRadius: 2,
                                  blurRadius: 5,
                                  offset: Offset(0, 3), //Position of shadow
                                )
                              ],
                            ),
                            child: Column(
                              children: [
                                Align(
                                  alignment: Alignment.topLeft,
                                  child: Text(
                                    "Motion:\n" + motion.pastMotion + "\n",
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
                                        motion.allAmendments.toString() +
                                        // amendmentss[0].toString() +
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
                                    "Results: " + motion.result,
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
                  ),
                ),
                SizedBox(
                  height: size.height * 0.05,
                ),
                // ),
                // ),
                // ),
                // SizedBox(
                //   height: size.height,
                // ),
              ],
            ),
          ),
          // ],
        ),
        // ],
      ),
    );
    // ),
    // ),
    // );
    // );
  }
}
