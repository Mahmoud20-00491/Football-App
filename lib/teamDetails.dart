import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:http/http.dart' as http;

class TeamDetails extends StatefulWidget {
  TeamDetails({Key? key, required this.index, required this.url})
      : super(key: key);
  final int index;
  final Uri url;

  @override
  State<TeamDetails> createState() => _TeamDetailsState();
}

class _TeamDetailsState extends State<TeamDetails> {
  @override
  void initState() {
    super.initState();
    getTeam(widget.url);
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
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.grey[200],
        iconTheme: IconThemeData(color: Colors.black),
      ),
      backgroundColor: Colors.grey[200],
      body: FutureBuilder<List<dynamic>>(
        future: getTeam(widget.url),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else {
            var team = snapshot.data![widget.index]['team'];
            var position = snapshot.data![widget.index]['position'];
            var points = snapshot.data![widget.index]['points'];
            var playedGames = snapshot.data![widget.index]['playedGames'];

            var won = snapshot.data![widget.index]['won'];
            var draw = snapshot.data![widget.index]['draw'];
            var lost = snapshot.data![widget.index]['lost'];
            var goalsFor = snapshot.data![widget.index]['goalsFor'];
            var goalsAgainst = snapshot.data![widget.index]['goalsAgainst'];
            var goalDifference = snapshot.data![widget.index]['goalDifference'];

            if (team['crest'] != null && team['crest'].endsWith('.svg')) {
              return Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SvgPicture.network(
                      team['crest'],
                      width: 100,
                      height: 100,
                      fit: BoxFit.contain,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Text(
                      team['shortName'],
                      style: const TextStyle(
                          fontSize: 22, fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                    Expanded(
                      child: GridView.count(
                        crossAxisCount: 3,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              height: 100,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(30),
                              ),
                              width: 100,
                              child: Column(
                                children: [
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  const Text(
                                    'Position',
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 14),
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  Text('$position',
                                      style: const TextStyle(
                                          color: Colors.blue,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold)),
                                ],
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              height: 100,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(30),
                              ),
                              width: 100,
                              child: Column(
                                children: [
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  const Text(
                                    'Points',
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 14),
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  Text('$points',
                                      style: const TextStyle(
                                          color: Colors.blue,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold)),
                                ],
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              height: 100,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(30),
                              ),
                              width: 100,
                              child: Column(
                                children: [
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  const Text(
                                    'Played Games',
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 14),
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  Text('$playedGames',
                                      style: const TextStyle(
                                          color: Colors.blue,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold)),
                                ],
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              height: 100,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(30),
                              ),
                              width: 100,
                              child: Column(
                                children: [
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  const Text(
                                    'Won',
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 14),
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  Text('$won',
                                      style: const TextStyle(
                                          color: Colors.blue,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold)),
                                ],
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              height: 100,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(30),
                              ),
                              width: 100,
                              child: Column(
                                children: [
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  const Text(
                                    'Draw',
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 14),
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  Text('$draw',
                                      style: const TextStyle(
                                          color: Colors.blue,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold)),
                                ],
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              height: 100,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(30),
                              ),
                              width: 100,
                              child: Column(
                                children: [
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  const Text(
                                    'Lost',
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 14),
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  Text('$lost',
                                      style: const TextStyle(
                                          color: Colors.blue,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold)),
                                ],
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              height: 100,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(30),
                              ),
                              width: 100,
                              child: Column(
                                children: [
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  const Text(
                                    'Goals For',
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 14),
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  Text('$goalsFor',
                                      style: const TextStyle(
                                          color: Colors.blue,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold)),
                                ],
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              height: 100,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(30),
                              ),
                              width: 100,
                              child: Column(
                                children: [
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  const Text(
                                    'Goals Against',
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 14),
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  Text('$goalsAgainst',
                                      style: const TextStyle(
                                          color: Colors.blue,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold)),
                                ],
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              height: 100,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(30),
                              ),
                              width: 100,
                              child: Column(
                                children: [
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  const Text(
                                    'Goal Difference',
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 14),
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  Text('$goalDifference',
                                      style: const TextStyle(
                                          color: Colors.blue,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold)),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            } else {
              return Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.network(
                      team['crest'],
                      width: 100,
                      height: 100,
                      fit: BoxFit.contain,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Text(
                      team['name'],
                      style: const TextStyle(
                          fontSize: 22, fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                    Expanded(
                      child: GridView.count(
                        crossAxisCount: 3,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              height: 100,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(30),
                              ),
                              width: 100,
                              child: Column(
                                children: [
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  const Text(
                                    'Position',
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 14),
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  Text('$position',
                                      style: const TextStyle(
                                          color: Colors.blue,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold)),
                                ],
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              height: 100,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(30),
                              ),
                              width: 100,
                              child: Column(
                                children: [
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  const Text(
                                    'Points',
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 14),
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  Text('$points',
                                      style: const TextStyle(
                                          color: Colors.blue,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold)),
                                ],
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              height: 100,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(30),
                              ),
                              width: 100,
                              child: Column(
                                children: [
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  const Text(
                                    'Played Games',
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 14),
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  Text('$playedGames',
                                      style: const TextStyle(
                                          color: Colors.blue,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold)),
                                ],
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              height: 100,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(30),
                              ),
                              width: 100,
                              child: Column(
                                children: [
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  const Text(
                                    'Won',
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 14),
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  Text('$won',
                                      style: const TextStyle(
                                          color: Colors.blue,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold)),
                                ],
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              height: 100,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(30),
                              ),
                              width: 100,
                              child: Column(
                                children: [
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  const Text(
                                    'Draw',
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 14),
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  Text('$draw',
                                      style: const TextStyle(
                                          color: Colors.blue,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold)),
                                ],
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              height: 100,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(30),
                              ),
                              width: 100,
                              child: Column(
                                children: [
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  const Text(
                                    'Lost',
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 14),
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  Text('$lost',
                                      style: const TextStyle(
                                          color: Colors.blue,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold)),
                                ],
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              height: 100,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(30),
                              ),
                              width: 100,
                              child: Column(
                                children: [
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  const Text(
                                    'Goals For',
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 14),
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  Text('$goalsFor',
                                      style: const TextStyle(
                                          color: Colors.blue,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold)),
                                ],
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              height: 100,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(30),
                              ),
                              width: 100,
                              child: Column(
                                children: [
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  const Text(
                                    'Goals Against',
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 14),
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  Text('$goalsAgainst',
                                      style: const TextStyle(
                                          color: Colors.blue,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold)),
                                ],
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              height: 100,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(30),
                              ),
                              width: 100,
                              child: Column(
                                children: [
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  const Text(
                                    'Goal Difference',
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 14),
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  Text('$goalDifference',
                                      style: const TextStyle(
                                          color: Colors.blue,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold)),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }
          }
        },
      ),
    );
  }
}
