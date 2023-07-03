import 'package:flutter/material.dart';
import 'package:nothing_browser/pages/dash.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:toastification/toastification.dart';

class SearchBarPage extends StatefulWidget {
  final TextEditingController controller;
  final ValueChanged<String> onSubmitted;

  const SearchBarPage({super.key,
    required this.controller,
    required this.onSubmitted,
  });

  @override
  State<SearchBarPage> createState() => _SearchBarPageState();
}


class _SearchBarPageState extends State<SearchBarPage> {
  void _clearCache(BuildContext context) async {
    //store the navigator instance in a local variable
    final navigator = Navigator.of(context);
    //show confirmation dialog
    DefaultCacheManager().emptyCache();
    //use the navigator variable instead of context for navigation
    navigator.pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => const DashboarddPage()),
          (route) => false,
    );

    //ToastNotification Files
    toastification.show(
      context: context,
      title: 'Everything Cleared',
      autoCloseDuration: const Duration(seconds: 3),
      icon: const Icon(Icons.local_fire_department_rounded, color: Colors.yellow,),
      backgroundColor: Colors.blueGrey.withOpacity(0.3),
      foregroundColor: Colors.white,
    );
  }



  @override
  Widget build(BuildContext context) {
    return Column(
        children: [
          Container(
            color: Colors.black,
            height: 45,
            padding: const EdgeInsets.all(5),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.safety_check_outlined,
                  size: 20,
                    color: Colors.lightGreen,
                  ),
                  onPressed: (){

                  },
                ),
                Expanded(
                  child: Card(
                    elevation: 3,
                    child: TextField(

                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(vertical: 3.0, horizontal: 5.0),

                        filled: true,
                        fillColor: Colors.blueGrey.withOpacity(0.3),
                        hintText: 'Search Here....',
                        hintStyle: TextStyle(
                          color: Colors.grey[400],
                          fontSize: 12.0,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      textAlign: TextAlign.center,
                      controller: widget.controller,
                      keyboardType: TextInputType.url,
                      style: const TextStyle(
                        fontSize: 12.0, // Adjust the font size here
                      ),


                      onSubmitted: widget.onSubmitted,
                    ),
                  ),
                ),
                IconButton(
                  color: Colors.yellow,
                  icon: const Icon(Icons.add),
                  onPressed: () {},
                ),

                IconButton(
                  color: Colors.yellow,
                  icon: const Icon(Icons.local_fire_department_rounded),
                  onPressed: () => _clearCache(context),
                ),
              ],
            ),
          ),
        ],
      );

  }
}
