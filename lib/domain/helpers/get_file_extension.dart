String getFileExtensionHelper(String path){
  List<String> parts = path.split('/').last.split('.');
  return parts.last;
}