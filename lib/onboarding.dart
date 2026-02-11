import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hotel_de_luna/Navigate_temp.dart';
import 'package:hotel_de_luna/auth%20screens/guest_login.dart';

class OnboardingContents {
  final String title;
  final String image;
  final String desc;

  const OnboardingContents({
    required this.title,
    required this.image,
    required this.desc,
  });
}

List<OnboardingContents> contents = const [
  OnboardingContents(
    title: "Choose a branch",
    image: "assets/images/onboarding/location.webp",
    desc: "Hotel De Luna has many branches across Mumbai.",
  ),
  OnboardingContents(
    title: "Book a room",
    image: "assets/images/onboarding/paperplane.webp",
    desc: "Book one of hundreds of types of rooms.",
  ),
  OnboardingContents(
    title: "Enjoy a Luxurious stay",
    image: "assets/images/onboarding/sun.webp",
    desc: "Let go, unwind and enjoy with your loved ones.",
  ),
];

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  late PageController _controller;
  int _currentPage = 0;

  final List<String> bgimages = const [
    "assets/images/onboarding/hotel_building.webp",
    "assets/images/onboarding/hotel_room.webp",
    "assets/images/onboarding/poolside.webp",
  ];

  @override
  void initState() {
    super.initState();
    _controller = PageController();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    for (String path in bgimages) {
      precacheImage(AssetImage(path), context);
    }
    for (var content in contents) {
      precacheImage(AssetImage(content.image), context);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _buildDots(int index) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      margin: const EdgeInsets.only(right: 5),
      height: 10,
      width: _currentPage == index ? 20 : 10,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(25)),
        color: Color.fromARGB(255, 219, 217, 217),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Optimized: Use MediaQuery directly for better performance than a custom static class
    final Size size = MediaQuery.of(context).size;
    final double width = size.width;

    return Scaffold(
      backgroundColor: Colors.black,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        systemOverlayStyle: SystemUiOverlayStyle.light,
      ),
      body: Stack(
        children: [
          // Background Image Transition
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 400),
            child: Container(
              key: ValueKey<int>(_currentPage),
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: ResizeImage(
                    AssetImage(bgimages[_currentPage]),
                    width:
                        (MediaQuery.of(context).size.width *
                                MediaQuery.of(context).devicePixelRatio)
                            .toInt(),
                  ),
                  fit: BoxFit.cover,
                  colorFilter: const ColorFilter.mode(
                    Color.fromARGB(150, 20, 40, 20), // Adjusted for readability
                    BlendMode.darken,
                  ),
                ),
              ),
            ),
          ),

          // Content Layer
          SafeArea(
            child: Column(
              children: [
                Expanded(
                  flex: 3,
                  child: PageView.builder(
                    physics: const BouncingScrollPhysics(),
                    controller: _controller,
                    onPageChanged: (value) =>
                        setState(() => _currentPage = value),
                    itemCount: contents.length,
                    itemBuilder: (context, i) {
                      return Padding(
                        padding: const EdgeInsets.all(40.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                              child: Image.asset(
                                contents[i].image,
                                cacheWidth: 300,
                                fit: BoxFit.contain,
                              ),
                            ),
                            const SizedBox(height: 20),
                            Text(
                              contents[i].title,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                fontFamily: "Poppins",
                              ),
                            ),
                            const SizedBox(height: 15),
                            Text(
                              contents[i].desc,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontFamily: "Poppins",
                                fontWeight: FontWeight.w300,
                                fontSize: width <= 550 ? 16 : 22,
                                color: Colors.white70,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),

                // Bottom Controls
                Expanded(
                  flex: 1,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                          contents.length,
                          (index) => _buildDots(index),
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 30,
                          vertical: 20,
                        ),
                        child: _currentPage + 1 == contents.length
                            ? ElevatedButton(
                                onPressed: () {
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const GuestLoginScreen(),
                                    ),
                                  );
                                }, //GuestLoginScreen
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFFD1D3D0),
                                  foregroundColor: Colors.black,
                                  minimumSize: Size(width * 0.7, 55),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                ),
                                child: const Text("GET STARTED"),
                              )
                            : Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              const NavigateTemp(),
                                        ),
                                      );
                                    },
                                    child: const Text(
                                      "SKIP",
                                      style: TextStyle(color: Colors.white70),
                                    ),
                                  ),
                                  ElevatedButton(
                                    onPressed: () {
                                      _controller.nextPage(
                                        duration: const Duration(
                                          milliseconds: 300,
                                        ),
                                        curve: Curves.easeInOut,
                                      );
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.white,
                                      foregroundColor: Colors.black,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 30,
                                        vertical: 15,
                                      ),
                                    ),
                                    child: const Text("NEXT"),
                                  ),
                                ],
                              ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
