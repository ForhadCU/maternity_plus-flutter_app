import 'package:splash_screen/consts/const.keywords.dart';

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

  BabyGrowthModel();

  BabyGrowthModel.initialQuesOnly({required String question}) {
    _question = question;
  }

  BabyGrowthModel.initialQuesData(
      {required String question,
      required String quesId,
       required int timestar,
        int? ansStatus,
     /*  
      required int babyId,
      required int momId,
      required String email, */
  /*    
      required String timestamp,
      required String options */}) {
    // _momId = momId;
    // _email = email;
    _quesId = quesId;
    _ansStatus = ansStatus;
    // _babyId = babyId;
    _timestar = timestar;
    _question = question;

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
    // map['status'] = _ansStatus;
  /*   map['timestamp'] = _timeStamp;
    map['options'] = _options; */

    return map;
  }

  //getter setter

  get options => this._options;

  set options(value) => this._options = value;
  get question => this._question;

  set question(value) => this._question = value;
  get babyId => this._babyId;

  set babyId(value) => this._babyId = value;

  get timestar => this._timestar;

  set timestar(value) => this._timestar = value;

  get ques_id => this._quesId;

  set ques_id(value) => this._quesId = value;

  get ans_status => this._ansStatus;

  set ans_status(value) => this._ansStatus = value;
}
