final String imageAssetsRoot = "images/";
final String logo = _getImagePath("logo.png");


String _getImagePath(String fileName){
  return imageAssetsRoot + fileName;
}