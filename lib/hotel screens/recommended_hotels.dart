import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hotel_de_luna/services/widget_support.dart';
import 'package:hotel_de_luna/services/hotel_service.dart';
import 'package:hotel_de_luna/models/hotel_model.dart';

class RecommendedHotels extends StatefulWidget {
  const RecommendedHotels({super.key});

  @override
  State<RecommendedHotels> createState() => _RecommendedHotelsState();
}

class _RecommendedHotelsState extends State<RecommendedHotels> {
  final _hotelService = HotelService();

  List<Hotel> _hotels = [];
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadHotels();
  }

  Future<void> _loadHotels() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final hotels = await _hotelService.getAllHotels();

      setState(() {
        _hotels = hotels;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to load hotels: $e';
        _isLoading = false;
      });
    }
  }

  // Card item builder with dynamic data
  Widget _buildListItem(Hotel hotel) {
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
                padding: EdgeInsets.all(5),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.network(
                    hotel.images[0],
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: Colors.grey[300],
                        child: Image.asset(
                          "assets/images/hotel2.webp",
                          fit: BoxFit.cover,
                        ),
                      );
                    },
                  ),
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
                      hotel.name,
                      style: AppWidget.headingcustomtext(Colors.black, 15),
                    ),
                    Text(
                      hotel.location,
                      style: AppWidget.bodytext(Colors.black, 12),
                    ),
                    SizedBox(height: 25),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '₹${hotel.price.toString()}',
                          style: AppWidget.bodytext(Colors.black, 12),
                        ),
                        Row(
                          children: [
                            Icon(Icons.star, color: Colors.amber, size: 16),
                            Text(
                              ' ${hotel.starRating.toString()}/5',
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
                            // Navigate to hotel details page
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

  int get count => _hotels.length;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: false,
      backgroundColor: Color(0xFFE8F4EA),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Navigator.canPop(context)
            ? const BackButton(color: Colors.black)
            : null,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        title: Text(
          'RECOMMENDED ROOMS',
          style: AppWidget.headingcustomtext(Colors.black, 23),
        ),
        centerTitle: true,
      ),
      body: RefreshIndicator(
        onRefresh: _loadHotels,
        child: SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 15),
              // Location filter chips
              Align(
                alignment: Alignment.centerLeft,
                child: Row(
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(
                        vertical: 3,
                        horizontal: 10,
                      ),
                      margin: EdgeInsets.only(left: 10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25),
                        color: const Color.fromARGB(108, 173, 171, 171),
                        border: Border.all(
                          color: const Color.fromARGB(55, 255, 255, 255),
                          width: 1.0,
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
                      padding: EdgeInsets.symmetric(
                        vertical: 3,
                        horizontal: 10,
                      ),
                      margin: EdgeInsets.only(left: 10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25),
                        color: const Color.fromARGB(108, 173, 171, 171),
                        border: Border.all(
                          color: const Color.fromARGB(55, 255, 255, 255),
                          width: 1.0,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.star_border_outlined, color: Colors.black),
                          Text(
                            "3 stars and above",
                            style: AppWidget.bodytext(Colors.black, 14),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 7),

              // Hotels List
              _isLoading
                  ? Container(
                      height: MediaQuery.of(context).size.height * 0.6,
                      child: Center(child: CircularProgressIndicator()),
                    )
                  : _errorMessage != null
                  ? Container(
                      height: MediaQuery.of(context).size.height * 0.6,
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              _errorMessage!,
                              style: TextStyle(color: Colors.red),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: 10),
                            ElevatedButton(
                              onPressed: _loadHotels,
                              child: Text('Retry'),
                            ),
                          ],
                        ),
                      ),
                    )
                  : _hotels.isEmpty
                  ? Container(
                      height: MediaQuery.of(context).size.height * 0.6,
                      child: Center(child: Text('No hotels found')),
                    )
                  : SizedBox(
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
                            final hotel = _hotels[index];
                            return _buildListItem(hotel);
                          },
                        ),
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
