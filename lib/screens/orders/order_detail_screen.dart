import 'package:carded/carded.dart';
import 'package:e_commerce/common/snakbar/custom_snakbar.dart';
import 'package:e_commerce/providers/orders/orders_provider.dart';
import 'package:e_commerce/utils/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // For Clipboard
import 'package:e_commerce/models/orders/get_my_orders.dart';
import 'package:e_commerce/utils/api_constnsts.dart';
import 'package:e_commerce/utils/date_and_time_formatting.dart';
import 'package:provider/provider.dart';

class OrderDetailsScreen extends StatelessWidget {
  final Datum order;
  final bool isServiceProvider;

  const OrderDetailsScreen({
    super.key,
    required this.order,
    required this.isServiceProvider,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Order Details'),
      ),
      body: SingleChildScrollView(
          child: OrderCard(order: order, isServiceProvider: isServiceProvider)),
    );
  }
}

class OrderCard extends StatelessWidget {
  final Datum order;
  final bool isServiceProvider;

  const OrderCard({
    super.key,
    required this.order,
    required this.isServiceProvider,
  });

  @override
  Widget build(BuildContext context) {
    Brightness brightness = Theme.of(context).brightness;
    bool isDarkMode = brightness == Brightness.dark;
    return CardyContainer(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16.0),
      color: isDarkMode ? AppTheme.fdarkBlue : Colors.white,
      spreadRadius: 0,
      blurRadius: 1,
      borderRadius: BorderRadius.circular(8),
      shadowColor: isDarkMode ? AppTheme.fdarkBlue : Colors.grey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
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
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  'Order ID: ${order.id}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              IconButton(
                icon: Icon(Icons.copy, color: AppTheme.fMainColor),
                onPressed: () {
                  Clipboard.setData(ClipboardData(text: order.id));
                  showCustomSnackBar(
                      context, "Order ID copied to clipboard!", Colors.green);
                },
              ),
            ],
          ),
          const SizedBox(height: 8),
          _DetailRow(label: 'Service:', value: order.service.serviceName),
          if (order.serviceProvider != null) ...[
            _DetailRow(
                label: 'Service Provider Name: ',
                value:
                    '${order.serviceProvider!.firstName} ${order.serviceProvider!.lastName}'),
            _DetailRow(
                label: 'Address:',
                value: order.serviceProvider!.address.location),
          ] else
            ...[],
          _DetailRow(label: 'Status:', value: order.orderStatus.toUpperCase()),
          if (order.orderStatus == "cancelled") ...[
            _DetailRow(
                label: 'Cancelled Reason:',
                value: '${order.cancellationReason ?? "Empty"}'),
          ] else
            ...[],
          _DetailRow(label: 'Price:', value: 'Rs. ${order.orderPrice}'),
          _DetailRow(
              label: 'Payment:', value: order.paymentStatus.toUpperCase()),
          _DetailRow(
              label: 'Selected Payment Method:',
              value: order.paymentMethod.toUpperCase()),
          _DetailRow(
              label: 'Order Placed On:',
              value: formatTime(order.placedAt.toString())),
          _DetailRow(
              label: 'Order Date:',
              value: formatTime(order.orderDate.toString())),
          if (order.customer != null) ...[
            _DetailRow(
                label: 'Customer Name:',
                value: order.customer != null
                    ? '${order.customer!.firstName} ${order.customer!.lastName}'
                    : 'N/A'),
            _DetailRow(
                label: 'Address:', value: order.customerAddress.location),
          ] else
            ...[],
          if (order.additionalNotes != null &&
              order.additionalNotes!.isNotEmpty)
            _DetailRow(label: 'Notes:', value: order.additionalNotes!),
          const SizedBox(height: 16),
          _buildActionButtons(context, order),
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context, Datum order) {
    return GridView.count(
      crossAxisCount: 2, // Two buttons per row
      mainAxisSpacing: 10, // Space between rows
      crossAxisSpacing: 10, // Space between columns
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(), // Prevent scrolling
      childAspectRatio: 4, // Adjust the button's width-to-height ratio
      children: [
        if (!isServiceProvider)
          _ActionButton(
            label: 'Update Order',
            color: Colors.orange,
            onPressed: () {
              // Add logic to update the order
            },
          ),
        if (!isServiceProvider)
          _ActionButton(
            label: 'Cancel Order',
            color: Colors.red,
            onPressed: () {
              _showCancelOrderDialog(context, order);
            },
          ),
        if (isServiceProvider)
          _ActionButton(
            label: 'Accept Order',
            color: Colors.green,
            onPressed: () {
              // Add logic to accept the order
            },
          ),
        if (isServiceProvider)
          _ActionButton(
            label: 'Reject Order',
            color: Colors.redAccent,
            onPressed: () {
              // Add logic to reject the order
            },
          ),
        if (isServiceProvider)
          _ActionButton(
            label: 'Complete Order',
            color: Colors.blue,
            onPressed: () {
              // Add logic to mark the order as complete
            },
          ),
      ],
    );
  }
}

class _ActionButton extends StatelessWidget {
  final String label;
  final Color color;
  final VoidCallback onPressed;

  const _ActionButton({
    required this.label,
    required this.color,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      child: Text(label, style: const TextStyle(color: Colors.white)),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;

  const _DetailRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              value,
              style: TextStyle(color: Colors.grey[600]),
            ),
          ),
        ],
      ),
    );
  }
}

void _showCancelOrderDialog(BuildContext context, Datum order) {
  final TextEditingController reasonController = TextEditingController();

  void _cancelOrderWithReason(String reason) {
    // Replace this with your cancellation logic, e.g., API call
    print('Order canceled with reason: $reason');

    // Optionally, show confirmation
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Order has been canceled successfully!'),
        backgroundColor: Colors.green,
      ),
    );
  }

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Cancel Order'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Please provide a reason for canceling the order:'),
            const SizedBox(height: 10),
            TextFormField(
              controller: reasonController,
              maxLines: 3,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Write your reason here...',
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              final reason = reasonController.text.trim();
              if (reason.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Reason cannot be empty!'),
                    backgroundColor: Colors.red,
                  ),
                );
              } else {
                // Call the cancel order API
                final provider =
                    Provider.of<OrderProvider>(context, listen: false);
                provider
                    .cancelOrder(orderId: order.id, cancellationReason: reason)
                    .then((_) {
                  if (provider.errorMessage == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Order canceled successfully!'),
                        backgroundColor: Colors.green,
                      ),
                    );
                    Navigator.of(context).pop();
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(provider.errorMessage!),
                        backgroundColor: Colors.red,
                      ),
                    );
                    Navigator.of(context).pop();
                  }
                });
              }
            },
            child: const Text('OK'),
          ),
        ],
      );
    },
  );
}
