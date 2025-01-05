class Category {
  String catetype;
  String category;
  String icon;
  int budget = 0;

  Category({
    required this.catetype,
    required this.category,
    required this.icon,
    this.budget = 0,
  });

  Map<String, dynamic> toMap() {
    return {
      'catetype': catetype,
      'category': category,
      'icon': icon,
      'budget': budget,
    };
  }

  factory Category.fromMap(Map<String, dynamic> map) {
    return Category(
      catetype: map['catetype'],
      category: map['category'],
      icon: map['icon'],
      budget: map['budget'],
    );
  }
}