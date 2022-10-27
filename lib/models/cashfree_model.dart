class CashFreeTocken {
  String _status;
  String _message;
  String _cftoken;
  String _subCode;
  CashFreeTocken({String status, String subCode, String message, String cftoken}) {
    this._status = status;
    this._message = message;
    this._cftoken = cftoken;
    this._subCode = subCode;
  }

  String get status => _status;
  set status(String status) => _status = status;
  String get message => _message;
  set message(String message) => _message = message;
  String get cftoken => _cftoken;
  set cftoken(String cftoken) => _cftoken = cftoken;
  String get subCode => _subCode;
  set subCode(String subCode) => _subCode = subCode;

  CashFreeTocken.fromJson(Map<String, dynamic> json) {
    _status = json['status'];
    _message = json['message'];
    _cftoken = json['cftoken'];
    _subCode = json['subCode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this._status;
    data['message'] = this._message;
    data['subCode'] = this._subCode;
    data['cftoken'] = this._cftoken;
    return data;
  }
}