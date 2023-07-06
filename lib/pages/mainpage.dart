import 'package:flutter/material.dart';
import 'package:nothing_browser/pages/duckducksearch.dart';
import 'package:nothing_browser/pages/allappsearch.dart';
import 'package:nothing_browser/parts/main_search_bar.dart';
import '../websitedetails/websitedata.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

class DashboarddPage extends StatefulWidget {
  const DashboarddPage({Key? key}) : super(key: key);

  @override
  State<DashboarddPage> createState() => _DashboarddPageState();
}

class _DashboarddPageState extends State<DashboarddPage> {
  //for images
  List<String> images = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    images = List.from(websiteData['images']!);
  }
  //images end

  //Main Search Bar Top Setting Starts Here
  final TextEditingController searchController = TextEditingController();

  void navigateToSearchPage(BuildContext context, String query) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DuckDuckSearchPage(
          query: query,
          index: 0,
        ),
      ),
    );
  }
  //Main Search Bar Setting Ends Here

  //List of Images

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                //Main Search Bar Design Starts Here
                MainSearchBar(
                  searchController: searchController,
                  onSearch: (string ) {
                    (query) {
                      if (query.isNotEmpty) {
                        navigateToSearchPage(context, query);
                      }
                    };
                  },
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
                  child: AnimationLimiter(
                    child: GridView.count(
                      crossAxisCount: 5, // number of items per row
                      crossAxisSpacing: 20, // horizontal spacing between the items
                      mainAxisSpacing: 20, // vertical spacing between the items

                      
                      children: List.generate(images.length, (index) {
                        return AnimationConfiguration.staggeredGrid(
                          position: index,
                          duration: const Duration(milliseconds: 450),
                          columnCount: 5,
                          child: ScaleAnimation(
                            child: FadeInAnimation(
                              child: InkWell(
                                onTap: () {
                                  // handle click event by navigating to the page
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => AllAppSearchPage(index: index),
                                    ),
                                  );
                                },

                                //Images Starts Here
                                child: Image.asset(
                                  images[index],
                                  fit: BoxFit
                                      .cover, // load image from asset folder using the lis// make the image cover the available space
                                ),
                              ),
                            ),
                          ),
                        );
                      }),
                    ),
                  ),
                )

                //Search Engine Items End Here
              ],
            ),
          ),
        ),
      ),
    );
  }
}
