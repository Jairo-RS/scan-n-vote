import 'package:flutter/material.dart';
import 'package:scan_n_vote/components/backdrop.dart';
import 'package:scan_n_vote/models/current_motion_model.dart';
import 'package:scan_n_vote/models/past_motions_model.dart';
import 'package:scan_n_vote/repositories/user_repository.dart';
import 'package:scan_n_vote/screens/home_page/home_screen.dart';
import 'package:scan_n_vote/screens/results/results_screen.dart';
import 'package:scan_n_vote/screens/voting/voting_screen.dart';

class MotionsBody extends StatefulWidget {
  final UserRepository userRepository;
  MotionsBody({Key key, @required this.userRepository}) : super(key: key);

  @override
  _MotionsBodyState createState() => _MotionsBodyState(this.userRepository);
}

class _MotionsBodyState extends State<MotionsBody> {
  final UserRepository userRepository;
  _MotionsBodyState(this.userRepository);

  Future<List<CurrentMotion>> currentMotion;
  Future<List<PastMotions>> pastMotions;

  @override
  void initState() {
    super.initState();
    currentMotion = CurrentMotion.browseCurrentMotion();
    pastMotions = PastMotions.browsePastMotions();
  }

  @override
  Widget build(BuildContext context) {
    //Used for total height and width of the screen
    Size size = MediaQuery.of(context).size;
    final ScrollController _scrollController = ScrollController();
    return WillPopScope(
      //when back button is pressed return to desired screen
      onWillPop: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) {
            return HomeScreen(
              userRepository: userRepository,
            );
          },
        ),
      ),
      child: SafeArea(
        child: Scaffold(
          extendBodyBehindAppBar: true,
          appBar: AppBar(
            leading: IconButton(
              icon: Icon(
                Icons.arrow_back,
              ),
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return HomeScreen(
                      userRepository: userRepository,
                    );
                  },
                ),
              ),
            ),
            // Displays refresh button which will fetch data when clicked
            actions: <Widget>[
              IconButton(
                icon: Icon(Icons.refresh),
                onPressed: () {
                  var _currentMotion = CurrentMotion.browseCurrentMotion();
                  var _pastMotions = PastMotions.browsePastMotions();

                  setState(() {
                    currentMotion = _currentMotion;
                    pastMotions = _pastMotions;
                  });
                },
              ),
            ],
            backgroundColor: Colors.transparent,
            elevation: 0,
            iconTheme: IconThemeData(color: Colors.black),
          ),
          body: Backdrop(
            child: ListView(
              // shrinkWrap: true,
              children: <Widget>[
                Center(
                  child: Text(
                    'Motions',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 40,
                    ),
                  ),
                ),
                SizedBox(
                  height: size.height * 0.05,
                ),
                Padding(
                  padding: EdgeInsets.only(left: 20, right: 20),
                  child: Container(
                    height: 150,
                    child: FutureBuilder(
                      future: currentMotion,
                      // ignore: missing_return
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
                            var currentMotion = snapshot.data;
                            return ListView.builder(
                              itemCount: currentMotion.length,
                              itemBuilder: (BuildContext context, int index) {
                                CurrentMotion currMotion = currentMotion[index];
                                return Padding(
                                  padding: EdgeInsets.only(left: 5, right: 5),
                                  child: Container(
                                    width: size.width * 0.8,
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 20, vertical: 10),
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
                                          alignment: Alignment.topLeft,
                                          child: Text(
                                            currMotion.motion + '\n',
                                            style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                primary: Colors.blue,
                                                onPrimary: Colors.white,
                                              ),
                                              child: Padding(
                                                padding: EdgeInsets.only(
                                                    left: 20, right: 20),
                                                child: Text(
                                                  'Vote',
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
                                                      return VotingScreen(
                                                        userRepository:
                                                            userRepository,
                                                      );
                                                    },
                                                  ),
                                                );
                                              },
                                            ),
                                            SizedBox(
                                              width: size.width * 0.1,
                                            ),
                                            ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                primary: Colors.green,
                                                onPrimary: Colors.white,
                                              ),
                                              child: Padding(
                                                padding: EdgeInsets.only(
                                                    left: 20, right: 20),
                                                child: Text(
                                                  'Results',
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
                                                      return ResultsScreen();
                                                    },
                                                  ),
                                                );
                                              },
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            );
                        }
                      },
                    ),
                  ),
                ),
                SizedBox(
                  height: size.height * 0.05,
                ),
                Center(
                  child: Text(
                    'Past Motions',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 30,
                    ),
                  ),
                ),
                SizedBox(
                  height: size.height * 0.05,
                ),
                Padding(
                  padding: EdgeInsets.only(left: 25, right: 25),
                  child: Container(
                    height: 700,
                    child: FutureBuilder(
                      future: pastMotions,
                      // ignore: missing_return
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
                            var pastMotions = snapshot.data;
                            return ListView.separated(
                              controller: _scrollController,
                              // physics: ClampingScrollPhysics(),
                              // shrinkWrap: true,
                              // reverse: true,
                              itemCount: pastMotions.length,
                              separatorBuilder:
                                  (BuildContext context, int index) {
                                return SizedBox(
                                  height: size.height * 0.03,
                                );
                              },
                              itemBuilder: (BuildContext context, int index) {
                                PastMotions motion = pastMotions[index];
                                if (motion.allAmendments == null) {
                                  motion.allAmendments =
                                      "Ninguna enmienda se ha hecho.";
                                }
                                return Padding(
                                  padding: EdgeInsets.only(left: 5, right: 5),
                                  child: Container(
                                    width: size.width * 0.8,
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 10,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(10),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey.withOpacity(0.5),
                                          spreadRadius: 2,
                                          blurRadius: 5,
                                          offset:
                                              Offset(0, 3), //Position of shadow
                                        )
                                      ],
                                    ),
                                    child: Column(
                                      children: [
                                        Align(
                                          alignment: Alignment.topLeft,
                                          child: Text(
                                            "Motion:",
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18,
                                            ),
                                          ),
                                        ),
                                        Align(
                                          alignment: Alignment.topLeft,
                                          child: Text(
                                            motion.pastMotion + "\n",
                                            style: TextStyle(
                                              // fontWeight: FontWeight.bold,
                                              fontSize: 18,
                                            ),
                                          ),
                                        ),
                                        Align(
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            "Amendments:",
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18,
                                            ),
                                          ),
                                        ),
                                        Align(
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            motion.allAmendments.toString() +
                                                "\n",
                                            style: TextStyle(
                                              fontSize: 18,
                                            ),
                                          ),
                                        ),
                                        Align(
                                          alignment: Alignment.bottomLeft,
                                          child: Text(
                                            "Results: " + motion.result,
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            );
                        }
                      },
                    ),
                  ),
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
}
