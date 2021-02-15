class CategoryModel{
  int id;
  String name;
  String image;

  CategoryModel.fromMap(Map data){
    id = data['catid'];
    name = data['catname'];
    image = data['catimgurl'];
  }
}