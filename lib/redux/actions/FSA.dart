class FSA{
  final String type;
  final dynamic payload;

  FSA({this.type, this.payload});

  factory FSA.fromMap(Map action){
    return FSA(type: action['type'], payload: action['payload']);
  }
}