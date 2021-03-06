import 'package:flutter/material.dart';
import 'package:scan_n_vote/components/backdrop.dart';
import 'package:scan_n_vote/models/assemblies_model.dart';
import 'package:scan_n_vote/models/motions_model.dart';
import 'package:scan_n_vote/models/voting_model.dart';
import 'package:scan_n_vote/repositories/user_repository.dart';
import 'package:scan_n_vote/screens/home_page/home_screen.dart';
import 'package:scan_n_vote/screens/results/results_screen.dart';
import 'package:scan_n_vote/screens/voting/voting_screen.dart';

class MotionsBody extends StatefulWidget {
  final UserRepository userRepository;
  final Assemblies currentAssembly;
  MotionsBody(
      {Key key, @required this.userRepository, @required this.currentAssembly})
      : super(key: key);

  @override
  _MotionsBodyState createState() =>
      _MotionsBodyState(this.userRepository, this.currentAssembly);
}

class _MotionsBodyState extends State<MotionsBody> {
  final UserRepository userRepository;
  final Assemblies currentAssembly;

  bool isAmendment;

  _MotionsBodyState(this.userRepository, this.currentAssembly);

  Future<List<Motions>> motions;

  @override
  void initState() {
    super.initState();
    motions = Motions.fetchMotions();
  }

  //To see if voting is ready
  // ignore: missing_return
  Future<VotingModel> voteReady2Voting(bool voteable, bool archived) async {
    if (voteable == true && archived == false) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) {
            return VotingScreen(
              userRepository: userRepository,
              currentAssembly: currentAssembly,
            );
          },
        ),
      );
    } else if (voteable == false) {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text("Aviso!"),
              content:
                  Text('Las votaciones no están activas en este momento.\n'),
              actions: [
                TextButton(
                    //OK Button
                    onPressed: () =>
                        Navigator.pop(context), //return to motions screen
                    child: Text("Regresar")),
              ],
            );
          });
    }
  }

  // ignore: missing_return
  Future<VotingModel> voteReady2Results(
      bool voteable, bool archived, int pk, bool isAmend) async {
    if (voteable == false && archived == false) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) {
            return ResultsScreen(
              userRepository: userRepository,
              currentAssembly: currentAssembly,
            );
          },
        ),
      );
    } else {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text("Aviso!"),
              content:
                  Text('Favor esperar a que se finalicen las votaciones.\n'),
              actions: [
                TextButton(
                    //OK Button
                    onPressed: () =>
                        Navigator.pop(context), //return to motions screen
                    child: Text("Regresar")),
              ],
            );
          });
    }
  }

  @override
  Widget build(BuildContext context) {
    //Used for total height and width of the screen
    Size size = MediaQuery.of(context).size;
    // ignore: unused_local_variable
    final ScrollController _scrollController = ScrollController();
    return WillPopScope(
      //when back button is pressed return to desired screen
      onWillPop: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) {
            return HomeScreen(
              userRepository: userRepository,
              currentAssembly: currentAssembly,
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
                      currentAssembly: currentAssembly,
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
                  var _motions = Motions.fetchMotions();

                  setState(() {
                    motions = _motions;
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
                FutureBuilder(
                  future: motions,
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
                          shrinkWrap: true,
                          itemCount: currentMotion.length,
                          // ignore: missing_return
                          itemBuilder: (BuildContext context, int index) {
                            Motions currMotion = currentMotion[index];
                            if (!currMotion.archived) {
                              return Padding(
                                padding: EdgeInsets.only(left: 25, right: 25),
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
                                          i < currMotion.originalMotion.length;
                                          i++)
                                        Align(
                                          alignment: Alignment.center,
                                          child: Text(
                                            "○ " +
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
                                            style: ElevatedButton.styleFrom(
                                              primary: Colors.blue,
                                              onPrimary: Colors.white,
                                            ),
                                            child: Padding(
                                              padding: EdgeInsets.only(
                                                  left: 20, right: 20),
                                              child: Text(
                                                'Votar',
                                                style: TextStyle(
                                                  fontSize: 18,
                                                ),
                                              ),
                                            ),
                                            onPressed: () {
                                              for (int i = 0;
                                                  i <=
                                                      currMotion.originalMotion
                                                          .length;
                                                  i++) {
                                                if (!currMotion.archived &&
                                                    !currMotion.voteable &&
                                                    currMotion.originalMotion
                                                        .isNotEmpty &&
                                                    currMotion.originalMotion[i]
                                                        .voteable &&
                                                    !currMotion
                                                        .originalMotion[i]
                                                        .archived) {
                                                  isAmendment = true;
                                                  voteReady2Voting(
                                                      currMotion
                                                          .originalMotion[i]
                                                          .voteable,
                                                      currMotion
                                                          .originalMotion[i]
                                                          .archived);
                                                  break;
                                                } else if (!currMotion
                                                        .archived &&
                                                    currMotion.voteable) {
                                                  isAmendment = false;
                                                  voteReady2Voting(
                                                      currMotion.voteable,
                                                      currMotion.archived);
                                                  break;
                                                } else {
                                                  isAmendment = null;
                                                  showDialog(
                                                    context: context,
                                                    builder: (context) {
                                                      return AlertDialog(
                                                        title: Text("Error!"),
                                                        content: Text(
                                                            "Las votaciones no están abiertas en este momento. Vuelva a intentar luego."),
                                                        actions: [
                                                          TextButton(
                                                              //OK Button
                                                              onPressed: () =>
                                                                  Navigator.pop(
                                                                      context), //return to motions screen
                                                              child: Text(
                                                                  "Regresar")),
                                                        ],
                                                      );
                                                    },
                                                  );
                                                  break;
                                                }
                                              }
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
                                                  left: 10, right: 10),
                                              child: Text(
                                                'Resultados',
                                                style: TextStyle(
                                                  fontSize: 18,
                                                ),
                                              ),
                                            ),
                                            onPressed: () {
                                              for (int i = 0;
                                                  i <
                                                      currMotion.originalMotion
                                                          .length;
                                                  i++) {
                                                if (!currMotion.archived &&
                                                    !currMotion.voteable &&
                                                    currMotion.originalMotion
                                                        .isNotEmpty &&
                                                    !currMotion
                                                        .originalMotion[i]
                                                        .archived &&
                                                    !currMotion
                                                        .originalMotion[i]
                                                        .voteable) {
                                                  isAmendment = true;
                                                  voteReady2Results(
                                                      currMotion
                                                          .originalMotion[i]
                                                          .voteable,
                                                      currMotion
                                                          .originalMotion[i]
                                                          .archived,
                                                      currMotion
                                                          .originalMotion[i].pk,
                                                      isAmendment);
                                                  break;
                                                } else if (!currMotion
                                                        .archived &&
                                                    !currMotion.voteable &&
                                                    currMotion.originalMotion
                                                        .isNotEmpty &&
                                                    !currMotion
                                                        .originalMotion[i]
                                                        .archived &&
                                                    currMotion.originalMotion[i]
                                                        .voteable) {
                                                  isAmendment = null;
                                                  showDialog(
                                                    context: context,
                                                    builder: (context) {
                                                      return AlertDialog(
                                                        title: Text("Error!"),
                                                        content: Text(
                                                            "Los resultados de la votación por la enmienda aún no estan listos. Vuelva a intentar luego."),
                                                        actions: [
                                                          TextButton(
                                                              //OK Button
                                                              onPressed: () =>
                                                                  Navigator.pop(
                                                                      context), //return to motions screen
                                                              child: Text(
                                                                  "Regresar")),
                                                        ],
                                                      );
                                                    },
                                                  );
                                                  break;
                                                } else if (!currMotion
                                                        .archived &&
                                                    !currMotion.voteable &&
                                                    currMotion.originalMotion
                                                        .isNotEmpty &&
                                                    currMotion
                                                        .originalMotion[currMotion
                                                                .originalMotion
                                                                .length -
                                                            1]
                                                        .archived &&
                                                    !currMotion
                                                        .originalMotion[currMotion
                                                                .originalMotion
                                                                .length -
                                                            1]
                                                        .voteable) {
                                                  isAmendment = false;
                                                  voteReady2Results(
                                                      currMotion.voteable,
                                                      currMotion.archived,
                                                      currMotion.pk,
                                                      isAmendment);
                                                  break;
                                                }
                                              }
                                              //for loop ends
                                              if (!currMotion.archived &&
                                                  !currMotion.voteable &&
                                                  currMotion
                                                      .originalMotion.isEmpty) {
                                                isAmendment = false;
                                                voteReady2Results(
                                                    currMotion.voteable,
                                                    currMotion.archived,
                                                    currMotion.pk,
                                                    isAmendment);
                                              } else if (!currMotion.archived &&
                                                  currMotion.voteable) {
                                                showDialog(
                                                  context: context,
                                                  builder: (context) {
                                                    return AlertDialog(
                                                      title: Text("Error!"),
                                                      content: Text(
                                                          "Los resultados de la votación por la moción aún no estan listos. Vuelva a intentar luego."),
                                                      actions: [
                                                        TextButton(
                                                          //OK Button
                                                          onPressed: () =>
                                                              Navigator.pop(
                                                                  context), //return to motions screen
                                                          child:
                                                              Text("Regresar"),
                                                        ),
                                                      ],
                                                    );
                                                  },
                                                );
                                              }
                                            },
                                          ),
                                        ],
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
                FutureBuilder(
                  future: motions,
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
                        return Padding(
                          padding: EdgeInsets.only(left: 25, right: 25),
                          child: Container(
                            height: 700,
                            child: ListView.separated(
                              shrinkWrap: true,
                              itemCount: pastMotions.length,
                              separatorBuilder:
                                  (BuildContext context, int index) {
                                return SizedBox(
                                  height: size.height * 0.03,
                                );
                              },
                              itemBuilder: (BuildContext context, int index) {
                                Motions pastMotion = pastMotions[index];
                                if (pastMotion.assemblyID ==
                                        widget.currentAssembly.pk &&
                                    pastMotion.archived == true &&
                                    pastMotion.voteable == false) {
                                  return Container(
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
                                        Text(
                                          "Moción",
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20,
                                          ),
                                        ),
                                        Text(
                                          pastMotion.motion + "\n",
                                          style: TextStyle(
                                            fontSize: 18,
                                          ),
                                        ),
                                        Text(
                                          "Enmiendas",
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20,
                                          ),
                                        ),
                                        for (int i = 0;
                                            i <
                                                pastMotion
                                                    .originalMotion.length;
                                            i++)
                                          Text(
                                            "○ " +
                                                pastMotion
                                                    .originalMotion[i].motion,
                                            style: TextStyle(
                                              fontSize: 18,
                                            ),
                                          ),
                                        Text(
                                          "\n",
                                        ),
                                        Text(
                                          "Resultados",
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20,
                                          ),
                                        ),
                                        Text(
                                          "A favor: " +
                                              pastMotion.favor.toString() +
                                              "\n" +
                                              "En contra: " +
                                              pastMotion.agaisnt.toString() +
                                              "\n" +
                                              "Abstenidx: " +
                                              pastMotion.abstained.toString(),
                                          style: TextStyle(
                                            fontSize: 18,
                                          ),
                                        ),
                                        Text(
                                          announceWinner(
                                              pastMotion.favor,
                                              pastMotion.abstained,
                                              pastMotion.agaisnt),
                                          style: TextStyle(
                                            fontSize: 18,
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                } else {
                                  return SizedBox(
                                    height: 0,
                                  );
                                }
                              },
                            ),
                          ),
                        );
                    }
                  },
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

  //Displays message of the final result
  String announceWinner(int aFavor, int abstenido, int enContra) {
    String result;
    //Announce winners
    //Gano A Favor
    if (aFavor > enContra && aFavor > abstenido) {
      result = "Pasa la moción con $aFavor votos a favor.\n";
    }
    //Gano En Contra
    else if (enContra > aFavor && enContra > abstenido) {
      result = "No pasa la moción con $enContra votos en contra.\n";
    }
    //Gano Abstenido
    else if ((abstenido > enContra) && (abstenido > aFavor)) {
      result = "No se decide en la moción con $abstenido votos abtenidos.\n";
    }
    // Hubo empate
    // A favor = En Contra
    else if ((aFavor) == (enContra) && (aFavor) > (abstenido)) {
      result =
          "No hay decision en moción por empate a $aFavor votos a favor y en contra.\n";
    }
    // A favor = abstenido
    else if ((aFavor) == (abstenido) && (aFavor) > (enContra)) {
      result =
          "No hay decision en moción por empate a $aFavor votos a favor y abstenidos.\n";
    }
    // Abstenido = en contra
    else if ((enContra) == (abstenido) && (enContra) > (abstenido)) {
      result =
          "No hay decision en moción por empate a $enContra votos en contra y abstenidos.\n";
    }
    //Triple empate
    else if ((enContra) == (abstenido) && (enContra) == (aFavor)) {
      result = "Hay un triple empate a $enContra votos.\n";
    }
    return result;
  }
}
