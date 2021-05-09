import 'dart:convert';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scan_n_vote/bloc/authentication_bloc/authentication_bloc.dart';
import 'package:scan_n_vote/bloc/authentication_bloc/authentication_state.dart';
import 'package:scan_n_vote/components/backdrop.dart';
import 'package:scan_n_vote/components/round_button.dart';
import 'package:scan_n_vote/models/motions_model.dart';
import 'package:scan_n_vote/models/voting_model.dart';
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

  int currentMotionPK;

  VotingModel _vote;

  VotingBodyState(this.userRepository);

  //Used for the radio button values
  int voteValue; //0 = A favor, 1 = En Contra, 2 = Abstenido

  List<Motions> motion = const [];

  // ignore: missing_return
  Future<VotingModel> addVote(String choice, int currentMotionPK) async {
    //////////////////////////////////////
    BlocBuilder<AuthenticationBloc, AuthenticationState>(
        builder: (context, state) {
      // If current state is authenticated, then display Assemblies screen
      if (state is AuthenticationAuthenticated) {
        print("IM LOGGED IN");
      }
      // If current state is unauthenticated, then display Initial screen
      if (state is AuthenticationUnauthenticated) {
        print("IM LOGGED OUT");
      }
    });
    ///////////////////////////////////////

    Uri url = Uri.parse //('https://reqres.in/api/users');
        ("https://scannvote.herokuapp.com/api/motions/" +
            currentMotionPK.toString() +
            "/vote");

    print("**** $choice *******");
    print("**** $currentMotionPK");

    final response = await http.post(url, body: {"choice": choice});

    print(response.statusCode);
    print(response.body);

    if (response.statusCode == 200) {
      final String responseString = response.body;
      print("SUCCESS!!!!!!!!!!!!!!!!");
      return votingModelFromJson(responseString);
    }
  }

  Future loadMotion() async {
    // Reading from a remote server/file
    Uri url =
        Uri.parse('https://scannvote.herokuapp.com/api/motions/?format=json');
    // 'https://run.mocky.io/v3/a58c1b7a-b688-4d22-8dec-6009a840b1f4');
    http.Response response = await http.get(url);
    String content = response.body;
    // End reading from a remote server/file

    List collection = json.decode(content);
    List<Motions> _motions =
        collection.map((json) => Motions.fromJson(json)).toList();
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
                    fontStyle: FontStyle.italic,
                    fontSize: 42,
                  ),
                ),
                Text(
                  "Por favor seleccione su voto para la siguiente moción:",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),

                //Motion Prompt
                ListView.builder(
                  itemCount: motion.length,
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  // ignore: missing_return
                  itemBuilder: (BuildContext context, int index) {
                    Motions theMotion = motion[index];

                    if (theMotion.archived == false) {
                      currentMotionPK = theMotion.pk;
                      return SingleChildScrollView(
                        child: Column(
                          //mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              color: Colors.white,
                              alignment: Alignment.center,
                              height: 100,
                              width: 375,
                              child: SingleChildScrollView(
                                child: Text(
                                  theMotion.motion, //displays the motion text
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 30,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }
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
                    "Abstenidx",
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
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
                      showDialog(
                          context: context,
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
                                        final VotingModel vote = await addVote(
                                            choice, currentMotionPK);

                                        setState(() {
                                          _vote = vote;
                                        });

                                        if (_vote == null) {
                                          print("no user");
                                        } else {
                                          print(
                                              "Therefore user voted for: ${_vote.choice}\n");
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
                                    'Are you sure you want to vote "Abstenidx" to the current motion?'),
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
                          }); // end showDialog builder
                    }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
