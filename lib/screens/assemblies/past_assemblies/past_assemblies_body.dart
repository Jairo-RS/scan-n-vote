import 'package:flutter/material.dart';

class PastAssembliesBody extends StatefulWidget {
  @override
  _PastAssembliesBodyState createState() => _PastAssembliesBodyState();
}

class _PastAssembliesBodyState extends State<PastAssembliesBody> {
  //This list is used for early testing (not final)
  var assemblies = const [
    {
      "date": "First date",
      "motions": [
        [
          "First motion",
        ],
        [
          "Second motion",
        ],
        [
          "Third motion",
        ],
        [
          "Fourth motion",
        ],
      ],
      "amendments": [
        [
          "Amendment for first motion",
        ],
        [
          "First amendment for second motion",
          "Second amendment for second motion",
          "Third amendment for second motion",
        ],
        [
          "Amendment for third motion",
        ],
        [
          "First amendment for fourth motion",
          "Second amendment for fourth motion"
        ],
      ],
      "results": [
        [
          "Result of first motion",
        ],
        [
          "Result of second motion",
        ],
        [
          "Result of third motion",
        ],
        [
          "Result of fourth motion",
        ],
      ],
    },
    {
      "date": "Second date",
      "motions": [
        "First motion",
        "Second motion",
      ],
      "amendments": [
        [
          "Amendment for first motion",
        ],
        [
          "First amendment for second motion",
          "Second amendment for second motion",
        ],
      ],
      "results": [
        [
          "Result of first motion",
        ],
        [
          "Result of second motion",
        ],
      ],
    },
    {
      "date": "Third date",
      "motions": [
        "First motion",
        "Second motion",
        "Third motion",
      ],
      "amendments": [
        [
          "Amendment for first motion",
        ],
        [
          "Amendment for second motion",
        ],
      ],
      "results": [
        [
          "Result of first motion",
        ],
        [
          "Result of second motion",
        ],
        [
          "Result of third motion",
        ],
      ],
    },
  ];

  @override
  Widget build(BuildContext context) {
    //Used for total height and width of the screen
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Past Assemblies',
          style: TextStyle(fontSize: 30),
        ),
        centerTitle: true,
      ),
      body: ListView.separated(
        itemCount: assemblies.length,
        separatorBuilder: (BuildContext context, int index) => Divider(),
        itemBuilder: (BuildContext context, int index) {
          var assembly = assemblies[index];
          return Container(
            padding: EdgeInsets.symmetric(horizontal: 15),
            margin: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(8)),
              border: Border.all(color: Theme.of(context).primaryColor),
            ),
            child: ExpansionTile(
              title: Text(
                "${index + 1}. " + assembly["date"],
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              children: [
                // Container(
                // margin: EdgeInsets.all(16),
                // decoration: BoxDecoration(
                //   color: Colors.white,
                //   borderRadius: BorderRadius.all(Radius.circular(8)),
                //   border: Border.all(color: Theme.of(context).primaryColor),
                // ),
                // child:
                ExpansionTile(
                  // key: PageStorageKey(assembly["motions"]),
                  title: Text(
                    "Motions",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  children: [
                    Text(assembly["motions"].toString()),
                  ],
                ),
                // ),
                ExpansionTile(
                  title: Text(
                    "Amendments",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  children: [
                    Text(assembly["amendments"].toString()),
                  ],
                ),
                ExpansionTile(
                  title: Text(
                    "Results",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  children: [
                    Text(assembly["results"].toString()),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
