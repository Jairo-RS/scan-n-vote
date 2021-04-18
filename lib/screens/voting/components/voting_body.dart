import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:scan_n_vote/components/backdrop.dart';
import 'package:scan_n_vote/components/round_button.dart';
import 'package:scan_n_vote/models/voting_motions.dart';
import 'package:scan_n_vote/screens/waiting/waiting_screen.dart';

class VotingBody extends StatefulWidget {
  VotingBody({Key key}) : super(key: key);
  @override
  VotingBodyState createState() => VotingBodyState();
}

class VotingBodyState extends State<VotingBody> {
  //Used for the radio button values
  int voteValue; //0 = A favor, 1 = En Contra, 2 = Abstenido

  List<VotingMotions> motion = const [];

  Future loadMotion() async {
    String content =
        await rootBundle.loadString('assets/json/current_voting_motion.json');
    List collection = json.decode(content);
    List<VotingMotions> _motions =
        collection.map((json) => VotingMotions.fromJson(json)).toList();
    //print(content);

    setState(() {
      motion = _motions;
    });
  }

  void initState() {
    loadMotion();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //Used for total height and width of the screen
    Size size = MediaQuery.of(context).size;
    //print("First Vote Value: $voteValue "); //used for testing purposes
    //print(motion.toString());

    return SafeArea(
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Colors.black,
            ),
            onPressed: () => Navigator.of(context).pop(),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
          iconTheme: IconThemeData(color: Colors.black),
        ),
        body: Backdrop(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  "VOTE",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 42,
                  ),
                ),

                //Motion Prompt
                ListView.builder(
                  itemCount: motion.length,
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemBuilder: (BuildContext context, int index) {
                    VotingMotions theMotion = motion[index];

                    return SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            height: 100,
                            width: 375,
                            child: SingleChildScrollView(
                              child: Text(
                                theMotion.motion, //displays the motion text
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),

                SizedBox(height: size.height * 0.02),
                RadioListTile<int>(
                  title: Text(
                    "A Favor",
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Text("In Favor", style: TextStyle(fontSize: 18)),
                  activeColor: Colors.black,
                  tileColor: Colors.green[400],
                  toggleable: true,
                  value: 0,
                  groupValue: voteValue,
                  onChanged: (value) {
                    setState(() {
                      voteValue = value;
                      print("Vote Value: $voteValue selected");
                    });
                  },
                ),
                SizedBox(
                  height: size.height * 0.04,
                ),
                RadioListTile<int>(
                  title: Text(
                    "Abstenido",
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Text("Abstained", style: TextStyle(fontSize: 18)),
                  activeColor: Colors.black,
                  tileColor: Colors.yellow[400],
                  toggleable: true,
                  value: 2,
                  groupValue: voteValue,
                  onChanged: (value) {
                    setState(() {
                      voteValue = value;
                      print("Vote Value: $voteValue selected");
                    });
                  },
                ),
                SizedBox(
                  height: size.height * 0.04,
                ),
                RadioListTile<int>(
                  title: Text(
                    "En Contra",
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Text("Against", style: TextStyle(fontSize: 18)),
                  activeColor: Colors.black,
                  tileColor: Colors.red[400],
                  toggleable: true,
                  value: 1,
                  groupValue: voteValue,
                  onChanged: (value) {
                    setState(() {
                      voteValue = value;
                      print("Vote Value: $voteValue selected");
                    });
                  },
                ),
                SizedBox(
                  height: size.height * 0.04,
                ),
                RoundButton(
                  text: "Cast Vote",
                  color: Colors.black87,
                  press: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          if (voteValue == 0) {
                            return AlertDialog(
                              title: Text("Cast Vote"),
                              content: Text(
                                  'Are you sure you want to vote "A Favor" to the current motion?'),
                              actions: [
                                TextButton(
                                    //No Button
                                    onPressed: () => Navigator.pop(
                                        context), //return to voting screen
                                    child: Text("No")),
                                TextButton(
                                    //Yes Button
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) {
                                            return WaitingScreen();
                                          },
                                        ),
                                      );
                                    },
                                    child: Text("Yes"))
                              ],
                            );
                          } // end if
                          else if (voteValue == 2) {
                            return AlertDialog(
                              title: Text("Cast Vote"),
                              content: Text(
                                  'Are you sure you want to vote "Abstenido" to the current motion?'),
                              actions: [
                                TextButton(
                                    //No Button
                                    onPressed: () => Navigator.pop(
                                        context), //return to voting screen
                                    child: Text("No")),
                                TextButton(
                                    //Yes Button
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) {
                                            return WaitingScreen();
                                          },
                                        ),
                                      );
                                    },
                                    child: Text("Yes"))
                              ],
                            );
                          } // end else if
                          else if (voteValue == 1) {
                            return AlertDialog(
                              title: Text("Cast Vote"),
                              content: Text(
                                  'Are you sure you want to vote \n"En Contra" to the current motion?'),
                              actions: [
                                TextButton(
                                    //No Button
                                    onPressed: () => Navigator.pop(
                                        context), //return to voting screen
                                    child: Text("No")),
                                TextButton(
                                    //Yes Button
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) {
                                            return WaitingScreen();
                                          },
                                        ),
                                      );
                                    },
                                    child: Text("Yes"))
                              ],
                            );
                          } // end else if
                          else {
                            return AlertDialog(
                              title: Text("Cast Vote"),
                              content: Text(
                                  'No vote has been cast.\nPlease cast a vote.'),
                              actions: [
                                TextButton(
                                    //OK Button
                                    onPressed: () => Navigator.pop(
                                        context), //return to voting screen
                                    child: Text("OK")),
                              ],
                            );
                          } // end else
                        },
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
