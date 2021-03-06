import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:scan_n_vote/components/backdrop.dart';
import 'package:scan_n_vote/models/assemblies_model.dart';
import 'package:scan_n_vote/models/motions_model.dart';
import 'package:scan_n_vote/repositories/user_repository.dart';
import 'package:scan_n_vote/screens/motions/motions_screen.dart';

class ResultsBody extends StatefulWidget {
  final UserRepository userRepository;
  final Assemblies currentAssembly;

  ResultsBody({
    Key key,
    @required this.userRepository,
    @required this.currentAssembly,
  })  : assert(userRepository != null),
        super(key: key);
  @override
  _ResultsBodyState createState() =>
      _ResultsBodyState(this.userRepository, this.currentAssembly);
}

class _ResultsBodyState extends State<ResultsBody> {
  final Assemblies currentAssembly;
  final UserRepository userRepository;

  _ResultsBodyState(this.userRepository, this.currentAssembly);

  List<Motions> results = const [];

  Future<List<Motions>> futureAssemblies;
  var _refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();

  void initState() {
    super.initState();
    futureAssemblies = Motions.fetchMotions();
  }

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
              color: Colors.black,
            ),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) {
                  return MotionsScreen(
                    userRepository: userRepository,
                    currentAssembly: currentAssembly,
                  );
                },
              ),
            ),
            // Navigator.of(context).pop(),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
          iconTheme: IconThemeData(color: Colors.black),
        ),
        body: Backdrop(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                "Resultados de Votaciones",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 36,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: size.height * 0.05),
              Container(
                height: 310,
                width: size.width * 0.8,
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 0),
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
                child: Center(
                  child: FutureBuilder(
                      future: futureAssemblies,
                      builder:
                          // ignore: missing_return
                          (BuildContext context, AsyncSnapshot snapshot) {
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
                            var mociones = snapshot.data;
                            return RefreshIndicator(
                              key: _refreshIndicatorKey,
                              onRefresh: () async {
                                return refreshResults();
                              },
                              child: ListView.builder(
                                itemCount: mociones.length,
                                padding: EdgeInsets.zero,
                                // ignore: missing_return
                                itemBuilder: (BuildContext context, int index) {
                                  Motions resultsCount = mociones[index];
                                  //is amendment
                                  for (int i = 0;
                                      i < resultsCount.originalMotion.length;
                                      i++) {
                                    if (!resultsCount.archived &&
                                        !resultsCount.voteable &&
                                        resultsCount
                                            .originalMotion.isNotEmpty &&
                                        !resultsCount
                                            .originalMotion[i].archived &&
                                        !resultsCount
                                            .originalMotion[i].voteable) {
                                      return Column(
                                        children: [
                                          SizedBox(height: size.height * 0.02),
                                          Align(
                                            alignment: Alignment.topLeft,
                                            child: Text(
                                              'Enmienda:\n' +
                                                  resultsCount.originalMotion[i]
                                                      .motion +
                                                  "\n",
                                              style: TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                          Align(
                                            alignment: Alignment.topLeft,
                                            child: Text(
                                              'A Favor:                               ' +
                                                  resultsCount
                                                      .originalMotion[i].favor
                                                      .toString() +
                                                  "\n",
                                              style: TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                          Align(
                                            alignment: Alignment.topLeft,
                                            child: Text(
                                              'Abstenidxs:                         ' +
                                                  resultsCount.originalMotion[i]
                                                      .abstained
                                                      .toString() +
                                                  "\n",
                                              style: TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                          Align(
                                            alignment: Alignment.topLeft,
                                            child: Text(
                                              'En Contra:                            ' +
                                                  resultsCount
                                                      .originalMotion[i].agaisnt
                                                      .toString() +
                                                  "\n",
                                              style: TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                          Align(
                                            alignment: Alignment.topLeft,
                                            child: Text(
                                              announceWinnerAmend(
                                                  resultsCount
                                                      .originalMotion[i].favor,
                                                  resultsCount.originalMotion[i]
                                                      .abstained,
                                                  resultsCount.originalMotion[i]
                                                      .agaisnt),
                                              style: TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ],
                                      );
                                    }
                                  }
                                  // is motion
                                  if (!resultsCount.archived &&
                                      !resultsCount.voteable) {
                                    return Column(
                                      children: [
                                        SizedBox(height: size.height * 0.02),
                                        Align(
                                          alignment: Alignment.topLeft,
                                          child: Text(
                                            'Moci??n:\n' +
                                                resultsCount.motion +
                                                "\n",
                                            style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        Align(
                                          alignment: Alignment.topLeft,
                                          child: Text(
                                            'A Favor:                               ' +
                                                resultsCount.favor.toString() +
                                                "\n",
                                            style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        Align(
                                          alignment: Alignment.topLeft,
                                          child: Text(
                                            'Abstenidxs:                         ' +
                                                resultsCount.abstained
                                                    .toString() +
                                                "\n",
                                            style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        Align(
                                          alignment: Alignment.topLeft,
                                          child: Text(
                                            'En Contra:                            ' +
                                                resultsCount.agaisnt
                                                    .toString() +
                                                "\n",
                                            style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        Align(
                                          alignment: Alignment.topLeft,
                                          child: Text(
                                            announceWinner(
                                                resultsCount.favor,
                                                resultsCount.abstained,
                                                resultsCount.agaisnt),
                                            style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ],
                                    );
                                  }
                                },
                              ),
                            );
                        }
                      }),
                ),
              ),
              SizedBox(height: size.height * 0.05),
              SvgPicture.asset(
                "assets/icons/undraw_election.svg",
                height: size.height * 0.15,
              )
            ],
          ),
        ),
      ),
    );
  }

  String announceWinner(int aFavor, int abstenido, int enContra) {
    String result;
    //Announce winners
    //Gano A Favor
    if (aFavor > enContra && aFavor > abstenido) {
      result = "Pasa la moci??n con $aFavor votos a favor.\n";
    }
    //Gano En Contra
    else if (enContra > aFavor && enContra > abstenido) {
      result = "No pasa la moci??n con $enContra votos en contra.\n";
    }
    //Gano Abstenido
    else if ((abstenido > enContra) && (abstenido > aFavor)) {
      result = "No se decide en la moci??n con $abstenido votos abtenidos.\n";
    }
    // Hubo empate
    // A favor = En Contra
    else if ((aFavor) == (enContra) && (aFavor) > (abstenido)) {
      result =
          "No hay decision en moci??n por empate a $aFavor votos a favor y en contra.\n";
    }
    // A favor = abstenido
    else if ((aFavor) == (abstenido) && (aFavor) > (enContra)) {
      result =
          "No hay decision en moci??n por empate a $aFavor votos a favor y abstenidos.\n";
    }
    // Abstenido = en contra
    else if ((enContra) == (abstenido) && (enContra) > (abstenido)) {
      result =
          "No hay decision en moci??n por empate a $enContra votos en contra y abstenidos.\n";
    }
    //Triple empate
    else if ((enContra) == (abstenido) && (enContra) == (aFavor)) {
      result = "Hay un triple empate a $enContra votos.\n";
    }
    return result;
  }

  String announceWinnerAmend(int aFavor, int abstenido, int enContra) {
    String result;
    //Announce winners
    //Gano A Favor
    if (aFavor > enContra && aFavor > abstenido) {
      result = "Pasa la enmienda con $aFavor votos a favor.\n";
    }
    //Gano En Contra
    else if (enContra > aFavor && enContra > abstenido) {
      result = "No pasa la enmienda con $enContra votos en contra.\n";
    }
    //Gano Abstenido
    else if ((abstenido > enContra) && (abstenido > aFavor)) {
      result = "No se decide en la enmienda con $abstenido votos abtenidos.\n";
    }
    // Hubo empate
    // A favor = En Contra
    else if ((aFavor) == (enContra) && (aFavor) > (abstenido)) {
      result =
          "No hay decision en la enmienda por empate a $aFavor votos a favor y en contra.\n";
    }
    // A favor = abstenido
    else if ((aFavor) == (abstenido) && (aFavor) > (enContra)) {
      result =
          "No hay decision en la enmienda por empate a $aFavor votos a favor y abstenidos.\n";
    }
    // Abstenido = en contra
    else if ((enContra) == (abstenido) && (enContra) > (abstenido)) {
      result =
          "No hay decision en la enmienda por empate a $enContra votos en contra y abstenidos.\n";
    }
    //Triple empate
    else if ((enContra) == (abstenido) && (enContra) == (aFavor)) {
      result = "Hay un triple empate a $enContra votos.\n";
    }
    return result;
  }

  Future<void> refreshResults() async {
    _refreshIndicatorKey.currentState?.show();
    await Future.delayed(Duration(seconds: 1));

    Future<List<Motions>> _motions = Motions.fetchMotions();
    setState(() {
      futureAssemblies = _motions;
    });
  }
}
