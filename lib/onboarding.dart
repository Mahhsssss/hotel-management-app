import 'package:flutter/material.dart';
import 'package:hotel_de_luna/hotel%20screens/hotel_homepage.dart';
import 'package:hotel_de_luna/services/widget_support.dart';

//Functionality done, need to add images, change colours etc..

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

class SizeConfig {
  static MediaQueryData? _mediaQueryData;
  static double? screenW;
  static double? screenH;
  static double? blockH;
  static double? blockV;

  void init(BuildContext context) {
    _mediaQueryData = MediaQuery.of(context);
    screenW = _mediaQueryData!.size.width;
    screenH = _mediaQueryData!.size.height;
    blockH = screenW! / 100;
    blockV = screenH! / 100;
  }
}

List<OnboardingContents> contents = [
  OnboardingContents(
    title: "Choose a branch",
    image: "assets/images/location.png",
    desc: "Hotel De Luna has many branches across Mumbai.",
  ),
  OnboardingContents(
    title: "Book a room",
    image: "assets/images/paperplane.png",
    desc: "Book one of hundreds of types of rooms.",
  ),
  OnboardingContents(
    title: "Enjoy a Luxurious stay",
    image: "assets/images/sun.png",
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

  List<String> bgimages = [
    "assets/images/hotel_building.jpg",
    "assets/images/hotel_room.jpg",
    "assets/images/poolside.jpg",
  ];

  @override
  void initState() {
    _controller = PageController();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose(); // ✅ GOOD PRACTICE
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    for (String path in bgimages) {
      precacheImage(AssetImage(path), context);
    }
  }

  AnimatedContainer _buildDots({int? index}) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(25)),
        color: Color.fromARGB(255, 219, 217, 217),
      ),
      margin: const EdgeInsets.only(right: 5),
      height: 10,
      curve: Curves.easeInToLinear,
      width: _currentPage == index ? 20 : 10,
    );
  }

  // void _goToLogin() {
  //   Navigator.pushReplacement(
  //     context,
  //     MaterialPageRoute(builder: (_) => const GuestLoginScreen()),
  //   );
  // } Commenting for now, will reintegrate once all pages are made

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    double width = SizeConfig.screenW!;
    double height = SizeConfig.screenH!;

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 400),
            layoutBuilder:
                (Widget? currentChild, List<Widget> previousChildren) {
                  return Stack(
                    alignment: Alignment.center,
                    children: <Widget>[
                      ...previousChildren,
                      if (currentChild != null) currentChild,
                    ],
                  );
                },
            child: Container(
              key: ValueKey<int>(_currentPage),
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(bgimages[_currentPage]),
                  fit: BoxFit.cover,
                  colorFilter: const ColorFilter.mode(
                    Color.fromARGB(255, 48, 84, 49),
                    BlendMode.modulate,
                  ),
                ),
              ),
            ),
          ),

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
                        padding: const EdgeInsets.all(50.0),
                        child: Column(
                          children: [
                            Expanded(child: Image.asset(contents[i].image)),
                            SizedBox(height: (height >= 840) ? 40 : 20),
                            Text(
                              contents[i].title,
                              textAlign: TextAlign.center,
                              style: AppWidget.headingtext(Colors.white, 27),
                            ),
                            const SizedBox(height: 15),
                            Text(
                              contents[i].desc,
                              style: TextStyle(
                                fontFamily: "Poppins",
                                fontWeight: FontWeight.w300,
                                fontSize: (width <= 550) ? 17 : 25,
                                color: Colors.white,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),

                Expanded(
                  flex: 1,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                          contents.length,
                          (index) => _buildDots(index: index),
                        ),
                      ),

                      _currentPage + 1 == contents.length
                          ? Padding(
                              padding: const EdgeInsets.all(30),
                              child: ElevatedButton(
                                onPressed: () {},
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color.fromARGB(
                                    255,
                                    209,
                                    211,
                                    208,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  padding: (width <= 550)
                                      ? const EdgeInsets.symmetric(
                                          horizontal: 80,
                                          vertical: 15,
                                        )
                                      : EdgeInsets.symmetric(
                                          horizontal: width * 0.2,
                                          vertical: 25,
                                        ),
                                ),
                                child: const Text(
                                  "START",
                                  style: TextStyle(color: Colors.black),
                                ),
                              ),
                            )
                          : Padding(
                              padding: const EdgeInsets.all(30),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  TextButton(
                                    onPressed: () => Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => HotelHomepage(),
                                      ),
                                    ), // ✅ SKIP → LOGIN
                                    child: const Text(
                                      "SKIP",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                  ElevatedButton(
                                    onPressed: () {
                                      _controller.nextPage(
                                        duration: const Duration(
                                          milliseconds: 200,
                                        ),
                                        curve: Curves.easeIn,
                                      );
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color.fromARGB(
                                        255,
                                        227,
                                        219,
                                        219,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                    ),
                                    child: const Text(
                                      "NEXT",
                                      style: TextStyle(color: Colors.black),
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
          ),
        ],
      ),
    );
  }
}
