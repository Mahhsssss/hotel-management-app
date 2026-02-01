import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:getwidget/getwidget.dart';
import 'package:hotel_de_luna/hotel%20screens/hotel_homepage.dart';
import 'package:hotel_de_luna/services/widget_support.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  static AppBar customAppBar({
    required BuildContext context,
    String? title,
    required colors,
    SystemUiOverlayStyle overlayStyle = SystemUiOverlayStyle.dark,
  }) {
    return AppBar(
      backgroundColor: Colors.transparent,
      title: title != null
          ? Text(title, style: AppWidget.headingtext(colors, 20))
          : null,
      centerTitle: true,
      iconTheme: IconThemeData(color: colors, size: 30),
      actions: [
        Builder(
          builder: (context) => IconButton(
            onPressed: () => Scaffold.of(context).openEndDrawer(),
            icon: Icon(Icons.menu_open, color: colors),
          ),
        ),
      ],
      systemOverlayStyle: overlayStyle.copyWith(
        statusBarColor: Colors.transparent,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        // Ensures content doesn't hit the status bar
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              // 1. Better Close Button
              Material(
                color: const Color.fromARGB(255, 15, 56, 16),
                borderRadius: BorderRadius.circular(10),
                child: IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(
                    Icons.close_rounded,
                    size: 30,
                    color: Colors.white,
                  ),
                ),
              ),

              const SizedBox(height: 30),

              // 2. Profile Item
              ListTile(
                onTap: () {
                  /* Navigate */
                },
                contentPadding: EdgeInsets.zero, // Aligns better with the edges
                trailing: const Icon(
                  Icons.person,
                  color: Color.fromARGB(255, 15, 56, 16),
                ),
                title: Text(
                  "Profile",
                  style: AppWidget.bodytext(
                    Colors.black,
                    17,
                  ), // Slightly bigger
                  textAlign: TextAlign.end,
                ),
              ),

              // 3. Home Item
              ListTile(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => HotelHomepage()),
                ),
                contentPadding: EdgeInsets.zero,
                trailing: const Icon(
                  Icons.home_rounded,
                  color: Color.fromARGB(255, 15, 56, 16),
                ),
                title: Text(
                  "Home",
                  style: AppWidget.bodytext(Colors.black, 17),
                  textAlign: TextAlign.end,
                ),
              ),

              // 4. Push everything below to the bottom
              const Spacer(),

              // 5. Sign Out
              GFButton(
                onPressed: () => Navigator.pop(context),
                text: "Sign out",
                textStyle: TextStyle(
                  decoration: TextDecoration.underline,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: const Color.fromARGB(255, 50, 109, 48),
                ),
                type: GFButtonType.transparent,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
