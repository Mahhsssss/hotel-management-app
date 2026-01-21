import 'package:flutter/material.dart';

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
    image: "assets/images/image2.png",
    desc: "Book one of hundreds of types of rooms.",
  ),
  OnboardingContents(
    title: "Enjoy a Luxurious stay",
    image: "assets/images/image3.png",
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
  List colors = const [
    Color.fromARGB(212, 124, 173, 138),
    Color.fromARGB(210, 130, 179, 145),
    Color.fromARGB(211, 139, 192, 154),
  ]; //The background colours.

  AnimatedContainer _buildDots({int? index}) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(25)),
        color: Color(0xFF000000),
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
      backgroundColor: colors[_currentPage],
      body: SafeArea(
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
                onPageChanged: (value) => setState(() => _currentPage = value),
                itemCount: contents.length,
                itemBuilder: (context, i) {
                  //Dynamically builds each list items widget
                  return Padding(
                    padding: const EdgeInsets.all(40.0),
                    child: Column(
                      children: [
                        Expanded(
                          // Wrap the Image.asset with Expanded
                          child: Image.asset(
                            contents[i].image,
                            // Remove fixed height here, let it be flexible
                          ),
                        ),
                        SizedBox(height: (height >= 840) ? 60 : 30), //Title
                        Text(
                          contents[i].title,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: "Serif",
                            fontWeight: FontWeight.w800,
                            fontSize: (width <= 550) ? 30 : 35,
                          ),
                        ),
                        const SizedBox(height: 15), //Description
                        Text(
                          contents[i].desc,
                          style: TextStyle(
                            fontFamily: "Poppins",
                            fontWeight: FontWeight.w300,
                            fontSize: (width <= 550) ? 17 : 25,
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
                      (int index) => _buildDots(index: index),
                    ),
                  ),
                  _currentPage + 1 == contents.length
                      ? Padding(
                          padding: const EdgeInsets.all(30),
                          child: ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.black,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              padding: (width <= 550)
                                  ? const EdgeInsets.symmetric(
                                      horizontal: 100,
                                      vertical: 20,
                                    )
                                  : EdgeInsets.symmetric(
                                      horizontal: width * 0.2,
                                      vertical: 25,
                                    ),
                              textStyle: TextStyle(
                                fontSize: (width <= 550) ? 13 : 17,
                              ),
                            ),
                            child: const Text("START"),
                          ),
                        )
                      : Padding(
                          padding: const EdgeInsets.all(30),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                  style: TextStyle(color: Colors.black),
                                ),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  _controller.nextPage(
                                    duration: const Duration(milliseconds: 200),
                                    curve: Curves.easeIn,
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.black,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  elevation: 0,
                                  padding: (width <= 550)
                                      ? const EdgeInsets.symmetric(
                                          horizontal: 30,
                                          vertical: 20,
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
                                    color: Color.fromARGB(255, 247, 229, 229),
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
    );
  }
}
