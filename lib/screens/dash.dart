import 'package:flutter/material.dart';
import 'package:nothing_browser/screens/duckducksearch.dart';
import 'package:nothing_browser/screens/inappsec.dart';

class DashboarddPage extends StatefulWidget {
  const DashboarddPage({Key? key}) : super(key: key);

  @override
  State<DashboarddPage> createState() => _DashboarddPageState();
}

class _DashboarddPageState extends State<DashboarddPage> {
  //Main Search Bar Top Setting Starts Here
  final TextEditingController searchController = TextEditingController();

  void navigateToSearchPage(BuildContext context, String query) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DuckDuckGoSearchPage(query: query),
      ),
    );
  }

  //Main Search Bar Setting Ends Here

  //List of Images
  List<String> images = [
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Container(
            decoration: const BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft,
                    colors: [Colors.blueGrey, Colors.black87])),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  //Main Search Bar Design Starts Here
                  Container(
                    padding: const EdgeInsets.all(25.0),
                    child: TextField(
                      controller: searchController,
                      style: TextStyle(color: Colors.white.withOpacity(0.8)),
                      decoration: InputDecoration(
                        hintText: 'I Love You ❤...',
                        hintStyle:
                            TextStyle(color: Colors.white.withOpacity(0.8)),

                        //Main Search Bar Icon
                        prefixIcon: IconButton(
                          color: Colors.white,
                          icon: const Icon(Icons.search),
                          onPressed: () {
                            final query = searchController.text.trim();
                            if (query.isNotEmpty) {
                              navigateToSearchPage(context, query);
                            }
                          },
                        ),

                        //Main Search Bar Ends Here
                        filled: true,
                        fillColor: Colors.white.withOpacity(0.3),
                        border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 16.0),
                      ),
                      onSubmitted: (query) {
                        if (query.isNotEmpty) {
                          navigateToSearchPage(context, query);
                        }
                      },
                    ),
                  ),

                  //Main Search Bar Design Ends Here

                  //ChatgptEnds Here

                  //Select Engine Text End Here

                  const SizedBox(
                    height: 5,
                  ),

                  //Search Engine Items Starts Here

                  Container(
                    margin: const EdgeInsets.all(25),
                    height: 200,
                    color: Colors.transparent,
                    child: GridView.count(
                      crossAxisCount: 5, // number of items per row
                      crossAxisSpacing:
                          20, // horizontal spacing between the items
                      mainAxisSpacing: 20, // vertical spacing between the items
                      children: List.generate(images.length, (index) {
                        return InkWell(
                          onTap: () {
                            // handle click event by navigating to the page
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => DashedPage(index: index),
                              ),
                            );
                          },

                          //Images Starts Here
                          child: Image.asset(
                            images[index],
                            fit: BoxFit
                                .cover, // load image from asset folder using the lis// make the image cover the available space
                          ),
                        );
                      }),
                    ),
                  )

                  //Search Engine Items End Here
                ],
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.blueGrey,
              blurRadius: 1.0,
              spreadRadius: 0.0,
              offset: Offset(0.0, 0.0),
              blurStyle: BlurStyle.outer,
            ),
          ],
        ),
        height: 50,
        child: BottomAppBar(
          elevation: 50,
          child: Center(
              child: InkWell(
            child: const Text(
              'Explore More...',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            onTap: () {},
          )),
        ),
      ),
    );
  }
}
