import 'dart:convert';

class Recent {
  String uri;
  String path;
  String createdDate;

  Recent({
    required this.uri,
    required this.path,
    required this.createdDate,
  });

  Map<String, dynamic> toJson() {
    return {
      'uri': uri,
      'path': path,
      'createdDate': createdDate,
    };
  }

  factory Recent.fromJson(Map<String, dynamic> json) {
    return Recent(
      uri: json['uri'] as String,
      path: json['path'] as String,
      createdDate: json['createdDate'] as String,
    );
  }

  static String toListJson(List<Recent> list){
    return jsonEncode(list);
  }

  static List<Recent> fromListJson(String json){
    return List.from(jsonDecode(json).map((e) => Recent.fromJson(e)).toList());
  }
}
