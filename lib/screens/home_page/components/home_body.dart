import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:scan_n_vote/bloc/authentication_bloc/authentication_bloc.dart';
import 'package:scan_n_vote/bloc/authentication_bloc/authentication_event.dart';
import 'package:scan_n_vote/components/round_button.dart';
import 'package:scan_n_vote/components/backdrop.dart';
import 'package:scan_n_vote/models/assemblies_model.dart';
import 'package:scan_n_vote/repositories/user_repository.dart';
import 'package:scan_n_vote/screens/agenda/agenda_screen.dart';
import 'package:scan_n_vote/screens/assemblies/assemblies_screen.dart';
import 'package:scan_n_vote/screens/initial/initial_screen.dart';
import 'package:scan_n_vote/screens/motions/motions_screen.dart';
import 'package:scan_n_vote/screens/quorum/quorum_screen.dart';
import 'package:http/http.dart' as http;

class HomeBody extends StatefulWidget {
  final UserRepository userRepository;
  final Assemblies currentAssembly;

  HomeBody(
      {Key key, @required this.userRepository, @required this.currentAssembly})
      : super(key: key);

  @override
  _HomeBodyState createState() =>
      _HomeBodyState(this.userRepository, this.currentAssembly);
}

class _HomeBodyState extends State<HomeBody> {
  // ignore: unused_field
  Future<String> _logoutFuture;

  final UserRepository userRepository;
  final Assemblies currentAssembly;

  _HomeBodyState(this.userRepository, this.currentAssembly);

  var logoutUrl = "https://scannvote.herokuapp.com/api/logout/";

  //Used to store information about login functionality
  final FlutterSecureStorage storage = new FlutterSecureStorage();

  // Logout token POST request
  Future<String> logout(String csrftoken) async {
    String csrftoken = await storage.read(key: 'set-cookie');
    final response = await http.post(
      logoutUrl,
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode(<String, String>{
        "csrfmiddlewaretoken": csrftoken,
      }),
    );

    if (response.statusCode == 200) {
      return response.body;
    } else {
      // If not successful, display error status code (403)
      throw Exception(response.statusCode);
    }
  }

  @override
  Widget build(BuildContext context) {
    //Used for total height and width of the screen
    Size size = MediaQuery.of(context).size;

    return SafeArea(
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Colors.black,
            ),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) {
                  return AssembliesScreen(
                    userRepository: userRepository,
                  );
                },
              ),
            ),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
          iconTheme: IconThemeData(color: Colors.black),
        ),
        body: Backdrop(
          child: Backdrop(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    "??Bienvenidos Estudiantes!",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 32,
                    ),
                  ),
                  SizedBox(
                    height: size.height * 0.02,
                  ),
                  SvgPicture.asset(
                    "assets/icons/undraw_education.svg",
                    height: size.height * 0.20,
                  ),
                  SizedBox(height: size.height * 0.02),
                  RoundButton(
                    text: "Agenda",
                    color: Colors.green,
                    textColor: Colors.white,
                    press: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return AgendaScreen();
                          },
                        ),
                      );
                    },
                  ),
                  RoundButton(
                    text: "Mociones",
                    color: Colors.deepPurple,
                    textColor: Colors.white,
                    press: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return MotionsScreen(
                              userRepository: userRepository,
                              currentAssembly: currentAssembly,
                            );
                          },
                        ),
                      );
                    },
                  ),
                  RoundButton(
                    text: "Qu??rum",
                    color: Colors.purple,
                    textColor: Colors.white,
                    press: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return QuorumScreen();
                          },
                        ),
                      );
                    },
                  ),
                  SizedBox(
                    height: size.height * 0.04,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      GestureDetector(
                        onTap: () {
                          showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: Text("Terminar Sesi??n"),
                                  content: Text(
                                      '??Desea desconectarse de su cuenta? \n'),
                                  actions: [
                                    TextButton(
                                        //No Button
                                        onPressed: () => Navigator.pop(
                                            context), //return to voting screen
                                        child: Text("No")),
                                    TextButton(
                                        //Yes Button
                                        onPressed: () async {
                                          String csrftoken = await storage.read(
                                              key: "set-cookie");

                                          BlocProvider.of<AuthenticationBloc>(
                                                  context)
                                              .add(LoggedOut());

                                          setState(() {
                                            _logoutFuture = logout(csrftoken);
                                          });

                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) {
                                                //enviar logout a backend
                                                BlocProvider.of<
                                                            AuthenticationBloc>(
                                                        context)
                                                    .add(LoggedOut());
                                                return InitialScreen(
                                                  userRepository:
                                                      userRepository,
                                                );
                                              },
                                            ),
                                          );
                                        },
                                        child: Text("Si"))
                                  ],
                                );
                              });
                        },
                        child: Text(
                          "Desconectarse",
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.blue,
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
