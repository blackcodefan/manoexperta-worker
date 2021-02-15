import 'package:flutter/material.dart';
import 'package:workerf/global/index.dart';
import 'package:workerf/model/index.dart';
import 'package:workerf/ui/Components/index.dart';
import 'package:workerf/ui/style.dart';
import 'CategoryGridItem.dart';

import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:workerf/redux/index.dart';

class PCategory extends StatefulWidget{
  _PCategory createState() => _PCategory();
}

class _PCategory extends State<PCategory>{

  int _selected;

  void _fetchCategories(_Props props) {
    props.fetch();
  }

  void _pick(int id, String catName, _Props props){
    setState(() {
      _selected = id;
    });

    Navigator.pop(context, {"catId": id, "catName": catName});
  }

  @override
  Widget build(BuildContext context) {

    return StoreConnector<AppState, _Props>(
        onInitialBuild: (props) => _fetchCategories(props),
        converter: (store) => _Props.mapStateToProps(store),
        builder: (context, props){
          List<CategoryModel> _categories = props.categoryState
              .repository
              .filterCategory(globalMarket.categories);

          return Scaffold(
              body: Container(
                  width: double.infinity,
                  height: double.infinity,
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: <Color>[
                            Color(0xFF7F30DA),
                            Color(0xFF6732DB)
                          ],
                          stops: [0.05, 0.3]
                      )),
                  child: Stack(
                      children: [
                        Scaffold(
                            backgroundColor: Colors.transparent,
                            appBar: AppBar(
                                centerTitle: true,
                                title: Text(
                                    'Mis especialidades',
                                    style: appbarTitle),
                                elevation: 0.0,
                                backgroundColor: Colors.transparent,
                                leading: IconButton(
                                    icon: Icon(Icons.arrow_back_ios),
                                    onPressed: () => Navigator.pop(context))),
                            body: Container(
                              width: double.infinity,
                              height: double.infinity,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.only(
                                      topRight: Radius.circular(30),
                                      topLeft: Radius.circular(30))),
                              padding: EdgeInsets.all(20),
                              child: GridView.builder(
                                  itemCount: _categories.length,
                                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
                                  itemBuilder: (context, int index){
                                    CategoryModel _category = _categories[index];
                                    return CategoryGridItem(
                                      catId: _category.id,
                                      catName: _category.name,
                                      isSelected:  _selected == _category.id,
                                      imgUrl: _category.image,
                                      onTap: (id, name) => _pick(id, name, props),
                                    );
                                  }),
                            )),
                        Positioned(
                            top: 0, left: 0,
                            child: props.categoryState.loading?FullScreenLoaderWhite():Container())
                      ]
                  )));
        }
    );
  }
}

class _Props{
  final CategoryState categoryState;
  final Function fetch;
  _Props({this.categoryState, this.fetch});

  static _Props mapStateToProps(Store<AppState> store){
    return _Props(
        categoryState: store.state.categoryState,
        fetch: () => store.dispatch(getCategory())
    );
  }
}