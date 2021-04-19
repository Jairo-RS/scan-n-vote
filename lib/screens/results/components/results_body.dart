import 'dart:convert';

import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:scan_n_vote/components/backdrop.dart';
import 'package:scan_n_vote/models/results.dart';
import 'package:http/http.dart' as http;

class ResultsBody extends StatefulWidget {
  @override
  _ResultsBodyState createState() => _ResultsBodyState();
}

class _ResultsBodyState extends State<ResultsBody> {
  List<VotingResults> results = const [];
  Future loadResults() async {
    // Reading from local JSON file
    //  String content = await rootBundle.loadString('assets/json/results.json');
    //  End Reading from local JSON file

    // Reading from a remote server/file
    Uri url = Uri.parse(
        'https://run.mocky.io/v3/210d6c65-c964-42ea-9a60-d4e6af3e1fee');
    http.Response response = await http.get(url);
    String content = response.body;
    // End reading from a remote server/file

    List collection = json.decode(content);
    List<VotingResults> _results =
        collection.map((json) => VotingResults.fromJson(json)).toList();

    //print(content);

    setState(() {
      results = _results;
    });
  }

  void initState() {
    loadResults();
    super.initState();
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
                "Vote Results",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 36,
                ),
              ),
              SizedBox(height: size.height * 0.05),
              Container(
                height: 270,
                width: size.width * 0.8,
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
                child: ListView.builder(
                  itemCount: results.length,
                  itemBuilder: (BuildContext context, int index) {
                    VotingResults resultsCount = results[index];

                    return Column(
                      children: [
                        Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            'A Favor:                               ' +
                                resultsCount.aFavor +
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
                            'Abstenidos:                         ' +
                                resultsCount.abstenido +
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
                                resultsCount.enContra +
                                "\n",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
              SizedBox(height: size.height * 0.05),
              SvgPicture.asset(
                "assets/icons/undraw_election.svg",
                height: size.height * 0.15,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
