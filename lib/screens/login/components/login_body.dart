import 'package:flutter/material.dart';
import 'package:scan_n_vote/components/round_button.dart';
import 'package:scan_n_vote/components/text_field_container.dart';
import 'package:scan_n_vote/screens/assemblies/assemblies_screen.dart';
import 'package:scan_n_vote/screens/forgot_password/forgot_password_screen.dart';
import 'package:scan_n_vote/components/backdrop.dart';

class LoginBody extends StatelessWidget {
  var _formkey = GlobalKey<FormState>();
  String username = '';
//  TextEditingController _userNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    //Used for total height and width of the screen
    Size size = MediaQuery.of(context).size;

    return Backdrop(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "Login",
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
                    child: Stack(
                      children: [
                        buildUsername(),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: size.height * 0.01,
                  ),
                  TextFieldContainer(
                    child: Stack(
                      children: [
                        buildPassword(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: size.height * 0.05,
            ),
            RoundButton(
              text: "LOGIN",
              press: () {
                final isValid = _formkey.currentState.validate();
                if (isValid) {
                  _formkey.currentState.save();
                }
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return AssembliesScreen();
                    },
                  ),
                );
              },
            ),
            SizedBox(
              height: size.height * 0.02,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => new ForgotPasswordScreen(),
                      ),
                    );
                  },
                  child: Text(
                    "Forgot your password?",
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

  Widget buildUsername() => TextFormField(
        decoration: InputDecoration(
          labelText: 'Username',
          //border: InputBorder.none,
          //hintText: "Username",
        ),
        validator: (value) {
          if (value.isEmpty) {
            return 'Please enter your username';
          }
          if (value.contains(new RegExp(r'[~!#$%^&*(),/?":;{}|<>]'))) {
            return 'Invalid Special Character. Only use: ./@/_/-/+';
          }
          if (value.length < 6) {
            return 'Enter at least 6 characters';
          } else {
            return null;
          }
        },
        // maxLength: 30,
        //onSaved: (value) => setState(() => username = value),
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
          if (!value.contains(new RegExp(r'[~!@#$%^&*()_+,./?":;{}|<>-]'))) {
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
        // onSaved: (value) => setState(() => password = value),
        keyboardType: TextInputType.visiblePassword,
        obscureText: false,
      );
}
