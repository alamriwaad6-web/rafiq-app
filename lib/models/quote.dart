class Quote {
  final String text;
  final String author;

  const Quote({required this.text, required this.author});

  factory Quote.fromJson(Map<String, dynamic> json) {
    final authorData = json['author'];

    return Quote(
      text: json['text'] as String,
      author: authorData is Map
          ? authorData['name'] as String
          : authorData as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {'text': text, 'author': author};
  }
}
