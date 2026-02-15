import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:getwidget/getwidget.dart';
import 'package:hotel_de_luna/hotel%20screens/featured_retreats.dart';

import 'package:hotel_de_luna/hotel%20screens/recommended_hotels.dart';
import 'package:hotel_de_luna/screens/location_choose.dart';
import 'package:hotel_de_luna/services/header.dart';
import 'package:hotel_de_luna/services/widget_support.dart';

class HotelHomepage extends StatefulWidget {
  const HotelHomepage({super.key});

  @override
  State<HotelHomepage> createState() => _HotelHomepageState();
}

class _HotelHomepageState extends State<HotelHomepage> {
  final ScrollController _mainScrollController = ScrollController();

  // ignore: unused_field
  int _currentCardIndex = 0;

  static Widget _buildCard(String title, String sub, String image) {
    return GFCard(
      margin: EdgeInsets.all(8),
      padding: EdgeInsets.all(0),
      showOverlayImage: true,
      imageOverlay: AssetImage(image),
      boxFit: BoxFit.cover,
      title: GFListTile(
        title: Text(
          title,
          style: AppWidget.headingcustomtext(Colors.white, 15),
        ),
        subTitle: Text(sub, style: AppWidget.smalltext(Colors.white, 12)),
      ),
    );
  }

  static Widget _buildListItem(
    String name,
    String location,
    String price,
    String ratings,
    String image,
  ) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      elevation: 5,
      child: SizedBox(
        height: 100,
        child: Row(
          children: [
            SizedBox(
              width: 100,
              height: 100,
              child: Padding(
                padding: EdgeInsetsGeometry.all(5),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.asset(image, fit: BoxFit.cover),
                ),
              ),
            ),
            const SizedBox(width: 5),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: AppWidget.headingcustomtext(Colors.black, 15),
                    ),
                    Text(location, style: AppWidget.bodytext(Colors.black, 12)),
                    SizedBox(height: 25),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          price,
                          style: AppWidget.bodytext(Colors.black, 10),
                        ),
                        Text(
                          ratings,
                          style: AppWidget.bodytext(Colors.black, 10),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  // final List<Widget> cards

  final List<Map<String, String>> hotels = [
    {
      "name": 'Hotel Name',
      "location": 'Location',
      "price": '100.00',
      "rating": '4.5/5',
      "image": "assets/images/onboarding/placeholder.webp",
    },

    {
      "name": 'Hotel Name',
      "location": 'Location',
      "price": '100.00',
      "rating": '4.5/5',
      "image": "assets/images/onboarding/placeholder.webp",
    },

    {
      "name": 'Hotel Name',
      "location": 'Location',
      "price": '100.00',
      "rating": '4.5/5',
      "image": "assets/images/onboarding/placeholder.webp",
    },

    {
      "name": 'Hotel Name',
      "location": 'Location',
      "price": '100.00',
      "rating": '4.5/5',
      "image": "assets/images/onboarding/placeholder.webp",
    },

    {
      "name": 'Hotel Name',
      "location": 'Location',
      "price": '100.00',
      "rating": '4.5/5',
      "image": "assets/images/onboarding/placeholder.webp",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Color(0xFFE8F4EA),
      appBar: AppDrawer.customAppBar(
        context: context,
        colors: Colors.white,
        overlayStyle: SystemUiOverlayStyle.light,
      ),
      endDrawer: const AppDrawer(),
      body: SingleChildScrollView(
        controller: _mainScrollController,
        physics: BouncingScrollPhysics(),
        child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
              child: Container(
                padding: EdgeInsets.only(
                  top: MediaQuery.of(context).padding.top + kToolbarHeight - 20,
                  left: 20,
                  right: 20,
                ),
                height: 400,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/images/homepage-backdrop.jpg"),
                    fit: BoxFit.cover,
                    colorFilter: const ColorFilter.mode(
                      Color.fromARGB(255, 57, 67, 57),
                      BlendMode.modulate,
                    ),
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.center,

                  children: [
                    Text(
                      'Welcome to \nHOTEL DE LUNA',
                      textAlign: TextAlign.center,
                      style: AppWidget.headingcustomtext(Colors.white, 25),
                    ),
                    Text(
                      'some description here',
                      style: AppWidget.smalltext(Colors.white, 15),
                    ),
                    const SizedBox(height: 70),
                    Container(
                      margin: EdgeInsets.only(top: 15, bottom: 15),
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(130, 255, 255, 255),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: TextField(
                        textAlignVertical: TextAlignVertical.center,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          isDense: true,
                          prefixIcon: Icon(
                            Icons.search_rounded,
                            color: const Color.fromARGB(255, 0, 0, 0),
                          ),
                          hintText: "Search a location",
                          hintStyle: AppWidget.smalltext(Colors.black, 16),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Featured Retreats ",
                    style: AppWidget.headingcustomtext(Colors.black, 20),
                  ),
                  GFButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => FeaturedRetreats(),
                        ),
                      );
                    },
                    text: "See all",
                    color: const Color.fromARGB(255, 50, 109, 48),
                    type: GFButtonType.transparent,
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 250,
              width: MediaQuery.of(context).size.width,
              child: GFCarousel(
                scrollPhysics: const AlwaysScrollableScrollPhysics(),
                height: 220,
                items: [
                  _buildCard(
                    "Hotel name",
                    "description",
                    "assets/images/onboarding/placeholder.webp",
                  ),
                  _buildCard(
                    "Hotel name",
                    "description",
                    "assets/images/onboarding/placeholder.webp",
                  ),
                  _buildCard(
                    "Hotel name",
                    "description",
                    "assets/images/onboarding/placeholder.webp",
                  ),
                ],
                viewportFraction: 0.8,
                onPageChanged: (i) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    if (mounted) {
                      setState(() {
                        _currentCardIndex = i;
                      });
                    }
                  });
                },
                enlargeMainPage: true,
                enableInfiniteScroll: true,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Recommended",
                    style: AppWidget.headingcustomtext(Colors.black, 20),
                  ),
                  GFButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => RecommendedHotels(),
                        ),
                      );
                    },
                    text: "See all",
                    color: const Color.fromARGB(255, 50, 109, 48),
                    type: GFButtonType.transparent,
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 250,
              width: MediaQuery.of(context).size.width,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Scrollbar(
                  thumbVisibility: true,
                  radius: Radius.circular(4),
                  child: ListView.separated(
                    padding: EdgeInsets.zero,
                    itemCount: 5,
                    separatorBuilder: (BuildContext context, int index) =>
                        const SizedBox(height: 5),
                    itemBuilder: (BuildContext context, int index) {
                      final hotel = hotels[index];

                      return _buildListItem(
                        hotel["name"]!,
                        hotel["location"]!,
                        hotel["price"]!,
                        hotel["rating"]!,
                        hotel["image"]!,
                      );
                    },
                  ),
                ),
              ),
            ),
            SizedBox(height: 15),
            SizedBox(
              height: 50,
              width: 275,
              child: Container(
                // margin: EdgeInsets.only(left: 45, right: 45),
                // padding: EdgeInsets.only(),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ExplorePage(),
                      ),
                    );
                    /* Will navigate to booking screen/ filtering screen*/
                  },
                  style: ElevatedButton.styleFrom(
                    elevation: 5,
                    visualDensity: VisualDensity(horizontal: 3, vertical: 3),
                    shadowColor: const Color.fromARGB(255, 28, 65, 29),
                    backgroundColor: const Color.fromARGB(255, 125, 175, 68),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    'Start Booking now',
                    style: AppWidget.bodytext(Colors.black, 15),
                  ),
                ),
              ),
            ),
            SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
