// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import '../models/booking_data.dart';
import '../services/hotel_service.dart';
import 'hotel_list_screen.dart';

class HotelFilterScreen extends StatefulWidget {
  final String selectedLocation;
  const HotelFilterScreen({super.key, required this.selectedLocation});

  @override
  State<HotelFilterScreen> createState() => _HotelFilterScreenState();
}

class _HotelFilterScreenState extends State<HotelFilterScreen> {
  String selectedRoomType = "Deluxe Room";
  int selectedRating = 3;
  String selectedPriceCategory = "Medium";
  String guestsAdults = "1";
  String guestsChildren = "0";
  String petsPresent = "No";
  DateTime? startDate;
  DateTime? endDate;
  List<String> selectedAmenities = [];

  final List<String> amenitiesList = [
    "Wifi",
    "Pool",
    "Parking area",
    "Restaurant",
    "Spa",
  ];

  final Color primaryGreen = const Color(0xFF388E3C);
  final Color lightGreenBg = const Color(0xFFE8F5E9);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: primaryGreen,
        centerTitle: true,
        title: const Text(
          "Filter your Hotel Requirements",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle("Trip Dates"),
            Row(
              children: [
                Expanded(
                  child: _buildDatePickerCard("Start Date", startDate, true),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: _buildDatePickerCard("End Date", endDate, false),
                ),
              ],
            ),
            const SizedBox(height: 25),

            _buildSectionTitle("Guests"),
            _buildCustomDropdown(
              "Adults",
              ["1", "2", "3", "4"],
              guestsAdults,
              (v) => setState(() => guestsAdults = v!),
            ),
            const SizedBox(height: 15),
            _buildCustomDropdown(
              "Children",
              ["0", "1", "2", "3"],
              guestsChildren,
              (v) => setState(() => guestsChildren = v!),
            ),
            const SizedBox(height: 15),
            _buildCustomDropdown(
              "Pets Present",
              ["No", "Yes"],
              petsPresent,
              (v) => setState(() => petsPresent = v!),
            ),
            const SizedBox(height: 25),

            _buildSectionTitle("Room Types"),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children:
                  [
                        "Deluxe Room",
                        "One Bedroom Suite",
                        "Junior Suite",
                        "Executive Suite",
                        "Presidential Suite",
                        "Single Room",
                        "Double / Queen",
                        "Twin Room",
                      ]
                      .map(
                        (type) => _buildSelectionChip(
                          type,
                          selectedRoomType == type,
                          () => setState(() => selectedRoomType = type),
                        ),
                      )
                      .toList(),
            ),
            const SizedBox(height: 25),

            _buildSectionTitle("Price Range"),
            // Fixed: use RadioGroup instead of deprecated RadioListTile params
            RadioGroup<String>(
              groupValue: selectedPriceCategory,
              onChanged: (v) => setState(() => selectedPriceCategory = v!),
              values: const ["Low", "Medium", "High"],
              labels: const ["Low", "Medium", "High"],
              activeColor: primaryGreen,
            ),
            const SizedBox(height: 25),

            _buildSectionTitle("Star Rating"),
            RadioGroup<int>(
              groupValue: selectedRating,
              onChanged: (v) => setState(() => selectedRating = v!),
              values: const [1, 2, 3, 4, 5],
              labels: const [
                "1 Stars",
                "2 Stars",
                "3 Stars",
                "4 Stars",
                "5 Stars",
              ],
              activeColor: primaryGreen,
            ),
            const SizedBox(height: 25),

            _buildSectionTitle("Amenities"),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: amenitiesList.map((amenity) {
                final isSelected = selectedAmenities.contains(amenity);
                return FilterChip(
                  label: Text(amenity),
                  selected: isSelected,
                  selectedColor: lightGreenBg,
                  checkmarkColor: primaryGreen,
                  onSelected: (value) {
                    setState(() {
                      if (value) {
                        selectedAmenities.add(amenity);
                      } else {
                        selectedAmenities.remove(amenity);
                      }
                    });
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: 100),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(24.0),
        child: ElevatedButton(
          onPressed: _search,
          style: ElevatedButton.styleFrom(
            backgroundColor: primaryGreen,
            minimumSize: const Size(double.infinity, 55),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
          ),
          child: const Text(
            "Show Hotels 🌿",
            style: TextStyle(
              fontSize: 18,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  // ── THE KEY FIX: build BookingData and pass it to next screen ─
  void _search() async {
    if (startDate == null || endDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select start and end dates")),
      );
      return;
    }
    if (!endDate!.isAfter(startDate!)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Check-out must be after check-in")),
      );
      return;
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );

    try {
      final hotels = await HotelService().getFilteredHotels(
        location: widget.selectedLocation,
        roomType: selectedRoomType,
        starRating: selectedRating,
        priceCategory: selectedPriceCategory,
        selectedAmenities: selectedAmenities,
      );

      if (!mounted) return;
      Navigator.pop(context); // close loading

      final bookingData = BookingData(
        location: widget.selectedLocation,
        checkIn: startDate!,
        checkOut: endDate!,
        adults: int.parse(guestsAdults),
        children: int.parse(guestsChildren),
        selectedAmenities: List.from(selectedAmenities),
      );

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) =>
              HotelListScreen(hotels: hotels, bookingData: bookingData),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      Navigator.pop(context);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error: $e")));
    }
  }

  // ── UI helpers ──────────────────────────────────────────────────

  Widget _buildSectionTitle(String title) => Padding(
    padding: const EdgeInsets.only(bottom: 12),
    child: Text(
      title,
      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
    ),
  );

  Widget _buildDatePickerCard(String title, DateTime? date, bool isStart) {
    return InkWell(
      onTap: () async {
        final now = DateTime.now();
        final picked = await showDatePicker(
          context: context,
          initialDate: date ?? now,
          firstDate: now,
          lastDate: DateTime(2030),
        );
        if (picked != null) {
          setState(() {
            if (isStart) {
              startDate = picked;
              if (endDate != null && !endDate!.isAfter(picked)) endDate = null;
            } else {
              endDate = picked;
            }
          });
        }
      },
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          border: Border.all(color: primaryGreen),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 5),
            Text(
              date == null
                  ? "Select date"
                  : "${date.day}/${date.month}/${date.year}",
              style: TextStyle(color: primaryGreen),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCustomDropdown(
    String label,
    List<String> items,
    String current,
    ValueChanged<String?> onChanged,
  ) {
    return DropdownButtonFormField<String>(
      initialValue: current,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
      ),
      items: items
          .map((v) => DropdownMenuItem(value: v, child: Text(v)))
          .toList(),
      onChanged: onChanged,
    );
  }

  Widget _buildSelectionChip(
    String label,
    bool isSelected,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? lightGreenBg : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: isSelected ? primaryGreen : Colors.grey),
        ),
        child: Text(
          label,
          style: TextStyle(color: isSelected ? primaryGreen : Colors.black),
        ),
      ),
    );
  }
}

// ── RadioGroup widget — replaces deprecated RadioListTile params ──
class RadioGroup<T> extends StatelessWidget {
  final T groupValue;
  final ValueChanged<T?> onChanged;
  final List<T> values;
  final List<String> labels;
  final Color activeColor;

  const RadioGroup({
    super.key,
    required this.groupValue,
    required this.onChanged,
    required this.values,
    required this.labels,
    required this.activeColor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(values.length, (i) {
        return InkWell(
          onTap: () => onChanged(values[i]),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Row(
              children: [
                Radio<T>(
                  value: values[i],
                  groupValue: groupValue,
                  activeColor: activeColor,
                  onChanged: onChanged,
                ),
                Text(labels[i], style: const TextStyle(fontSize: 15)),
              ],
            ),
          ),
        );
      }),
    );
  }
}
