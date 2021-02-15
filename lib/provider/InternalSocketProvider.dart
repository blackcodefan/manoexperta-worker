import 'package:event/event.dart';

enum InternalSocketT{
  notification,
  pushNotificationConfirm,
  locationUpdate,
  complete,
  cancel,
  paySuccess,
  payFailed
}

class InternalSocketArgs extends EventArgs{
  final InternalSocketT type;
  final dynamic data;
  InternalSocketArgs(this.type, {this.data});
}

class InternalSocket{
  final socket = Event<InternalSocketArgs>();

  void trigger(InternalSocketT type, {dynamic data}){
    socket.broadcast(InternalSocketArgs(type, data: data));
  }
}