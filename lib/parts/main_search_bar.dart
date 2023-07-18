import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:nothing_browser/pages/duckducksearch.dart';
import 'package:nothing_browser/parts/thememodeswitch.dart';

class MainSearchBar extends StatefulWidget {
  final TextEditingController searchController;
  final Function(String) onSearch;

  const MainSearchBar({
    Key? key,
    required this.searchController,
    required this.onSearch,
  }) : super(key: key);

  @override
  State<MainSearchBar> createState() => _MainSearchBarState();
}

class _MainSearchBarState extends State<MainSearchBar> {
  final DatabaseReference databaseReference =
  FirebaseDatabase.instance.ref();

  String dynamicHintText = 'Search or Enter URL';

  void navigateToSearchPage(BuildContext context, String query) {
    if (Uri.tryParse(query)?.hasScheme == true) {
      // If query is a valid URL, navigate to DuckDuckSearchPage directly
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => DuckDuckSearchPage(
            query: query,
            index: 0,
          ),
        ),
      );
    } else {
      // If query is not a URL, navigate to DuckDuckSearchPage with search query
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => DuckDuckSearchPage(
            query: 'https://start.duckduckgo.com/?q=$query',
            index: 0,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 315,
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
          ),
        ],
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Card(
        elevation: 0,
        shadowColor: Colors.grey,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: TextField(
          controller: widget.searchController,
          style: const TextStyle(color: Colors.black54),
          decoration: InputDecoration(
            hintText: dynamicHintText,
            hintStyle: const TextStyle(
              color: Colors.black54,
              fontSize: 12,
            ),
            suffixIcon: IconButton(
              color: Colors.black54,
              icon: const Icon(Icons.search_sharp),
              onPressed: () {
                final query = widget.searchController.text.trim();
                navigateToSearchPage(context, query);
              },
            ),
            prefixIcon: const ThemeModeSwitch(),

            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.circular(10.0),
            ),
            contentPadding: const EdgeInsets.symmetric(
              vertical: 10.0,
              horizontal: 16.0,
            ),
          ),
          onSubmitted: (query) {
            if (query.isNotEmpty) {
              navigateToSearchPage(context, query);
            }
          },
        ),
      ),
    );
  }
}
