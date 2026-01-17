import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../models/onboarding_model.dart';

class OnboardingPage extends StatelessWidget {
  final OnboardingModel data;

  const OnboardingPage({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          /// HERO IMAGE
          SizedBox(
            width: 353,
            child: Image.asset(
                data.heroImage,
                fit: BoxFit.cover,
              ),
            ),

          const SizedBox(height: 45),

          /// TITLE WITH INLINE IMAGE
          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              children: data.titleParts.map((part) {
                if (part.text != null) {
                  return TextSpan(
                    text: part.text,
                    style: GoogleFonts.instrumentSerif(
                      fontSize: 36,
                      fontWeight: FontWeight.normal,
                      color: Colors.black,
                    ),
                  );
                } else {
                  return WidgetSpan(
                    alignment: PlaceholderAlignment.middle,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: Image.asset(
                        part.image!,
                        height: 47,
                      ),
                    ),
                  );
                }
              }).toList(),
            ),
          ),

          /// SUBTITLE
          Text(
            data.subtitle,
            textAlign: TextAlign.center,
            style: GoogleFonts.instrumentSans(
              fontSize: 20,
              fontWeight: FontWeight.normal,
              color: Colors.grey.shade600,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}