// To parse this JSON data, do
//
//     final fileResponse = fileResponseFromJson(jsonString);

import 'dart:convert';

List<FileModel> fileResponseFromJson(String str) => List<FileModel>.from(json.decode(str).map((x) => FileModel.fromJson(x)));

String fileResponseToJson(List<FileModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class FileModel {
    String fileName;
    String name;
    String publicUrl;
    String format;

    FileModel({
        required this.fileName,
        required this.name,
        required this.publicUrl,
        required this.format,
    });

    factory FileModel.fromJson(Map<String, dynamic> json) => FileModel(
        fileName: json["fileName"],
        name: json["name"],
        publicUrl: json["publicUrl"],
        format: json["format"],
    );

    Map<String, dynamic> toJson() => {
        "fileName": fileName,
        "name": name,
        "publicUrl": publicUrl,
        "format": format,
    };
}
