import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:scan_n_vote/components/backdrop.dart';
import 'package:scan_n_vote/components/round_button.dart';
import 'package:scan_n_vote/models/voting_model.dart';
import 'package:scan_n_vote/models/voting_model_test.dart';
import 'package:scan_n_vote/models/voting_motions.dart';
import 'package:scan_n_vote/repositories/user_repository.dart';
import 'package:scan_n_vote/screens/waiting/waiting_screen.dart';
import 'package:http/http.dart' as http;

class VotingBody extends StatefulWidget {
  final UserRepository userRepository;
  VotingBody({Key key, @required this.userRepository})
      : assert(userRepository != null),
        super(key: key);
  @override
  VotingBodyState createState() => VotingBodyState(this.userRepository);
}

class VotingBodyState extends State<VotingBody> {
  final UserRepository userRepository;

  VotingModelTest _vote;

  VotingBodyState(this.userRepository);

  //Used for the radio button values
  int voteValue; //0 = A favor, 1 = En Contra, 2 = Abstenido

  List<VotingMotions> motion = const [];

  Future<VotingModelTest> addVote(String choice, String choiceDesc) async {
    Uri url = Uri.parse('https://reqres.in/api/users');

    final response =
        await http.post(url, body: {"name": choice, "job": choiceDesc});

    if (response.statusCode == 201) {
      final String responseString = response.body;

      return votingModelTestFromJson(responseString);
    } else
      return null;
  }

  Future loadMotion() async {
    // Reading from local JSON file
    //  String content =
    //     await rootBundle.loadString('assets/json/current_voting_motion.json');
    //  End Reading from local JSON file

    // Reading from a remote server/file
    Uri url = Uri.parse(
        'https://run.mocky.io/v3/a58c1b7a-b688-4d22-8dec-6009a840b1f4');
    http.Response response = await http.get(url);
    String content = response.body;
    // End reading from a remote server/file

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
                  subtitle: Text("In Favor",
                      style:
                          TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
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
                                    onPressed: () async {
                                      final String choice = "0";
                                      final String choiceDesc = "voto a favor";

                                      final VotingModelTest vote =
                                          await addVote(choice, choiceDesc);

                                      setState(() {
                                        _vote = vote;
                                      });

                                      if (_vote == null) {
                                        print("no user");
                                      } else {
                                        print(
                                            "The voter selected: ${_vote.name}\n");
                                        print(
                                            "Therefore user voted for: ${_vote.job}\n");
                                        print(
                                            "Created at time: ${_vote.createdAt.toIso8601String()}");
                                      }

                                      //go to next screen
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) {
                                            return WaitingScreen(
                                              userRepository: userRepository,
                                            );
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
                                            return WaitingScreen(
                                              userRepository: userRepository,
                                            );
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
                                            return WaitingScreen(
                                              userRepository: userRepository,
                                            );
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
