import 'dart:convert';

import 'package:file_management/config/enviroment_config.dart';
import 'package:http/http.dart' as http;

class FileServices{

  static const String baseUrl = EnviromentConfig.baseUrl;

  static Future<http.Response> getFiles({String folderName = ''}) async {

    final response = await http.get(Uri.parse('$baseUrl/files/?folderName=$folderName'));
    
    return response;
  }

  static Future<http.StreamedResponse> uploadFile({required List<String> paths, String folderName = ''}) async{
    print('--------------------------');
    print(folderName);
    final request = http.MultipartRequest("POST", Uri.parse('$baseUrl/files/?folderName=$folderName'));

    for (var path in paths) {
      request.files.add(await http.MultipartFile.fromPath('image', path));
    }
    
    var resp = await request.send();

    return resp;

  }

  static Future<http.Response> deleteFile(String fileName) async {
    final encodedFileName = Uri.encodeComponent(fileName);
    print(encodedFileName);
    final response = await http.delete(Uri.parse('$baseUrl/files/$encodedFileName'));
    
    return response;
  }

  static Future<http.Response> createFolder(String folderName) async {
    
    final body = {
      'folderName': folderName
    };

    final response = await http.post(
      Uri.parse('$baseUrl/files/folders'), 
      body: json.encode(body),
      headers: {
        'Content-Type': 'application/json',
      },
    );
    
    return response;
  }
}