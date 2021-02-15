import 'package:workerf/model/index.dart';

class HintRepository{
  List<HintModel> hints;

  HintRepository(this.hints);

  factory HintRepository.fromList(List<dynamic> data){
    List<HintModel> _hints = [];
    data.forEach((hint) {
      _hints.add(HintModel(title: hint['title'], hint: hint['hint'], img: hint['imgurl']));
    });

    return HintRepository(_hints);
  }
}