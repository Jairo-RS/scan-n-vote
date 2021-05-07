import 'package:flutter/material.dart';
import 'package:numerus/numerus.dart';
import 'package:scan_n_vote/components/backdrop.dart';
import 'package:scan_n_vote/models/assemblies_model.dart';

class AgendaBody extends StatefulWidget {
  @override
  _AgendaBodyState createState() => _AgendaBodyState();
}

class _AgendaBodyState extends State<AgendaBody> {
  Future<List<Assemblies>> futureAssemblies;
  // Future<List<AgendaEntry>> agendaEntries;
  var _refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();

  @override
  void initState() {
    super.initState();
    // agendaEntries = AgendaEntry.browse();
    futureAssemblies = Assemblies.fetchAssemblies();
    // refreshAgenda();
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
          backgroundColor: Colors.transparent,
          elevation: 0,
          iconTheme: IconThemeData(color: Colors.black),
        ),
        body: Backdrop(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                SizedBox(
                  height: size.height * 0.13,
                ),
                Text(
                  'Agenda',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 40,
                  ),
                ),
                SizedBox(
                  height: size.height * 0.07,
                ),
                Container(
                  width: size.width * 0.85,
                  height: size.height - 250,
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
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
                                separatorBuilder: (context, index) =>
                                    SizedBox(),
                                // ignore: missing_return
                                itemBuilder: (BuildContext context, int index) {
                                  Assemblies assemblies = agenda[index];
                                  if (assemblies.archived == false) {
                                    return Text(
                                      assemblies.agenda,
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
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  //Used to refresh and fetch any new data from the agenda
  Future<void> refreshAgenda() async {
    _refreshIndicatorKey.currentState?.show();
    await Future.delayed(Duration(seconds: 1));

    Future<List<Assemblies>> _assemblies = Assemblies.fetchAssemblies();
    setState(() {
      futureAssemblies = _assemblies;
    });
  }
}
