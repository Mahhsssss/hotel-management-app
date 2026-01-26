import 'package:flutter/material.dart';
import 'package:hotel_de_luna/services/widget_support.dart';

class HotelHomepage extends StatefulWidget {
  const HotelHomepage({super.key});

  @override
  State<HotelHomepage> createState() => _HotelHomepageState();
}

class _HotelHomepageState extends State<HotelHomepage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFE8F4EA),
      body: Container(
        child: Column(
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  ),
                  child: Container(
                    padding: EdgeInsets.only(top: 50, left: 30, right: 30),
                    height: 250,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(
                          "assets/images/homepage-backdrop.jpg",
                        ),
                        fit: BoxFit.cover,
                        colorFilter: const ColorFilter.mode(
                          Color.fromARGB(255, 67, 117, 69),
                          BlendMode.modulate,
                        ),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.location_on_outlined,
                              color: Colors.white,
                            ),
                            SizedBox(width: 4),
                            Text(
                              "Mumbai, India",
                              style: AppWidget.smalltext(Colors.white, 15),
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                        Text(
                          'Welcome to Hotel De Luna',
                          style: AppWidget.headingcustomtext(Colors.white, 25),
                        ),
                        SizedBox(height: 10),
                        Container(
                          margin: EdgeInsets.only(top: 20, right: 5, left: 5),
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(117, 255, 255, 255),
                            borderRadius: BorderRadius.circular(25),
                          ),
                          child: TextField(
                            textAlignVertical: TextAlignVertical.center,
                            decoration: InputDecoration(
                              border: InputBorder.none,
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
              ],
            ),
          ],
        ),
      ),
    );
  }
}
