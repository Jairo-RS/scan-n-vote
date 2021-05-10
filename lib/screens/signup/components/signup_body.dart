import 'package:flutter/material.dart';
import 'package:scan_n_vote/components/round_button.dart';
import 'package:scan_n_vote/components/text_field_container.dart';
import 'package:scan_n_vote/components/backdrop.dart';
import 'package:scan_n_vote/models/token_model.dart';
import 'package:scan_n_vote/models/user_model.dart';
import 'package:scan_n_vote/repositories/user_repository.dart';
import 'package:scan_n_vote/screens/initial/initial_screen.dart';
import 'package:scan_n_vote/screens/login/login_screen.dart';

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

  // ignore: unused_field
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
          title: Text("Bienvenido a Scan-N-Vote"),
          content: Text("¡Tu cuenta ha sido creada exitosamente!"),
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

        //Body that contains main widgets being presented
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
        ),
        controller: _usernameController,
        validator: UsernameFieldValidator.validate,
        maxLength: 16,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        //Testing: save values in username field
        onSaved: (value) => setState(() => username = value),
      );

  // Custom widget that creates student number field with validations
  Widget buildStudentNumber() => TextFormField(
        decoration: InputDecoration(
          labelText: 'Número de estudiante',
        ),
        controller: _studentNumberController,
        validator: StudentNumberFieldValidator.validate,
        keyboardType: TextInputType.number,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        //Testing: save values in student number field
        onSaved: (value) => setState(() => studentNumber = value),
      );

  // Custom widget that creates password field with validations
  Widget buildPassword() => TextFormField(
        decoration: InputDecoration(
          labelText: 'Contraseña',
        ),
        controller: _passwordController,
        validator: PasswordFieldValidator.validate,
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
            return 'Las contraseñas no coinciden';
          } else {
            return null;
          }
        },
        keyboardType: TextInputType.visiblePassword,
        obscureText: true,
        autovalidateMode: AutovalidateMode.disabled,
        //Saves value in confirm password field
        onSaved: (value) => setState(() => passwordConfirmation = value),
      );
}

// Class that contains all username validations
class UsernameFieldValidator {
  static String validate(String value) {
    if (value.isEmpty) {
      return 'Entre un nombre de usuario (username)';
    }
    if (value.contains(new RegExp(r'[~!#$%^&*(),/?":;{}|<>=]'))) {
      return 'Carácter especial inválido: Aceptable: @/./_ /-/+';
    }
    if (value.length < 8 || value.length > 16) {
      return 'Debe tener entre 8 a 16 caracteres de largo';
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
      return 'Por favor entre su número de estudiante';
    }
    if (!regExp.hasMatch(value)) {
      return 'Debe solo entrar dígitos. Formato: xxxxxxxxx';
    }
    if (value.contains(new RegExp(r'[a-z]'))) {
      return 'Debe solo entrar dígitos. Formato: xxxxxxxxx';
    }
    if (value.contains(new RegExp(r'[A-Z]'))) {
      return 'Debe solo entrar dígitos. Formato: xxxxxxxxx';
    }
    if (value.contains(new RegExp(r'[!@#$%^&*()_+,./?":;{}|<>=-]'))) {
      return 'Debe solo entrar dígitos. Formato: xxxxxxxxx';
    }
    if (value.length < 9 || value.length > 9) {
      return 'Inválido: Debe entrar 9 dígitos. Formato: xxxxxxxxx';
    } else {
      return null;
    }
  }
}

// Class that contains the password validations
class PasswordFieldValidator {
  static String validate(String value) {
    if (value.isEmpty) {
      return 'Por favor entre una contraseña';
    }
    if (!value.contains(new RegExp(r'[a-z]'))) {
      return 'Debe contener al menos un carácter en minúscula';
    }
    if (!value.contains(new RegExp(r'[A-Z]'))) {
      return 'Debe contener al menos un carácter en mayúscula';
    }
    if (!value.contains(new RegExp(r'(?=.*[0-9])'))) {
      return 'Debe contener al menos un dígito';
    }
    if (!value.contains(new RegExp(r'[~!@#$%^&*()_+,./?":;{}|<>=-]'))) {
      return 'Debe contener al menos un carácter especial';
    }
    if (value.length < 8 || value.length > 24) {
      return 'Debe tener entre 8 y 24 caracteres';
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
      return 'Por favor entre una contraseña';
    }
    if (!value.contains(new RegExp(r'[a-z]'))) {
      return 'Debe contener al menos un carácter en minúscula';
    }
    if (!value.contains(new RegExp(r'[A-Z]'))) {
      return 'Debe contener al menos un carácter en mayúscula';
    }
    if (!value.contains(new RegExp(r'(?=.*[0-9])'))) {
      return 'Debe contener al menos un dígito';
    }
    if (!value.contains(new RegExp(r'[~!@#$%^&*()_+,./?":;{}|<>=-]'))) {
      return 'Debe contener al menos un carácter especial';
    }
    if (value.length < 8 || value.length > 24) {
      return 'Debe tener entre 8 y 24 caracteres';
    }
  }
}
