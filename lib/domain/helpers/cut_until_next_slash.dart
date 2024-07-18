String cutUntilNextSlash(String stringData) {
  if (stringData.endsWith('/')) {
    return stringData.substring(0, stringData.lastIndexOf('/') + 1);
  } else {
    int lastSlashIndex = stringData.lastIndexOf('/');
    if (lastSlashIndex == -1) {
      return '';
    }
    return stringData.substring(0, lastSlashIndex + 1);
  }
}