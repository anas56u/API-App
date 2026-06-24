class CartItem {
  final int id; 
  final String title;
  final double price;
  final String thumbnail;
  int quantity;

  CartItem({
    required this.id,
    required this.title,
    required this.price,
    required this.thumbnail,
    this.quantity = 1, 
  });
}