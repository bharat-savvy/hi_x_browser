import 'dart:math';

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
    super.initState();
    images = List.from(websiteData['images']!);
  }
  Color _getRandomColor() {
    final random = Random();
    return Color.fromARGB(
      25,
      random.nextInt(256),
      random.nextInt(256),
      random.nextInt(256),
    );
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: _getRandomColor(),


        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
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
                height: 200,
                color: Colors.transparent,
                child: AnimationLimiter(
                  child: GridView.builder(
                    itemCount: images.length,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 5, // number of items per row
                      crossAxisSpacing: 20, // horizontal spacing between the items
                      mainAxisSpacing: 20, // vertical spacing between the items
                      childAspectRatio: 1, // control the aspect ratio of grid items
                    ),
                    itemBuilder: (BuildContext context, int index) {
                      return AnimationConfiguration.staggeredGrid(
                        position: index,
                        duration: const Duration(milliseconds: 450),
                        columnCount: 5,
                        child: ScaleAnimation(
                          child: FadeInAnimation(
                            child: Hero(
                              tag: 'image$index',
                              child: InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => AllAppSearchPage(index: index),
                                    ),
                                  );
                                },
                                child: Image.asset(
                                  images[index],
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              // Search Engine Items End Here
            ],
          ),
        ),
      ),
    );
  }

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
}
