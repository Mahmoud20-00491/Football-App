import 'package:flutter/material.dart';
import 'package:football_app/home_page.dart';
import 'package:football_app/next_matches.dart';
import 'package:football_app/playing_matches.dart';
import 'package:page_transition/page_transition.dart';

class NavBar extends StatelessWidget {
  const NavBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 55,
      decoration: const BoxDecoration(
        color: Colors.blue,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    PageTransition(
                        type: PageTransitionType.fade, child: NextMatch()));
              },
              child: Column(
                children: [
                  Icon(
                    Icons.home,
                    color: Colors.white,
                    size: 30,
                  ),
                  Text('Matches', style: TextStyle(color: Colors.white))
                ],
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    PageTransition(
                        type: PageTransitionType.fade, child: HomePage()));
              },
              child: Column(
                children: [
                  Icon(
                    Icons.schedule,
                    color: Colors.white,
                    size: 30,
                  ),
                  Text('Schedules', style: TextStyle(color: Colors.white))
                ],
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    PageTransition(
                        type: PageTransitionType.fade, child: PlayingNow()));
              },
              child: Column(
                children: [
                  Image.asset(
                    'assets/football.png',
                    width: 30,
                    height: 30,
                    color: Colors.white,
                  ),
                  Text('Playing Now', style: TextStyle(color: Colors.white))
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
