import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:nothing_browser/initialpages/appcolors.dart';
import 'package:nothing_browser/parts/theme_provider.dart';
import 'package:provider/provider.dart';
import 'package:toastification/toastification.dart';
import 'package:nothing_browser/pages/mainpage.dart';

class HeaderPage extends StatefulWidget {
  final TextEditingController controller;
  final ValueChanged<String> onSubmitted;
  final VoidCallback onRefresh; // Callback function for refresh action


  const HeaderPage({
    Key? key,
    required this.controller,
    required this.onSubmitted, required this.onRefresh,
  }) : super(key: key);

  @override
  State<HeaderPage> createState() => _HeaderPageState();
}

class _HeaderPageState extends State<HeaderPage> {

  late ThemeProvider themeProvider;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    themeProvider = Provider.of<ThemeProvider>(context);
  }

  void _clearCache(BuildContext context) async {
    final navigator = Navigator.of(context);
    DefaultCacheManager().emptyCache();
    navigator.pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => const DashboarddPage()),
          (route) => false,
    );

    final themeMode = themeProvider.themeMode;
    final backgroundColor = themeMode == ThemeMode.light ? AppColors.firefoxPurple : AppColors.lightBlue;
    final foregroundColor = themeMode == ThemeMode.light ? AppColors.lightGray : AppColors.firefoxPurple;


    toastification.show(
      context: context,
      title: 'Everything Cleared',
      autoCloseDuration: const Duration(seconds: 3),
      icon: const Icon(Icons.local_fire_department_rounded,
      color: Colors.red),
      backgroundColor: backgroundColor,
      foregroundColor: foregroundColor,
    );



  }







  @override
  Widget build(BuildContext context) {
    final themeMode = themeProvider.themeMode;


    final headerContainer = Material(
      elevation: 4,
      child: Container(
        color: themeMode == ThemeMode.light ? AppColors.lightBlue : AppColors.firefoxPurple, // Set the color based on the theme mode
        height: 45,
        padding: const EdgeInsets.all(5),
        child: Row(
          children: [
            IconButton(
              icon: const Icon(
                  Icons.menu
              ),

              onPressed: (){
                Scaffold.of(context).openDrawer();

              }, // Call the onRefresh callback



            ),

            IconButton(
              icon: const Icon(
                  Icons.refresh
              ),

              onPressed: widget.onRefresh, // Call the onRefresh callback



            ),







            Expanded(
              child: Card(
                elevation: 3,
                child: TextField(
                  decoration: InputDecoration(

                    contentPadding: const EdgeInsets.symmetric(vertical: 3.0, horizontal: 5.0),
                    filled: true,
                    fillColor: AppColors.lightBlue,
                    hintText: 'Search Here....',
                    hintStyle: const TextStyle(
                      color: AppColors.firefoxPurple,
                      fontSize: 12.0,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(3.0),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  textAlign: TextAlign.center,
                  controller: widget.controller,
                  keyboardType: TextInputType.url,
                  style: const TextStyle(
                    fontSize: 12.0,
                    color: AppColors.firefoxPurple,
                  ),
                  onSubmitted: widget.onSubmitted,
                ),
              ),
            ),

            IconButton(
              icon: const Icon(
                Icons.bookmark_add_outlined,
              ),
              onPressed: () {

              },
            ),

            IconButton(
              color: themeMode == ThemeMode.light ? Colors.red : Colors.yellow, // Set the color based on the theme mode
              icon: const Icon(
                Icons.local_fire_department_outlined,
              ),
              onPressed: () => _clearCache(context),
            ),

          ],
        ),
      ),
    );

    return Column(
      children: [
        headerContainer,
      ],
    );
  }
}
