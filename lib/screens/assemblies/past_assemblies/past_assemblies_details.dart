import 'package:flutter/material.dart';
import 'package:scan_n_vote/models/past_assemblies_model.dart';

class PastAssembliesDetailsScreen extends StatelessWidget {
  final PastAssemblies pastAssembly;

  const PastAssembliesDetailsScreen({Key key, @required this.pastAssembly})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            pastAssembly.date,
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
                text: "Amendments",
              ),
              Tab(
                text: "Quorum",
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: <Widget>[
            Center(
              child: Text('Test: Motions'),
            ),
            Center(
              child: Text('Test: Amendments'),
            ),
            Center(
              child: Text('Test: Quorum'),
            ),
          ],
        ),
      ),
    );
  }
}
