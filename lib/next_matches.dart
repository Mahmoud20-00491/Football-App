import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:football_app/nav_bar.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';

class NextMatch extends StatefulWidget {
  const NextMatch({Key? key}) : super(key: key);

  @override
  _NextMatchState createState() => _NextMatchState();
}

class _NextMatchState extends State<NextMatch> {
  List<dynamic> matches = [];

  @override
  void initState() {
    super.initState();
    fetchMatches(
        Uri.parse('https://api.football-data.org/v4/competitions/PL/matches'));
  }

  Future<void> fetchMatches(final url) async {
    final response = await http.get(
      url,
      headers: {'X-Auth-Token': '30c321e5d0e04d48a564fa203db0c83a'},
    );

    if (response.statusCode == 200) {
      try {
        final data = jsonDecode(response.body);
        setState(() {
          matches = data['matches'];
        });
      } catch (e) {
        print('Failed to parse JSON response: $e');
      }
    } else {
      print('Failed to fetch matches');
    }
  }

  Widget buildImage(String? imageUrl) {
    if (imageUrl != null && imageUrl.endsWith('.svg')) {
      return SvgPicture.network(
        imageUrl,
        placeholderBuilder: (context) => CircularProgressIndicator(),
      );
    } else {
      return FutureBuilder(
        future: precacheImage(NetworkImage(imageUrl ?? ''), context),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError) {
              return Text('0');
            } else {
              return Image.network(imageUrl ?? '');
            }
          } else {
            return CircularProgressIndicator();
          }
        },
      );
    }
  }

  List<String> leagues = ['Premier League', 'La Liga', 'Bundesliga', 'Serie A'];
  int selectedLeagueIndex = 0; // Initially no league is selected

  String getFormattedDate(DateTime utcDate) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final tomorrow = today.add(Duration(days: 1));
    final todayDate = DateFormat('dd-MM-yyyy').format(today);
    final matchDate = DateFormat('dd-MM-yyyy').format(utcDate);
    final tomorrowDate = DateFormat('dd-MM-yyyy').format(tomorrow);

    if (matchDate == (todayDate)) {
      return 'Today';
    } else if (matchDate == tomorrowDate) {
      return 'Tomorrow';
    } else {
      return DateFormat('dd-MM-yyyy').format(utcDate);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: NavBar(),
      backgroundColor: Colors.grey[300],
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(
              height: 30,
            ),
            Text(
              'Matches',
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
                          fetchMatches(Uri.parse(
                              'https://api.football-data.org/v4/competitions/PL/matches'));
                        }

                        if (index == 1) {
                          fetchMatches(Uri.parse(
                              'https://api.football-data.org/v4/competitions/PD/matches'));
                        }
                        if (index == 2) {
                          fetchMatches(Uri.parse(
                              'https://api.football-data.org/v4/competitions/BL1/matches'));
                        }
                        if (index == 3) {
                          fetchMatches(Uri.parse(
                              'https://api.football-data.org/v4/competitions/SA/matches'));
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
                itemCount: matches.length,
                itemBuilder: (context, index) {
                  final match = matches[index];
                  final homeTeam = match['homeTeam'];
                  final awayTeam = match['awayTeam'];

                  if (match['status'] == 'FINISHED' ||
                      match['status'] == 'IN_PLAY' ||
                      match['status'] == 'PAUSED') {
                    return SizedBox(); // Exclude finished matches from the ListView
                  }
                  final utcDate = DateTime.parse(match['utcDate']);
                  final formattedTime = DateFormat.jm()
                      .format(utcDate.toLocal().add(Duration(hours: 1)));
                  final formattedDate = getFormattedDate(utcDate);

                  if (formattedDate.isEmpty) {
                    return SizedBox(
                        height: 30); // Display a SizedBox for other dates
                  }

                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Container(
                              height: 50,
                              width: 50,
                              child: buildImage(homeTeam['crest']),
                            ),
                            Column(
                              children: [
                                Text(
                                  formattedDate,
                                  style: TextStyle(
                                    color: Colors.blue,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 5),
                                Text(
                                  "${homeTeam['shortName']} vs ${awayTeam['shortName']}",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                SizedBox(height: 5),
                                Row(
                                  children: [
                                    Text(
                                      "Time: ",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w500),
                                    ),
                                    Text(
                                      formattedTime,
                                      style: TextStyle(
                                        color: Colors.blue,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            Container(
                              height: 50,
                              width: 50,
                              child: buildImage(awayTeam['crest']),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
