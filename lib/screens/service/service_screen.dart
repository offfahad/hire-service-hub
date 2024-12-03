import 'package:carded/carded.dart';
import 'package:e_commerce/providers/service/service_provider.dart';
import 'package:e_commerce/screens/service/widgets/service_card_widget.dart';
import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:provider/provider.dart';

class ServiceScreen extends StatefulWidget {
  const ServiceScreen({super.key});

  @override
  State<ServiceScreen> createState() => _ServiceScreenState();
}

class _ServiceScreenState extends State<ServiceScreen> {
  String? selectedCity;
  bool isCitySelected = false;

  final List<String> cities = [
    'Lahore',
    'Islamabad',
    'Multan',
    'Sialkot',
    'Karachi',
    'Peshawar',
  ];

// Function to show draggable and expandable bottom sheet
  void _openCityBottomSheet(BuildContext context) {
    showModalBottomSheet(
      backgroundColor: Colors.white,
      context: context,
      isScrollControlled: true, // Allow the bottom sheet to expand fully
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (BuildContext context) {
        return DraggableScrollableSheet(
          initialChildSize:
              0.5, // Initial height as a fraction of the screen height
          minChildSize: 0.2, // Minimum height
          maxChildSize: 0.9, // Maximum height
          expand: false, // Prevents it from automatically expanding
          builder: (context, scrollController) {
            return Container(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  // Row with close button, title, and reset button
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () {
                          Navigator.pop(context); // Close bottom sheet
                        },
                      ),
                      const Text(
                        "City",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      TextButton(
                        onPressed: () {
                          // Reset selection
                          setState(() {
                            selectedCity = null;
                            isCitySelected = false;
                          });
                          Navigator.pop(
                              context); // Close the sheet after resetting
                        },
                        child: const Text(
                          "Reset",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                  // Radio list for cities
                  Expanded(
                    child: ListView.builder(
                      controller: scrollController, // Attach scroll controller
                      itemCount: cities.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          contentPadding: EdgeInsets.zero,
                          title: Text(cities[index]),
                          leading: SizedBox(
                            child: Radio<String>(
                              value: cities[index],
                              groupValue: selectedCity,
                              onChanged: (String? value) {
                                setState(() {
                                  selectedCity = value;
                                  isCitySelected = true;
                                });
                                Navigator.pop(
                                    context); // Close the bottom sheet after selection
                              },
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ServiceProvider>(context, listen: false).fetchServices();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Services"),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Icon(IconlyLight.filter),
                  const SizedBox(width: 10),
                  Chip(
                    label: const Text("Category"),
                    deleteIcon: const Icon(IconlyLight.arrow_down_2),
                    onDeleted: () {
                      // Add logic for category filter here
                    },
                  ),
                  const SizedBox(width: 10),
                  GestureDetector(
                    onTap: () {
                      _openCityBottomSheet(context);
                    },
                    child: Chip(
                      label: Text(selectedCity ?? 'City'),
                      backgroundColor:
                          isCitySelected ? Colors.black87 : Colors.white,
                      labelStyle: TextStyle(
                          color: isCitySelected ? Colors.white : Colors.black),
                      deleteIcon: Icon(
                          isCitySelected
                              ? Icons.cancel
                              : IconlyLight.arrow_down_2,
                          color: isCitySelected ? Colors.white : Colors.black),
                      onDeleted: () {
                        if (selectedCity == null || isCitySelected == false) {
                          _openCityBottomSheet(context);
                        }
                        setState(() {
                          selectedCity = null;
                          isCitySelected = false;
                        });
                      },
                    ),
                  ),
                  const SizedBox(width: 10),
                  Chip(
                    label: const Text("Price Range"),
                    deleteIcon: const Icon(IconlyLight.arrow_down_2),
                    onDeleted: () {
                      // Add logic for price filter here
                    },
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: Consumer<ServiceProvider>(
              builder: (context, provider, child) {
                if (provider.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if ((provider.errorMessage ?? "").isNotEmpty) {
                  return Center(child: Text('Error: ${provider.errorMessage}'));
                } else if (provider.services.isEmpty) {
                  return const Center(child: Text('No services available'));
                } else {
                  return ListView.builder(
                    itemCount: provider.services.length,
                    itemBuilder: (context, index) {
                      final service = provider.services[index];
                      return ServiceCard(service: service);
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
