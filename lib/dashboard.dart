import 'package:flutter/material.dart';



class DashboardPage extends StatefulWidget {
  const DashboardPage({Key? key}) : super(key: key);

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  // define a list of image paths





  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [


              //This is top Height
              const SizedBox(
                height: 150,
              ),
              //Top Height Ends Here


              //This is main Logo
              Container(
                decoration: const BoxDecoration(
                  color: Colors.transparent,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.deepPurpleAccent,
                      blurRadius: 100.0,
                      spreadRadius: 0.0,
                      offset: Offset(0.0, 0.0),
                      blurStyle: BlurStyle.outer,
                    ),
                  ],
                ),
                child: Image.asset('assets/images/LogoFinal.png',
                width: 50,
                height: 50,

                ),
              ),
              //Logo Container Ends Here

              //Logo Bottom Space
              const SizedBox(
                height: 40,
              ),
              //Logo Bottom Space ends here


              //Select Engine Text Starts here
              const Text('SELECT ENGINE',
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 14
              ),
              ),



              //Select Engine Text End Here
              //Search Engine Items Starts Here







            ],
          ),
        ),
      ),


      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.deepPurpleAccent,
              blurRadius: 100.0,
              spreadRadius: 0.0,
              offset: Offset(0.0, 0.0),
              blurStyle: BlurStyle.outer,
            ),
          ],
        ),
        height: 50,
        child: const BottomAppBar(
          elevation: 50,
          child: Center(child: Text('Nothing Browser',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500
          ),

          )),
        ),
      ),





    );
  }
}
