import 'package:e_commerce/services/reviews/reviews_service.dart';
import 'package:http/http.dart' as http;

class ReviewsRepository {
  final ReviewService _reviewsService = ReviewService();

  Future<http.Response> createReview({
    required String orderId,
    required String serviceId,
    required String reviewMessage,
    required double rating,
  }) {
    return _reviewsService.createReview(
      orderId: orderId,
      serviceId: serviceId,
      reviewMessage: reviewMessage,
      rating: rating,
    );
  }

  //delete review
  Future<http.Response> deleteReview(String reviewId) async {
    return await _reviewsService.deleteReview(reviewId);
  }
}
