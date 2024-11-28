class Roles {
  String? id;
  String? title;
  List<dynamic>? permissions;

  Roles({
    this.id,
    this.title,
    this.permissions,
  });

  factory Roles.fromJson(Map<String, dynamic> json) => Roles(
        id: json["id"],
        title: json["title"],
        permissions: json["permissions"] == null
            ? []
            : List<dynamic>.from(json["permissions"]!.map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "permissions": permissions == null
            ? []
            : List<dynamic>.from(permissions!.map((x) => x)),
      };
}
