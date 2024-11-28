class OnboardingContents {
  final String title;
  final String image;
  final String desc;

  OnboardingContents({
    required this.title,
    required this.image,
    required this.desc,
  });
}

List<OnboardingContents> contents = [
  OnboardingContents(
    title: "Explore a Variety of Products",
    image: "assets/images/image1.png",
    desc: "Discover top-quality items from trusted sellers, all in one place.",
  ),
  OnboardingContents(
    title: "Fast and Secure Payments",
    image: "assets/images/image2.png",
    desc:
        "Enjoy quick and secure payment options for a seamless shopping experience.",
  ),
  OnboardingContents(
    title: "Track Your Orders in Real-Time",
    image: "assets/images/image3.png",
    desc:
        "Stay updated on your order's status with real-time tracking and notifications.",
  ),
];
