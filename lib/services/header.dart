import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:getwidget/getwidget.dart';
import 'package:hotel_de_luna/drawer%20nav%20screens/terms_cnd_page.dart';
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
      backgroundColor: const Color.fromARGB(0, 255, 255, 255),
      scrolledUnderElevation: 0, 
      surfaceTintColor: Colors.transparent,
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
        statusBarColor: const Color.fromARGB(0, 0, 0, 0),
      ),
    );
  }

  static AppBar customEmpAppBar({
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
      systemOverlayStyle: overlayStyle.copyWith(
        statusBarColor: Colors.transparent,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
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

              ListTile(
                onTap: () {
                  /* Navigate */
                },
                contentPadding: EdgeInsets.zero,
                trailing: const Icon(
                  Icons.person,
                  color: Color.fromARGB(255, 15, 56, 16),
                ),
                title: Text(
                  "Profile",
                  style: AppWidget.bodytext(Colors.black, 17),
                  textAlign: TextAlign.end,
                ),
              ),

              ListTile(
                onTap: () => Navigator.pushReplacement(
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

              ListTile(
                onTap: () => Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => HotelHomepage()),
                ),
                contentPadding: EdgeInsets.zero,
                trailing: const Icon(
                  Icons.search_rounded,
                  color: Color.fromARGB(255, 15, 56, 16),
                ),
                title: Text(
                  "Search now!",
                  style: AppWidget.bodytext(Colors.black, 17),
                  textAlign: TextAlign.end,
                ),
              ),

              // ListTile(
              //   onTap: () => Navigator.push(
              //     context,
              //     MaterialPageRoute(builder: (context) => HotelHomepage()),
              //   ),
              //   contentPadding: EdgeInsets.zero,
              //   trailing: const Icon(
              //     Icons.home_rounded,
              //     color: Color.fromARGB(255, 15, 56, 16),
              //   ),
              //   title: Text(
              //     "",
              //     style: AppWidget.bodytext(Colors.black, 17),
              //     textAlign: TextAlign.end,
              //   ),

              // ),

              //add more drawer items here
              const Spacer(),

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

              GFButton(
                onPressed: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> TermsConditionsPage())),
                text: "Terms and conditions",
                textStyle: TextStyle(
                  decoration: TextDecoration.underline,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: const Color.fromARGB(255, 95, 99, 95),
                ),
                type: GFButtonType.transparent,
              ),

              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    IconButton(
                      onPressed: () {},
                      icon: FaIcon(
                        FontAwesomeIcons.instagram,
                        color: const Color.fromARGB(255, 255, 255, 255),
                        size: 20,
                      ),
                      style: IconButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        backgroundColor: const Color.fromARGB(255, 15, 56, 16),
                      ),
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: FaIcon(
                        FontAwesomeIcons.linkedin,
                        color: const Color.fromARGB(255, 255, 255, 255),
                        size: 20,
                      ),
                      style: IconButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        backgroundColor: const Color.fromARGB(255, 15, 56, 16),
                      ),
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: FaIcon(
                        FontAwesomeIcons.twitter,
                        color: const Color.fromARGB(255, 255, 255, 255),
                        size: 20,
                      ),
                      style: IconButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        backgroundColor: const Color.fromARGB(255, 15, 56, 16),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Future<void> _launchUrl(String urlString) async {
//   final Uri url = Uri.parse(urlString);
//   if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
//     throw 'Could not launch $urlString';
//   }
// }
