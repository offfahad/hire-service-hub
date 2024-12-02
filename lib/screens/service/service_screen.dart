import 'package:e_commerce/providers/service/service_provider.dart';
import 'package:e_commerce/screens/service/widgets/service_card_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ServiceScreen extends StatefulWidget {
  const ServiceScreen({super.key});

  @override
  State<ServiceScreen> createState() => _ServiceScreenState();
}

class _ServiceScreenState extends State<ServiceScreen> {
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
        forceMaterialTransparency: true,
      ),
      body: Consumer<ServiceProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (provider.errorMessage!.isNotEmpty) {
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
    );
  }
}
