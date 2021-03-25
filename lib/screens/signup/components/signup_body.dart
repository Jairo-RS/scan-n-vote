import 'package:flutter/material.dart';
import 'package:scan_n_vote/components/round_button.dart';
import 'package:scan_n_vote/components/text_field_container.dart';
import 'package:scan_n_vote/constants.dart';
import 'package:scan_n_vote/components/backdrop.dart';
import 'package:scan_n_vote/screens/login/login_screen.dart';

class SignUpBody extends StatelessWidget {
  var _formkey = GlobalKey<FormState>();
//  TextEditingController _studentNumberController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    //Used for total height and width of the screen
    Size size = MediaQuery.of(context).size;
    return Backdrop(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              height: size.height * 0.05,
            ),
            Text(
              'Sign up',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 40,
              ),
            ),
            SizedBox(
              height: size.height * 0.05,
            ),
            Form(
              key: _formkey,
              autovalidateMode: AutovalidateMode.always,
              child: Column(
                children: [
                  TextFieldContainer(
                    child: buildFullName(),
                  ),
                  SizedBox(
                    height: size.height * 0.01,
                  ),
                  TextFieldContainer(
                    child: buildMajor(),
                  ),
                  SizedBox(
                    height: size.height * 0.01,
                  ),
                  TextFieldContainer(
                    child: buildStudentNumber(),
                  ),
                  SizedBox(
                    height: size.height * 0.01,
                  ),
                  TextFieldContainer(
                    child: buildUsername(),
                  ),
                  SizedBox(
                    height: size.height * 0.01,
                  ),
                  TextFieldContainer(
                    child: buildPassword(),
                  ),
                  SizedBox(
                    height: size.height * 0.01,
                  ),
                  TextFieldContainer(
                    child: buildPasswordConfirmation(),
                  ),
                  SizedBox(
                    height: size.height * 0.01,
                  ),
                ],
              ),
            ),
            SizedBox(
              height: size.height * 0.03,
            ),
            RoundButton(
              text: "SIGN UP",
              color: signButtonColor,
              textColor: Colors.black,
              press: () {
                final isValid = _formkey.currentState.validate();
                if (isValid) {
                  _formkey.currentState.save();
                }
              },
            ),
            SizedBox(
              height: size.height * 0.02,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  'Already have an account? ',
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => new LoginScreen(),
                      ),
                    );
                  },
                  child: Text(
                    'Login',
                    style: TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget buildFullName() => TextFormField(
        decoration: InputDecoration(
          labelText: 'Full Name',
          // icon: Icon(
          //   Icons.person,
          //   color: Colors.blueGrey,
          // ),
          // suffixIcon: Icon(
          //   Icons.person_rounded,
          //   color: Colors.blueGrey,
          // ),
          // border: InputBorder.none,
        ),
        validator: (value) {
          String pattern = r'^[a-z A-Z,.\-]+$';
          RegExp regExp = new RegExp(pattern);
          if (value.length == 0) {
            return 'Please enter your full name';
          } else if (!regExp.hasMatch(value)) {
            return 'Please enter a valid full name';
          } else {
            return null;
          }
        },
        keyboardType: TextInputType.name,
      );

  Widget buildMajor() => TextFormField(
        decoration: InputDecoration(
          labelText: 'Major (Initials)',
          // border: InputBorder.none,
        ),
        validator: (value) {
          String pattern = r'[A-Z]';
          RegExp regExp = new RegExp(pattern);
          if (value.isEmpty) {
            return "Please enter your major's initials";
          }
          if (!regExp.hasMatch(value)) {
            return 'Must be all uppercase characters';
          }
          if (value.length < 4 || value.length > 4) {
            return 'Initials should only be 4 characters';
          } else {
            return null;
          }
        },
      );

  Widget buildStudentNumber() => TextFormField(
        decoration: InputDecoration(
          labelText: 'Student Number',
          // icon: Icon(
          //   Icons.badge,
          //   color: Colors.blueGrey,
          // ),
          // border: InputBorder.none,
        ),
        validator: (value) {
          //Need to make special characters and letters not valid
          String pattern = r'[0-9]';
          RegExp regExp = new RegExp(pattern);
          if (value.isEmpty) {
            return 'Please enter your student number';
          }
          if (!regExp.hasMatch(value)) {
            return 'Must be only digits';
          }
          if (value.contains(new RegExp(r'[a-z]'))) {
            return 'Must be only digits';
          }
          if (value.contains(new RegExp(r'[A-Z]'))) {
            return 'Must be only digits';
          }
          if (value.contains(new RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
            return 'Must be only digits';
          }
          if (value.length < 9 || value.length > 9) {
            return 'Invalid: Must enter 9 digits';
          } else {
            return null;
          }
        },
        keyboardType: TextInputType.number,
      );

  Widget buildUsername() => TextFormField(
        decoration: InputDecoration(
          labelText: 'Username',
          //border: InputBorder.none,
          // hintText: 'Username',
        ),
        validator: (value) {
          if (value.isEmpty) {
            return 'Please enter your username';
          }
          if (value.contains(new RegExp(r'[!#$%^&*(),?":{}|<>]'))) {
            return 'Invalid Special Character: Acceptable: @/./_/-/+';
          }
          if (value.length < 6) {
            return 'Enter at least 6 characters';
          } else {
            return null;
          }
        },
        // maxLength: 30,
      );

  Widget buildPassword() => TextFormField(
        decoration: InputDecoration(
          labelText: 'Password',
          //border: InputBorder.none,
        ),
        validator: (value) {
          // Pattern pattern =
          //     r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$';
          // RegExp regex = new RegExp(pattern);
          if (value.isEmpty) {
            return 'Please enter a password';
          }
          if (!value.contains(new RegExp(r'[a-z]'))) {
            return 'Must contain at least one lowercase character';
          }
          if (!value.contains(new RegExp(r'[A-Z]'))) {
            return 'Must contain at least one uppercase character';
          }
          if (!value.contains(new RegExp(r'(?=.*[0-9])'))) {
            return 'Must contain at least one digit';
          }
          if (!value.contains(new RegExp(r'[!@#$%^&*()-_+,.?":{}|<>]'))) {
            return 'Must contain at least one special character';
          }
          if (value.length < 8 || value.length > 16) {
            return 'Must be between 8 to 16 characters long';
          } else {
            return null;
            // if (!regex.hasMatch(value)) {
            //   return 'Enter valid password';
            // } else {
            // }
          }
        },
        keyboardType: TextInputType.visiblePassword,
        obscureText: true,
      );

  //Need to make password confirmation compare to password
  Widget buildPasswordConfirmation() => TextFormField(
        decoration: InputDecoration(
          labelText: 'Password Confirmation',
          //border: InputBorder.none,
        ),
        validator: (value) {
          // Pattern pattern =
          //     r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$';
          // RegExp regex = new RegExp(pattern);
          if (value.isEmpty) {
            return 'Please enter a password';
          }
          if (!value.contains(new RegExp(r'[a-z]'))) {
            return 'Must contain at least one lowercase character';
          }
          if (!value.contains(new RegExp(r'[A-Z]'))) {
            return 'Must contain at least one uppercase character';
          }
          if (!value.contains(new RegExp(r'(?=.*[0-9])'))) {
            return 'Must contain at least one digit';
          }
          if (!value.contains(new RegExp(r'[!@#$%^&*()-_+,.?":{}|<>]'))) {
            return 'Must contain at least one special character';
          }
          if (value.length < 8 || value.length > 16) {
            return 'Must be between 8 to 16 characters long';
          } else {
            return null;
            // if (!regex.hasMatch(value)) {
            //   return 'Enter valid password';
            // } else {
            // }
          }
        },
        keyboardType: TextInputType.visiblePassword,
        obscureText: true,
      );
}
