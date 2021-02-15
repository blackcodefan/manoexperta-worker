import 'package:flutter/material.dart';
import 'package:workerf/global/index.dart';
import 'package:workerf/model/index.dart';
import 'package:workerf/ui/Components/index.dart';
import 'package:workerf/ui/style.dart';
import 'CategoryGridItem.dart';

import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:workerf/redux/index.dart';

class Category extends StatefulWidget{
  _Category createState() => _Category();
}

class _Category extends State<Category>{

  List<CategoryModel> _categories = [];

  void _fetchCategories(_Props props) async{
    await props.fetch();
    setState(() {
      _categories = props.categoryState
          .repository
          .filterCategory(globalMarket.categories);
    });
  }

  void _toggle(int id, bool selected, _Props props){
    UserModel user = props.authState.user;
    if(selected){
      user.categories.remove(id);
    }else if(user.categories.length < user.maxCat){
      user.categories.add(id);
    }
    props.updateStore(user);
  }

  void _update(_Props props)async{
    UserModel user = props.authState.user;
    
    if(user.categories.length < 1){
      CToast.warning("seleccione mínimo 1 categoría");
      return;
    }else if(user.categories.length > user.maxCat){
      CToast.warning("número máximo de categoría: ${user.maxCat}");
      return;
    }

    currentUser = user;
    await props.update(user.token, user.categories);
    eSocket.socketConfig();
    if(Navigator.canPop(context)){
      Navigator.pop(context);
    }else{
      Navigator.pushReplacementNamed(context, '/map');
    }
  }

  @override
  Widget build(BuildContext context) {

    return StoreConnector<AppState, _Props>(
      onInitialBuild: (props) => _fetchCategories(props),
      converter: (store) => _Props.mapStateToProps(store),
      builder: (context, props){
        List<dynamic> _myCategories = props.authState.user.categories;

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
                            leading: Navigator.canPop(context)?IconButton(
                                icon: Icon(Icons.arrow_back_ios),
                                onPressed: () => Navigator.pop(context)):Container(),
                            actions: [
                              IconButton(
                                  icon: Icon(Icons.check),
                                  onPressed: () => _update(props))
                            ]),
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
                                  isSelected: _myCategories.indexOf(_category.id) != -1 ,
                                  imgUrl: _category.image,
                                  onTap: (id, selected) => _toggle(id, selected, props),
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
  final AuthState authState;
  final CategoryState categoryState;
  final Function update;
  final Function updateStore;
  final Function fetch;
  _Props({this.authState, this.categoryState, this.update, this.updateStore, this.fetch});

  static _Props mapStateToProps(Store<AppState> store){
    return _Props(
        authState: store.state.authState,
        categoryState: store.state.categoryState,
        updateStore: (UserModel user) => store.dispatch(updateUser(user)),
        update: (String token, List<dynamic> categories) => store.dispatch(updateProfile(token, categories: categories)),
      fetch: () => store.dispatch(getCategory())
    );
  }
}