import 'package:flutter/material.dart';
import 'package:scan_n_vote/components/round_button.dart';
import 'package:scan_n_vote/components/text_field_container.dart';
import 'package:scan_n_vote/constants.dart';
import 'package:scan_n_vote/components/backdrop.dart';
import 'package:scan_n_vote/repositories/user_repository.dart';
import 'package:scan_n_vote/screens/login/login_screen.dart';

class SignUpBody extends StatefulWidget {
  final UserRepository userRepository;
  SignUpBody({Key key, @required this.userRepository})
      : assert(userRepository != null),
        super(key: key);

  @override
  _SignUpBodyState createState() => _SignUpBodyState(userRepository);
}

class _SignUpBodyState extends State<SignUpBody> {
  final UserRepository userRepository;
  _SignUpBodyState(this.userRepository);

  var _formkey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _studentNumberController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  // Used to test that values in each field are being saved
  String username = '';
  String studentNumber = '';
  String password = '';
  String passwordConfirmation = '';

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
                SizedBox(
                  height: size.height * 0.08,
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
                        child: buildUsername(),
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
                      _formkey.currentState.save(); //Executing onSaved

                      // Testing if information is being stored when sign up
                      // button is pressed.
                      final message = 'Username: $username\n' +
                          'Student Number: $studentNumber\n' +
                          'Password: $password\n' +
                          'Confirm Password: $passwordConfirmation';
                      final snackBar = SnackBar(
                        content: Text(
                          message,
                          style: TextStyle(
                            fontSize: 20,
                          ),
                        ),
                        backgroundColor: Colors.green,
                      );
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
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
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => new LoginScreen(
                              userRepository: userRepository,
                            ),
                          ),
                        );
                      },
                      child: Text(
                        'Login',
                        style: TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: size.height * 0.05,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Custom widget that creates username field with validations
  Widget buildUsername() => TextFormField(
        decoration: InputDecoration(
          labelText: 'Username',
          //border: InputBorder.none,
          // hintText: 'Username',
        ),
        controller: _usernameController,
        validator: (value) {
          if (value.isEmpty) {
            return 'Please enter your username';
          }
          if (value.contains(new RegExp(r'[~!#$%^&*(),/?":;{}|<>=]'))) {
            return 'Invalid Special Character: Acceptable: @/./_/-/+';
          }
          if (value.length < 6) {
            return 'Enter at least 6 characters';
          } else {
            return null;
          }
        },
        maxLength: 25,
        //Testing: save values in username field
        onSaved: (value) => setState(() => username = value),
      );

  // Custom widget that creates student number field with validations
  Widget buildStudentNumber() => TextFormField(
        decoration: InputDecoration(
          labelText: 'Student Number',
          // icon: Icon(
          //   Icons.badge,
          //   color: Colors.blueGrey,
          // ),
          // border: InputBorder.none,
        ),
        controller: _studentNumberController,
        validator: (value) {
          String pattern = r'[0-9]';
          RegExp regExp = new RegExp(pattern);
          if (value.isEmpty) {
            return 'Please enter your student number';
          }
          if (!regExp.hasMatch(value)) {
            return 'Must be only digits. Format: xxxxxxxxx';
          }
          if (value.contains(new RegExp(r'[a-z]'))) {
            return 'Must be only digits. Format: xxxxxxxxx';
          }
          if (value.contains(new RegExp(r'[A-Z]'))) {
            return 'Must be only digits. Format: xxxxxxxxx';
          }
          if (value.contains(new RegExp(r'[!@#$%^&*()_+,./?":;{}|<>=-]'))) {
            return 'Must be only digits. Format: xxxxxxxxx';
          }
          if (value.length < 9 || value.length > 9) {
            return 'Invalid: Must enter 9 digits. Format: xxxxxxxxx';
          } else {
            return null;
          }
        },
        keyboardType: TextInputType.number,
        //Testing: save values in student number field
        onSaved: (value) => setState(() => studentNumber = value),
      );

  // Custom widget that creates password field with validations
  Widget buildPassword() => TextFormField(
        decoration: InputDecoration(
          labelText: 'Password',
          //border: InputBorder.none,
        ),
        controller: _passwordController,
        validator: (value) {
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
          if (!value.contains(new RegExp(r'[~!@#$%^&*()_+,./?":;{}|<>=-]'))) {
            return 'Must contain at least one special character';
          }
          if (value.length < 8 || value.length > 16) {
            return 'Must be between 8 to 16 characters long';
          } else {
            return null;
          }
        },
        keyboardType: TextInputType.visiblePassword,
        obscureText: true,
        //Testing: save values in password field
        onSaved: (value) => setState(() => password = value),
      );

  //Custom widget used to create password confirmation that compares with password
  Widget buildPasswordConfirmation() => TextFormField(
        decoration: InputDecoration(
          labelText: 'Confirm Password',
        ),
        controller: _confirmPasswordController,
        validator: (value) {
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
          if (!value.contains(new RegExp(r'[~!@#$%^&*()_+,./?":;{}|<>=-]'))) {
            return 'Must contain at least one special character';
          }
          if (value.length < 8 || value.length > 16) {
            return 'Must be between 8 to 16 characters long';
          }
          if (value != _passwordController.text) {
            return 'Passwords do not match';
          } else {
            return null;
          }
        },
        keyboardType: TextInputType.visiblePassword,
        obscureText: true,
        //Testing: save values in confirm password field
        onSaved: (value) => setState(() => passwordConfirmation = value),
      );
}
