import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:scan_n_vote/components/backdrop.dart';
import 'package:scan_n_vote/models/past_assemblies_model.dart';

class PastAssembliesBody extends StatefulWidget {
  @override
  _PastAssembliesBodyState createState() => _PastAssembliesBodyState();
}

class _PastAssembliesBodyState extends State<PastAssembliesBody> {
  Future<List<PastAssemblies>> pastAssemblies;
  var _refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();

  @override
  void initState() {
    super.initState();
    pastAssemblies = PastAssemblies.browsePastAssemblies();
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
                    if (snapshot.hasError) {
                      return Text(
                        "There was an error: ${snapshot.error}",
                      );
                    }
                    //snapshot.data holds the results of the future
                    var pastAssemblies = snapshot.data;
                    return RefreshIndicator(
                      key: _refreshIndicatorKey,
                      onRefresh: () async {
                        return refreshPastAssemblies();
                      },
                      child: ListView.separated(
                        itemCount: pastAssemblies.length,
                        separatorBuilder: (BuildContext context, int index) =>
                            Divider(),
                        itemBuilder: (BuildContext context, int index) {
                          PastAssemblies assembly = pastAssemblies[index];
                          return Container(
                            padding: EdgeInsets.symmetric(horizontal: 15),
                            margin: EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8)),
                              border: Border.all(
                                  color: Theme.of(context).primaryColor),
                            ),
                            child: ExpansionTile(
                              title: Text(
                                "Date: " + assembly.date,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                              children: <Widget>[
                                ExpansionTile(
                                  title: Text(
                                    "Motions",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                    ),
                                  ),
                                  children: [
                                    Text(
                                      assembly.motions.toString(),
                                      style: TextStyle(
                                        fontSize: 18,
                                      ),
                                    ),
                                  ],
                                ),
                                // ),
                                ExpansionTile(
                                  title: Text(
                                    "Amendments",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                    ),
                                  ),
                                  children: [
                                    Text(
                                      assembly.amendments.toString(),
                                      style: TextStyle(fontSize: 18),
                                    ),
                                  ],
                                ),
                                ExpansionTile(
                                  title: Text(
                                    "Results",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                    ),
                                  ),
                                  children: [
                                    Text(
                                      assembly.results.toString(),
                                      style: TextStyle(fontSize: 18),
                                    ),
                                  ],
                                ),
                                Padding(
                                  padding: EdgeInsets.only(
                                      left: 15, top: 20, bottom: 20),
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      "Quorum: " + assembly.quorum,
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
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

  Future<void> refreshPastAssemblies() async {
    _refreshIndicatorKey.currentState?.show();
    await Future.delayed(Duration(seconds: 1));

    Future<List<PastAssemblies>> _pastAssemblies =
        PastAssemblies.browsePastAssemblies();
    setState(() {
      pastAssemblies = _pastAssemblies;
    });
  }
}

// class BasicTileWidget extends StatelessWidget {
//   final BasicTile tile;

//   const BasicTileWidget({
//     Key key,
//     @required this.tile,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     final title = tile.title;
//     final tiles = tile.tiles;

//     if (tiles.isEmpty) {
//       return ListTile(
//         title: Text(title),
//         onTap: () {},
//       );
//     } else {
//       return Container(
//         margin: EdgeInsets.all(16),
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.all(Radius.circular(8)),
//           border: Border.all(color: Theme.of(context).primaryColor),
//         ),
//         child: ExpansionTile(
//           key: PageStorageKey(title),
//           title: Text(title),
//           children: tiles.map((tile) => BasicTileWidget(tile: tile)).toList(),
//         ),
//       );
//     }
//   }
// }
