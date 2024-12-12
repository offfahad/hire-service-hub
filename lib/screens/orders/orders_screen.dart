import 'package:carded/carded.dart';
import 'package:e_commerce/providers/orders/orders_provider.dart';
import 'package:e_commerce/utils/app_theme.dart';
import 'package:flutter/material.dart';
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
      Provider.of<OrderProvider>(context, listen: false).fetchMyOrders();
    });
  }

  @override
  Widget build(BuildContext context) {
    Brightness brightness = Theme.of(context).brightness;
    bool isDarkMode = brightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Orders'),
      ),
      body: Consumer<OrderProvider>(
        builder: (context, orderProvider, child) {
          if (orderProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          final orders = orderProvider.orders;

          if (orders == null || orders.data.isEmpty) {
            return const Center(child: Text('No orders available.'));
          }

          return ListView.builder(
            itemCount: orders.data.length,
            itemBuilder: (context, index) {
              final order = orders.data[index];
              return CardyContainer(
                color: isDarkMode ? AppTheme.fdarkBlue : Colors.white,
                spreadRadius: 0,
                blurRadius: 1,
                shadowColor: isDarkMode ? AppTheme.fdarkBlue : Colors.grey,
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                child: ListTile(
                  leading: CircleAvatar(
                    child: Text(order.id.toString()),
                  ),
                  title: Text(order.service.description),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Status: ${order.orderStatus}'),
                      Text('Amount: \$${order.orderPrice}'),
                      Text('Date: ${order.orderDate}'),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
