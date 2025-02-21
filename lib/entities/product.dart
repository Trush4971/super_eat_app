class Product
{
  int id;
  String name;
  double price;
  String image;
  String description;
  bool? isRecommended;
  bool? isHamburger;
  //isHamburger=true:Hamburger,
  //isHamburger=false:Pizza,
  //isHamburger=null:Salad,
  Product({
    this.id=0,
    this.name='',
    this.price=0.00,
    this.image='',
    required this.description,
    this.isRecommended=false,
    this.isHamburger=false,
  });

  //  JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'image': image,
      'price': price,
      'description': description,
      'isHamburger': isHamburger,
      'isRecommended': isRecommended,
    };}

  // CREATE FROM JSON
  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      name: json['name'],
      image: json['image'],
      price: json['price'].toDouble(),
      description: json['description'],
      isHamburger: json['isHamburger'],
      isRecommended: json['isRecommended'],
    );
  }


}