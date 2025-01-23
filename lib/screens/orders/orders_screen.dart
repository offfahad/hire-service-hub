import 'package:cached_network_image/cached_network_image.dart';
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
    final authProvider =
        Provider.of<AuthenticationProvider>(context, listen: true);
    return Scaffold(
      appBar: AppBar(
        forceMaterialTransparency: true,
        title: Text(
          authProvider.user?.role?.title == "service_provider"
              ? "Received Orders"
              : "My Orders",
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
      ),
      body: Consumer2<OrderProvider, AuthenticationProvider>(
        builder: (context, orderProvider, authProvider, child) {
          bool isCustomer = authProvider.user?.role?.title == 'customer';
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
                  .toList()
            ..sort((a, b) => b.orderDate.compareTo(a.orderDate));

          return Column(
            children: [
              // Horizontal Scrollable Chips
              Container(
                height: 50,
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    buildFilterChip("All"),
                    buildFilterChip("processing"),
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

                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  SlidePageRoute(
                                      page: OrderDetailsScreen(
                                    order: order,
                                    isServiceProvider:
                                        authProvider.user?.role!.title ==
                                                "service_provider"
                                            ? true
                                            : false,
                                  )));
                            },
                            child: CardyContainer(
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 8),
                              color: isDarkMode
                                  ? AppTheme.fdarkBlue
                                  : Colors.white,
                              spreadRadius: 0,
                              blurRadius: 1,
                              shadowColor:
                                  isDarkMode ? AppTheme.fdarkBlue : Colors.grey,
                              borderRadius: BorderRadius.circular(16),
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                padding: const EdgeInsets.all(12),
                                child: Column(
                                  children: [
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          child:
                                              order.service.coverPhoto != null
                                                  ? Image.network(
                                                      '${Constants.baseUrl}${order.service.coverPhoto}',
                                                      width: 80,
                                                      height: 60,
                                                      fit: BoxFit.cover,
                                                    )
                                                  : Image.asset(
                                                      'assets/images/content-writer.webp',
                                                      width: 80,
                                                      height: 60,
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
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    "Rs${order.orderPrice}",
                                                    style: const TextStyle(
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(height: 2),
                                              Text(
                                                order.service.description,
                                                style: const TextStyle(
                                                  fontSize: 12,
                                                ),
                                                maxLines: 3,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 8,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(16),
                                              child: CachedNetworkImage(
                                                imageUrl: isCustomer
                                                    ? authProvider.user
                                                            ?.profilePicture ??
                                                        'https://static.vecteezy.com/system/resources/thumbnails/009/292/244/small_2x/default-avatar-icon-of-social-media-user-vector.jpg'
                                                    : order.customer
                                                            ?.profilePicture ??
                                                        "https://static.vecteezy.com/system/resources/thumbnails/009/292/244/small_2x/default-avatar-icon-of-social-media-user-vector.jpg",
                                                width: 30,
                                                height: 30,
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                            const SizedBox(
                                              width: 8,
                                            ),
                                            Text(
                                              isCustomer
                                                  ? "${authProvider.user?.firstName} "
                                                      "${authProvider.user?.lastName}"
                                                  : "${order.customer?.firstName} "
                                                      " ${order.customer?.lastName}",
                                              style: const TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                        CardyContainer(
                                          padding: const EdgeInsets.all(3),
                                          spreadRadius: 0,
                                          blurRadius: 1,
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          color:
                                              getStatusColor(order.orderStatus),
                                          child: Text(
                                            order.orderStatus.toUpperCase(),
                                            style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 10),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const Divider(),
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const Icon(
                                              IconlyLight.time_circle,
                                              size: 18,
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
                                        const Icon(Icons.more_vert_outlined)
                                      ],
                                    )
                                  ],
                                ),
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
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
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
      case "processing":
        return Colors.grey;
      case "pending":
        return Colors.orange;
      case "cancelled":
        return Colors.red;
      case "completed":
        return Colors.green;
      default:
        return Colors.blue;
    }
  }
}
