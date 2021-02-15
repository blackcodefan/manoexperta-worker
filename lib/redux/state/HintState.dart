import 'package:workerf/model/index.dart';

class HintState{
  dynamic error;
  List<HintModel> hints;

  HintState({this.error, this.hints});

  factory HintState.init() => HintState(
    hints: [
      HintModel.init()
    ]
  );
}