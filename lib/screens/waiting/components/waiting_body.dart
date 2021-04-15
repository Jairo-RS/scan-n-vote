import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:scan_n_vote/components/backdrop.dart';
import 'package:scan_n_vote/components/round_button.dart';
import 'package:scan_n_vote/screens/motions/motions_screen.dart';

class WaitingBody extends StatelessWidget {
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
              'Your vote has been cast',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 30,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: size.height * 0.05,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 25, right: 25),
              child: Text(
                'Thanks for voting!\n\n'
                'Please wait while others \nfinish casting their votes.\n \n'
                'Voting results will be \nposted shortly.\n',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ),
            SizedBox(
              height: size.height * 0.05,
            ),
            SvgPicture.asset(
              "assets/icons/undraw_voting.svg",
              height: size.height * 0.15,
            ),
            RoundButton(
              text: "Back to Motions",
              color: Colors.black87,
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
          ],
        ),
      ),
    );
  }
}
