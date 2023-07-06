import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nothing_browser/pages/mainpage.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:toastification/toastification.dart';

class HeaderPage extends StatefulWidget {
  final TextEditingController controller;
  final ValueChanged<String> onSubmitted;

  const HeaderPage({super.key,
    required this.controller,
    required this.onSubmitted,
  });

  @override
  State<HeaderPage> createState() => _HeaderPageState();
}


class _HeaderPageState extends State<HeaderPage> {
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

  Color _getRandomColor() {
    final random = Random();
    return Color.fromRGBO(
      random.nextInt(256),
      random.nextInt(256),
      random.nextInt(256),
      1,
    );
  }

  Color _getContrastingIconColor(Color color) {
    final luminance = (0.299 * color.red + 0.587 * color.green + 0.114 * color.blue) / 255;
    return luminance > 0.5 ? Colors.black : Colors.white;
  }

  void _setSystemUIOverlayStyle(Color statusBarColor) {
    final brightness = ThemeData.estimateBrightnessForColor(statusBarColor);
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: statusBarColor,
      statusBarBrightness: brightness,
      statusBarIconBrightness: brightness == Brightness.light ? Brightness.dark : Brightness.light,
    ));
  }

  @override
  void initState() {
    super.initState();
    final randomColor = _getRandomColor();
    _setSystemUIOverlayStyle(randomColor);
  }


  @override
  Widget build(BuildContext context) {
    final randomColor = _getRandomColor();
    final iconColor = _getContrastingIconColor(randomColor);

    return Column(
        children: [
          Container(
            color: _getRandomColor(),
            height: 45,
            padding: const EdgeInsets.all(5),
            child: Row(
              children: [
                IconButton(
                  icon: Icon(Icons.safety_check_outlined,
                  size: 22,
                    color: iconColor,
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
                  color: iconColor,
                  icon: const Icon(Icons.block_flipped,
                    size: 22,
                  ),
                  onPressed: () {},
                ),

                IconButton(
                  color: iconColor,
                  icon: const Icon(Icons.local_fire_department_rounded,
                  ),
                  onPressed: () => _clearCache(context),
                ),
              ],
            ),
          ),
        ],
      );

  }
}
