import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:scan_n_vote/components/round_button.dart';
import 'package:scan_n_vote/components/text_field_container.dart';
import 'package:scan_n_vote/constants.dart';
import 'package:scan_n_vote/components/backdrop.dart';
import 'package:scan_n_vote/models/token_model.dart';
import 'package:scan_n_vote/models/user_model.dart';
import 'package:scan_n_vote/repositories/user_repository.dart';
import 'package:scan_n_vote/screens/initial/initial_screen.dart';
import 'package:scan_n_vote/screens/login/login_screen.dart';
import 'package:http/http.dart' as http;

// Class that contains all the widgets that will be displayed by the Sign up
// screen
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

  UserModel _user;
  TokenModel futureToken;
  bool _disposed = false;

  //Variables
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
  void initState() {
    super.initState();
    if (!_disposed) {
      TokenModel.getToken().then(
        (data) => setState(() {
          futureToken = data;
        }),
      );
    }
  }

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }

  // //display message alert
  void messageDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Tu cuenta ha sido creada exitosamente!\n"),
          actions: [
            TextButton(
              child: Text(
                "Ok",
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => InitialScreen(
                      userRepository: userRepository,
                    ),
                  ),
                );
                ;
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    //Used for total height and width of the screen
    Size size = MediaQuery.of(context).size;

    return SafeArea(
      child: Scaffold(
        extendBodyBehindAppBar: true,
        //Appbar at the top of screen
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
          //Making screen scrollable
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  height: size.height * 0.08,
                ),
                Text(
                  'Registrarte',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 40,
                  ),
                ),
                SizedBox(
                  height: size.height * 0.05,
                ),

                //Widget that creates a container for all form fields
                Form(
                  key: _formkey,
                  // autovalidateMode: AutovalidateMode.always,
                  child: Column(
                    children: [
                      TextFieldContainer(
                        child: buildUsername(), //Creates username field
                      ),
                      SizedBox(
                        height: size.height * 0.01,
                      ),
                      TextFieldContainer(
                        child:
                            buildStudentNumber(), //Creates student number field
                      ),
                      SizedBox(
                        height: size.height * 0.01,
                      ),
                      TextFieldContainer(
                        //Creates password field
                        child: buildPassword(),
                      ),
                      SizedBox(
                        height: size.height * 0.01,
                      ),
                      TextFieldContainer(
                        //Creates confirm password field
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
                //Custom widget that creates the sign up button
                RoundButton(
                  text: "Registrarte",
                  color: Colors.purple[700],
                  textColor: Colors.white,
                  press: () async {
                    final String username = _usernameController.text;
                    final String studentNumber = _studentNumberController.text;
                    final String password = _passwordController.text;
                    final String passwordConfirmation =
                        _confirmPasswordController.text;
                    // Future<String> token = UserModel.getToken();
                    // String csrfmiddlewaretoken = token.toString();
                    var csrfmiddlewaretoken =
                        futureToken.csrfmiddlewaretoken.toString();
                    //Verifying validation of all forms
                    final isValid = _formkey.currentState.validate();
                    if (isValid) {
                      final UserModel user = await UserModel.createUser(
                        username,
                        studentNumber,
                        password,
                        passwordConfirmation,
                        csrfmiddlewaretoken,
                      );
                      setState(() {
                        _user = user;
                      });
                      messageDialog(context);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            "Credenciales inválidos\n Complete el formulario correctamente.",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 18,
                            ),
                          ),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                    // //Verifying validation of all forms
                    // final isValid = _formkey.currentState.validate();
                    // if (isValid) {
                    //   final UserModel user = await UserModel.createUser(
                    //     username,
                    //     studentNumber,
                    //     password,
                    //     passwordConfirmation,
                    //     csrfmiddlewaretoken,
                    //   );
                    //   setState(() {
                    //     _user = user;
                    //   });
                    //   messageDialog(context);
                    // } else {
                    //   Flushbar(
                    //     title: "Credenciales invalidos",
                    //     message:
                    //         "Por favor, complete el formulario correctamente.",
                    //     duration: Duration(seconds: 5),
                    //   ).show(context);
                    // }

                    // final isValid = _formkey.currentState.validate();
                    // if (isValid) {
                    //   _formkey.currentState.save(); //Executing onSaved

                    // // Testing if information is being stored when sign up
                    // // button is pressed.
                    // final message = 'Username: $username\n' +
                    //     'Student Number: $studentNumber\n' +
                    //     'Password: $password\n' +
                    //     'Confirm Password: $passwordConfirmation';
                    // // For testing: displays stored valid information
                    // final snackBar = SnackBar(
                    //   content: Text(
                    //     message,
                    //     style: TextStyle(
                    //       fontSize: 20,
                    //     ),
                    //   ),
                    //   backgroundColor: Colors.green,
                    // );
                    // ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    // }
                  },
                ),
                SizedBox(
                  height: size.height * 0.02,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      '¿Ya tienes una cuenta? ',
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                    // Gives Login text functionality to transition to Login
                    // screen
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
                        'Iniciar sesión',
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
          labelText: 'Nombre de usuario (Username)',
          //border: InputBorder.none,
          // hintText: 'Username',
        ),
        controller: _usernameController,
        validator: UsernameFieldValidator.validate,
        //Commented for Testing
        // if (value.isEmpty) {
        //   return 'Please enter your username';
        // }
        // if (value.contains(new RegExp(r'[~!#$%^&*(),/?":;{}|<>=]'))) {
        //   return 'Invalid Special Character: Acceptable: @/./_/-/+';
        // }
        // if (value.length < 6) {
        //   return 'Enter at least 6 characters';
        // } else {
        //   return null;
        // }
        // },
        maxLength: 16,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        //Testing: save values in username field
        onSaved: (value) => setState(() => username = value),
      );

  // Custom widget that creates student number field with validations
  Widget buildStudentNumber() => TextFormField(
        decoration: InputDecoration(
          labelText: 'Número de estudiante',
          // icon: Icon(
          //   Icons.badge,
          //   color: Colors.blueGrey,
          // ),
          // border: InputBorder.none,
        ),
        controller: _studentNumberController,
        validator: StudentNumberFieldValidator.validate,
        // COMMENTED FOR TESTING
        // String pattern = r'[0-9]';
        // RegExp regExp = new RegExp(pattern);
        // if (value.isEmpty) {
        //   return 'Please enter your student number';
        // }
        // if (!regExp.hasMatch(value)) {
        //   return 'Must be only digits. Format: xxxxxxxxx';
        // }
        // if (value.contains(new RegExp(r'[a-z]'))) {
        //   return 'Must be only digits. Format: xxxxxxxxx';
        // }
        // if (value.contains(new RegExp(r'[A-Z]'))) {
        //   return 'Must be only digits. Format: xxxxxxxxx';
        // }
        // if (value.contains(new RegExp(r'[!@#$%^&*()_+,./?":;{}|<>=-]'))) {
        //   return 'Must be only digits. Format: xxxxxxxxx';
        // }
        // if (value.length < 9 || value.length > 9) {
        //   return 'Invalid: Must enter 9 digits. Format: xxxxxxxxx';
        // } else {
        //   return null;
        // }
        // },
        keyboardType: TextInputType.number,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        //Testing: save values in student number field
        onSaved: (value) => setState(() => studentNumber = value),
      );

  // Custom widget that creates password field with validations
  Widget buildPassword() => TextFormField(
        decoration: InputDecoration(
          labelText: 'Contraseña',
          //border: InputBorder.none,
        ),
        controller: _passwordController,
        validator: PasswordFieldValidator.validate,
        // COMMENTED FOR TESTING
        // if (value.isEmpty) {
        //   return 'Please enter a password';
        // }
        // if (!value.contains(new RegExp(r'[a-z]'))) {
        //   return 'Must contain at least one lowercase character';
        // }
        // if (!value.contains(new RegExp(r'[A-Z]'))) {
        //   return 'Must contain at least one uppercase character';
        // }
        // if (!value.contains(new RegExp(r'(?=.*[0-9])'))) {
        //   return 'Must contain at least one digit';
        // }
        // if (!value.contains(new RegExp(r'[~!@#$%^&*()_+,./?":;{}|<>=-]'))) {
        //   return 'Must contain at least one special character';
        // }
        // if (value.length < 8 || value.length > 16) {
        //   return 'Must be between 8 to 16 characters long';
        // } else {
        //   return null;
        // }
        // },
        keyboardType: TextInputType.visiblePassword,
        obscureText: true,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        //Testing: save values in password field
        onSaved: (value) => setState(() => password = value),
      );

  //Custom widget used to create password confirmation that compares with password
  Widget buildPasswordConfirmation() => TextFormField(
        decoration: InputDecoration(
          labelText: 'Confirmar contraseña',
        ),
        controller: _confirmPasswordController,
        validator: (value) {
          PasswordConfirmationFieldValidator.validate(value);
          if (value != _passwordController.text) {
            return 'Passwords do not match';
          } else {
            return null;
          }
          // COMMENTED FOR TESTING
          //   if (value.isEmpty) {
          //     return 'Please enter a password';
          //   }
          //   if (!value.contains(new RegExp(r'[a-z]'))) {
          //     return 'Must contain at least one lowercase character';
          //   }
          //   if (!value.contains(new RegExp(r'[A-Z]'))) {
          //     return 'Must contain at least one uppercase character';
          //   }
          //   if (!value.contains(new RegExp(r'(?=.*[0-9])'))) {
          //     return 'Must contain at least one digit';
          //   }
          //   if (!value.contains(new RegExp(r'[~!@#$%^&*()_+,./?":;{}|<>=-]'))) {
          //     return 'Must contain at least one special character';
          //   }
          //   if (value.length < 8 || value.length > 16) {
          //     return 'Must be between 8 to 16 characters long';
          //   }
          //   if (value != _passwordController.text) {
          //     return 'Passwords do not match';
          //   } else {
          //     return null;
          //   }
        },
        keyboardType: TextInputType.visiblePassword,
        obscureText: true,
        autovalidateMode: AutovalidateMode.disabled,
        //Testing: save values in confirm password field
        onSaved: (value) => setState(() => passwordConfirmation = value),
      );
}

// Class that contains all username validations
class UsernameFieldValidator {
  static String validate(String value) {
    if (value.isEmpty) {
      return 'Please enter your username';
    }
    // if (value.contains(new RegExp(r'[~!#$%^&*(),/?":;{}|<>=]'))) {
    //   return 'Invalid Special Character: Acceptable: @/./_/-/+';
    // }
    if (value.length < 8 || value.length > 16) {
      return 'Must be between 8 to 16 characters long';
    } else {
      return null;
    }
  }
}

// Class that contains the student number validations
class StudentNumberFieldValidator {
  static String validate(String value) {
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
  }
}

// Class that contains the password validations
class PasswordFieldValidator {
  static String validate(String value) {
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
    if (value.length < 8 || value.length > 24) {
      return 'Must be between 8 to 24 characters long';
    } else {
      return null;
    }
  }
}

// Class that contains the confirm password validations
class PasswordConfirmationFieldValidator {
  // ignore: missing_return
  static String validate(String value) {
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
    if (value.length < 8 || value.length > 24) {
      return 'Must be between 8 to 24 characters long';
    }
  }
}
