class HintModel{
  String title;
  String hint;
  String img;

  HintModel({this.title, this.hint, this.img});

  factory HintModel.init() =>HintModel(
      title: '¡No batalles más! Déjalo al que sabe',
      hint: 'Encuentra el oficio que tanto estabas buscando',
      img: 'https://manoexperta.s3.amazonaws.com/flutter/hint_nobatallesmas.png'
  );
}