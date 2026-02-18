import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class EmployeeHomeScreen extends StatefulWidget {
  const EmployeeHomeScreen({super.key});

  @override
  State<EmployeeHomeScreen> createState() => _EmployeeHomeScreenState();
}

class _EmployeeHomeScreenState extends State<EmployeeHomeScreen> {
  int selectedIndex = 0;

  // Tasks dummy data
  final List<Map<String, dynamic>> tasks = [
    {
      "title": "Task 1",
      "subtitle": "Supporting line text, lorem ipsum...",
      "done": false,
    },
    {
      "title": "Task 2",
      "subtitle": "Supporting line text, lorem ipsum...",
      "done": false,
    },
    {
      "title": "Task 3",
      "subtitle": "Supporting line text, lorem ipsum...",
      "done": false,
    },
    {
      "title": "Task 4",
      "subtitle": "Supporting line text, lorem ipsum...",
      "done": false,
    },
    {
      "title": "Task 5",
      "subtitle": "Supporting line text, lorem ipsum...",
      "done": false,
    },
  ];

  // Calendar
  DateTime focusedDay = DateTime.now();
  DateTime selectedDay = DateTime.now();

  // Dummy shift timings
  final Map<String, String> shiftTimings = {
    "2026-02-10": "10:00 AM - 06:00 PM",
    "2026-02-11": "02:00 PM - 10:00 PM",
    "2026-02-12": "OFF",
    "2026-02-13": "09:00 AM - 05:00 PM",
  };

  double get progress {
    int doneCount = tasks.where((t) => t["done"] == true).length;
    return tasks.isEmpty ? 0 : doneCount / tasks.length;
  }

  String getShiftForDay(DateTime day) {
    String key =
        "${day.year.toString().padLeft(4, '0')}-${day.month.toString().padLeft(2, '0')}-${day.day.toString().padLeft(2, '0')}";
    return shiftTimings[key] ?? "No shift assigned";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F3FA),
      body: SafeArea(
        child: Column(
          children: [
            // Top header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.arrow_back_ios_new),
                  ),
                  const SizedBox(width: 10),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.network(
                      "https://i.pravatar.cc/150?img=3",
                      width: 60,
                      height: 60,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(width: 14),
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Employee name",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 2),
                      Text(
                        "Profession",
                        style: TextStyle(fontSize: 13, color: Colors.black54),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),

            // Buttons row (instead of swipe tabs)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18),
              child: Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    _tabButton("Tasks", 0),
                    _tabButton("Shifts", 1),
                    _tabButton("Account", 2),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Content
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18),
                child: IndexedStack(
                  index: selectedIndex,
                  children: [_tasksPage(), _shiftsPage(), _accountPage()],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ----------- UI Parts -----------

  Widget _tabButton(String text, int index) {
    bool active = selectedIndex == index;

    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            selectedIndex = index;
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: active ? const Color(0xFF6C3CE9) : Colors.transparent,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Center(
            child: Text(
              text,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: active ? Colors.white : Colors.black87,
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ----------- TASKS PAGE -----------

  Widget _tasksPage() {
    return SingleChildScrollView(
      child: Column(
        children: [
          // Progress card
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        "TODAY'S PROGRESS",
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: Colors.black54,
                        ),
                      ),
                      SizedBox(height: 6),
                      Text(
                        "Complete your tasks",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),

                // Progress circle
                SizedBox(
                  width: 70,
                  height: 70,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      CircularProgressIndicator(
                        value: progress,
                        strokeWidth: 8,
                        backgroundColor: const Color(0xFFE8E1FB),
                        color: const Color(0xFF6C3CE9),
                      ),
                      Text(
                        "${(progress * 100).toInt()}%",
                        style: const TextStyle(fontWeight: FontWeight.w700),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 14),

          // Tasks list card
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: tasks.length,
              separatorBuilder: (_, __) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final task = tasks[index];

                return ListTile(
                  leading: Icon(
                    task["done"] ? Icons.check_circle : Icons.star_border,
                    color: task["done"]
                        ? const Color(0xFF6C3CE9)
                        : Colors.black54,
                  ),
                  title: Text(
                    task["title"],
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      decoration: task["done"]
                          ? TextDecoration.lineThrough
                          : TextDecoration.none,
                    ),
                  ),
                  subtitle: Text(task["subtitle"]),
                  trailing: Checkbox(
                    value: task["done"],
                    activeColor: const Color(0xFF6C3CE9),
                    onChanged: (val) {
                      setState(() {
                        task["done"] = val ?? false;
                      });
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // ----------- SHIFTS PAGE -----------

  Widget _shiftsPage() {
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: TableCalendar(
              firstDay: DateTime.utc(2020, 1, 1),
              lastDay: DateTime.utc(2030, 12, 31),
              focusedDay: focusedDay,
              selectedDayPredicate: (day) => isSameDay(day, selectedDay),
              onDaySelected: (selected, focused) {
                setState(() {
                  selectedDay = selected;
                  focusedDay = focused;
                });
              },
              headerStyle: const HeaderStyle(
                formatButtonVisible: false,
                titleCentered: true,
              ),
              calendarStyle: CalendarStyle(
                selectedDecoration: BoxDecoration(
                  color: const Color(0xFF6C3CE9),
                  borderRadius: BorderRadius.circular(10),
                ),
                todayDecoration: BoxDecoration(
                  color: const Color(0xFFBFA9FF),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),

          const SizedBox(height: 14),

          // Shift timing card
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "SHIFT TIMING",
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: Colors.black54,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  getShiftForDay(selectedDay),
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  "For ${selectedDay.day}/${selectedDay.month}/${selectedDay.year}",
                  style: const TextStyle(color: Colors.black54),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ----------- ACCOUNT PAGE -----------

  Widget _accountPage() {
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(50),
                  child: Image.network(
                    "https://i.pravatar.cc/150?img=3",
                    width: 90,
                    height: 90,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  "Employee name",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 4),
                const Text(
                  "Profession",
                  style: TextStyle(color: Colors.black54),
                ),
                const SizedBox(height: 18),

                // Edit image button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF6C3CE9),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    onPressed: () {
                      // Later you can connect image picker here
                    },
                    icon: const Icon(Icons.edit),
                    label: const Text("Edit Image"),
                  ),
                ),

                const SizedBox(height: 12),

                // Logout button
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    onPressed: () {
                      // Later you can connect logout logic
                    },
                    icon: const Icon(Icons.logout),
                    label: const Text("Log out"),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
