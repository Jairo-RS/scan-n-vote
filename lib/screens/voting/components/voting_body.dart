import 'dart:convert';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:scan_n_vote/bloc/authentication_bloc/authentication_bloc.dart';
import 'package:scan_n_vote/bloc/authentication_bloc/authentication_event.dart';
import 'package:scan_n_vote/bloc/authentication_bloc/authentication_state.dart';
import 'package:scan_n_vote/components/backdrop.dart';
import 'package:scan_n_vote/components/round_button.dart';
import 'package:scan_n_vote/models/assemblies_model.dart';
import 'package:scan_n_vote/models/motions_model.dart';
import 'package:scan_n_vote/models/token_model.dart';
import 'package:scan_n_vote/models/voting_model.dart';
import 'package:scan_n_vote/repositories/user_repository.dart';
import 'package:scan_n_vote/screens/motions/motions_screen.dart';
import 'package:scan_n_vote/screens/voting/voting_screen.dart';
import 'package:scan_n_vote/screens/waiting/waiting_screen.dart';
import 'package:http/http.dart' as http;

class VotingBody extends StatefulWidget {
  final UserRepository userRepository;
  final Assemblies currentAssembly;
  VotingBody(
      {Key key, @required this.userRepository, @required this.currentAssembly})
      : assert(userRepository != null),
        super(key: key);
  @override
  VotingBodyState createState() =>
      VotingBodyState(this.userRepository, this.currentAssembly);
}

class VotingBodyState extends State<VotingBody> {
  final Assemblies currentAssembly;
  final UserRepository userRepository;

  //Used to store information about login functionality
  final FlutterSecureStorage storage = new FlutterSecureStorage();

  //used to determine which is the current assembly
  int currentMotionPK;

  // ignore: unused_field
  String _vote;

  VotingBodyState(this.userRepository, this.currentAssembly);

  //Used for the radio button values
  int voteValue; //0 = A favor, 1 = En Contra, 2 = Abstenido

  List<Motions> motion = const [];

  Future loadMotion() async {
    // Reading from a remote server/file
    Uri url =
        Uri.parse('https://scannvote.herokuapp.com/api/motions/?format=json');
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
    //used for testing purposes
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
                    text: "Votar",
                    color: Colors.black87,
                    press: () {
                      showDialog(
                          context: context,
                          builder: (context) {
                            if (voteValue == 0) {
                              return AlertDialog(
                                title: Text("Confirme su voto"),
                                content: Text(
                                    '¿Desea confirmar voto "A Favor" a la moción actual?'),
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

                                        final String vote = await addVote(
                                            choice, currentMotionPK);

                                        setState(() {
                                          _vote = vote;
                                        });
                                      },
                                      child: Text("Si"))
                                ],
                              );
                            } // end if
                            else if (voteValue == 2) {
                              return AlertDialog(
                                title: Text("Confirme su voto"),
                                content: Text(
                                    '¿Desea confirmar voto "Abtenidx" a la moción actual?'),
                                actions: [
                                  TextButton(
                                      //No Button
                                      onPressed: () => Navigator.pop(
                                          context), //return to voting screen
                                      child: Text("No")),
                                  TextButton(
                                      //Yes Button
                                      onPressed: () async {
                                        final String choice = "2";

                                        final String vote = await addVote(
                                            choice, currentMotionPK);

                                        setState(() {
                                          _vote = vote;
                                        });
                                      },
                                      child: Text("Si"))
                                ],
                              );
                            } // end else if
                            else if (voteValue == 1) {
                              return AlertDialog(
                                title: Text("Confirmar su voto"),
                                content: Text(
                                    '¿Desea confirmar voto "En Contra" a la moción actual?'),
                                actions: [
                                  TextButton(
                                      //No Button
                                      onPressed: () => Navigator.pop(
                                          context), //return to voting screen
                                      child: Text("No")),
                                  TextButton(
                                      //Yes Button
                                      onPressed: () async {
                                        final String choice = "1";

                                        final String vote = await addVote(
                                            choice, currentMotionPK);

                                        setState(() {
                                          _vote = vote;
                                        });
                                      },
                                      child: Text("Si"))
                                ],
                              );
                            } // end else if
                            else {
                              return AlertDialog(
                                title: Text("Error"),
                                content: Text(
                                    'No seleccionó ningun voto.\nFavor escoger una opción antes de votar.'),
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

  // ignore: missing_return
  Future<String> addVote(String choice, int currentMotionPK) async {
    String csrftoken = await storage.read(key: 'set-cookie');
    String user = await storage.read(key: 'user');

    //print("Storage token = " + csrftoken);

    Uri url = Uri.parse("https://scannvote.herokuapp.com/api/motions/" +
        currentMotionPK.toString() +
        "/vote");

    print("**** $choice *******"); //check voter's choice
    print("**** $currentMotionPK"); //check if on current motion

    //http.post
    final response = await http.post(url,
        headers: <String, String>{
          "Content-Type": "application/json",
        },
        body: jsonEncode(
          <String, String>{
            "choice": choice,
            "csrfmiddlewaretoken": csrftoken,
            "username": user,
          },
        ));

    //for testing
    // print("HTTP Response Status Code = " + response.statusCode.toString());
    // print(response.body);

    // initialize variables to decode code in case of an error in http response
    String str, theCode;
    int statusCode;

    if (response.statusCode != 200) {
      str = response.body;
      statusCode = response.statusCode;

      const start = '"code":"';
      const end = '"}';

      final startIndex = str.indexOf(start);
      final endIndex = str.indexOf(end, startIndex + start.length);

      theCode = str.substring(startIndex + start.length, endIndex);
      //for testing
      // print("theCode = " + theCode);
    } else {
      //for testing
      // print("Status code = 200");
    }

    //se logro votar correctamente
    if (response.statusCode == 200) {
      //go to next screen
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) {
            return WaitingScreen(
              userRepository: userRepository,
              currentAssembly: currentAssembly,
            );
          },
        ),
      );
      final String responseString = response.body;

      print("SUCCESS!!!!!!!!!!!!!!!!");

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) {
            return WaitingScreen(
              userRepository: userRepository,
              currentAssembly: currentAssembly,
            );
          },
        ),
      ); //return to voting screen

      return responseString;
    }
    //usuario not logged in
    else if (statusCode == 403 && int.parse(theCode) == 5) {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text("Error! Voto NO contado!"),
              content: Text(
                  'Usuario no ha sido inicializado.\nFavor iniciar sesión con su cuenta.\n'),
              actions: [
                TextButton(
                    //OK Button
                    onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return MotionsScreen(
                                userRepository: userRepository,
                                currentAssembly: currentAssembly,
                              );
                            },
                          ),
                        ), //return to voting screen
                    child: Text("OK")),
              ],
            );
          });
    }
    //voting unavailable
    else if (statusCode == 405 && int.parse(theCode) == 0) {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text("Error! Voto NO contado!"),
              content: Text(
                  'Todavía no está disponible votar.\nVuelva a intentar pronto.\n'),
              actions: [
                TextButton(
                    //OK Button
                    onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return MotionsScreen(
                                userRepository: userRepository,
                                currentAssembly: currentAssembly,
                              );
                            },
                          ),
                        ), //return to voting screen
                    child: Text("OK")),
              ],
            );
          });
    }
    //usuario no presente en asamblea
    else if (statusCode == 403 && int.parse(theCode) == 1) {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text("Error! Voto NO contado!"),
              content: Text(
                  'Su usuario no está marcado como presente en la asamblea.\n'),
              actions: [
                TextButton(
                    //OK Button
                    onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return MotionsScreen(
                                userRepository: userRepository,
                                currentAssembly: currentAssembly,
                              );
                            },
                          ),
                        ), //return to voting screen
                    child: Text("OK")),
              ],
            );
          });
    }
    //usuario no selecciono voto
    else if (statusCode == 400 && int.parse(theCode) == 2) {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text("Error! Voto NO contado!"),
              content: Text('Al votar, usted no tomó ninguna selección.\n'),
              actions: [
                TextButton(
                    //OK Button
                    onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return MotionsScreen(
                                userRepository: userRepository,
                                currentAssembly: currentAssembly,
                              );
                            },
                          ),
                        ), //return to voting screen
                    child: Text("OK")),
              ],
            );
          });
    }
    //usuario ya voto a esta mocion anteriormente
    else if (statusCode == 403 && int.parse(theCode) == 3) {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text("Error! Voto NO contado!"),
              content: Text('Usted ya votó para la pasada moción.\n'),
              actions: [
                TextButton(
                    //OK Button
                    onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return MotionsScreen(
                                userRepository: userRepository,
                                currentAssembly: currentAssembly,
                              );
                            },
                          ),
                        ), //return to voting screen
                    child: Text("OK")),
              ],
            );
          });
    }
  }
}
