class PProjectModel{
  int reqId;
  int clientId;
  String firstName;
  String lastName;
  String avatar;
  double rate;
  String comment;
  String description;

  PProjectModel.fromMap(Map data){
    reqId = data['reqid'];
    clientId = data['clientid'];
    firstName = data['firstname'];
    lastName = data['lastname'];
    avatar = data['clientavatar'];
    rate = data['stars'];
    comment = data['comments'];
    description = data['describe'];
  }
}