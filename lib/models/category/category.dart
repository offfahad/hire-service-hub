class Category {
  String? id;
  String? title;
  String? description;
  bool? isAvailable;

  Category({
    this.id,
    this.title,
    this.description,
    this.isAvailable,
  });

  factory Category.fromJson(Map<String, dynamic> json) => Category(
        id: json["id"],
        title: json["title"],
        description: json["description"],
        isAvailable: json["is_available"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "description": description,
        "is_available": isAvailable,
      };
}
