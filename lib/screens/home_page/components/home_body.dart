import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:scan_n_vote/components/round_button.dart';
import 'package:scan_n_vote/components/backdrop.dart';
import 'package:scan_n_vote/screens/agenda/agenda_screen.dart';
import 'package:scan_n_vote/screens/assemblies/assemblies_screen.dart';
import 'package:scan_n_vote/screens/initial/initial_screen.dart';
import 'package:scan_n_vote/screens/motions/motions_screen.dart';
import 'package:scan_n_vote/screens/quorum/quorum_screen.dart';

class HomeBody extends StatelessWidget {
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
                  return AssembliesScreen();
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
                    "Welcome Students",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 36,
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
                    text: "Assembly's Agenda",
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
                    text: "View Motions",
                    color: Colors.deepPurple,
                    textColor: Colors.white,
                    press: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return MotionsScreen();
                          },
                        ),
                      );
                    },
                  ),
                  RoundButton(
                    text: "Quorum Count",
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
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => new AlertDialog(
                                title: Text("Logout"),
                                content:
                                    Text('Are you sure you want to logout? \n'),
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
                                              //enviar logout a backend
                                              ////
                                              ///
                                              return InitialScreen();
                                            },
                                          ),
                                        );
                                      },
                                      child: Text("Yes"))
                                ],
                              ),
                            ),
                          );
                        },
                        child: Text(
                          "Logout",
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
