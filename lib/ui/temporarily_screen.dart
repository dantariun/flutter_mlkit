import 'package:flutter/material.dart';
import 'package:mlkit_test/ui/home_screen.dart';
import 'package:mlkit_test/ui/prepare_liveness_screen.dart';
import 'package:mlkit_test/ui/widget/menu_button.dart';

class TemporarilyScreen extends StatelessWidget {
  const TemporarilyScreen({super.key});

  void _onNextPressed(BuildContext context) {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const PrepareLivenessScreen(),
        ));
  }

  void _gotoMain(BuildContext context) {
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const HomeScreen()),
        (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 21, vertical: 93),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(
              height: 269,
            ),
            Image.asset('assets/images/seeu_logo_large.png'),
            const SizedBox(
              height: 62,
            ),
            const Text(
              "The ID authenticity verification\nservice is temporarily unavailable.",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w300,
                color: Color(0xFF606060),
              ),
            ),
            const SizedBox(
              height: 13,
            ),
            const Text(
              "This service is currently under development\nto comply with the restrictions of each country.\nThank you for your understanding.",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w300,
                color: Color(0xFF606060),
              ),
            ),
            Expanded(child: Container()),
            TextButton(
              onPressed: () => _gotoMain(context),
              child: const Text(
                "Return to Main Menu",
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  decoration: TextDecoration.underline,
                  color: Color(0xFF777777),
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            MenuButonWidget(
              title: "Next",
              textColor: const Color(0xff000000),
              backgoundColor: const Color(0xffFFC92F),
              boxWidth: MediaQuery.of(context).size.width,
              boxHeight: 55,
              boxRadius: 6,
              onPressed: () => _onNextPressed(context),
            ),
          ],
        ),
      ),
    );
  }
}
