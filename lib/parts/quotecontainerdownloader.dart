import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:nothing_browser/initialpages/appcolors.dart';
import 'package:nothing_browser/parts/theme_provider.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';

class QuoteContainerDownloader extends StatefulWidget {
  const QuoteContainerDownloader({Key? key}) : super(key: key);

  @override
  State<QuoteContainerDownloader> createState() => _QuoteContainerDownloaderState();
}

class _QuoteContainerDownloaderState extends State<QuoteContainerDownloader> {
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
          width: 300,
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
                  totalRepeatCount: 1,
                  stopPauseOnTap: true,
                  animatedTexts: [
                    TypewriterAnimatedText(
                      'Please note that some downloads may not be supported due to copyright issues. Use link with extension.',
                  ),
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
