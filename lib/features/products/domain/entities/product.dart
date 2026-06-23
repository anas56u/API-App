// 1. كيان المراجعة (Review)
class Review {
  final int rating;
  final String comment;
  final String reviewerName;

  Review({
    required this.rating,
    required this.comment,
    required this.reviewerName,
  });
}

class Product {
  final int id;
  final String title;
  final String description;
  final String category;
  final num price; 
  final num rating;
  final String thumbnail;
  final List<String> images;
  final List<Review> reviews; 

  Product({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.price,
    required this.rating,
    required this.thumbnail,
    required this.images,
    required this.reviews,
  });
}