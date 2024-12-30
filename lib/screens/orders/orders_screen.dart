import 'package:carded/carded.dart';
import 'package:e_commerce/common/slide_page_routes/slide_page_route.dart';
import 'package:e_commerce/providers/authentication/authentication_provider.dart';
import 'package:e_commerce/providers/orders/orders_provider.dart';
import 'package:e_commerce/screens/orders/order_detail_screen.dart';
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
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<OrderProvider>(context, listen: false).clearOrders();
      Provider.of<OrderProvider>(context, listen: false).fetchMyOrders();
    });
  }

  @override
  Widget build(BuildContext context) {
    Brightness brightness = Theme.of(context).brightness;
    bool isDarkMode = brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Orders',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Consumer2<OrderProvider, AuthenticationProvider>(
        builder: (context, orderProvider, authProvider, child) {
          if (orderProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          final orders = orderProvider.orders;

          if (orders == null || orders.data.isEmpty) {
            return const Center(child: Text('No orders available.'));
          }

          final filteredOrders = orderProvider.selectedFilter == "All"
              ? orders.data
              : orders.data
                  .where(
                    (order) =>
                        order.orderStatus == orderProvider.selectedFilter,
                  )
                  .toList();

          return Column(
            children: [
              // Horizontal Scrollable Chips
              Container(
                height: 50,
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    buildFilterChip("All"),
                    buildFilterChip("pending"),
                    buildFilterChip("cancelled"),
                    buildFilterChip("completed"),
                  ],
                ),
              ),
              // Orders List
              Expanded(
                child: filteredOrders.isEmpty
                    ? Center(
                        child: Text(
                          "No ${orderProvider.selectedFilter.toLowerCase()} order available yet.",
                          style: const TextStyle(
                            fontSize: 14,
                          ),
                        ),
                      )
                    : ListView.builder(
                        itemCount: filteredOrders.length,
                        itemBuilder: (context, index) {
                          final order = filteredOrders[index];

                          return CardyContainer(
                            margin: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 8),
                            color:
                                isDarkMode ? AppTheme.fdarkBlue : Colors.white,
                            spreadRadius: 0,
                            blurRadius: 1,
                            shadowColor:
                                isDarkMode ? AppTheme.fdarkBlue : Colors.grey,
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
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
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              color: getStatusColor(
                                                  order.orderStatus),
                                              child: Text(
                                                order.orderStatus.toUpperCase(),
                                                style: const TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 10),
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
                                              formatDate(
                                                order.orderDate.toString(),
                                              ),
                                              style:
                                                  const TextStyle(fontSize: 12),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 8),
                                        InkWell(
                                          onTap: () {
                                            Navigator.push(
                                                context,
                                                SlidePageRoute(
                                                    page: OrderDetailsScreen(
                                                  order: order,
                                                  isServiceProvider:
                                                      authProvider.user!.role!
                                                                  .title ==
                                                              "service_provider"
                                                          ? true
                                                          : false,
                                                )));
                                          },
                                          child: const Align(
                                            alignment: Alignment.bottomRight,
                                            child: Text(
                                              "See More",
                                              style: TextStyle(
                                                  fontSize: 12,
                                                  decoration:
                                                      TextDecoration.underline),
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
      ),
    );
  }

  Widget buildFilterChip(String label) {
    Brightness brightness = Theme.of(context).brightness;
    bool isDarkMode = brightness == Brightness.dark;

    final selectedFilter = Provider.of<OrderProvider>(context).selectedFilter;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: ChoiceChip(
        backgroundColor: isDarkMode ? AppTheme.fdarkBlue : Colors.white,
        label: Text(label.toUpperCase()),
        selected: selectedFilter == label,
        onSelected: (isSelected) {
          Provider.of<OrderProvider>(context, listen: false).setFilter(label);
        },
      ),
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
