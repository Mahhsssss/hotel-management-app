import 'package:flutter/material.dart';

class HotelFilterScreen extends StatefulWidget {
  const HotelFilterScreen({super.key});

  @override
  _HotelFilterScreenState createState() => _HotelFilterScreenState();
}

class _HotelFilterScreenState extends State<HotelFilterScreen> {
  DateTime? startDate;
  DateTime? endDate;

  String adults = "1";
  String children = "0";
  String pets = "No";

  String priceRange = "Medium";
  int starRating = 3;

  List<String> selectedRoomTypes = [];
  List<String> selectedAmenities = [];

  final roomTypes = [
    "Deluxe Room",
    "One Bedroom Suite",
    "Junior Suite",
    "Executive Suite",
    "Presidential Suite",
    "Single Room",
    "Double / Queen",
    "Twin Room",
    "Triple Room",
  ];

  final amenities = [
    "Gym",
    "Spa",
    "Restaurant",
    "Parking",
    "Wi-Fi",
  ];

  Future<void> pickDate(bool isStart) async {
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2030),
    );
    if (date != null) {
      setState(() {
        isStart ? startDate = date : endDate = date;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F8F7),
      appBar: AppBar(
        title: const Text("Hotel Filters ✨"),
        backgroundColor: Colors.green.shade700,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            /// 📅 DATE PICKER
            _sectionTitle("Trip Dates"),
            Row(
              children: [
                _dateCard("Start Date", startDate, () => pickDate(true)),
                const SizedBox(width: 12),
                _dateCard("End Date", endDate, () => pickDate(false)),
              ],
            ),

            _sectionTitle("Guests"),
            _dropdown("Adults", adults, ["1","2","3","4"], (v)=>setState(()=>adults=v!)),
            _dropdown("Children", children, ["0","1","2","3"], (v)=>setState(()=>children=v!)),
            _dropdown("Pets Allowed", pets, ["Yes","No"], (v)=>setState(()=>pets=v!)),

            _sectionTitle("Room Types"),
            _multiSelect(roomTypes, selectedRoomTypes),

            _sectionTitle("Amenities"),
            _multiSelect(amenities, selectedAmenities),

            _sectionTitle("Price Range"),
            _radioGroup(["Low","Medium","High"], priceRange, (v)=>setState(()=>priceRange=v)),

            _sectionTitle("Star Rating"),
            _radioGroup(["1","2","3","4","5"], starRating.toString(),
                (v)=>setState(()=>starRating=int.parse(v))),

            const SizedBox(height: 30),

            /// 🔘 BUTTON
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green.shade700,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                onPressed: () {},
                child: const Text(
                  "Show Hotels 🌿",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// ===================== WIDGETS =====================

  Widget _sectionTitle(String title) => Padding(
    padding: const EdgeInsets.only(top: 22, bottom: 8),
    child: Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
    ),
  );

  Widget _dropdown(String label, String value, List<String> items, Function(String?) onChanged) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: DropdownButtonFormField(
        initialValue: value,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
        items: items.map((e)=>DropdownMenuItem(value: e, child: Text(e))).toList(),
        onChanged: onChanged,
      ),
    );
  }

  Widget _multiSelect(List<String> options, List<String> selected) {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: options.map((item) {
        final isSelected = selected.contains(item);
        return GestureDetector(
          onTap: () {
            setState(() {
              isSelected ? selected.remove(item) : selected.add(item);
            });
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: isSelected ? Colors.green.shade100 : Colors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: isSelected ? Colors.green.shade800 : Colors.grey.shade400,
                width: 2,
              ),
            ),
            child: Text(
              item,
              style: TextStyle(
                color: isSelected ? Colors.green.shade900 : Colors.black,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _radioGroup(List<String> options, String groupValue, Function(String) onChanged) {
    return Column(
      children: options.map((e) {
        return RadioListTile(
          title: Text(e),
          value: e,
          groupValue: groupValue,
          activeColor: Colors.green.shade700,
          onChanged: (val) => onChanged(val.toString()),
        );
      }).toList(),
    );
  }

  Widget _dateCard(String label, DateTime? date, VoidCallback onTap) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: Colors.green.shade600),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 6),
              Text(
                date == null ? "Select date" : "${date.day}/${date.month}/${date.year}",
                style: TextStyle(color: Colors.green.shade700),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
