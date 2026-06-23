import '../../domain/entities/product.dart';

class ReviewModel extends Review {
  ReviewModel({
    required super.rating,
    required super.comment,
    required super.reviewerName,
  });

  factory ReviewModel.fromJson(Map<String, dynamic> json) {
    return ReviewModel(
      rating: json['rating'] ?? 0, 
      comment: json['comment'] ?? '',
      reviewerName: json['reviewerName'] ?? 'Unknown',
    );
  }
}

class ProductModel extends Product {
  ProductModel({
    required super.id,
    required super.title,
    required super.description,
    required super.category,
    required super.price,
    required super.rating,
    required super.thumbnail,
    required super.images,
    required super.reviews,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'],
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      category: json['category'] ?? '',
      price: json['price'] ?? 0,
      rating: json['rating'] ?? 0,
      thumbnail: json['thumbnail'] ?? '',
      
      images: List<String>.from(json['images'] ?? []),
      
      reviews: json['reviews'] != null
          ? (json['reviews'] as List).map((reviewJson) => ReviewModel.fromJson(reviewJson)).toList()
          : [],
    );
  }
}