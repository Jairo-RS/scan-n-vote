// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:scan_n_vote/bloc/authentication_bloc.dart';
// import 'package:scan_n_vote/bloc/login_bloc/login_bloc.dart';
// import 'package:scan_n_vote/components/round_button.dart';
// import 'package:scan_n_vote/components/text_field_container.dart';
// import 'package:scan_n_vote/repositories/user_repository.dart';
// import 'package:scan_n_vote/screens/assemblies/assemblies_screen.dart';
// import 'package:scan_n_vote/screens/forgot_password/forgot_password_screen.dart';
// import 'package:scan_n_vote/components/backdrop.dart';
// import 'package:scan_n_vote/shared_information.dart';

// class LoginBody extends StatefulWidget {
//   final UserRepository userRepository;
//   LoginBody({Key key, @required this.userRepository})
//       : assert(userRepository != null),
//         super(key: key);

//   @override
//   _LoginBodyState createState() => _LoginBodyState(userRepository);
// }

// class _LoginBodyState extends State<LoginBody> {
//   final UserRepository userRepository;
//   _LoginBodyState(this.userRepository);

//   var _formkey = GlobalKey<FormState>();
//   final _usernameController = TextEditingController();
//   final _passwordController = TextEditingController();

//   // final authBloc = AuthenticationBloc(AuthenticationState.initial());
//   // final sharedInformation = SharedInformation();

//   // //loading widget
//   // void loadingDialog(BuildContext context) {
//   //   showDialog(
//   //     context: context,
//   //     builder: (BuildContext context) {
//   //       return AlertDialog(
//   //         title: Center(
//   //           child: Text("Loading..."),
//   //         ),
//   //         content: Column(
//   //           mainAxisAlignment: MainAxisAlignment.center,
//   //           mainAxisSize: MainAxisSize.min,
//   //           children: <Widget>[
//   //             SizedBox(
//   //               width: 30,
//   //               height: 30,
//   //               child: CircularProgressIndicator(),
//   //             ),
//   //           ],
//   //         ),
//   //       );
//   //     },
//   //   );
//   // }

//   // //display message alert
//   // void messageDialog(BuildContext context, String message) {
//   //   showDialog(
//   //       context: context,
//   //       barrierDismissible: false,
//   //       builder: (BuildContext context) {
//   //         return AlertDialog(
//   //           title: Text(message),
//   //           actions: [
//   //             TextButton(
//   //               child: Text(
//   //                 "Ok",
//   //                 style: TextStyle(
//   //                   fontSize: 18,
//   //                 ),
//   //               ),
//   //               onPressed: () {
//   //                 Navigator.of(context, rootNavigator: true).pop();
//   //               },
//   //             ),
//   //           ],
//   //         );
//   //       });
//   // }

//   // String username = '';

//   @override
//   Widget build(BuildContext context) {
//     //Used for total height and width of the screen
//     Size size = MediaQuery.of(context).size;
//     _onLoginButtonPressed() {
//       BlocProvider.of<LoginBloc>(context).add(
//         LoginButtonPressed(
//           email: _usernameController.text,
//           password: _passwordController.text,
//         ),
//       );
//     }

//     // return SafeArea(
//     return BlocListener(
//       listener: (context, state) {
//         if (state is LoginFailure) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(
//               content: Text("Login failed."),
//               backgroundColor: Colors.red,
//             ),
//           );
//         }
//       },
//       child: BlocBuilder(
//         builder: (context, state) {
//           return SafeArea(
//             child: Scaffold(
//               extendBodyBehindAppBar: true,
//               appBar: AppBar(
//                 leading: IconButton(
//                   icon: Icon(
//                     Icons.arrow_back,
//                   ),
//                   onPressed: () => Navigator.of(context).pop(),
//                 ),
//                 backgroundColor: Colors.transparent,
//                 elevation: 0,
//                 iconTheme: IconThemeData(color: Colors.black),
//               ),
//               body: Backdrop(
//                 child: SingleChildScrollView(
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: <Widget>[
//                       Text(
//                         "Login",
//                         style: TextStyle(
//                           fontWeight: FontWeight.bold,
//                           fontSize: 40,
//                         ),
//                       ),
//                       SizedBox(
//                         height: size.height * 0.05,
//                       ),
//                       Form(
//                         key: _formkey,
//                         // autovalidateMode: AutovalidateMode.always,
//                         child: Column(
//                           children: [
//                             TextFieldContainer(
//                               child: Stack(
//                                 children: [
//                                   buildUsername(),
//                                 ],
//                               ),
//                             ),
//                             SizedBox(
//                               height: size.height * 0.01,
//                             ),
//                             TextFieldContainer(
//                               child: Stack(
//                                 children: [
//                                   buildPassword(),
//                                 ],
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                       SizedBox(
//                         height: size.height * 0.05,
//                       ),
//                       Padding(
//                         padding: EdgeInsets.only(
//                           top: 30,
//                           bottom: 20,
//                         ),
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.stretch,
//                           children: [
//                             SizedBox(
//                               height: 45,
//                               child: state is LoginLoading
//                                   ? Column(
//                                       crossAxisAlignment:
//                                           CrossAxisAlignment.center,
//                                       mainAxisAlignment:
//                                           MainAxisAlignment.center,
//                                       children: [
//                                         Center(
//                                           child: Column(
//                                             children: [
//                                               SizedBox(
//                                                 height: 25,
//                                                 width: 25,
//                                                 child:
//                                                     CircularProgressIndicator(),
//                                               )
//                                             ],
//                                           ),
//                                         )
//                                       ],
//                                     )
//                                   : ElevatedButton(
//                                       onPressed: _onLoginButtonPressed,
//                                       style: ElevatedButton.styleFrom(
//                                         primary: Colors.black, // background
//                                         onPrimary: Colors.white, // foreground
//                                         shape: RoundedRectangleBorder(
//                                           borderRadius: BorderRadius.circular(
//                                             30,
//                                           ),
//                                         ),
//                                       ),
//                                       child: Text(
//                                         "LOGIN",
//                                         style: TextStyle(
//                                           fontSize: 18,
//                                         ),
//                                       ),
//                                     ),
//                             ),
//                           ],
//                         ),
//                       ),
//                       // RoundButton(
//                       //   text: "LOGIN",
//                       //   press: _onLoginButtonPressed,
//                       // {

//                       // authBloc.onLogin(
//                       //     usernameController.text, passwordController.text);
//                       // final isValid = _formkey.currentState.validate();
//                       // if (isValid) {
//                       //   _formkey.currentState.save();
//                       // }
//                       // Navigator.push(
//                       //   context,
//                       //   MaterialPageRoute(
//                       //     builder: (context) {
//                       //       return AssembliesScreen();
//                       //     },
//                       //   ),
//                       // );
//                       // },
//                       // ),
//                       SizedBox(
//                         height: size.height * 0.02,
//                       ),
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: <Widget>[
//                           GestureDetector(
//                             onTap: () {
//                               Navigator.of(context).push(
//                                 MaterialPageRoute(
//                                   builder: (context) =>
//                                       new ForgotPasswordScreen(),
//                                 ),
//                               );
//                             },
//                             child: Text(
//                               "Forgot your password?",
//                               style: TextStyle(
//                                 color: Colors.blue,
//                                 fontWeight: FontWeight.bold,
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//           );
//         },
//       ),
//     );
//     // child: BlocListener(
//     //   bloc: authBloc,
//     //   listener: (context, AuthenticationState state) {
//     //     if (state.userModel != null && state is AuthenticationState) {
//     //       // Dismiss loading widget
//     //       Navigator.of(context, rootNavigator: true).pop();
//     //       // Save user login information to shared information
//     //       sharedInformation.sharedLoginSave(state.userModel);
//     //       // Go to assemblies screen
//     //       Navigator.of(context).push(
//     //         MaterialPageRoute(
//     //           builder: (context) => AssembliesScreen(),
//     //         ),
//     //       );
//     //     } else if (state is LoadingState) {
//     //       // Display loading
//     //       WidgetsBinding.instance
//     //           .addPostFrameCallback((_) => loadingDialog(context));
//     //     } else if (state is GetFailureState) {
//     //       Navigator.of(context, rootNavigator: true).pop();
//     //       WidgetsBinding.instance.addPostFrameCallback(
//     //         (_) => messageDialog(context,
//     //             "Login Error:\nCredentials are incorrect.\n" + state.error),
//     //       );
//     //     }
//     //   },
//     // child:
//     // return Scaffold(
//     //   extendBodyBehindAppBar: true,
//     //   appBar: AppBar(
//     //     leading: IconButton(
//     //       icon: Icon(
//     //         Icons.arrow_back,
//     //       ),
//     //       onPressed: () => Navigator.of(context).pop(),
//     //     ),
//     //     backgroundColor: Colors.transparent,
//     //     elevation: 0,
//     //     iconTheme: IconThemeData(color: Colors.black),
//     //   ),
//     //   body: Backdrop(
//     //     child: SingleChildScrollView(
//     //       child: Column(
//     //         mainAxisAlignment: MainAxisAlignment.center,
//     //         children: <Widget>[
//     //           Text(
//     //             "Login",
//     //             style: TextStyle(
//     //               fontWeight: FontWeight.bold,
//     //               fontSize: 40,
//     //             ),
//     //           ),
//     //           SizedBox(
//     //             height: size.height * 0.05,
//     //           ),
//     //           Form(
//     //             key: _formkey,
//     //             // autovalidateMode: AutovalidateMode.always,
//     //             child: Column(
//     //               children: [
//     //                 TextFieldContainer(
//     //                   child: Stack(
//     //                     children: [
//     //                       buildUsername(),
//     //                     ],
//     //                   ),
//     //                 ),
//     //                 SizedBox(
//     //                   height: size.height * 0.01,
//     //                 ),
//     //                 TextFieldContainer(
//     //                   child: Stack(
//     //                     children: [
//     //                       buildPassword(),
//     //                     ],
//     //                   ),
//     //                 ),
//     //               ],
//     //             ),
//     //           ),
//     //           SizedBox(
//     //             height: size.height * 0.05,
//     //           ),
//     //           RoundButton(
//     //             text: "LOGIN",
//     //             press: () {
//     //               // authBloc.onLogin(
//     //               //     usernameController.text, passwordController.text);
//     //               // final isValid = _formkey.currentState.validate();
//     //               // if (isValid) {
//     //               //   _formkey.currentState.save();
//     //               // }
//     //               // Navigator.push(
//     //               //   context,
//     //               //   MaterialPageRoute(
//     //               //     builder: (context) {
//     //               //       return AssembliesScreen();
//     //               //     },
//     //               //   ),
//     //               // );
//     //             },
//     //           ),
//     //           SizedBox(
//     //             height: size.height * 0.02,
//     //           ),
//     //           Row(
//     //             mainAxisAlignment: MainAxisAlignment.center,
//     //             children: <Widget>[
//     //               GestureDetector(
//     //                 onTap: () {
//     //                   Navigator.of(context).push(
//     //                     MaterialPageRoute(
//     //                       builder: (context) => new ForgotPasswordScreen(),
//     //                     ),
//     //                   );
//     //                 },
//     //                 child: Text(
//     //                   "Forgot your password?",
//     //                   style: TextStyle(
//     //                     color: Colors.blue,
//     //                     fontWeight: FontWeight.bold,
//     //                   ),
//     //                 ),
//     //               ),
//     //             ],
//     //           ),
//     //         ],
//     //       ),
//     //     ),
//     //   ),
//     // ),
//     // ),
//     // );
//   }

//   Widget buildUsername() => TextFormField(
//         decoration: InputDecoration(
//           labelText: 'Username',
//           //border: InputBorder.none,
//           //hintText: "Username",
//         ),
//         controller: _usernameController,
//         // validator: (value) {
//         //   if (value.isEmpty) {
//         //     return 'Please enter your username';
//         //   }
//         //   if (value.contains(new RegExp(r'[~!#$%^&*(),/?":;{}|<>]'))) {
//         //     return 'Invalid Special Character. Only use: ./@/_/-/+';
//         //   }
//         //   if (value.length < 6) {
//         //     return 'Enter at least 6 characters';
//         //   } else {
//         //     return null;
//         //   }
//         // },
//         // maxLength: 30,
//         //onSaved: (value) => setState(() => username = value),
//       );

//   Widget buildPassword() => TextFormField(
//         decoration: InputDecoration(
//           labelText: 'Password',
//           //border: InputBorder.none,
//         ),
//         controller: _passwordController,
//         // validator: (value) {
//         //   // Pattern pattern =
//         //   //     r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$';
//         //   // RegExp regex = new RegExp(pattern);
//         //   if (value.isEmpty) {
//         //     return 'Please enter a password';
//         //   }
//         //   if (!value.contains(new RegExp(r'[a-z]'))) {
//         //     return 'Must contain at least one lowercase character';
//         //   }
//         //   if (!value.contains(new RegExp(r'[A-Z]'))) {
//         //     return 'Must contain at least one uppercase character';
//         //   }
//         //   if (!value.contains(new RegExp(r'(?=.*[0-9])'))) {
//         //     return 'Must contain at least one digit';
//         //   }
//         //   if (!value.contains(new RegExp(r'[~!@#$%^&*()_+,./?":;{}|<>-]'))) {
//         //     return 'Must contain at least one special character';
//         //   }
//         //   if (value.length < 8 || value.length > 16) {
//         //     return 'Must be between 8 to 16 characters long';
//         //   } else {
//         //     return null;
//         //     // if (!regex.hasMatch(value)) {
//         //     //   return 'Enter valid password';
//         //     // } else {
//         //     // }
//         //   }
//         // },
//         // onSaved: (value) => setState(() => password = value),
//         keyboardType: TextInputType.visiblePassword,
//         obscureText: false,
//       );
// }

// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:scan_n_vote/bloc/login_bloc/login_bloc.dart';
// import 'package:scan_n_vote/repositories/user_repository.dart';

// class LoginBody extends StatefulWidget {
//   final UserRepository userRepository;
//   LoginBody({Key key, @required this.userRepository})
//       : assert(userRepository != null),
//         super(key: key);

//   @override
//   State<LoginBody> createState() => _LoginBodyState(userRepository);
// }

// class _LoginBodyState extends State<LoginBody> {
//   final UserRepository userRepository;
//   _LoginBodyState(this.userRepository);
//   final _usernameController = TextEditingController();
//   final _passwordController = TextEditingController();

//   @override
//   Widget build(BuildContext context) {
//     _onLoginButtonPressed() {
//       BlocProvider.of<LoginBloc>(context).add(
//         LoginButtonPressed(
//           email: _usernameController.text,
//           password: _passwordController.text,
//         ),
//       );
//     }

//     return BlocListener<LoginBloc, LoginState>(
//       listener: (context, state) {
//         if (state is LoginFailure) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(
//               content: Text("Login failed."),
//               backgroundColor: Colors.red,
//             ),
//           );
//         }
//       },
//       child: BlocBuilder<LoginBloc, LoginState>(
//         builder: (context, state) {
//           // return Padding(
//           //   padding: const EdgeInsets.only(right: 20.0, left: 20.0, top: 80.0),
//           //   child:
//           return Form(
//             child: Column(
//               children: [
//                 Container(
//                     height: 200.0,
//                     padding: EdgeInsets.only(bottom: 20.0, top: 40.0),
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.start,
//                       children: [
//                         Text(
//                           "LOGIN",
//                           style: TextStyle(
//                               color: Colors.black,
//                               fontWeight: FontWeight.bold,
//                               fontSize: 36.0),
//                         ),
//                         SizedBox(
//                           height: 5.0,
//                         ),
//                         // Text(
//                         //   "Login app using BLOC pattern and REST API",
//                         //   style: TextStyle(
//                         //       fontSize: 10.0, color: Colors.black38),
//                         // )
//                       ],
//                     )),
//                 SizedBox(
//                   height: 30.0,
//                 ),
//                 TextFormField(
//                   style: TextStyle(
//                     fontSize: 14.0,
//                     // color: Style.Colors.titleColor,
//                     fontWeight: FontWeight.bold,
//                   ),
//                   controller: _usernameController,
//                   // keyboardType: TextInputType.number,
//                   decoration: InputDecoration(
//                     // prefixIcon: Icon(EvaIcons.emailOutline, color: Colors.black26),
//                     enabledBorder: OutlineInputBorder(
//                       borderSide: new BorderSide(
//                         color: Colors.black12,
//                       ),
//                       borderRadius: BorderRadius.circular(30.0),
//                     ),
//                     focusedBorder: OutlineInputBorder(
//                       borderSide: new BorderSide(
//                         color: Colors.black,
//                       ),
//                       borderRadius: BorderRadius.circular(30.0),
//                     ),
//                     contentPadding: EdgeInsets.only(
//                       left: 10.0,
//                       right: 10.0,
//                     ),
//                     labelText: "E-Mail",
//                     hintStyle: TextStyle(
//                         fontSize: 12.0,
//                         color: Colors.grey,
//                         fontWeight: FontWeight.w500),
//                     labelStyle: TextStyle(
//                         fontSize: 12.0,
//                         color: Colors.grey,
//                         fontWeight: FontWeight.w500),
//                   ),
//                   autocorrect: false,
//                 ),
//                 SizedBox(
//                   height: 20.0,
//                 ),
//                 TextFormField(
//                   style: TextStyle(
//                       fontSize: 14.0,
//                       color: Colors.black,
//                       fontWeight: FontWeight.bold),
//                   controller: _passwordController,
//                   decoration: InputDecoration(
//                     fillColor: Colors.white,
//                     // prefixIcon: Icon(EvaIcons.lockOutline, color: Colors.black26,),
//                     enabledBorder: OutlineInputBorder(
//                         borderSide: new BorderSide(color: Colors.black12),
//                         borderRadius: BorderRadius.circular(30.0)),
//                     focusedBorder: OutlineInputBorder(
//                         borderSide: new BorderSide(color: Colors.black),
//                         borderRadius: BorderRadius.circular(30.0)),
//                     contentPadding: EdgeInsets.only(left: 10.0, right: 10.0),
//                     labelText: "Password",
//                     hintStyle: TextStyle(
//                         fontSize: 12.0,
//                         color: Colors.grey,
//                         fontWeight: FontWeight.w500),
//                     labelStyle: TextStyle(
//                         fontSize: 12.0,
//                         color: Colors.grey,
//                         fontWeight: FontWeight.w500),
//                   ),
//                   autocorrect: false,
//                   obscureText: true,
//                 ),
//                 SizedBox(
//                   height: 30.0,
//                 ),
//                 Align(
//                   alignment: Alignment.centerRight,
//                   child: new InkWell(
//                       child: new Text(
//                         "Forget password?",
//                         style: TextStyle(color: Colors.black45, fontSize: 12.0),
//                       ),
//                       onTap: () {}),
//                 ),
//                 Padding(
//                   padding: EdgeInsets.only(top: 30.0, bottom: 20.0),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.stretch,
//                     children: <Widget>[
//                       SizedBox(
//                         height: 45,
//                         child: state is LoginLoading
//                             ? Column(
//                                 crossAxisAlignment: CrossAxisAlignment.center,
//                                 mainAxisAlignment: MainAxisAlignment.center,
//                                 children: <Widget>[
//                                   Center(
//                                       child: Column(
//                                     mainAxisAlignment: MainAxisAlignment.center,
//                                     children: [
//                                       SizedBox(
//                                         height: 25.0,
//                                         width: 25.0,
//                                         child: CircularProgressIndicator(),
//                                       )
//                                     ],
//                                   ))
//                                 ],
//                               )
//                             : ElevatedButton(
//                                 onPressed: _onLoginButtonPressed,
//                                 style: ElevatedButton.styleFrom(
//                                   primary: Colors.black, // background
//                                   onPrimary: Colors.white, // foreground
//                                   shape: RoundedRectangleBorder(
//                                     borderRadius: BorderRadius.circular(
//                                       30,
//                                     ),
//                                   ),
//                                 ),
//                                 child: Text(
//                                   "LOG IN",
//                                   style: new TextStyle(
//                                       fontSize: 12.0,
//                                       fontWeight: FontWeight.bold,
//                                       color: Colors.white),
//                                 ),
//                               ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 SizedBox(
//                   height: 20.0,
//                 ),
//                 //                 Row(
//                 //                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 //                   children: [
//                 //                     Container(
//                 //   height: 40.0,
//                 //   width: 180.0,
//                 //   child: RaisedButton(
//                 //     color: Color(0xFF385c8e),
//                 //     disabledColor: Colors.mainColor,
//                 //     disabledTextColor: Colors.white,
//                 //     shape: RoundedRectangleBorder(
//                 //       borderRadius: BorderRadius.circular(8.0),
//                 //     ),
//                 //     onPressed: _onLoginButtonPressed,
//                 //     child: Row(
//                 //       mainAxisAlignment: MainAxisAlignment.center,
//                 //       children: [
//                 //         Icon(EvaIcons.facebook, color: Colors.white,),
//                 //         SizedBox(
//                 //           width: 5.0,
//                 //         ),
//                 //         Text("Facebook", style: new TextStyle(fontSize: 12.0, fontWeight: FontWeight.bold, color: Colors.white)),
//                 //       ],
//                 //     )
//                 //   ),
//                 // ),
//                 //                     Container(
//                 //                       width: 180.0,
//                 //                       height: 40.0,
//                 //                       child: RaisedButton(
//                 //   color: Color(0xFFf14436),
//                 //   disabledColor: Style.Colors.mainColor,
//                 //   disabledTextColor: Colors.white,
//                 //   shape: RoundedRectangleBorder(
//                 //     borderRadius: BorderRadius.circular(8.0),
//                 //   ),
//                 //   onPressed: () {},
//                 //   child: Row(
//                 //     mainAxisAlignment: MainAxisAlignment.center,
//                 //       children: [
//                 //         Icon(EvaIcons.google, color: Colors.white,),
//                 //         SizedBox(
//                 //           width: 5.0,
//                 //         ),
//                 //         Text("Google", style: new TextStyle(fontSize: 12.0, fontWeight: FontWeight.bold, color: Colors.white)),
//                 //       ],
//                 //     )
//                 // ),
//                 //                     ),

//                 //                   ],
//                 //                 ),
//                 SizedBox(
//                   height: 20.0,
//                 ),
//                 Expanded(
//                   child: Align(
//                     alignment: Alignment.bottomCenter,
//                     child: Container(
//                         padding: EdgeInsets.only(bottom: 30.0),
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           crossAxisAlignment: CrossAxisAlignment.center,
//                           children: <Widget>[
//                             Text(
//                               "Don't have an account?",
//                               style: TextStyle(color: Colors.grey),
//                             ),
//                             Padding(
//                               padding: EdgeInsets.only(right: 5.0),
//                             ),
//                             GestureDetector(
//                                 onTap: () {},
//                                 child: Text(
//                                   "Register",
//                                   style: TextStyle(
//                                       color: Colors.black,
//                                       fontWeight: FontWeight.bold),
//                                 ))
//                           ],
//                         )),
//                   ),
//                 ),
//                 SizedBox(
//                   height: 20.0,
//                 )
//               ],
//             ),
//           );
//           // );
//         },
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scan_n_vote/bloc/login_bloc/login_bloc.dart';
import 'package:scan_n_vote/components/backdrop.dart';
import 'package:scan_n_vote/components/text_field_container.dart';
import 'package:scan_n_vote/repositories/user_repository.dart';
import 'package:scan_n_vote/screens/forgot_password/forgot_password_screen.dart';

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

  var _formkey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    //Used for total height and width of the screen
    Size size = MediaQuery.of(context).size;

    _onLoginButtonPressed() {
      BlocProvider.of<LoginBloc>(context).add(
        LoginButtonPressed(
            email: _usernameController.text,
            password: _passwordController.text),
      );
    }

    return BlocListener<LoginBloc, LoginState>(
      listener: (context, state) {
        if (state is LoginFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Login failed"),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      child: BlocBuilder<LoginBloc, LoginState>(
        builder: (context, state) {
          // return SafeArea(
          //   child:
          return Scaffold(
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
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Center(
                                      child: Column(
                                        children: [
                                          SizedBox(
                                            height: 25,
                                            width: 25,
                                            child: CircularProgressIndicator(),
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
                                  child: ElevatedButton(
                                    onPressed: _onLoginButtonPressed,
                                    child: Text(
                                      "LOGIN",
                                      style: new TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                    style: ElevatedButton.styleFrom(
                                      // background color
                                      primary: Colors.black,
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
                      height: size.height * 0.05,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
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
                            "Forgot your password?",
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
            // ),
          );
        },
      ),
    );
  }

  Widget buildUsername() => TextFormField(
        decoration: InputDecoration(
          labelText: 'Username',
          //border: InputBorder.none,
          //hintText: "Username",
        ),
        controller: _usernameController,
        // validator: (value) {
        //   if (value.isEmpty) {
        //     return 'Please enter your username';
        //   }
        //   if (value.contains(new RegExp(r'[~!#$%^&*(),/?":;{}|<>]'))) {
        //     return 'Invalid Special Character. Only use: ./@/_/-/+';
        //   }
        //   if (value.length < 6) {
        //     return 'Enter at least 6 characters';
        //   } else {
        //     return null;
        //   }
        // },
        // maxLength: 30,
        //onSaved: (value) => setState(() => username = value),
      );

  Widget buildPassword() => TextFormField(
        decoration: InputDecoration(
          labelText: 'Password',
          //border: InputBorder.none,
        ),
        controller: _passwordController,
        // validator: (value) {
        //   // Pattern pattern =
        //   //     r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$';
        //   // RegExp regex = new RegExp(pattern);
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
        //   if (!value.contains(new RegExp(r'[~!@#$%^&*()_+,./?":;{}|<>-]'))) {
        //     return 'Must contain at least one special character';
        //   }
        //   if (value.length < 8 || value.length > 16) {
        //     return 'Must be between 8 to 16 characters long';
        //   } else {
        //     return null;
        //     // if (!regex.hasMatch(value)) {
        //     //   return 'Enter valid password';
        //     // } else {
        //     // }
        //   }
        // },
        // onSaved: (value) => setState(() => password = value),
        keyboardType: TextInputType.visiblePassword,
        obscureText: false,
      );
}
