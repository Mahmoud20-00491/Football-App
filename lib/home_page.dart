import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:football_app/nav_bar.dart';
import 'package:football_app/teamDetails.dart';
import 'package:http/http.dart' as http;
import 'package:page_transition/page_transition.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int selectedLeagueIndex = 0;
  List<String> leagues = ['Premier League', 'La Liga', 'Bundesliga', 'Serie A'];
  Uri url =
      Uri.parse("http://api.football-data.org/v4/competitions/PL/standings");

  @override
  void initState() {
    super.initState();
    getTeam(url);
  }

  Future<List<dynamic>> getTeam(Uri url) async {
    final response = await http.get(
      url,
      headers: {'X-Auth-Token': '30c321e5d0e04d48a564fa203db0c83a'},
    );
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      return data['standings'][0]['table'];
    } else {
      throw Exception('Failed to load team data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: NavBar(),
      backgroundColor: Colors.grey[200],
      body: FutureBuilder<List<dynamic>>(
        future: getTeam(url),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else {
            return SafeArea(
              child: Column(
                children: [
                  SizedBox(
                    height: 30,
                  ),
                  Text(
                    'Standings Leagues',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    height: 60,
                    child: ListView.builder(
                      itemCount: leagues.length,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                selectedLeagueIndex = index;
                              });
                              if (index == 0) {
                                url = Uri.parse(
                                    "http://api.football-data.org/v4/competitions/PL/standings");
                                getTeam(url);
                              } else if (index == 1) {
                                url = Uri.parse(
                                    "http://api.football-data.org/v4/competitions/PD/standings");
                                getTeam(url);
                              } else if (index == 2) {
                                url = Uri.parse(
                                    "http://api.football-data.org/v4/competitions/BL1/standings");
                                getTeam(url);
                              } else if (index == 3) {
                                url = Uri.parse(
                                    "http://api.football-data.org/v4/competitions/SA/standings");
                                getTeam(url);
                              }
                            },
                            child: Container(
                              height: 30,
                              width: 120,
                              decoration: BoxDecoration(
                                color: selectedLeagueIndex == index
                                    ? Colors.blue
                                    : Colors.white,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              alignment: Alignment.center,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  leagues[index],
                                  style: TextStyle(
                                    color: selectedLeagueIndex == index
                                        ? Colors.white
                                        : Colors.black,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, i) {
                        var team = snapshot.data![i]['team'];
                        var position = snapshot.data![i]['position'];
                        var points = snapshot.data![i]['points'];

                        if (team['crest'] != null &&
                            team['crest'].endsWith('.svg')) {
                          return GestureDetector(
                            onTap: () {
                              if (selectedLeagueIndex == 0) {
                                Navigator.push(
                                    context,
                                    PageTransition(
                                        type: PageTransitionType.rightToLeft,
                                        child: TeamDetails(
                                          index: i,
                                          url: Uri.parse(
                                              "http://api.football-data.org/v4/competitions/PL/standings"),
                                        )));
                              } else if (selectedLeagueIndex == 1) {
                                Navigator.push(
                                    context,
                                    PageTransition(
                                        type: PageTransitionType.rightToLeft,
                                        child: TeamDetails(
                                          index: i,
                                          url: Uri.parse(
                                              "http://api.football-data.org/v4/competitions/PD/standings"),
                                        )));
                              } else if (selectedLeagueIndex == 2) {
                                Navigator.push(
                                    context,
                                    PageTransition(
                                        type: PageTransitionType.rightToLeft,
                                        child: TeamDetails(
                                          index: i,
                                          url: Uri.parse(
                                              "http://api.football-data.org/v4/competitions/BL1/standings"),
                                        )));
                              } else {
                                Navigator.push(
                                    context,
                                    PageTransition(
                                        type: PageTransitionType.rightToLeft,
                                        child: TeamDetails(
                                          index: i,
                                          url: Uri.parse(
                                              "http://api.football-data.org/v4/competitions/SA/standings"),
                                        )));
                              }
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                color: Colors.white,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10.0,
                                    vertical: 10,
                                  ),
                                  child: Row(
                                    children: [
                                      Text('$position'),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      SvgPicture.network(
                                        team['crest'],
                                        width: 50,
                                        height: 50,
                                        fit: BoxFit.contain,
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              team['shortName'],
                                              style: TextStyle(fontSize: 16),
                                            ),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            Row(
                                              children: [
                                                Text('Points: '),
                                                Text(
                                                  '$points',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.blue),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        } else {
                          return GestureDetector(
                            onTap: () {
                              if (selectedLeagueIndex == 0) {
                                Navigator.push(
                                    context,
                                    PageTransition(
                                        type: PageTransitionType.rightToLeft,
                                        child: TeamDetails(
                                          index: i,
                                          url: Uri.parse(
                                              "http://api.football-data.org/v4/competitions/PL/standings"),
                                        )));
                              } else if (selectedLeagueIndex == 1) {
                                Navigator.push(
                                    context,
                                    PageTransition(
                                        type: PageTransitionType.rightToLeft,
                                        child: TeamDetails(
                                          index: i,
                                          url: Uri.parse(
                                              "http://api.football-data.org/v4/competitions/PD/standings"),
                                        )));
                              } else if (selectedLeagueIndex == 2) {
                                Navigator.push(
                                    context,
                                    PageTransition(
                                        type: PageTransitionType.rightToLeft,
                                        child: TeamDetails(
                                          index: i,
                                          url: Uri.parse(
                                              "http://api.football-data.org/v4/competitions/BL1/standings"),
                                        )));
                              } else {
                                Navigator.push(
                                    context,
                                    PageTransition(
                                        type: PageTransitionType.rightToLeft,
                                        child: TeamDetails(
                                          index: i,
                                          url: Uri.parse(
                                              "http://api.football-data.org/v4/competitions/SA/standings"),
                                        )));
                              }
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                color: Colors.white,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10.0,
                                    vertical: 10,
                                  ),
                                  child: Row(
                                    children: [
                                      Text('$position'),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Image.network(
                                        team['crest'],
                                        width: 50,
                                        height: 50,
                                        fit: BoxFit.contain,
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              team['name'],
                                              style: TextStyle(fontSize: 16),
                                            ),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            Row(
                                              children: [
                                                Text('Points: '),
                                                Text(
                                                  '$points',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.blue),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        }
                      },
                    ),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
