import 'package:e_commerce/models/service/fetch_signle_service_model.dart';
import 'package:e_commerce/models/service/service_model.dart';
import 'package:e_commerce/services/service/service_service.dart';

class ServiceRepository {
  final ServiceService serviceService = ServiceService();

  Future<List<ServiceModel>> getServices() async {
    return await serviceService.fetchServices();
  }

  Future<FetchSingleService?> getService(String serviceId) async {
    return await serviceService.fetchSingleService(serviceId);
  }

  Future<List<ServiceModel>> getFilterServices({
    String? categoryId,
    String? city,
    String? priceRangeType,
  }) async {
    return await serviceService.fetchFilteredServices(
      categoryId: categoryId,
      city: city,
      priceRangeType: priceRangeType,
    );
  }
}
