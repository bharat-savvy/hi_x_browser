import 'package:flutter/material.dart';
import 'package:nothing_browser/pages/duckducksearch.dart';

class MainSearchBar extends StatelessWidget {
  final TextEditingController searchController;
  final Function(String) onSearch;

  const MainSearchBar({
    Key? key,
    required this.searchController,
    required this.onSearch,
  }) : super(key: key);

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

  bool isURL(String text) {
    const pattern =
        r'^(http:\/\/www\.|https:\/\/www\.|http:\/\/|https:\/\/)?[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,5}(:[0-9]{1,5})?(\/.*)?$';
    final regExp = RegExp(pattern, caseSensitive: false);
    return regExp.hasMatch(text);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 315,
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 0.1,
            blurRadius: 2,
            offset: const Offset(0, 0), // changes the position of the shadow
          ),
        ],
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Card(
        elevation: 0, // Adjust the elevation here
        shadowColor: Colors.grey, // Adjust the shadow color here
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),


        child: TextField(
          controller: searchController,
          style: const TextStyle(color: Colors.black54),
          decoration: InputDecoration(
            hintText: 'I love someone...',
            hintStyle: const TextStyle(color: Colors.black54),
            prefixIcon: IconButton(
              color: Colors.black54,
              icon: const Icon(Icons.search),
              onPressed: () {
                final query = searchController.text.trim();
                if (query.isNotEmpty) {
                  if (isURL(query)) {
                    // If the query is a valid URL, open it in DuckDuckGoSearchPage
                    navigateToSearchPage(context, query);
                  } else {
                    // Otherwise, perform a search
                    navigateToSearchPage(context, query);
                  }
                }
              },
            ),
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
              if (isURL(query)) {
                // If the query is a valid URL, open it in DuckDuckGoSearchPage
                navigateToSearchPage(context, query);
              } else {
                // Otherwise, perform a search
                navigateToSearchPage(context, query);
              }
            }
          },
        ),
      ),
    );
  }
}