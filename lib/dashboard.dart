import 'package:flutter/material.dart';
import 'package:nothing_browser/inapp.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({Key? key}) : super(key: key);

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {


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
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                //This is top Height
                const SizedBox(
                  height: 110,
                ),
                //Top Height Ends Here

                //This is main Logo
                Container(
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                    color: Colors.transparent,
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
                  child: Image.asset(
                    'assets/images/LogoFinal.png',
                    width: 50,
                    height: 50,
                  ),
                ),
                //Logo Container Ends Here

                //Logo Bottom Space
                const SizedBox(
                  height: 70,
                ),
                //Logo Bottom Space ends here

                //Select Engine Text Starts here
                const Text(
                  'SELECT ENGINE',
                  style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
                ),

                //Select Engine Text End Here

                const SizedBox(
                  height: 10,
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
                              builder: (context) =>
                                  InAppWebViewPage(index: index),
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
              ],
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
        child: const BottomAppBar(
          elevation: 50,
          child: Center(
              child: Text(
            'Nothing Browser',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          )),
        ),
      ),
    );
  }
}
