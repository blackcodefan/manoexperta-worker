import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:workerf/ui/style.dart';

class Payments extends StatefulWidget{
  _Payments createState() => _Payments();
}

class _Payments extends State<Payments>  with SingleTickerProviderStateMixin{
  TabController _tabController;
  int _currentTab = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      setState(() {
        _currentTab = _tabController.index;
      });
    });
  }


  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;

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
            child: Scaffold(
                backgroundColor: Colors.transparent,
                appBar: AppBar(
                    centerTitle: true,
                    title: Text(
                        'Pagos',
                        style: appbarTitle),
                    elevation: 0.0,
                    backgroundColor: Colors.transparent,
                    leading: IconButton(
                        icon: Icon(Icons.arrow_back_ios),
                        onPressed: () => Navigator.pop(context)),
                  actions: [
                    IconButton(
                        icon: Icon(Icons.account_balance), 
                        onPressed: () => Navigator.pushNamed(context, '/aPayment'))
                  ]),
                body: DefaultTabController(
                    length: 2,
                    child: Column(
                        children: [
                          Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                FlatButton(
                                    textColor: Colors.white,
                                    color: _currentTab == 0?
                                    Color(0xFF1B998B):Color(0xFFAAAAAA),
                                    child: Text('Reservados'),
                                    onPressed: ()=> _updateTab(0)),
                                FlatButton(
                                  textColor: Colors.white,
                                  color: _currentTab == 0?
                                  Color(0xFFAAAAAA):Color(0xFF1B998B),
                                  child: Text('Liberados'),
                                  onPressed: ()=> _updateTab(1)
                                )]),
                          Expanded(
                              child: Container(
                                  width: screenSize.width,
                                  decoration: BoxDecoration(
                                      color: Color(0xFFFE5E5E5),
                                      borderRadius: BorderRadius.only(
                                          topRight: Radius.circular(30),
                                          topLeft: Radius.circular(30))),
                                  padding: EdgeInsets.only(top: 20),
                                  child: TabBarView(
                                      controller: _tabController,
                                      children: <Widget>[
                                        Container(
                                            width: double.infinity,
                                            padding: EdgeInsets.all(10),
                                            child: _NoResult()),
                                        Container(
                                            width: double.infinity,
                                            padding: EdgeInsets.all(10),
                                            child: _NoResult())]
                                  )))])
                ))));
  }

  void _updateTab(int tabIndex){
    setState(() {
      _currentTab = tabIndex;
    });
    _tabController.animateTo(tabIndex);
  }
}

class _NoResult extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset('assets/img/nopayment.png',
          width: 200),
          Container(
            padding: EdgeInsets.symmetric(vertical: 20),
            child: Text('Sin pagos',
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold)))
        ]));
  }
}