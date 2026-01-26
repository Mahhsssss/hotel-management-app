import 'package:flutter/material.dart';
import 'package:hotel_de_luna/hotel_homepage.dart';
import 'package:hotel_de_luna/services/widget_support.dart';

//Functionality done, need to add images, change colours etc..

class OnboardingContents {
  //declaring variables for the onboarding contents.
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
  //declaring the size of the images within the page.
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
  //The actual contents in list format of type OnboardingContents
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
  //Stateful widget for page controller
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  late PageController _controller;

  @override
  void initState() {
    _controller = PageController();
    super.initState();
  }

  int _currentPage = 0;
  List<String> bgimages = [
    "assets/images/hotel_building.jpg",
    "assets/images/hotel_room.jpg",
    "assets/images/poolside.jpg",
  ]; //The background images

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Pre-load all background images into the system cache
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

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    double width = SizeConfig.screenW!;
    double height = SizeConfig.screenH!;

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 0, 0, 0),
      body: Stack(
        children: [
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 400),
            // layoutBuilder keeps the old image underneath the new one during the transition
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
              // The ValueKey is CRITICAL. It tells AnimatedSwitcher the image changed.
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
            //This automatically adds padding to the child
            child: Column(
              children: [
                Expanded(
                  //This fills any available space
                  flex: 3,
                  child: PageView.builder(
                    //Builds scrollabe pages, and builds the next page when scrolled to, making it memory efficient
                    physics: const BouncingScrollPhysics(),
                    controller: _controller,
                    onPageChanged: (value) =>
                        setState(() => _currentPage = value),
                    itemCount: contents.length,
                    itemBuilder: (context, i) {
                      //Dynamically builds each list items widget
                      return Padding(
                        padding: const EdgeInsets.all(50.0),
                        child: Column(
                          children: [
                            Expanded(
                              // Wrap the Image.asset with Expanded
                              child: Image.asset(
                                contents[i].image,
                                // Remove fixed height here, let it be flexible
                              ),
                            ),
                            SizedBox(height: (height >= 840) ? 40 : 20), //Title
                            Text(
                              contents[i].title,
                              textAlign: TextAlign.center,
                              style: AppWidget.headingtext(Colors.white, 27),
                            ),
                            const SizedBox(height: 15), //Description
                            Text(
                              contents[i].desc,
                              style: AppWidget.bodytext(Colors.white, 17),
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
                          (int index) => _buildDots(index: index),
                        ),
                      ),
                      _currentPage + 1 == contents.length
                          ? Padding(
                              padding: const EdgeInsets.all(30),
                              child: ElevatedButton(
                                onPressed: () {
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const HotelHomepage(), //Change this to sign in page once its made!!
                                    ),
                                  );
                                },
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
                                  textStyle: TextStyle(
                                    fontSize: (width <= 550) ? 13 : 17,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w700,
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
                                    onPressed: () {
                                      _controller.jumpToPage(2);
                                    },
                                    style: TextButton.styleFrom(
                                      elevation: 0,
                                      textStyle: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: (width <= 550) ? 13 : 17,
                                      ),
                                    ),
                                    child: const Text(
                                      "SKIP",
                                      style: TextStyle(
                                        color: Color.fromARGB(
                                          255,
                                          255,
                                          255,
                                          255,
                                        ),
                                      ),
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
                                      elevation: 0,
                                      padding: (width <= 550)
                                          ? const EdgeInsets.symmetric(
                                              horizontal: 30,
                                              vertical: 15,
                                            )
                                          : const EdgeInsets.symmetric(
                                              horizontal: 30,
                                              vertical: 25,
                                            ),
                                      textStyle: TextStyle(
                                        fontSize: (width <= 550) ? 13 : 17,
                                      ),
                                    ),
                                    child: const Text(
                                      "NEXT",
                                      style: TextStyle(
                                        color: Color.fromARGB(255, 0, 0, 0),
                                      ),
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
