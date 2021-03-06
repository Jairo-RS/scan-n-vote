import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:scan_n_vote/models/assemblies_model.dart';
import 'package:scan_n_vote/models/motions_model.dart';

//Class that displays all details for all tabs for each past assembly
//Display motions tab, agenda tab, and quorum tab
class PastAssembliesDetailsScreen extends StatefulWidget {
  final Assemblies pastAssembly;

  PastAssembliesDetailsScreen({Key key, @required this.pastAssembly})
      : super(key: key);

  @override
  _PastAssembliesDetailsScreenState createState() =>
      _PastAssembliesDetailsScreenState();
}

class _PastAssembliesDetailsScreenState
    extends State<PastAssembliesDetailsScreen> {
  Future<List<Motions>> futureMotions;

  @override
  void initState() {
    super.initState();
    futureMotions = Motions.fetchMotions();
  }

  @override
  Widget build(BuildContext context) {
    //Used for total height and width of the screen
    Size size = MediaQuery.of(context).size;
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            widget.pastAssembly.assemblyName,
            style: TextStyle(fontSize: 26),
          ),
          centerTitle: true,
          bottom: TabBar(
            labelStyle: TextStyle(fontSize: 16),
            tabs: <Widget>[
              Tab(
                text: "Motions",
              ),
              Tab(
                text: "Agenda",
              ),
              Tab(
                text: "Quorum",
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: <Widget>[
            //First Tab: Motions tab
            FutureBuilder(
              future: futureMotions,
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
                      itemCount: pastMotions.length,
                      separatorBuilder: (BuildContext context, int index) {
                        return SizedBox(
                          height: size.height * 0.03,
                        );
                      },
                      itemBuilder: (BuildContext context, int index) {
                        Motions pastMotion = pastMotions[index];
                        if (widget.pastAssembly.archived == true &&
                            pastMotion.assemblyID == widget.pastAssembly.pk) {
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
                                  offset: Offset(0, 3), //Position of shadow
                                )
                              ],
                            ),
                            child: Column(
                              children: [
                                Text(
                                  "Moci??n",
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
                                    i < pastMotion.originalMotion.length;
                                    i++)
                                  Text(
                                    "??? " + pastMotion.originalMotion[i].motion,
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
                                  announceWinner(pastMotion.favor,
                                      pastMotion.abstained, pastMotion.agaisnt),
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
                    );
                }
              },
            ),

            //Second tab: Agenda tab
            SingleChildScrollView(
              child: Column(
                children: [
                  if (widget.pastAssembly.archived == true)
                    SizedBox(
                      height: size.height * 0.05,
                    ),
                  Text(
                    'Agenda',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 34,
                    ),
                  ),
                  SizedBox(
                    height: size.height * 0.05,
                  ),
                  Container(
                    width: size.width * 0.85,
                    // height: size.height - 250,
                    padding: EdgeInsets.symmetric(horizontal: 15, vertical: 30),
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
                    child: SingleChildScrollView(
                      child: Text(
                        widget.pastAssembly.agenda,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            //Third tab: Quorum tab
            SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    height: size.height * 0.05,
                  ),
                  Text(
                    'Qu??rum',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 34,
                    ),
                  ),
                  SizedBox(
                    height: size.height * 0.05,
                  ),
                  Container(
                    width: size.width * 0.85,
                    padding: EdgeInsets.symmetric(horizontal: 15, vertical: 30),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: Offset(0, 3), //Position of shadow
                        )
                      ],
                    ),
                    child: SingleChildScrollView(
                      child: Text(
                        "El qu??rum m??ximo de esta asamblea fue:\n" +
                            widget.pastAssembly.quorum.toString(),
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: size.height * 0.05,
                  ),
                  SvgPicture.asset(
                    "assets/icons/undraw_team.svg",
                    height: size.height * 0.28,
                  ),
                ],
              ),
            ),
          ],
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
}
