import 'package:e_commerce/utils/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';

class JazzCashScreen extends StatefulWidget {
  const JazzCashScreen({super.key});

  @override
  _JazzCashScreenState createState() => _JazzCashScreenState();
}

class _JazzCashScreenState extends State<JazzCashScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        title: const Text(
          "JazzCash",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.help_outline, color: Colors.white),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.more_vert, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
      body: Stack(
        children: [
          // Main Content of Home Screen
          _buildHomeScreenContent(),

          // Draggable Slider
          DraggableScrollableSheet(
            initialChildSize: 0.05, // When minimized
            minChildSize: 0.05, // Minimum height
            maxChildSize: 0.9, // Maximum height
            builder: (context, scrollController) {
              return Container(
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                child: SingleChildScrollView(
                  controller: scrollController,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Draggable handle
                      const Center(
                        child: Icon(
                          Icons.keyboard_arrow_up,
                          size: 40,
                        ),
                      ),

                      // Slider content
                      Padding(
                        padding: const EdgeInsets.only(left: 16, right: 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "You can add detailed content here, such as transactions, options, or information.",
                              style:
                                  TextStyle(fontSize: 14, color: Colors.grey),
                            ),
                            const SizedBox(height: 20),
                            ElevatedButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: const Text("Close"),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        backgroundColor: Colors.white,
        unselectedIconTheme: IconThemeData(color: AppTheme.fMainColor),
        type: BottomNavigationBarType.fixed, // Prevents icon shifting
        selectedLabelStyle: const TextStyle(
          fontSize: 12, // Set the font size for the selected label
        ),
        unselectedLabelStyle: const TextStyle(
          fontSize: 10, // Set the font size for the unselected label
        ),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.location_on),
            label: "Locator",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.qr_code),
            label: "Scan",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: "Search",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: "Favorites",
          ),
        ],
      ),
    );
  }

  Widget _buildHomeScreenContent() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // User Info
          Row(
            children: [
              const CircleAvatar(
                backgroundColor: Colors.yellow,
                child: Text(
                  "MF",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(width: 10),
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Good Evening!", style: TextStyle(color: Colors.grey)),
                  Text("Muhammad",
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black)),
                ],
              ),
              const Spacer(),
              GestureDetector(
                onTap: () {},
                child: const Row(
                  children: [
                    Text("Login",
                        style: TextStyle(
                            color: Colors.orange,
                            fontSize: 16,
                            fontWeight: FontWeight.bold)),
                    Icon(Icons.arrow_forward, color: Colors.orange),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Add Money and My Account Buttons
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white),
                  child: const Text("+ Add Money"),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey.shade200,
                      foregroundColor: Colors.black),
                  child: const Text("My Account"),
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Quick Access Options
          const Text("My JazzCash", style: TextStyle(fontSize: 16)),
          const SizedBox(height: 10),
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 4,
            children: const [
              _IconLabelWidget(icon: Icons.send, label: "Money Transfer"),
              _IconLabelWidget(icon: Icons.receipt, label: "Bill Payment"),
              _IconLabelWidget(
                  icon: Icons.swipe_vertical_rounded, label: "Load & Packages"),
              _IconLabelWidget(icon: Icons.account_balance, label: "Banking"),
            ],
          ),
        ],
      ),
    );
  }
}

class _IconLabelWidget extends StatelessWidget {
  final IconData icon;
  final String label;

  const _IconLabelWidget({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        CircleAvatar(
          backgroundColor: Colors.red.shade50,
          child: Icon(icon, color: Colors.red),
        ),
        const SizedBox(height: 5),
        Text(
          label,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 12),
        ),
      ],
    );
  }
}
