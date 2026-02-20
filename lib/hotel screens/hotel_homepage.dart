import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:getwidget/components/card/gf_card.dart';
import 'package:getwidget/components/carousel/gf_carousel.dart';
import 'package:getwidget/components/list_tile/gf_list_tile.dart';
import 'package:hotel_de_luna/screens/explore_page.dart';
import 'package:hotel_de_luna/screens/filtering_screen.dart';
import 'package:hotel_de_luna/services/header.dart';
import 'package:hotel_de_luna/services/widget_support.dart';

class HotelHomepage extends StatefulWidget {
  const HotelHomepage({super.key});

  @override
  State<HotelHomepage> createState() => _HotelHomepageState();
}

class _HotelHomepageState extends State<HotelHomepage> {
  final ScrollController _mainScrollController = ScrollController();
  int _currentCardIndex = 0;

  static Widget _buildCard(
    String title,
    String sub,
    String image,
    VoidCallback onTapEvent,
  ) {
    return GestureDetector(
      onTap: onTapEvent,
      child: GFCard(
        margin: const EdgeInsets.all(8),
        padding: EdgeInsets.zero,
        showOverlayImage: true,
        imageOverlay: AssetImage(image),
        boxFit: BoxFit.cover,
        title: GFListTile(
          title: Text(
            title,
            style: AppWidget.headingcustomtext(Colors.white, 16),
          ),
          subTitle: Text(sub, style: AppWidget.smalltext(Colors.white70, 13)),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: const Color(0xFFE8F4EA),
      appBar: AppDrawer.customAppBar(
        context: context,
        colors: Colors.white,
        overlayStyle: SystemUiOverlayStyle.light,
      ),
      endDrawer: const AppDrawer(),
      body: SingleChildScrollView(
        controller: _mainScrollController,
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            // Hero Section - Full Width
            Container(
              height: 320,
              width: double.infinity,
              decoration: BoxDecoration(
                image: const DecorationImage(
                  image: AssetImage("assets/images/homepage-backdrop.jpg"),
                  fit: BoxFit.cover,
                  colorFilter: ColorFilter.mode(
                    Color.fromARGB(255, 57, 67, 57),
                    BlendMode.modulate,
                  ),
                ),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 15,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: SafeArea(
                bottom: false,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      const Text(
                        'Welcome to',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 16,
                          letterSpacing: 1,
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'HOTEL DE LUNA',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 2,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        height: 2,
                        width: 60,
                        color: Colors.white.withOpacity(0.5),
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        'Luxury Redefined',
                        style: TextStyle(color: Colors.white70, fontSize: 15),
                      ),
                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 30),

            // Featured Retreats Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Featured Retreats",
                        style: AppWidget.headingcustomtext(Colors.black87, 22),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "Explore our top destinations",
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Carousel
            SizedBox(
              height: 260,
              width: MediaQuery.of(context).size.width,
              child: GFCarousel(
                scrollPhysics: const AlwaysScrollableScrollPhysics(),
                height: 240,
                items: [
                  _buildCard(
                    "ANDHERI",
                    "12 hotels available",
                    "assets/images/andheri.webp",
                    () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            HotelFilterScreen(selectedLocation: 'ANDHERI'),
                      ),
                    ),
                  ),
                  _buildCard(
                    "BANDRA",
                    "8 hotels available",
                    "assets/images/bandra.webp",
                    () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            HotelFilterScreen(selectedLocation: 'BANDRA'),
                      ),
                    ),
                  ),
                  _buildCard(
                    "BORIVALI",
                    "15 hotels available",
                    "assets/images/borivali.webp",
                    () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            HotelFilterScreen(selectedLocation: 'BORIVALI'),
                      ),
                    ),
                  ),
                ],
                viewportFraction: 0.75,
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

            // Page Indicators
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(3, (index) {
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: _currentCardIndex == index ? 24 : 8,
                  height: 8,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    color: _currentCardIndex == index
                        ? const Color(0xFF3F5F45)
                        : Colors.grey.shade400,
                  ),
                );
              }),
            ),

            const SizedBox(height: 40),

            // CTA Button
            Center(
              child: Container(
                width: 280,
                height: 56,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  gradient: const LinearGradient(
                    colors: [
                      Color.fromARGB(255, 125, 175, 68),
                      Color.fromARGB(255, 100, 150, 50),
                    ],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: const Color.fromARGB(
                        255,
                        28,
                        65,
                        29,
                      ).withOpacity(0.3),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ExplorePage()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    padding: EdgeInsets.zero,
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Start Booking now',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(width: 8),
                      Icon(Icons.arrow_forward, size: 18),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
