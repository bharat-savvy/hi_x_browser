import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:nothing_browser/initialpages/appcolors.dart';
import 'package:nothing_browser/parts/theme_provider.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';

class QuoteContainer extends StatefulWidget {
  const QuoteContainer({Key? key}) : super(key: key);

  @override
  State<QuoteContainer> createState() => _QuoteContainerState();
}

class _QuoteContainerState extends State<QuoteContainer> {
  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, _) {
        return Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: themeProvider.themeMode == ThemeMode.light
                  ? AppColors.darkOliveGreen // Light mode color
                  : AppColors.paleYellow, // Dark mode color
              width: 1.0,
            ),
            borderRadius: const BorderRadius.only(
              topLeft: Radius.zero,
              topRight: Radius.circular(20.0),
              bottomLeft: Radius.circular(20.0),
              bottomRight: Radius.circular(20.0),
            ),


          ),
          width: 250.0,
          height: 80,
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Center(
              child: DefaultTextStyle(
                textAlign: TextAlign.center,
                style: GoogleFonts.lato(
                  letterSpacing: 0.3,
                  wordSpacing: 0.5,

                  fontSize: 15.0,
                  color: themeProvider.themeMode == ThemeMode.light
                      ? AppColors.firefoxPurple // Light mode color
                      : AppColors.lightPurple, // Dark mode color
                ),
                child: AnimatedTextKit(
                  stopPauseOnTap: true,
                  animatedTexts: [
                    TypewriterAnimatedText('Hurry! Search anything no one can catch you..'),
                  ],

                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
