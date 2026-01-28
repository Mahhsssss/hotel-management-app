import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hotel_de_luna/services/widget_support.dart';

class FeaturedRetreats extends StatefulWidget {
  const FeaturedRetreats({super.key});

  @override
  State<FeaturedRetreats> createState() => _RecommendedHotelsState();
}

class _RecommendedHotelsState extends State<FeaturedRetreats> {
  //Card Constructor
  final List<Map<String, String>> hotels = [
    {
      "name": 'Hotel Name',
      "location": 'Location',
      "price": '100.00',
      "rating": '4.5/5',
      "image": "assets/images/placeholder.jpg",
    },

    {
      "name": 'Hotel Name',
      "location": 'Location',
      "price": '100.00',
      "rating": '4.5/5',
      "image": "assets/images/placeholder.jpg",
    },

    {
      "name": 'Hotel Name',
      "location": 'Location',
      "price": '100.00',
      "rating": '4.5/5',
      "image": "assets/images/placeholder.jpg",
    },

    {
      "name": 'Hotel Name',
      "location": 'Location',
      "price": '100.00',
      "rating": '4.5/5',
      "image": "assets/images/placeholder.jpg",
    },

    {
      "name": 'Hotel Name',
      "location": 'Location',
      "price": '100.00',
      "rating": '4.5/5',
      "image": "assets/images/placeholder.jpg",
    },

    {
      "name": 'Hotel Name',
      "location": 'Location',
      "price": '100.00',
      "rating": '4.5/5',
      "image": "assets/images/placeholder.jpg",
    },

    {
      "name": 'Hotel Name',
      "location": 'Location',
      "price": '100.00',
      "rating": '4.5/5',
      "image": "assets/images/placeholder.jpg",
    },

    {
      "name": 'Hotel Name',
      "location": 'Location',
      "price": '100.00',
      "rating": '4.5/5',
      "image": "assets/images/placeholder.jpg",
    },

    {
      "name": 'Hotel Name',
      "location": 'Location',
      "price": '100.00',
      "rating": '4.5/5',
      "image": "assets/images/placeholder.jpg",
    },
  ];

  int get count => hotels.length.toInt();
  //Card items
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
        height: 150,
        child: Row(
          children: [
            SizedBox(
              width: 150,
              height: 150,
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
                          style: AppWidget.bodytext(Colors.black, 12),
                        ),
                        Row(
                          children: [
                            Icon(
                              Icons.star_outline_rounded,
                              color: const Color.fromARGB(255, 117, 114, 114),
                            ),
                            Text(
                              ratings,
                              style: AppWidget.bodytext(Colors.black, 12),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    Flexible(
                      child: Center(
                        child: ElevatedButton(
                          onPressed: () {
                            /*Will redirect to the hotel page */
                          },
                          style: ElevatedButton.styleFrom(
                            elevation: 2,
                            shadowColor: Colors.green,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: Text(
                            "Book Now!",
                            style: TextStyle(color: Colors.green),
                          ),
                        ),
                      ),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Color(0xFFE8F4EA),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Navigator.canPop(context)
            ? const BackButton(color: Colors.white)
            : null,
        systemOverlayStyle: SystemUiOverlayStyle.light,
      ),
      body: SingleChildScrollView(
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
                    padding: EdgeInsets.only(
                      top:
                          MediaQuery.of(context).padding.top +
                          kToolbarHeight -
                          20,
                      left: 20,
                      right: 20,
                    ),
                    height: 160,
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
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.end,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 15),
                          child: Text(
                            'FEATURED RETREATS',
                            style: AppWidget.headingcustomtext(
                              Colors.white,
                              25,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 15),
            Align(
              alignment: Alignment.centerLeft,
              child: Row(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 3, horizontal: 10),
                    margin: EdgeInsets.only(left: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                      color: const Color.fromARGB(108, 173, 171, 171),
                      border: Border.all(
                        color: const Color.fromARGB(
                          55,
                          255,
                          255,
                          255,
                        ), // Rectangle border color
                        width: 1.0, // Border thickness
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.location_on_sharp, color: Colors.black),
                        Text(
                          "Mumbai, India",
                          style: AppWidget.bodytext(Colors.black, 14),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 3, horizontal: 10),
                    margin: EdgeInsets.only(left: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                      color: const Color.fromARGB(108, 173, 171, 171),
                      border: Border.all(
                        color: const Color.fromARGB(
                          55,
                          255,
                          255,
                          255,
                        ), // Rectangle border color
                        width: 1.0, // Border thickness
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.star_border_outlined, color: Colors.black),
                        Text(
                          "4 stars and above",
                          style: AppWidget.bodytext(Colors.black, 14),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 7),
            SizedBox(
              height:
                  MediaQuery.of(context).size.height -
                  kBottomNavigationBarHeight,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListView.separated(
                  padding: EdgeInsets.zero,
                  itemCount: count,
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
          ],
        ),
      ),
    );
  }
}
