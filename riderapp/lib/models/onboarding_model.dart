class OnboardingTitlePart {
  final String? text;
  final String? image;

  const OnboardingTitlePart.text(this.text) : image = null;
  const OnboardingTitlePart.image(this.image) : text = null;
}

class OnboardingModel {
  final String heroImage;
  final List<OnboardingTitlePart> titleParts;
  final String subtitle;

  const OnboardingModel({
    required this.heroImage,
    required this.titleParts,
    required this.subtitle,
  });
}

const onboardingPages = [
  OnboardingModel(
    heroImage: "assets/images/page1.png",
    titleParts: [
      OnboardingTitlePart.text("Book a ride in"),
      OnboardingTitlePart.image("assets/images/clock.png"),
      OnboardingTitlePart.text(" seconds"),
    ],
    subtitle: "Safe drivers. Clean cars. Affordable prices.",
  ),
  OnboardingModel(
    heroImage: "assets/images/page2.png",
    titleParts: [
      OnboardingTitlePart.text("Pay"),
      OnboardingTitlePart.image("assets/images/coin.png"),
      OnboardingTitlePart.text("your way "),
    ],
    subtitle: "Avoid bank network delays when you pay in-app wallet.",
  ),
  OnboardingModel(
    heroImage: "assets/images/page3.png",
    titleParts: [
      OnboardingTitlePart.text("Ride more, save"),
      OnboardingTitlePart.image("assets/images/discount.png"),
      OnboardingTitlePart.text("more!"),
    ],
    subtitle: "Unlock special ride promos and wallet rewards.",
  ),
];

