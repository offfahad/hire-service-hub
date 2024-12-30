import 'dart:convert';

import 'package:carded/carded.dart';
import 'package:e_commerce/common/slide_page_routes/slide_page_route.dart';
import 'package:e_commerce/common/snakbar/custom_snakbar.dart';
import 'package:e_commerce/providers/orders/orders_provider.dart';
import 'package:e_commerce/screens/orders/order_update_screen.dart';
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
          // ClipRRect(
          //   borderRadius: BorderRadius.circular(8),
          //   child: order.service.coverPhoto != null
          //       ? Image.network(
          //           '${Constants.baseUrl}${order.service.coverPhoto}',
          //           width: 80,
          //           height: 80,
          //           fit: BoxFit.cover,
          //         )
          //       : Image.asset(
          //           'assets/images/content-writer.webp',
          //           width: 80,
          //           height: 80,
          //           fit: BoxFit.cover,
          //         ),
          // ),
          // const SizedBox(height: 20),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Order ID",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      order.id,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.copy, color: AppTheme.fMainColor),
                    onPressed: () {
                      Clipboard.setData(ClipboardData(text: order.id));
                      showCustomSnackBar(context,
                          "Order ID copied to clipboard!", Colors.green);
                    },
                  ),
                ],
              )
            ],
          ),
          _DetailRow(label: 'Service', value: order.service.serviceName),
          if (order.serviceProvider != null) ...[
            _DetailRow(
                label: 'Service Provider Name',
                value:
                    '${order.serviceProvider!.firstName} ${order.serviceProvider!.lastName}'),
            _DetailRow(
              label: 'Address',
              value: order.serviceProvider!.address.location ?? "Unknown",
            ),
          ] else
            ...[],
          _DetailRow(label: 'Status', value: order.orderStatus.toUpperCase()),
          if (order.orderStatus == "cancelled") ...[
            _DetailRow(
                label: 'Cancelled Reason',
                value: order.cancellationReason ?? "Empty"),
          ] else
            ...[],
          _DetailRow(label: 'Price', value: 'Rs. ${order.orderPrice}'),
          _DetailRow(
              label: 'Payment', value: order.paymentStatus.toUpperCase()),
          _DetailRow(
              label: 'Selected Payment Method',
              value: order.paymentMethod.toUpperCase()),
          _DetailRow(
              label: 'Order Placed Date',
              value: formatTime(order.placedAt.toString())),
          _DetailRow(
              label: 'Order Date',
              value: formatDate(order.orderDate.toString())),
          if (order.customer != null) ...[
            _DetailRow(
                label: 'Customer Name',
                value: order.customer != null
                    ? '${order.customer!.firstName} ${order.customer!.lastName}'
                    : 'N/A'),
            _DetailRow(
                label: 'Address',
                value: order.customerAddress.location ?? "Unknown"),
          ] else
            ...[],
          if (order.additionalNotes != null &&
              order.additionalNotes!.isNotEmpty)
            _DetailRow(label: 'Notes', value: order.additionalNotes!),
          const SizedBox(height: 8),
          _buildActionButtons(context, order),
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context, Datum order) {
    return Consumer<OrderProvider>(builder: (context, orderProvider, child) {
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
                Navigator.push(
                  context,
                  SlidePageRoute(
                    page: OrderUpdateScreen(
                      order: order,
                    ),
                  ),
                );
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
              onPressed: () async {
                try {
                  final response = await orderProvider.acceptOrder(order.id);

                  if (response!.statusCode == 200) {
                    orderProvider.fetchMyOrders();
                    final responseData = jsonDecode(response.body);
                    showCustomSnackBar(
                        context, responseData['message'], Colors.green);
                    Navigator.pop(context); // Close the dialog
                  } else {
                    final responseData = jsonDecode(response.body);
                    showCustomSnackBar(
                        context,
                        responseData['message'] ?? "An error occurred.",
                        Colors.red);
                  }
                } catch (e) {
                  showCustomSnackBar(
                      context, "An error occurred: $e", Colors.red);
                }
              },
            ),
          if (isServiceProvider)
            _ActionButton(
              label: 'Reject Order',
              color: Colors.redAccent,
              onPressed: () async {
                try {
                  final response = await orderProvider.rejectOrder(order.id);

                  if (response!.statusCode == 200) {
                    orderProvider.fetchMyOrders();
                    final responseData = jsonDecode(response.body);
                    showCustomSnackBar(
                        context, responseData['message'], Colors.green);
                    Navigator.pop(context); // Close the dialog
                  } else {
                    final responseData = jsonDecode(response.body);
                    showCustomSnackBar(
                        context,
                        responseData['message'] ?? "An error occurred.",
                        Colors.red);
                  }
                } catch (e) {
                  showCustomSnackBar(
                      context, "An error occurred: $e", Colors.red);
                }
              },
            ),
          if (isServiceProvider)
            _ActionButton(
              label: 'Complete Order',
              color: Colors.blue,
              onPressed: () async {
                try {
                  final response = await orderProvider.completeOrder(order.id);

                  if (response!.statusCode == 200) {
                    orderProvider.fetchMyOrders();
                    final responseData = jsonDecode(response.body);
                    showCustomSnackBar(
                        context, responseData['message'], Colors.green);
                    Navigator.pop(context); // Close the dialog
                  } else {
                    final responseData = jsonDecode(response.body);
                    showCustomSnackBar(
                        context,
                        responseData['message'] ?? "An error occurred.",
                        Colors.red);
                  }
                } catch (e) {
                  showCustomSnackBar(
                      context, "An error occurred: $e", Colors.red);
                }
              },
            ),
        ],
      );
    });
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
      padding: const EdgeInsets.only(bottom: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 15,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }
}

void _showCancelOrderDialog(BuildContext context, Datum order) {
  final TextEditingController reasonController = TextEditingController();

  showDialog(
    context: context,
    builder: (context) {
      return _CancelOrderDialog(
          reasonController: reasonController, order: order);
    },
  );
}

class _CancelOrderDialog extends StatefulWidget {
  final TextEditingController reasonController;
  final Datum order;

  const _CancelOrderDialog({
    required this.reasonController,
    required this.order,
  });

  @override
  State<_CancelOrderDialog> createState() => _CancelOrderDialogState();
}

class _CancelOrderDialogState extends State<_CancelOrderDialog> {
  bool _isLoading = false;

  Future<void> _cancelOrderWithReason() async {
    final provider = Provider.of<OrderProvider>(context, listen: false);
    final reason = widget.reasonController.text.trim();

    if (reason.isEmpty) {
      showCustomSnackBar(
          context, "Please provide a cancellation reason.", Colors.red);
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final response = await provider.cancelOrder(
        orderId: widget.order.id,
        cancellationReason: reason,
      );

      if (response.statusCode == 200) {
        provider.fetchMyOrders();
        final responseData = jsonDecode(response.body);
        showCustomSnackBar(context, responseData['message'], Colors.green);
        Navigator.pop(context); // Close the dialog
        Navigator.pop(context);
      } else {
        final responseData = jsonDecode(response.body);
        showCustomSnackBar(context,
            responseData['message'] ?? "An error occurred.", Colors.red);
        Navigator.pop(context); // Close the dialog
      }
    } catch (e) {
      showCustomSnackBar(context, "An error occurred: $e", Colors.red);
      Navigator.pop(context); // Close the dialog
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Cancel Order"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text("Please provide a reason for canceling this order."),
          const SizedBox(height: 10),
          TextField(
            controller: widget.reasonController,
            decoration: const InputDecoration(
              labelText: "Cancellation Reason",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(12)),
              ),
            ),
            maxLines: 2,
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Close"),
        ),
        ElevatedButton(
          onPressed: _isLoading ? null : _cancelOrderWithReason,
          style: ElevatedButton.styleFrom(
            backgroundColor:
                _isLoading ? Colors.grey : Theme.of(context).primaryColor,
          ),
          child: _isLoading
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2,
                  ),
                )
              : const Text(
                  "Cancel",
                  style: TextStyle(color: Colors.white),
                ),
        ),
      ],
    );
  }
}
