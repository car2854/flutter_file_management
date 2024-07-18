String getFormatHelper(String fileExtension){
  switch (fileExtension) {
    case 'png':
      return 'image';
    case 'jpg':
      return 'image';
    case 'pdf':
      return 'pdf';
    case 'gif':
      return 'git';
    case 'docx':
      return 'docx';
    default: return '';
  }
}