import 'package:flutter/material.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:nothing_browser/initialpages/appcolors.dart';
import 'package:nothing_browser/pages/mainpage.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
      backgroundColor: AppColors.firefoxPurple,
      duration: 3000, // Duration for which the splash screen will be visible
      splash: 'assets/images/LogoFinal.png', // Path to your splash screen image
      nextScreen:
          const DashboarddPage(), // Navigate to the security screen after splash screen
      splashTransition: SplashTransition.rotationTransition,
      animationDuration: const Duration(milliseconds: 2500),
      centered: true,
    );
  }
}
