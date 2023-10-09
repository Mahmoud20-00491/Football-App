import 'dart:convert';
import 'package:flutter_svg/svg.dart';
import 'package:football_app/nav_bar.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class PlayingNow extends StatefulWidget {
  @override
  _PlayingNowState createState() => _PlayingNowState();
}

class _PlayingNowState extends State<PlayingNow> {
  List<String> leagues = ['Premier League', 'La Liga', 'Bundesliga', 'Serie A'];
  int selectedLeagueIndex = 0;
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
              return Image.network(
                imageUrl ?? '',
                height: 40,
                width: 40,
              );
            }
          } else {
            return CircularProgressIndicator();
          }
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: NavBar(),
      backgroundColor: Colors.grey[200],
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(
              height: 30,
            ),
            Text(
              'Playing Now',
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
                  final homeScore = match['score']['fullTime']['home'];
                  final awayScore = match['score']['fullTime']['away'];
                  final utcDate = DateTime.parse(match['utcDate']).toLocal();

                  var lastUpdated = DateTime.now().difference(utcDate);
                  int minutes = lastUpdated.inMinutes - 18;
                  int seconds = (lastUpdated.inSeconds) % 60;

                  if (match['status'] == 'IN_PLAY') {
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8.0, horizontal: 8),
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
                                    "${homeTeam['shortName']}  vs  ${awayTeam['shortName']}",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16),
                                  ),
                                  SizedBox(height: 10),
                                  Row(
                                    children: [
                                      Text(
                                        "$minutes : $seconds",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 10),
                                  Text(
                                    '$homeScore : $awayScore',
                                    style: TextStyle(
                                      color: Colors.blue,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                    ),
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
                  } else if (match['status'] == 'PAUSED') {
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8.0, horizontal: 8),
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
                                    "${homeTeam['shortName']}  vs  ${awayTeam['shortName']}",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16),
                                  ),
                                  SizedBox(height: 10),
                                  Row(
                                    children: [
                                      Text(
                                        "Half Time",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 10),
                                  Text(
                                    '$homeScore : $awayScore',
                                    style: TextStyle(
                                      color: Colors.blue,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                    ),
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
                  } else if (match['score']['fullTime']['home'] != null &&
                      match['status'] == 'IN_PLAY') {
                    minutes = minutes - 18;
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8.0, horizontal: 8),
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
                                    "${homeTeam['shortName']}  vs  ${awayTeam['shortName']}",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16),
                                  ),
                                  SizedBox(height: 10),
                                  Row(
                                    children: [
                                      Text(
                                        "$minutes : $seconds",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 10),
                                  Text(
                                    '$homeScore : $awayScore',
                                    style: TextStyle(
                                      color: Colors.blue,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                    ),
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
                  } else {
                    return SizedBox();
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
