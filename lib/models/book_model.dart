class BookModel {
  String? id;
  String? title;
  String? description;
  int? year;
  String? author;
  String? category;
  String? coverUrl;

  BookModel({
    this.id,
    this.title,
    this.description,
    this.year,
    this.author,
    this.category,
    this.coverUrl,
  });

  BookModel.fromJson(Map<String, dynamic> json) {
    if (json["id"] is String) {
      id = json["id"];
    }
    if (json["title"] is String) {
      title = json["title"];
    }
    if (json["description"] is String) {
      description = json["description"];
    }
    if (json["year"] is int) {
      year = json["year"];
    }
    if (json["author"] is String) {
      author = json["author"];
    }
    if (json["category"] is String) {
      category = json["category"];
    }
    if (json["coverUrl"] is String) {
      coverUrl = json["coverUrl"];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["id"] = id;
    _data["title"] = title;
    _data["description"] = description;
    _data["year"] = year;
    _data["author"] = author;
    _data["category"] = category;
    _data["coverUrl"] = coverUrl;
    return _data;
  }
}
