import 'package:flutter/material.dart';
import 'package:nothing_browser/initialpages/appcolors.dart';
import 'package:nothing_browser/thememode/theme_provider.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';

class HelpPage extends StatefulWidget {

  const HelpPage({super.key});

  @override
  State<HelpPage> createState() => _HelpPageState();
}

class _HelpPageState extends State<HelpPage> {
  final List<HelpGuide> helpGuides = [
    HelpGuide('My downloads keep failing. What should I do?',
        'Download failures can sometimes occur due to network issues or server problems. Please ensure you have a stable internet connection and try downloading the file again. If the issue persists, you can reach out to our support team for further assistance.'),
    HelpGuide("I can't find my downloaded files. Where are they stored?",
        'Check Your Device Download Folder'),
    HelpGuide('Can I pause and resume downloads?',
        'Currently, our browser does not support pausing and resuming downloads. Were actively working on improving this feature to enhance your download experience.'),
    HelpGuide('How do I open a new tab?',
        'Tab options are not available for Security reasons'),
    HelpGuide('Is private browsing mode available?',
        'This Browser it self a Private Browser, you dont have to turn it on or off!'),
    HelpGuide('Where is my browsing History?',
        'We dont store Browsing History for your safety!'),
    HelpGuide('Can I bookmark my favorite websites?',
        'We are working on Bookmaring Feature!'),
    HelpGuide('Is there a way to change the default search engine?',
        'No, you Can"t change the default search engine. DuckDuckGo is the safest Search Engine.'),
    HelpGuide('How do I update the browser to the latest version?',
        'To update the browser, go to the app store (Google Play Store or Apple App Store), search for our browser app, and tap the "Update" button if its available.'),
    HelpGuide('Is there a way to sync my bookmarks and tabs across devices?',
        'At the moment, our browser does not support cross-device syncing. However, we are actively working on adding this feature to enhance your browsing experience.'),
  ];
  late ThemeProvider themeProvider;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    themeProvider = Provider.of<ThemeProvider>(context);
  }

  @override
  Widget build(BuildContext context) {
    final themeMode = themeProvider.themeMode;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: themeMode == ThemeMode.light ? AppColors.lightBlue : AppColors.firefoxPurple,
          title: Image.asset(
            'assets/images/LogoFinal.png',
            height: 40,

          ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 30),
            child: Text('Help Page',
            style: GoogleFonts.lato(
              fontWeight: FontWeight.bold

            ),
            ),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 50),
        child: ListView.builder(
          itemCount: helpGuides.length,
          itemBuilder: (context, index) {
            return HelpGuideCard(helpGuide: helpGuides[index]);
          },
        ),
      ),
    );
  }
}

class HelpGuide {
  final String title;
  final String description;

  HelpGuide(this.title, this.description);
}

class HelpGuideCard extends StatefulWidget {
  final HelpGuide helpGuide;

  const HelpGuideCard({super.key, required this.helpGuide});

  @override
  State<HelpGuideCard> createState() => _HelpGuideCardState();
}

class _HelpGuideCardState extends State<HelpGuideCard> {
  late ThemeProvider themeProvider;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    themeProvider = Provider.of<ThemeProvider>(context);
  }


  @override
  Widget build(BuildContext context) {
    final themeMode = themeProvider.themeMode;

    return Card(
      color: themeMode == ThemeMode.light ? AppColors.lightBlue : AppColors.firefoxPurple,

      elevation: 3,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        title: Text(widget.helpGuide.title,
        style: GoogleFonts.lato(
          fontSize: 15,
        ),
        ),
        onTap: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                icon: const Icon(Icons.help_outline,

                ),
                iconColor: Colors.green,
                content: Text(widget.helpGuide.description,
                style: GoogleFonts.lato(),
                ),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('Close'),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}


