import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:scan_n_vote/components/backdrop.dart';
import 'package:scan_n_vote/models/assemblies_model.dart';

class QuorumBody extends StatefulWidget {
  @override
  _QuorumBodyState createState() => _QuorumBodyState();
}

class _QuorumBodyState extends State<QuorumBody> {
  Future<List<Assemblies>> futureAssemblies;
  var _refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();

  void initState() {
    super.initState();
    futureAssemblies = Assemblies.fetchAssemblies();
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
            onPressed: () => Navigator.of(context).pop(),
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
                "Conteo de Quórum",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 36,
                ),
              ),
              SizedBox(height: size.height * 0.02),
              Container(
                height: 225,
                width: size.width * 0.8,
                padding: EdgeInsets.symmetric(horizontal: 20),
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
                          var agenda = snapshot.data;
                          return RefreshIndicator(
                            key: _refreshIndicatorKey,
                            onRefresh: () async {
                              return refreshAgenda();
                            },
                            child: ListView.separated(
                              itemCount: agenda.length,
                              separatorBuilder: (context, index) => SizedBox(),
                              // ignore: missing_return
                              itemBuilder: (BuildContext context, int index) {
                                Assemblies assemblies = agenda[index];
                                if (assemblies.archived == false) {
                                  return Text(
                                    "La asistencia actual \nde esta asamblea es:\n\n" +
                                        assemblies.quorum.toString(),
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                    ),
                                  );
                                }
                              },
                            ),
                          );
                      }
                    },
                  ),
                ),

                // child: ListView.builder(
                //   itemCount: quorum.length,
                //   itemBuilder: (BuildContext context, int index) {
                //     QuorumCount quorumCount = quorum[index];
                //     if (quorumCount.currentQuorum == null) {
                //       quorumCount.currentQuorum = "Assembly has not started";
                //     }
                //     return Column(
                //       children: [
                //         Align(
                //           alignment: Alignment.topCenter,
                //           child: Text(
                //             'The current attendance count is:\n',
                //             style: TextStyle(
                //               fontSize: 19,
                //               fontWeight: FontWeight.bold,
                //             ),
                //           ),
                //         ),
                //         Align(
                //           alignment: Alignment.center,
                //           child: Text(
                //             quorumCount.currentQuorum + "\n",
                //             style: TextStyle(
                //               fontSize: 22,
                //               fontWeight: FontWeight.bold,
                //             ),
                //           ),
                //         ),
                //         Align(
                //           alignment: Alignment.center,
                //           child: Text(
                //             'of ' +
                //                 quorumCount.quorumNeeded +
                //                 ' total needed \n   to reach quorum.\n',
                //             style: TextStyle(
                //               fontSize: 19,
                //               fontWeight: FontWeight.bold,
                //             ),
                //           ),
                //         ),
                //       ],
                //     );
                //   },
                // ),
              ),
              SizedBox(
                height: size.height * 0.02,
              ),
              SvgPicture.asset(
                "assets/icons/undraw_team.svg",
                height: size.height * 0.28,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> refreshAgenda() async {
    _refreshIndicatorKey.currentState?.show();
    await Future.delayed(Duration(seconds: 1));

    Future<List<Assemblies>> _assemblies = Assemblies.fetchAssemblies();
    setState(() {
      futureAssemblies = _assemblies;
    });
  }
}
