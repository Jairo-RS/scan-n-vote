import 'package:flutter/material.dart';
import 'package:scan_n_vote/components/backdrop.dart';
import 'package:scan_n_vote/models/assemblies_model.dart';
import 'package:scan_n_vote/models/motions_model.dart';
import 'package:scan_n_vote/models/past_motions_model.dart';
import 'package:scan_n_vote/models/voting_model.dart';
import 'package:scan_n_vote/models/voting_model_test.dart';
import 'package:scan_n_vote/repositories/user_repository.dart';
import 'package:scan_n_vote/screens/home_page/home_screen.dart';
import 'package:scan_n_vote/screens/results/results_screen.dart';
import 'package:scan_n_vote/screens/voting/voting_screen.dart';
import 'package:http/http.dart' as http;

class MotionsBody extends StatefulWidget {
  final UserRepository userRepository;
  final Assemblies currentAssembly;
  MotionsBody({Key key, @required this.userRepository, this.currentAssembly})
      : super(key: key);

  @override
  _MotionsBodyState createState() => _MotionsBodyState(this.userRepository);
}

class _MotionsBodyState extends State<MotionsBody> {
  final UserRepository userRepository;

  Future<VotingModel> futureVotingModel;
  _MotionsBodyState(this.userRepository);

  Future<List<Motions>> futureMotions;
  Future<List<PastMotions>> pastMotions;
  Future<List<VotingModel>> code;

  @override
  void initState() {
    super.initState();
    futureMotions = Motions.fetchMotions();
    pastMotions = PastMotions.browsePastMotions();
    code = VotingModel.browseCode();
  }

  String readCode(http.Response response) {
    String toBeReturned;
    FutureBuilder<VotingModel>(
        future: futureVotingModel,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            toBeReturned = snapshot.data.choice;
            return Text(snapshot.data.choice);
          } else if (snapshot.hasError) {
            return Text("${snapshot.error}");
          }
          return CircularProgressIndicator();
        });
    return toBeReturned;
  }

  //To see if voting is ready
  Future<VotingModelTest> voteReady2Voting() async {
    Uri url = Uri.parse(
        //  'https://run.mocky.io/v3/dd14f21e-1f8d-4975-a8d1-3e8d8cb5eef0'); //code 200
        'https://run.mocky.io/v3/53e4748d-d8d4-44e5-bb87-425e9690a866'); //code 404

    final response = await http.get(url);

    print("\nHttpResponseCode = " + response.statusCode.toString());
    if (response.statusCode == 200) {
      //////////////////////////////////////
      ///
      String theCode =
          readCode(response); //string that contains the content of the url
      ///
      //////////////////////////////////////
      if (theCode != "3") {
        print("entered the if");
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) {
              return VotingScreen(userRepository: userRepository);
            },
          ),
        );
      }
    } else {
      print("\nIncorrect HTTP Code.\nExpected 200, got ${response.statusCode}");
      print("Retry with a new URL.");
      return showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text("Cast Vote"),
              content: Text('Incorrect HTTP Code.\n'),
              actions: [
                TextButton(
                    //OK Button
                    onPressed: () =>
                        Navigator.pop(context), //return to motions screen
                    child: Text("OK")),
              ],
            );
          });
    }

    return null;
  }

  Future<VotingModelTest> voteReady2Results() async {
    Uri url = Uri.parse(
        'https://run.mocky.io/v3/a58c1b7a-b688-4d22-8dec-6009a840b1f4'); //code200

    final response = await http.get(url);

    print("\nHttpResponseCode = " + response.statusCode.toString());
    if (response.statusCode == 200) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) {
            return ResultsScreen();
          },
        ),
      );
    } else {
      print("Incorrect http code to continue");
      return showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text("Cast Vote"),
              content: Text('Incorrect HTTP Code.\n'),
              actions: [
                TextButton(
                    //OK Button
                    onPressed: () =>
                        Navigator.pop(context), //return to motions screen
                    child: Text("OK")),
              ],
            );
          });
    }
    return null;
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
                  var _currentMotions = Motions.fetchMotions();
                  // var _currentMotion = CurrentMotion.browseCurrentMotion();
                  var _pastMotions = PastMotions.browsePastMotions();
                  var _code = VotingModel.browseCode();

                  setState(() {
                    futureMotions = _currentMotions;
                    // currentMotion = _currentMotion;
                    pastMotions = _pastMotions;
                    code = _code;
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
                    'Mociones',
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
                    height: 250,
                    child: FutureBuilder(
                      future: futureMotions,
                      // future: currentMotion,
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
                                Motions currMotion = currentMotion[index];
                                if (currMotion.archived == false)
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
                                            offset: Offset(
                                                0, 3), //Position of shadow
                                          )
                                        ],
                                      ),
                                      child: Column(
                                        children: [
                                          Align(
                                            alignment: Alignment.topCenter,
                                            child: Text(
                                              'Moción actual',
                                              style: TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                          Align(
                                            alignment: Alignment.center,
                                            child: Text(
                                              currMotion.motion + '\n',
                                              style: TextStyle(
                                                fontSize: 18,
                                              ),
                                            ),
                                          ),
                                          Align(
                                            alignment: Alignment.topCenter,
                                            child: Text(
                                              'Enmiendas',
                                              style: TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                          for (int i = 0;
                                              i <
                                                  currMotion
                                                      .originalMotion.length;
                                              i++)
                                            Align(
                                              alignment: Alignment.center,
                                              child: Text(
                                                currMotion
                                                    .originalMotion[i].motion,
                                                style: TextStyle(
                                                  fontSize: 18,
                                                ),
                                              ),
                                            ),
                                          Text("\n"),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              ElevatedButton(
                                                  style:
                                                      ElevatedButton.styleFrom(
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
                                                    voteReady2Voting();
                                                  }),
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
                                                  voteReady2Results();
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
                    'Mociones Pasadas',
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
