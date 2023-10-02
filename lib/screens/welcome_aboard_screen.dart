import 'package:ff/Provider/AppProvider.dart';
import 'package:ff/screens/register_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../utils/Widgits/custom_button.dart';

class WelcomeAboardScreen extends StatefulWidget {
  const WelcomeAboardScreen({super.key});

  @override
  State<WelcomeAboardScreen> createState() => _WelcomeAboardScreenState();
}

class _WelcomeAboardScreenState extends State<WelcomeAboardScreen> {
  @override
  Widget build(BuildContext context) {
    final ap = Provider.of<AppProvider>(context, listen: false);

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 35),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  "assets/images/image1.png",
                  height: 300,
                ),
                const SizedBox(height: 20),
                const Text(
                  "Let's get started",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  "Never a better time than now to start.",
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.black38,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                // custom button
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: CustomButton(
                    onPressed: () async {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const RegisterScreen(),
                        ),
                      );
                      // if (ap.isSignedIn == true) {
                      //   await ap.getDataFromSP().whenComplete(
                      //         () => Navigator.pushReplacement(
                      //           context,
                      //           MaterialPageRoute(
                      //             builder: (context) => const HomeScreen(),
                      //           ),
                      //         ),
                      //       );
                      // } else {
                      //   Navigator.pushReplacement(
                      //     context,
                      //     MaterialPageRoute(
                      //       builder: (context) => const RegisterScreen(),
                      //     ),
                      //   );
                      // }
                    },
                    text: "Get started",
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
