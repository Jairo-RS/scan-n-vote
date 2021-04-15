import 'package:flutter/material.dart';
import 'package:scan_n_vote/components/backdrop.dart';
import 'package:scan_n_vote/models/agenda_entry.dart';

class AgendaBody extends StatefulWidget {
  @override
  _AgendaBodyState createState() => _AgendaBodyState();
}

class _AgendaBodyState extends State<AgendaBody> {
  Future<List<AgendaEntry>> agendaEntries;

  void initState() {
    super.initState();
    agendaEntries = AgendaEntry.browse();
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
                  child: FutureBuilder(
                    future: agendaEntries,
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
                          var entries = snapshot.data;
                          return RefreshIndicator(
                            onRefresh: () {
                              var _agendaEntries = AgendaEntry.browse();
                              return Future.delayed(
                                Duration(milliseconds: 500), //
                                () {
                                  setState(
                                    () {
                                      agendaEntries = _agendaEntries;
                                    },
                                  );
                                },
                              );
                            },
                            child: ListView.separated(
                              itemCount: entries.length,
                              separatorBuilder: (context, index) => Divider(),
                              itemBuilder: (BuildContext context, int index) {
                                AgendaEntry agenda = entries[index];
                                // return Text('$index Test');
                                return ListTile(
                                  title: Text(
                                    agenda.entry,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                    ),
                                  ),
                                );
                              },
                            ),
                          );
                      }
                    },
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
