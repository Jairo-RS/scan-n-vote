import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:scan_n_vote/components/round_button.dart';
import 'package:scan_n_vote/components/backdrop.dart';
import 'package:scan_n_vote/screens/agenda/agenda_screen.dart';
import 'package:scan_n_vote/screens/motions/motions_screen.dart';
import 'package:scan_n_vote/screens/quorum/quorum_screen.dart';

class HomeBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //Used for total height and width of the screen
    Size size = MediaQuery.of(context).size;

    return SafeArea(
      child: Backdrop(
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
              height: size.height * 0.28,
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
          ],
        ),
      ),
    );
  }
}
