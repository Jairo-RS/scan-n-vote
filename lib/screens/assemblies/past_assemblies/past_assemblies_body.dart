// import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:scan_n_vote/components/backdrop.dart';
import 'package:scan_n_vote/models/assemblies_model.dart';
import 'package:scan_n_vote/models/past_assemblies_model.dart';
import 'package:scan_n_vote/screens/assemblies/past_assemblies/past_assemblies_details.dart';

//Class contains all the widgets that will be displayed in PastAssemblies screen
class PastAssembliesBody extends StatefulWidget {
  @override
  _PastAssembliesBodyState createState() => _PastAssembliesBodyState();
}

class _PastAssembliesBodyState extends State<PastAssembliesBody> {
  Future<List<Assemblies>> pastAssemblies;
  var _refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();

  @override
  void initState() {
    super.initState();
    pastAssemblies = Assemblies.fetchAssemblies();
  }

  @override
  Widget build(BuildContext context) {
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
          title: Text(
            'Past Assemblies',
            style: TextStyle(fontSize: 30, color: Colors.black),
          ),
          centerTitle: true,
          backgroundColor: Colors.transparent,
          elevation: 0,
          iconTheme: IconThemeData(color: Colors.black),
        ),
        body: Backdrop(
          child: Center(
            //Widget that builds itself based on latest snapshot (obtained state)
            child: FutureBuilder(
              future: pastAssemblies,
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
                    //If receive error from latest snapshot, display the error
                    if (snapshot.hasError) {
                      return Text(
                        "There was an error: ${snapshot.error}",
                      );
                    }
                    //snapshot.data holds the results of the future
                    var pastAssemblies = snapshot.data;
                    //RefreshIndicator: Pull to refresh feature
                    return RefreshIndicator(
                      key: _refreshIndicatorKey,
                      onRefresh: () async {
                        return refreshPastAssemblies();
                      },
                      //Creates a list of all past assemblies
                      child: ListView.separated(
                        itemCount: pastAssemblies.length,
                        separatorBuilder: (BuildContext context, int index) =>
                            Divider(), //Separates each item on the list
                        itemBuilder: (BuildContext context, int index) {
                          Assemblies assembly = pastAssemblies[index];
                          if (assembly.archived == true) {
                            return Container(
                              padding: EdgeInsets.symmetric(horizontal: 15),
                              margin: EdgeInsets.all(15),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8)),
                                border: Border.all(
                                    color: Theme.of(context).primaryColor),
                              ),
                              //Dropdown feature for each past assembly
                              child: ListTile(
                                title: Text(
                                  assembly.assemblyName,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                                ),
                                trailing: IconButton(
                                  icon: Icon(Icons.arrow_forward),
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            PastAssembliesDetailsScreen(
                                                pastAssembly: assembly),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            );
                          } else {
                            return Text("");
                          }
                          // return Container(
                          //   padding: EdgeInsets.symmetric(horizontal: 15),
                          //   margin: EdgeInsets.all(15),
                          //   decoration: BoxDecoration(
                          //     color: Colors.white,
                          //     borderRadius:
                          //         BorderRadius.all(Radius.circular(8)),
                          //     border: Border.all(
                          //         color: Theme.of(context).primaryColor),
                          //   ),
                          //   //Dropdown feature for each past assembly
                          //   child: ListTile(
                          //     title: Text(
                          //       "Date: " + assembly.assemblyName,
                          //       style: TextStyle(
                          //         fontWeight: FontWeight.bold,
                          //         fontSize: 18,
                          //       ),
                          //     ),
                          //     trailing: IconButton(
                          //       icon: Icon(Icons.arrow_forward),
                          //       onPressed: () {
                          //         Navigator.push(
                          //           context,
                          //           MaterialPageRoute(
                          //             builder: (context) =>
                          //                 PastAssembliesDetailsScreen(
                          //                     pastAssembly: assembly),
                          //           ),
                          //         );
                          //       },
                          //     ),
                          //     // children: <Widget>[
                          //     //   ExpansionTile(
                          //     //     title: Text(
                          //     //       "Motions",
                          //     //       style: TextStyle(
                          //     //         fontWeight: FontWeight.bold,
                          //     //         fontSize: 18,
                          //     //       ),
                          //     //     ),
                          //     //     children: [
                          //     //       Text(
                          //     //         assembly.motions.toString(),
                          //     //         style: TextStyle(
                          //     //           fontSize: 18,
                          //     //         ),
                          //     //       ),
                          //     //     ],
                          //     //   ),
                          //     //   // ),
                          //     //   ExpansionTile(
                          //     //     title: Text(
                          //     //       "Amendments",
                          //     //       style: TextStyle(
                          //     //         fontWeight: FontWeight.bold,
                          //     //         fontSize: 18,
                          //     //       ),
                          //     //     ),
                          //     //     children: [
                          //     //       Text(
                          //     //         assembly.amendments.toString(),
                          //     //         style: TextStyle(fontSize: 18),
                          //     //       ),
                          //     //     ],
                          //     //   ),
                          //     //   ExpansionTile(
                          //     //     title: Text(
                          //     //       "Results",
                          //     //       style: TextStyle(
                          //     //         fontWeight: FontWeight.bold,
                          //     //         fontSize: 18,
                          //     //       ),
                          //     //     ),
                          //     //     children: [
                          //     //       Text(
                          //     //         assembly.results.toString(),
                          //     //         style: TextStyle(fontSize: 18),
                          //     //       ),
                          //     //     ],
                          //     //   ),
                          //     //   Padding(
                          //     //     padding: EdgeInsets.only(
                          //     //         left: 15, top: 20, bottom: 20),
                          //     //     child: Align(
                          //     //       alignment: Alignment.centerLeft,
                          //     //       child: Text(
                          //     //         "Quorum: " + assembly.quorum,
                          //     //         style: TextStyle(
                          //     //           fontSize: 18,
                          //     //           fontWeight: FontWeight.bold,
                          //     //         ),
                          //     //       ),
                          //     //     ),
                          //     //   ),
                          //     // ],
                          //   ),
                          // );
                        },
                      ),
                    );
                }
              },
            ),
          ),
        ),
      ),
    );
  }

  //Method that helps refresh the screen. Builds a new state.
  Future<void> refreshPastAssemblies() async {
    _refreshIndicatorKey.currentState?.show();
    await Future.delayed(Duration(seconds: 1));

    Future<List<Assemblies>> _pastAssemblies = Assemblies.fetchAssemblies();
    setState(() {
      pastAssemblies = _pastAssemblies;
    });
  }
}
