import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:scan_n_vote/components/backdrop.dart';
import 'package:scan_n_vote/components/round_button.dart';
import 'package:scan_n_vote/screens/motions/motions_screen.dart';
import 'package:scan_n_vote/screens/waiting/waiting_screen.dart';

class VotingBody extends StatefulWidget {
  VotingBody({Key key}) : super(key: key);
  @override
  VotingBodyState createState() => VotingBodyState();
}

class VotingBodyState extends State<VotingBody> {
  int voteValue = 0; //1 = A favor, 2 = Abstenido, 3 = En Contra

  @override
  Widget build(BuildContext context) {
    //Used for total height and width of the screen
    Size size = MediaQuery.of(context).size;
    //Used for the radio button values

    print("First Vote Value: $voteValue ");

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
                SizedBox(height: size.height * 0.02),

                //Motion Prompt
                //
                //Goes Here
                //
                //End prompt

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
                  value: 1,
                  groupValue: voteValue,
                  onChanged: (value) {
                    setState(() {
                      voteValue = value;
                      print("voteValue: $voteValue");
                      print("value: $value");
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
                      print("value: $value ");
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
                  value: 3,
                  groupValue: voteValue,
                  onChanged: (value) {
                    setState(() {
                      voteValue = value;
                      print("Vote Value: $voteValue selected");
                      print("value: $value ");
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
                          if (voteValue == 1) {
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
                          else if (voteValue == 3) {
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
                          } // end if
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
                          } // end else if
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
