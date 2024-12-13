import 'package:carded/carded.dart';
import 'package:e_commerce/providers/orders/orders_provider.dart';
import 'package:e_commerce/utils/api_constnsts.dart';
import 'package:e_commerce/utils/app_theme.dart';
import 'package:e_commerce/utils/date_and_time_formatting.dart';
import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:provider/provider.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  String selectedFilter = "All";

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<OrderProvider>(context, listen: false).fetchMyOrders();
    });
  }

  @override
  Widget build(BuildContext context) {
    Brightness brightness = Theme.of(context).brightness;
    bool isDarkMode = brightness == Brightness.dark;

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Orders'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'My Orders'),
              Tab(text: 'Received Orders'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            buildOrdersTab(context, isDarkMode, true),
            buildOrdersTab(context, isDarkMode, false),
          ],
        ),
      ),
    );
  }

  Widget buildOrdersTab(
      BuildContext context, bool isDarkMode, bool isMyOrders) {
    return Consumer<OrderProvider>(
      builder: (context, orderProvider, child) {
        if (orderProvider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        final orders = isMyOrders ? orderProvider.orders : orderProvider.orders;

        if (orders == null || orders.data.isEmpty) {
          return const Center(child: Text('No orders available.'));
        }

        final filteredOrders = selectedFilter == "All"
            ? orders.data
            : orders.data
                .where((order) => order.orderStatus == selectedFilter)
                .toList();

        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 0),
              child: Wrap(
                spacing: 8.0,
                children: [
                  buildFilterChip("pending"),
                  buildFilterChip("cancelled"),
                  buildFilterChip("completed"),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: filteredOrders.length,
                itemBuilder: (context, index) {
                  final order = filteredOrders[index];
                  return CardyContainer(
                    margin:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    color: isDarkMode ? AppTheme.fdarkBlue : Colors.white,
                    spreadRadius: 0,
                    blurRadius: 1,
                    shadowColor: isDarkMode ? AppTheme.fdarkBlue : Colors.grey,
                    borderRadius: BorderRadius.circular(5),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.all(12),
                      child: Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: order.service.coverPhoto != null
                                ? Image.network(
                                    '${Constants.baseUrl}${order.service.coverPhoto}',
                                    width: 80,
                                    height: 80,
                                    fit: BoxFit.cover,
                                  )
                                : Image.asset(
                                    'assets/images/content-writer.webp',
                                    width: 80,
                                    height: 80,
                                    fit: BoxFit.cover,
                                  ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      order.service.serviceName,
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    CardyContainer(
                                      padding: const EdgeInsets.all(3),
                                      spreadRadius: 0,
                                      blurRadius: 1,
                                      borderRadius: BorderRadius.circular(8),
                                      color: getStatusColor(order.orderStatus),
                                      child: Text(
                                        order.orderStatus.toUpperCase(),
                                        style: const TextStyle(
                                            color: Colors.white, fontSize: 10),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  order.service.description,
                                  style: const TextStyle(
                                    fontSize: 12,
                                  ),
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    const Icon(
                                      IconlyLight.time_circle,
                                      size: 16,
                                    ),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    Text(
                                      formatTime(
                                        order.orderDate.toString(),
                                      ),
                                      style: const TextStyle(fontSize: 12),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                InkWell(
                                  onTap: () {},
                                  child: const Align(
                                    alignment: Alignment.bottomRight,
                                    child: Text(
                                      "See More",
                                      style: TextStyle(
                                          fontSize: 12,
                                          decoration: TextDecoration.underline),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }

  Widget buildFilterChip(String label) {
    Brightness brightness = Theme.of(context).brightness;
    bool isDarkMode = brightness == Brightness.dark;
    return ChoiceChip(
      backgroundColor: isDarkMode ? AppTheme.fdarkBlue : Colors.white,
      label: Text(label.toUpperCase()),
      selected: selectedFilter == label,
      onSelected: (isSelected) {
        setState(() {
          if (selectedFilter == label) {
            // Deselect the chip and reset to "All"
            selectedFilter = "All";
          } else {
            // Select the new chip
            selectedFilter = label;
          }
        });
      },
    );
  }

  Color getStatusColor(String status) {
    switch (status) {
      case "pending":
        return Colors.orange;
      case "cancelled":
        return Colors.red;
      case "completed":
        return Colors.green;
      default:
        return Colors.grey;
    }
  }
}
