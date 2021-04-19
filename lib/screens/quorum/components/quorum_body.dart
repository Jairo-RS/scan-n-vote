import 'dart:convert';

import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:scan_n_vote/components/backdrop.dart';
import 'package:scan_n_vote/models/quorum.dart';
import 'package:http/http.dart' as http;

class QuorumBody extends StatefulWidget {
  @override
  _QuorumBodyState createState() => _QuorumBodyState();
}

class _QuorumBodyState extends State<QuorumBody> {
  List<QuorumCount> quorum = const [];

  Future loadQuorum() async {
    // Reading from local JSON file
    // String content =
    //     await rootBundle.loadString('assets/json/quorum_count.json');
    //  End Reading from local JSON file

    // Reading from a remote server/file
    Uri url = Uri.parse(
        'https://run.mocky.io/v3/4f0b1c90-4de3-4d96-b84c-74e1814b1be4');
    http.Response response = await http.get(url);
    String content = response.body;
    // End reading from a remote server/file

    List collection = json.decode(content);
    List<QuorumCount> _quorum =
        collection.map((json) => QuorumCount.fromJson(json)).toList();

    //print(content);
    //
    //Link with associated json file
    //https://run.mocky.io/v3/4f0b1c90-4de3-4d96-b84c-74e1814b1be4
    //
    //

    setState(() {
      quorum = _quorum;
    });
  }

  void initState() {
    loadQuorum();
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
                "Quorum Count",
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
                child: ListView.builder(
                  itemCount: quorum.length,
                  itemBuilder: (BuildContext context, int index) {
                    QuorumCount quorumCount = quorum[index];
                    if (quorumCount.currentQuorum == null) {
                      quorumCount.currentQuorum = "Assembly has not started";
                    }
                    return Column(
                      children: [
                        Align(
                          alignment: Alignment.topCenter,
                          child: Text(
                            'The current attendance count is:\n',
                            style: TextStyle(
                              fontSize: 19,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.center,
                          child: Text(
                            quorumCount.currentQuorum + "\n",
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.center,
                          child: Text(
                            'of ' +
                                quorumCount.quorumNeeded +
                                ' total needed \n   to reach quorum.\n',
                            style: TextStyle(
                              fontSize: 19,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
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
}
