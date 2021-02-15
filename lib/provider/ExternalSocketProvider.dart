import 'package:adhara_socket_io/adhara_socket_io.dart';
import 'package:adhara_socket_io/manager.dart';
import 'package:adhara_socket_io/socket.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:workerf/global/index.dart';
import 'package:workerf/model/index.dart';
import 'package:workerf/redux/index.dart';
import 'package:workerf/repository/index.dart';
import 'package:workerf/ui/Components/index.dart';
import 'InternalSocketProvider.dart';


class ExternalSocket{
  final SocketIOManager manager = SocketIOManager();
  SocketIO socket;
  Future<void> socketConfig() async {
    if(socket != null){
      manager.clearInstance(socket);
      socket = null;
    }

    SocketOptions options = SocketOptions('https://ws.manoexperta.com',
        enableLogging: true,
        query: {"token": authKey});

    socket = await manager.createInstance(options);

    socket.onConnect((data){
      socket.emit("init", [{"channels": currentUser.expertChannels, "userId": currentUser.userId}]);
    });

    socket.on('delete', (data) {
      ProjectRepository _repository = store.state.projectState.repository;
      _repository.deleteById(data['reqId']);
      store.dispatch(updateProjects(_repository));
    });//{reqId: 475}

    socket.on('cancel', (data){
      /// currently screen navigates to terminate screen so don't have to set active project to 0
//      UserModel user = store.state.authState.user;
//      user.activeProject = 0;
//      store.dispatch(updateUser(user));
      iSocket.trigger(InternalSocketT.cancel, data: data['reqId']);
    });

    socket.on('complete', (data) {
      iSocket.trigger(InternalSocketT.complete, data: data['reqId']);});

    socket.on('hire', (data){
      UserModel user = store.state.authState.user;
      user.activeProject = data['reqId'];
      store.dispatch(updateUser(user));
      navigationKey.currentState.pushNamedAndRemoveUntil('/progress', (route) => false);
    });

    socket.on('new', (message) {
      print('new event. message:$message');
      ProjectRepository _repository = store.state.projectState.repository;
      ProjectModel _newProject = ProjectModel.fromSocketMessage(message);
      _repository.add(_newProject);
      store.dispatch(updateProjects(_repository));
    });
    //{location: {_lng: -122.421945, _lat: 37.7710967}, exclusive: 0, img: https://firebasestorage.googleapis.com/v0/b/flutterme-60f5d.appspot.com/o/descriptionImage%2Fimage_cropper_1601930368291.jpg'?alt=media&token=94ba4871-50d1-4445-8c4b-0ddb71a78516, blockedXp: [], description: This is new socket message test., reqId: 476, catId: 3}

    socket.on('inquiry', (data)  {
      try{
        ProjectModel inquiry = ProjectModel.fromInquirySocket(data);
        inquiry.calcDistance(LatLng(globalLocationData.latitude, globalLocationData.longitude));
        if(inquiry.distance <= currentUser.range && currentUser.categories.indexOf(inquiry.catId) != -1){
          CToast.smUnread("Se ha publicado una nueva consulta");
          if(currentUser.activeProject == 0){
            navigationKey.currentState.pushNamed('/inquiry');
          }
        }
      }catch(e){
        print(e);
      }

    });

    socket.connect();
  }
}