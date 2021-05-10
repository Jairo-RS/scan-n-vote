import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scan_n_vote/bloc/login_bloc/login_bloc.dart';
import 'package:scan_n_vote/components/backdrop.dart';
import 'package:scan_n_vote/components/text_field_container.dart';
import 'package:scan_n_vote/repositories/user_repository.dart';
import 'package:scan_n_vote/screens/assemblies/assemblies_screen.dart';
import 'package:scan_n_vote/screens/forgot_password/forgot_password_screen.dart';

// Class that contains all widgets being displayed in login screen
class LoginBody extends StatefulWidget {
  final UserRepository userRepository;
  LoginBody({Key key, @required this.userRepository})
      : assert(userRepository != null),
        super(key: key);

  @override
  _LoginBodyState createState() => _LoginBodyState(userRepository);
}

class _LoginBodyState extends State<LoginBody> {
  final UserRepository userRepository;
  _LoginBodyState(this.userRepository);

  //Variables
  var _formkey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    //Used for total height and width of the screen
    Size size = MediaQuery.of(context).size;

    //when login button is pressed stores credentials
    _onLoginButtonPressed() {
      BlocProvider.of<LoginBloc>(context).add(
        LoginButtonPressed(
            username: _usernameController.text,
            password: _passwordController.text),
      );
    }

    //Listens to Login events and states
    return BlocListener<LoginBloc, LoginState>(
      listener: (context, state) {
        // When login is unsuccessful, display error message
        if (state is LoginFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                "Credenciales inválidos",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
              backgroundColor: Colors.red,
            ),
          );
        }

        // When login is successful transition to next screen
        if (state is LoginSuccess) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) {
                return AssembliesScreen(
                  userRepository: userRepository,
                );
              },
            ),
          );
        }
      },

      // Builds widget in response to a new states
      child: BlocBuilder<LoginBloc, LoginState>(
        builder: (context, state) {
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
                //Makes screen scrollable
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        "Iniciar sesión",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 40,
                        ),
                      ),
                      SizedBox(
                        height: size.height * 0.05,
                      ),
                      // Builds container with text fields
                      Form(
                        key: _formkey,
                        child: Column(
                          children: [
                            TextFieldContainer(
                              child: buildUsername(),
                            ),
                            SizedBox(
                              height: size.height * 0.01,
                            ),
                            TextFieldContainer(
                              child: buildPassword(),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: size.height * 0.05,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            child: state is LoginLoading
                                ?
                                //If loading, then display a progress indicator
                                Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Center(
                                        child: Column(
                                          children: [
                                            SizedBox(
                                              height: 25,
                                              width: 25,
                                              child:
                                                  CircularProgressIndicator(),
                                            ),
                                          ],
                                        ),
                                      )
                                    ],
                                  )
                                :
                                // If not loading, then display login button
                                ConstrainedBox(
                                    constraints: BoxConstraints.tightFor(
                                      width: size.width * 0.8,
                                      height: size.height * 0.085,
                                    ),

                                    //This is the Login button
                                    child: ElevatedButton(
                                      onPressed: _onLoginButtonPressed,
                                      child: Text(
                                        "Iniciar sesión",
                                        style: new TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                      style: ElevatedButton.styleFrom(
                                        // background color
                                        primary: Colors.green[700],
                                        // foreground color
                                        onPrimary: Colors.black,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            29,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: size.height * 0.03,
                      ),
                      SizedBox(
                        height: size.height * 0.05,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          //Gives functionality to forgot password text
                          GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) =>
                                      new ForgotPasswordScreen(),
                                ),
                              );
                            },
                            child: Text(
                              "¿Olvidaste tu contraseña?",
                              style: TextStyle(
                                color: Colors.blue,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
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
          );
        },
      ),
    );
  }

  //Custom widget that creates username textfield
  Widget buildUsername() => TextFormField(
        decoration: InputDecoration(
          labelText: 'Nombre de usuario (Username)',
        ),
        controller: _usernameController,
        // maxLength: 25,
      );

  //Custom widget that creates password textfield
  Widget buildPassword() => TextFormField(
        decoration: InputDecoration(
          labelText: 'Contraseña',
        ),
        controller: _passwordController,
        keyboardType: TextInputType.visiblePassword,
        obscureText: true,
      );
}
