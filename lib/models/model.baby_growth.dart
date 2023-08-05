class BabyGrowthModel {
  late String _question;

  //newly added
  late String _quesId;
  late int _momId;
  late String _email;
  late int? _ansStatus;
  late int? _babyId;
  late int _timestar;
  late String _timeStamp;
  late String _options;
  late String? _inputedAnswer;

  BabyGrowthModel();

  BabyGrowthModel.initialQuesOnly({required String question}) {
    _question = question;
  }

  BabyGrowthModel.initialQuesData(
      {required String question,
      required String quesId,
      required int timestar,
      int? ansStatus,
      String? inputedAnswer,
      required String options
      /*  
      required int babyId,
      required int momId,
      required String email, */
      /*    
      required String timestamp,
    */
      }) {
    // _momId = momId;
    // _email = email;
    _quesId = quesId;
    _ansStatus = ansStatus;
    // _babyId = babyId;
    _timestar = timestar;
    _question = question;
    _options = options;
    _inputedAnswer = inputedAnswer;

/*     _timeStamp = timestamp;
    _options = options; */
  }

  Map<String, dynamic> toJsonInitialQuesData() {
    var map = <String, dynamic>{};
    // map[MyKeywords.momId] = _momId;
    // map[MyKeywords.email] = _email;
    // map['baby_id'] = _babyId;
    map['timestar'] = _timestar;
    map['ques_id'] = _quesId;
    map['question'] = _question;
    map['options'] = _options;
    // map['status'] = _ansStatus;
    /*   map['timestamp'] = _timeStamp;
    */

    return map;
  }

  //getter setter

  get options => _options;

  set options(value) => _options = value;
  get question => _question;

  set question(value) => _question = value;
  get babyId => _babyId;

  set babyId(value) => _babyId = value;

  get timestar => _timestar;

  set timestar(value) => _timestar = value;

  get ques_id => _quesId;

  set ques_id(value) => _quesId = value;

  get ans_status => _ansStatus;

  set ans_status(value) => _ansStatus = value;
  get inputedAnswer => this._inputedAnswer;

  set inputedAnswer(value) => this._inputedAnswer = value;
}
