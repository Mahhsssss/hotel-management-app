// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hotel_de_luna/services/analytics_service.dart';
import 'package:hotel_de_luna/services/header.dart';

class AnalyticsDashboard extends StatefulWidget {
  const AnalyticsDashboard({Key? key}) : super(key: key);

  @override
  State<AnalyticsDashboard> createState() => _AnalyticsDashboardState();
}

class _AnalyticsDashboardState extends State<AnalyticsDashboard> {
  final AnalyticsService _analytics = AnalyticsService();

  // ── Colours matching employee_main.dart ──
  static const Color kGreenDark = Color.fromARGB(255, 50, 83, 50);
  static const Color kGreenMid = Color.fromARGB(255, 70, 110, 70);
  static const Color kBrown1 = Color.fromARGB(255, 100, 80, 60);
  static const Color kBrown2 = Color.fromARGB(255, 120, 100, 80);
  static const Color kBg = Color(0xFFF8FAF5);
  static const Color kBgMint = Color(0xFFE8F4EA);
  static const Color kSuccess = Color(0xFF4CAF50);
  static const Color kWarning = Color(0xFFFF9800);
  static const Color kError = Color(0xFFE53935);

  // ── Data ──
  double totalRevenue = 0;
  int totalBookings = 0;
  int confirmedBookings = 0;
  int successfulPayments = 0;
  int totalUsers = 0;
  int totalCustomers = 0;
  int totalEmployees = 0;
  double avgNights = 0;
  double avgGuests = 0;
  double avgPricePerNight = 0;

  Map<String, double> revenuePerHotel = {};
  Map<String, double> revenuePerLocation = {};
  Map<String, int> bookingsByStatus = {};
  Map<String, int> bookingsByPaymentMethod = {};
  Map<String, int> bookingsPerHotel = {};
  Map<String, int> bookingsPerLocation = {};
  Map<String, int> bookingsByRoomType = {};
  Map<String, int> taskStats = {};
  Map<String, int> usersByRole = {};

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _testEachMethod();
    _loadAll();
  }

  Future<void> _testEachMethod() async {
    print("=== TESTING EACH ANALYTICS METHOD ===");
    try {
      print("Total Revenue: ${await _analytics.getTotalRevenue()}");
      print("Total Bookings: ${await _analytics.getTotalBookings()}");
      print("Confirmed Bookings: ${await _analytics.getConfirmedBookings()}");
      print("Successful Payments: ${await _analytics.getSuccessfulPayments()}");
      print("Avg Guests: ${await _analytics.getAverageGuestsPerBooking()}");
      print("Avg Nights: ${await _analytics.getAverageNightsPerBooking()}");
      print("Avg Price/Night: ${await _analytics.getAveragePricePerNight()}");
      print("Total Users: ${await _analytics.getTotalUsers()}");
      print("Total Customers: ${await _analytics.getTotalCustomers()}");
      print("Total Employees: ${await _analytics.getTotalEmployees()}");

      // These return maps
      print("Revenue per Hotel: ${await _analytics.getRevenuePerHotel()}");
      print("Bookings by Status: ${await _analytics.getBookingsByStatus()}");
      print("Task Stats: ${await _analytics.getTaskStats()}");
    } catch (e) {
      print("❌ Error in test: $e");
    }
    print("=== END TEST ===");
  }

  Future<void> _loadAll() async {
    setState(() => isLoading = true);
    try {
      // Load all data with proper error handling
      totalRevenue = await _analytics.getTotalRevenue();
      totalBookings = await _analytics.getTotalBookings();
      confirmedBookings = await _analytics.getConfirmedBookings();
      successfulPayments = await _analytics.getSuccessfulPayments();
      totalUsers = await _analytics.getTotalUsers();
      totalCustomers = await _analytics.getTotalCustomers();
      totalEmployees = await _analytics.getTotalEmployees();
      avgNights = await _analytics.getAverageNightsPerBooking();
      avgGuests = await _analytics.getAverageGuestsPerBooking();
      avgPricePerNight = await _analytics.getAveragePricePerNight();

      revenuePerHotel = await _analytics.getRevenuePerHotel();
      revenuePerLocation = await _analytics.getRevenuePerLocation();
      bookingsByStatus = await _analytics.getBookingsByStatus();
      bookingsByPaymentMethod = await _analytics.getBookingsByPaymentMethod();
      bookingsPerHotel = await _analytics.getBookingsPerHotel();
      bookingsPerLocation = await _analytics.getBookingsPerLocation();
      bookingsByRoomType = await _analytics.getBookingsByRoomType();
      taskStats = await _analytics.getTaskStats();
      usersByRole = await _analytics.getUsersByRole();

      setState(() => isLoading = false);
    } catch (e) {
      print("❌ Analytics error: $e");
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBg,
      appBar: AppDrawer.customEmpAppBar(
        context: context,
        colors: kGreenDark,
        overlayStyle: SystemUiOverlayStyle.dark,
        title: "Hotel Analytics",
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator(color: kGreenDark))
          : RefreshIndicator(
              onRefresh: _loadAll,
              color: kGreenDark,
              child: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [kBgMint, kBg],
                  ),
                ),
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(
                    parent: BouncingScrollPhysics(),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 24,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ── Header Banner ──
                      _heroBanner(),
                      const SizedBox(height: 28),

                      // ── Revenue ──
                      _sectionTitle('💰 Revenue Overview'),
                      const SizedBox(height: 14),
                      _bigRevenueCard(),
                      const SizedBox(height: 14),
                      _twoStatRow(
                        label1: 'Avg Price / Night',
                        value1: '₹${avgPricePerNight.toStringAsFixed(0)}',
                        icon1: Icons.nights_stay,
                        color1: kGreenDark,
                        label2: 'Paid Bookings',
                        value2: '$successfulPayments',
                        icon2: Icons.check_circle_outline,
                        color2: kGreenMid,
                      ),
                      const SizedBox(height: 16),
                      _sectionTitle('Revenue by Hotel'),
                      const SizedBox(height: 10),
                      ...revenuePerHotel.entries.map(
                        (e) => _barRow(
                          e.key,
                          e.value,
                          revenuePerHotel.values.fold(
                            0.0,
                            (a, b) => a > b ? a : b,
                          ),
                          '₹${e.value.toStringAsFixed(0)}',
                          kGreenDark,
                        ),
                      ),
                      const SizedBox(height: 16),
                      _sectionTitle('Revenue by Location'),
                      const SizedBox(height: 10),
                      ...revenuePerLocation.entries.map(
                        (e) => _barRow(
                          e.key,
                          e.value,
                          revenuePerLocation.values.fold(
                            0.0,
                            (a, b) => a > b ? a : b,
                          ),
                          '₹${e.value.toStringAsFixed(0)}',
                          kBrown1,
                        ),
                      ),

                      const SizedBox(height: 28),

                      // ── Bookings ──
                      _sectionTitle('📅 Bookings Overview'),
                      const SizedBox(height: 14),
                      _threeStatRow(
                        label1: 'Total',
                        value1: '$totalBookings',
                        icon1: Icons.book_online,
                        color1: kGreenDark,
                        label2: 'Confirmed',
                        value2: '$confirmedBookings',
                        icon2: Icons.verified,
                        color2: kSuccess,
                        label3: 'Paid',
                        value3: '$successfulPayments',
                        icon3: Icons.payments,
                        color3: kBrown1,
                      ),
                      const SizedBox(height: 14),
                      _twoStatRow(
                        label1: 'Avg Nights',
                        value1: avgNights.toStringAsFixed(1),
                        icon1: Icons.calendar_today,
                        color1: kGreenMid,
                        label2: 'Avg Guests',
                        value2: avgGuests.toStringAsFixed(1),
                        icon2: Icons.people,
                        color2: kBrown1,
                      ),
                      const SizedBox(height: 16),
                      _sectionTitle('Bookings by Status'),
                      const SizedBox(height: 10),
                      ...bookingsByStatus.entries.map(
                        (e) => _barRow(
                          _capitalize(e.key),
                          e.value.toDouble(),
                          bookingsByStatus.values
                              .fold(0, (a, b) => a > b ? a : b)
                              .toDouble(),
                          '${e.value}',
                          _statusColor(e.key),
                        ),
                      ),
                      const SizedBox(height: 16),
                      _sectionTitle('Bookings by Hotel'),
                      const SizedBox(height: 10),
                      ...bookingsPerHotel.entries.map(
                        (e) => _barRow(
                          e.key,
                          e.value.toDouble(),
                          bookingsPerHotel.values
                              .fold(0, (a, b) => a > b ? a : b)
                              .toDouble(),
                          '${e.value}',
                          kGreenDark,
                        ),
                      ),
                      const SizedBox(height: 16),
                      _sectionTitle('Bookings by Location'),
                      const SizedBox(height: 10),
                      ...bookingsPerLocation.entries.map(
                        (e) => _barRow(
                          e.key,
                          e.value.toDouble(),
                          bookingsPerLocation.values
                              .fold(0, (a, b) => a > b ? a : b)
                              .toDouble(),
                          '${e.value}',
                          kBrown1,
                        ),
                      ),
                      const SizedBox(height: 28),

                      // ── Payments ──
                      _sectionTitle('💳 Payment Methods'),
                      const SizedBox(height: 10),
                      ...bookingsByPaymentMethod.entries.map(
                        (e) => _listTileCard(
                          e.key,
                          '${e.value} transactions',
                          Icons.payment,
                          kBrown1,
                        ),
                      ),

                      const SizedBox(height: 28),

                      // ── Tasks ──
                      _sectionTitle('✅ Task Overview'),
                      const SizedBox(height: 14),
                      _taskCard(),

                      const SizedBox(height: 28),

                      // ── Users ──
                      _sectionTitle('👤 People'),
                      const SizedBox(height: 14),
                      _threeStatRow(
                        label1: 'Users',
                        value1: '$totalUsers',
                        icon1: Icons.person,
                        color1: kGreenDark,
                        label2: 'Customers',
                        value2: '$totalCustomers',
                        icon2: Icons.supervisor_account,
                        color2: kBrown1,
                        label3: 'Employees',
                        value3: '$totalEmployees',
                        icon3: Icons.badge,
                        color3: kGreenMid,
                      ),

                      const SizedBox(height: 40),

                      // Footer
                      Center(
                        child: Text(
                          'Hotel de Luna • Analytics',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade500,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ),
    );
  }

  // ─────────────────────────────────────────────
  // REUSABLE WIDGETS
  // ─────────────────────────────────────────────

  Widget _heroBanner() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [kGreenDark, kGreenMid],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: kGreenDark.withOpacity(0.3),
            blurRadius: 25,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(
                  Icons.bar_chart,
                  color: Colors.white,
                  size: 26,
                ),
              ),
              const SizedBox(width: 14),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Total Revenue',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.85),
                      fontSize: 14,
                    ),
                  ),
                  Text(
                    '₹${totalRevenue.toStringAsFixed(0)}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _heroBannerStat('Bookings', '$totalBookings'),
              _divider(),
              _heroBannerStat('Confirmed', '$confirmedBookings'),
              _divider(),
              _heroBannerStat('Customers', '$totalCustomers'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _heroBannerStat(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: TextStyle(color: Colors.white.withOpacity(0.75), fontSize: 12),
        ),
      ],
    );
  }

  Widget _divider() {
    return Container(
      height: 36,
      width: 1,
      color: Colors.white.withOpacity(0.25),
    );
  }

  Widget _bigRevenueCard() {
    return _card(
      child: Row(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [kGreenDark, kGreenMid],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Icon(
              Icons.currency_rupee,
              color: Colors.white,
              size: 30,
            ),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Total Revenue (Paid)',
                style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
              ),
              const SizedBox(height: 4),
              Text(
                '₹${totalRevenue.toStringAsFixed(0)}',
                style: const TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: kGreenDark,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Color.fromARGB(255, 50, 50, 50),
      ),
    );
  }

  Widget _twoStatRow({
    required String label1,
    required String value1,
    required IconData icon1,
    required Color color1,
    required String label2,
    required String value2,
    required IconData icon2,
    required Color color2,
  }) {
    return Row(
      children: [
        Expanded(child: _miniCard(label1, value1, icon1, color1)),
        const SizedBox(width: 12),
        Expanded(child: _miniCard(label2, value2, icon2, color2)),
      ],
    );
  }

  Widget _threeStatRow({
    required String label1,
    required String value1,
    required IconData icon1,
    required Color color1,
    required String label2,
    required String value2,
    required IconData icon2,
    required Color color2,
    required String label3,
    required String value3,
    required IconData icon3,
    required Color color3,
  }) {
    return Row(
      children: [
        Expanded(child: _miniCard(label1, value1, icon1, color1)),
        const SizedBox(width: 10),
        Expanded(child: _miniCard(label2, value2, icon2, color2)),
        const SizedBox(width: 10),
        Expanded(child: _miniCard(label3, value3, icon3, color3)),
      ],
    );
  }

  Widget _miniCard(String label, String value, IconData icon, Color color) {
    return _card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [color, color.withOpacity(0.7)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: Colors.white, size: 18),
          ),
          const SizedBox(height: 10),
          Text(
            value,
            style: TextStyle(
              color: color,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            label,
            style: TextStyle(color: Colors.grey.shade500, fontSize: 11),
          ),
        ],
      ),
    );
  }

  Widget _barRow(
    String label,
    double value,
    double maxValue,
    String display,
    Color color,
  ) {
    final ratio = maxValue > 0 ? (value / maxValue).clamp(0.0, 1.0) : 0.0;
    return _card(
      margin: const EdgeInsets.only(bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  label,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Color.fromARGB(255, 50, 50, 50),
                  ),
                ),
              ),
              Text(
                display,
                style: TextStyle(
                  color: color,
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: ratio,
              backgroundColor: Colors.grey.shade200,
              valueColor: AlwaysStoppedAnimation<Color>(color),
              minHeight: 8,
            ),
          ),
        ],
      ),
    );
  }

  Widget _listTileCard(
    String title,
    String subtitle,
    IconData icon,
    Color color,
  ) {
    return _card(
      margin: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [color, color.withOpacity(0.7)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: Colors.white, size: 20),
          ),
          const SizedBox(width: 14),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: Color.fromARGB(255, 50, 50, 50),
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
              ),
            ],
          ),
          const Spacer(),
          Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(Icons.arrow_forward_ios, color: color, size: 14),
          ),
        ],
      ),
    );
  }

  Widget _taskCard() {
    final total = taskStats['total'] ?? 0;
    final completed = taskStats['completed'] ?? 0;
    final pending = taskStats['pending'] ?? 0;
    final rate = total > 0 ? (completed / total) : 0.0;

    return _card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _taskStat(
                'Total',
                '$total',
                const Color.fromARGB(255, 50, 50, 50),
              ),
              Container(height: 40, width: 1, color: Colors.grey.shade200),
              _taskStat('Completed', '$completed', kSuccess),
              Container(height: 40, width: 1, color: Colors.grey.shade200),
              _taskStat('Pending', '$pending', kWarning),
            ],
          ),
          const SizedBox(height: 18),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Completion Rate',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                  color: Color.fromARGB(255, 60, 60, 60),
                ),
              ),
              Text(
                '${(rate * 100).toStringAsFixed(1)}%',
                style: const TextStyle(
                  color: kGreenDark,
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: rate,
              backgroundColor: Colors.grey.shade200,
              valueColor: const AlwaysStoppedAnimation<Color>(kGreenDark),
              minHeight: 10,
            ),
          ),
        ],
      ),
    );
  }

  Widget _taskStat(String label, String value, Color color) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            color: color,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: TextStyle(color: Colors.grey.shade500, fontSize: 12),
        ),
      ],
    );
  }

  /// Base white card matching employee_main style
  Widget _card({required Widget child, EdgeInsetsGeometry? margin}) {
    return Container(
      margin: margin ?? const EdgeInsets.symmetric(vertical: 0),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: child,
    );
  }

  // ── Helpers ──

  Color _statusColor(String status) {
    switch (status.toLowerCase()) {
      case 'confirmed':
        return kSuccess;
      case 'cancelled':
        return kError;
      case 'pending':
        return kWarning;
      default:
        return kGreenDark;
    }
  }

  Color _roleColor(String role) {
    switch (role.toLowerCase()) {
      case 'admin':
        return kGreenDark;
      case 'guest':
        return kBrown1;
      case 'employee':
        return kGreenMid;
      default:
        return Colors.grey;
    }
  }

  String _capitalize(String s) =>
      s.isEmpty ? s : s[0].toUpperCase() + s.substring(1);
}
