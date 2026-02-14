import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:getwidget/getwidget.dart';
import 'package:hotel_de_luna/hotel%20screens/featured_retreats.dart';
import 'package:hotel_de_luna/hotel%20screens/hotel_info_screens/hotel_info1.dart';
import 'package:hotel_de_luna/hotel%20screens/recommended_hotels.dart';
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
        child: SizedBox(
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
      ),
    );
  }
}
