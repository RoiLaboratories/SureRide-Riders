import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 24),
                // --- WELCOME TEXT ---
                Text(
                  "Welcome",
                  style: GoogleFonts.poppins(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  "Sign up or log in to continue",
                  style: GoogleFonts.poppins(
                    fontSize: 20,
                    fontWeight: FontWeight.normal,
                    color: Colors.grey.shade700,
                  ),
                ),
      
                const SizedBox(height: 40),
      
                // --- BIG CIRCLE IN THE MIDDLE ---
                Expanded(
                  child: Center(
                    child: Material(
                      elevation: 10,
                      shape: const CircleBorder(),
                      clipBehavior: Clip.antiAlias,
                      child: CircleAvatar(
                        radius: screenHeight * 0.3, // 🔥 BIG
                        backgroundImage: const AssetImage(
                          'images/page1.png',
                        ),
                        backgroundColor: Colors.transparent,
                      ),
                    ),
                  ),
                ),
      
                const SizedBox(height: 40),
      
                // --- SIGN UP BUTTON ---
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/signup');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue, 
                      elevation: 6,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                    ),
                    child: Text(
                      "Sign Up",
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
      
                const SizedBox(height: 16),
      
                // --- LOG IN BUTTON ---
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/login');
                    },
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: Colors.blue, width: 2),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                      backgroundColor: Colors.white,
                    ),
                    child: Text(
                      "Log In",
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
                  ),
                ),
      
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
