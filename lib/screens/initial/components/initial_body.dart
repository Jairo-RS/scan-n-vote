import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:scan_n_vote/components/round_button.dart';
import 'package:scan_n_vote/components/backdrop.dart';
import 'package:scan_n_vote/screens/login/login_screen.dart';
import 'package:scan_n_vote/screens/signup/signup_screen.dart';

class InitialBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //Used for total height and width of the screen
    Size size = MediaQuery.of(context).size;

    return SafeArea(
      child: Backdrop(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                "Scan-N-Vote",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 36,
                ),
              ),
              SizedBox(
                height: size.height * 0.02,
              ),
              SvgPicture.asset(
                "assets/icons/AcceltraProject-logo.svg",
                height: size.height * 0.28,
              ),
              SizedBox(height: size.height * 0.02),
              Text(
                "Welcome!",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 26),
              ),
              SizedBox(height: size.height * 0.02),
              Text(
                "Please login or sign up to\n  continue using the app",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              SizedBox(height: size.height * 0.02),
              RoundButton(
                text: "LOGIN",
                press: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return LoginScreen();
                      },
                    ),
                  );
                },
              ),
              RoundButton(
                text: "SIGN UP",
                color: Color(0xFFFFABF3F3),
                textColor: Colors.black,
                press: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return SignUpScreen();
                      },
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
