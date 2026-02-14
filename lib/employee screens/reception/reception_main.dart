import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hotel_de_luna/services/header.dart';

class ReceptionMain extends StatelessWidget {
  const ReceptionMain({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 255, 255, 255),
      appBar: AppDrawer.customAppBar(
        context: context,
        colors: Colors.black,
        overlayStyle: SystemUiOverlayStyle.dark,
      ),
      endDrawer: const AppDrawer(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Column(
          children: [
            const ProfilePic(),
            const SizedBox(height: 40),
            ProfileMenu(
              text: "My Account",
              icon: Icons.person,
              press: () => {},
            ),
            ProfileMenu(text: "Tasks", icon: Icons.task, press: () {}),
            ProfileMenu(
              text: "Schedule",
              icon: Icons.calendar_month,
              press: () {},
            ),
            ProfileMenu(
              text: "Manage Employees",
              icon: Icons.manage_accounts,
              press: () {},
            ),

            ProfileMenu(text: "Log Out", icon: Icons.login, press: () {}),
          ],
        ),
      ),
    );
  }
}

class ProfilePic extends StatelessWidget {
  const ProfilePic({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 150,
      width: 150,
      child: Stack(
        fit: StackFit.expand,
        clipBehavior: Clip.none,
        children: [
          const CircleAvatar(
            backgroundImage: AssetImage(
              "assets/images/onboarding/placeholder.webp",
            ),
          ),
        ],
      ),
    );
  }
}

class ProfileMenu extends StatelessWidget {
  const ProfileMenu({
    super.key,
    required this.text,
    required this.icon,
    this.press,
  });

  final String text;
  final IconData icon;
  final VoidCallback? press;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height / 9,
      decoration: BoxDecoration(),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: TextButton(
          style: TextButton.styleFrom(
            foregroundColor: const Color.fromARGB(255, 50, 83, 50),
            padding: const EdgeInsets.all(20),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            backgroundColor: const Color(0xFFF5F6F9),
          ),
          onPressed: press,
          child: Row(
            children: [
              Icon(icon, size: 15),
              const SizedBox(width: 20),
              Expanded(
                child: Text(
                  text,
                  style: const TextStyle(
                    color: Color(0xFF757575),
                    fontSize: 15,
                  ),
                ),
              ),
              const Icon(
                Icons.arrow_forward_ios,
                color: Color.fromARGB(255, 50, 83, 50),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
