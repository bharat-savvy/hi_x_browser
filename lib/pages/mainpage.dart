import 'package:flutter/material.dart';
import 'package:nothing_browser/pages/duckducksearch.dart';
import 'package:nothing_browser/pages/allappsearch.dart';
import 'package:nothing_browser/parts/main_search_bar.dart';
import 'package:nothing_browser/parts/quotecontainer.dart';
import 'package:page_transition/page_transition.dart';
import 'package:google_fonts/google_fonts.dart';

class DashboarddPage extends StatefulWidget {
  const DashboarddPage({Key? key}) : super(key: key);

  @override
  State<DashboarddPage> createState() => _DashboarddPageState();
}

class _DashboarddPageState extends State<DashboarddPage> {
  //for images
  List<String> imagesUrls = [];


  @override
  void initState() {
    super.initState();
    fetchImages();
  }

  void fetchImages() {
    setState(() {
      imagesUrls = [
        'assets/images/duck.png',
        'assets/images/google.png',
        'assets/images/bing.png',
        'assets/images/yahoo.png',
        'assets/images/yandex.png',
        'assets/images/start.png',
        'assets/images/ask.png',
        'assets/images/ecosia.png',
        'assets/images/wolfarm.png',
        'assets/images/aol.png',
      ];
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: SizedBox(
        width: 40,
        height: 40,
        child: FloatingActionButton(

          backgroundColor: Colors.red,

          onPressed: (){
            Navigator.pushNamed(context, '/download');
          },
          child: const Icon(Icons.download,
          color: Colors.white,
          ),
        ),
      ),


      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/LogoFinal.png',
              height: 60,
            ),
            const SizedBox(height: 5,),
            Text('Hi xBrowser: Fast & Private',
            style: GoogleFonts.roboto(
              fontSize: 15,
              letterSpacing: .3,
              wordSpacing: 0.5
            ),
            ),




            const SizedBox(
              height: 40,
            ),

            // Main Search Bar Design Starts Here
            MainSearchBar(
              searchController: TextEditingController(),
              onSearch: (query) {
                if (query.isNotEmpty) {
                  navigateToSearchPage(context, query);
                }
              },
            ),
            // Main Search Bar Design Ends Here

            const SizedBox(
              height: 5,
            ),

            // Search Engine Items Starts Here
            Container(
              margin: const EdgeInsets.all(25),
              height: 150,
              color: Colors.transparent,
              child: GridView.builder(
                itemCount: imagesUrls.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 5, // number of items per row
                  crossAxisSpacing: 20, // horizontal spacing between the items
                  mainAxisSpacing: 20, // vertical spacing between the items
                  childAspectRatio: 1, // control the aspect ratio of grid items
                ),
                itemBuilder: (BuildContext context, int index) {
                  final imageUrl = imagesUrls[index];
                  return InkWell(
                    onTap: () {
                      navigateToNextPage(context, index);
                    },
                    child: Image.asset(
                      imageUrl,
                      fit: BoxFit.cover,
                    ),
                  );

                },
              ),
            ),



            const QuoteContainer(),






            // Search Engine Items End Here
          ],
        ),
      ),
    );
  }

  void navigateToSearchPage(BuildContext context, String query) {
    Navigator.push(
      context,
      PageTransition(
        type: PageTransitionType.fade, // or PageTransitionType.scale
        child: DuckDuckSearchPage(
          index: 0,
          query: query,
        ),
        duration: const Duration(milliseconds: 700),
      ),
    );
  }

  void navigateToNextPage(BuildContext context, int index) {
    Navigator.push(
      context,
      PageTransition(
        type: PageTransitionType.fade,
        childCurrent:
            const DashboarddPage(), // Replace with the current page widget
        child: AllAppSearchPage(index: index),
        duration: const Duration(milliseconds: 700),
      ),
    );
  }
}
