import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:scan_n_vote/components/round_button.dart';
import 'package:scan_n_vote/components/backdrop.dart';
import 'package:scan_n_vote/repositories/user_repository.dart';
import 'package:scan_n_vote/screens/login/login_screen.dart';
import 'package:scan_n_vote/screens/signup/signup_screen.dart';

//Class that builds all the widgets that will be displayed in the initial
//screen.
class InitialBody extends StatefulWidget {
  final UserRepository userRepository;
  InitialBody({Key key, @required this.userRepository})
      : assert(userRepository != null),
        super(key: key);

  @override
  _InitialBodyState createState() => _InitialBodyState(userRepository);
}

class _InitialBodyState extends State<InitialBody> {
  final UserRepository userRepository;
  _InitialBodyState(this.userRepository);

  //This method (widget) is used to ask the user if they want to exit the
  //application when they press the back button on their phone.
  Future<bool> _onBackPressed() {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          "Do you really want to exit the app?",
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(
              "No",
              style: TextStyle(
                fontSize: 16,
              ),
            ),
          ),
          TextButton(
            onPressed: () => SystemNavigator.pop(),
            // Navigator.pop(context, true),
            child: Text(
              "Yes",
              style: TextStyle(
                fontSize: 16,
              ),
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    //Used for total height and width of the screen
    Size size = MediaQuery.of(context).size;

    //Widget that provides specific functionality to Android back button
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: SafeArea(
        child: Backdrop(
          //Provides scrollable functionality to screen
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
                //Displays image (team logo) stored in assets folder
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
                          return LoginScreen(userRepository: userRepository);
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
                          return SignUpScreen(userRepository: userRepository);
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
