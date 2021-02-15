import 'package:workerf/model/index.dart';

class CategoryRepository{
  List<CategoryModel> categories;

  CategoryRepository(this.categories);

  factory CategoryRepository.fromList(List<dynamic> categories){
    List<CategoryModel> _categories = [];
    categories.forEach((category) {
      _categories.add(CategoryModel.fromMap(category));
    });

    return CategoryRepository(_categories);
  }

  List<CategoryModel> filterCategory(List<dynamic> allowedCats){
    List<CategoryModel> _result = [];
    for(int i = 0; i < categories.length; i++){
      if(allowedCats.indexOf(categories[i].id) != -1){
        _result.add(categories[i]);
      }
    }
    return _result;
  }
}