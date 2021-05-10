import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:scan_n_vote/bloc/authentication_bloc/authentication_bloc.dart';
import 'package:scan_n_vote/bloc/authentication_bloc/authentication_event.dart';
import 'package:scan_n_vote/components/backdrop.dart';
import 'package:scan_n_vote/models/assemblies_model.dart';
import 'package:scan_n_vote/repositories/user_repository.dart';
import 'package:scan_n_vote/screens/assemblies/past_assemblies/past_assemblies_screen.dart';
import 'package:scan_n_vote/screens/home_page/home_screen.dart';
import 'package:scan_n_vote/screens/initial/initial_screen.dart';
import 'package:http/http.dart' as http;

class AssembliesBody extends StatefulWidget {
  final UserRepository userRepository;
  AssembliesBody({Key key, @required this.userRepository})
      : assert(userRepository != null),
        super(key: key);

  @override
  _AssembliesBodyState createState() =>
      _AssembliesBodyState(this.userRepository);
}

class _AssembliesBodyState extends State<AssembliesBody> {
  final UserRepository userRepository;
  _AssembliesBodyState(this.userRepository);

  //Used to store information about login functionality
  final FlutterSecureStorage storage = new FlutterSecureStorage();

  // ignore: unused_field
  Future<String> _logoutFuture;

  Future<List<Assemblies>> futureAssembly;

  @override
  void initState() {
    super.initState();
    futureAssembly = Assemblies.fetchAssemblies();
  }

  var logoutUrl = "https://scannvote.herokuapp.com/api/logout/";

  // Logout token POST request
  Future<String> logout(String csrftoken) async {
    String csrftoken = await storage.read(key: 'set-cookie');
    final response = await http.post(
      logoutUrl,
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode(<String, String>{
        "csrfmiddlewaretoken": csrftoken,
      }),
    );

    if (response.statusCode == 200) {
      return response.body;
    } else {
      // If not successful, display error status code (403)
      throw Exception(response.statusCode);
    }
  }

  //This method (widget) is used to ask the user if they want to logout when
  //they press the back button on their phone.
  Future<bool> _onBackPressed() {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Are you sure you want to logout?"),
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
            onPressed: () async {
              String csrftoken = await storage.read(key: 'set-cookie');
              BlocProvider.of<AuthenticationBloc>(context).add(LoggedOut());
              setState(() {
                _logoutFuture = logout(csrftoken);
              });

              return Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => InitialScreen(
                    userRepository: userRepository,
                  ),
                ),
              );
              // return Navigator.pop(context); //Dismiss AlertDialog
            },
            child: Text(
              "Yes",
              style: TextStyle(
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    //Used for total height and width of the screen
    Size size = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: SafeArea(
        child: Backdrop(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  'Asambleas',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 40,
                  ),
                ),
                SizedBox(
                  height: size.height * 0.07,
                ),
                FutureBuilder(
                  future: futureAssembly,
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    switch (snapshot.connectionState) {
                      case ConnectionState.none:
                      case ConnectionState.waiting:
                      case ConnectionState.active:
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      case ConnectionState.done:
                        if (snapshot.hasError) {
                          return Text(
                            "There was an error: ${snapshot.error}",
                          );
                        }

                        //snapshot.data holds the results of the future
                        var assemblies = snapshot.data;
                        return ListView.builder(
                          shrinkWrap: true,
                          itemCount: assemblies.length,
                          // ignore: missing_return
                          itemBuilder: (BuildContext context, int index) {
                            Assemblies currentAssembly = assemblies[index];
                            if (currentAssembly.archived == false) {
                              return Padding(
                                padding: EdgeInsets.only(left: 30, right: 30),
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 10),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.5),
                                        spreadRadius: 5,
                                        blurRadius: 7,
                                        offset:
                                            Offset(0, 3), //Position of shadow
                                      )
                                    ],
                                  ),
                                  child: Column(
                                    children: [
                                      Align(
                                        alignment: Alignment.topCenter,
                                        child: Text(
                                          'Asamblea Actual\n',
                                          style: TextStyle(
                                            fontSize: 24,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          primary: Colors.green,
                                          onPrimary: Colors.white,
                                        ),
                                        child: Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 20, vertical: 4),
                                          child: Text(
                                            'Enter',
                                            style: TextStyle(
                                              fontSize: 18,
                                            ),
                                          ),
                                        ),
                                        onPressed: () async {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) {
                                                return HomeScreen(
                                                  userRepository:
                                                      userRepository,
                                                  currentAssembly:
                                                      currentAssembly,
                                                );
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
                          },
                        );
                    }
                  },
                ),
                SizedBox(
                  height: size.height * 0.1,
                ),
                Padding(
                  padding: EdgeInsets.only(left: 30, right: 30),
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 5,
                          blurRadius: 7,
                          offset: Offset(0, 3), //Position of shadow
                        )
                      ],
                    ),
                    child: Column(
                      children: [
                        Align(
                          alignment: Alignment.topCenter,
                          child: Text(
                            'Asambleas Pasadas\n',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: Colors.green,
                            onPrimary: Colors.white,
                          ),
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 20, vertical: 4),
                            child: Text(
                              'Enter',
                              style: TextStyle(
                                fontSize: 18,
                              ),
                            ),
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) {
                                  return PastAssembliesScreen();
                                },
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
