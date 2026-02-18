import 'package:flutter/material.dart';

class MyAccountScreen extends StatelessWidget {
  const MyAccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F3FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Color.fromARGB(255, 156, 198, 171)),
          onPressed: () {},
        ),
        title: const Text(
          "My Account",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Profile section
            const SizedBox(height: 10),
            const CircleAvatar(
              radius: 45,
              backgroundColor: Color(0xFFFFC107),
              child: CircleAvatar(
                radius: 40,
                backgroundImage: NetworkImage(
                  "https://i.pravatar.cc/300",
                ),
              ),
            ),
            const SizedBox(height: 12),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Text(
                  "Liam Smith",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(width: 6),
                Icon(Icons.verified, color: Colors.blue, size: 18),
              ],
            ),

            const SizedBox(height: 4),
            const Text(
              "wilson@example.com",
              style: TextStyle(
                color: Colors.grey,
                fontSize: 13,
              ),
            ),

            const SizedBox(height: 20),

            // Personal Details Card
            _InfoCard(
              title: "Personal details",
              rows: const [
                InfoRow(label: "Full name:", value: "Lara Raj"),
                InfoRow(label: "Date of Birth:", value: "January 1, 1987"),
                InfoRow(label: "Gender:", value: "--"),
                InfoRow(label: "Nationality:", value: "--"),
                InfoRow(
                  label: "Address:",
                  value: "California - United States",
                  leading: Text("🇺🇸", style: TextStyle(fontSize: 16)),
                ),
                InfoRow(label: "Phone Number:", value: "0123456789"),
                InfoRow(label: "Email:", value: "lararaj_hoteldeluna@hotel.org"),
              ],
            ),

            const SizedBox(height: 16),

            // Account Details Card
            _InfoCard(
              title: "Account Details",
              rows: const [
                InfoRow(label: "Display Name:", value: "s_wilson_168920"),
                InfoRow(label: "Account Created:", value: "March 20, 2020"),
                InfoRow(label: "Last Login:", value: "August 22, 2024"),
                InfoRow(
                  label: "Account Verification:",
                  value: "Verified",
                  valueWidget: _VerifiedBadge(),
                ),
                InfoRow(label: "Language Preference:", value: "English"),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// ---------------------------
/// Reusable Card Widget
/// ---------------------------
class _InfoCard extends StatelessWidget {
  final String title;
  final List<InfoRow> rows;

  const _InfoCard({
    required this.title,
    required this.rows,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 12,
            offset: const Offset(0, 6),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 12),

          ...rows.map((row) => Column(
            children: [
              row,
              if (row != rows.last)
                Divider(
                  height: 18,
                  thickness: 1,
                  color: Colors.grey.shade200,
                ),
            ],
          )),
        ],
      ),
    );
  }
}

/// ---------------------------
/// Single Row Widget
/// ---------------------------
class InfoRow extends StatelessWidget {
  final String label;
  final String value;
  final Widget? leading;
  final Widget? valueWidget;

  const InfoRow({
    super.key,
    required this.label,
    required this.value,
    this.leading,
    this.valueWidget,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 120,
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.grey,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),

        Expanded(
          child: Row(
            children: [
              if (leading != null) ...[
                leading!,
                const SizedBox(width: 6),
              ],
              Expanded(
                child: valueWidget ??
                    Text(
                      value,
                      style: const TextStyle(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// ---------------------------
/// Verified Badge Widget
/// ---------------------------
class _VerifiedBadge extends StatelessWidget {
  const _VerifiedBadge();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFFE8F7EE),
        borderRadius: BorderRadius.circular(20),
      ),

      child: const Text(
        "Verified",
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w700,
          color: Color(0xFF2E7D32),
        ),
      ),
    );
  }
}
