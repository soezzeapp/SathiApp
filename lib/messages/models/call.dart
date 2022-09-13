class Call {
  final String callerId;
  final String callerName;
  final String callerPic;
  final String receiverId;
  final String receiverName;
  final String receiverPic;
  final String callId;
  final bool hasDialled;

  Call({
    required this.callerId,
    required this.callerName,
    required this.callerPic,
    required this.receiverId,
    required this.receiverName,
    required this.receiverPic,
    required this.callId,
    required this.hasDialled
  });

  factory Call.fromJson(Map<String, dynamic> json) {
    return Call(
      callerId: json['a_callerId'],
      callerName: json['b_callerName'],
      callerPic: json['c_callerPic'],
      receiverId: json['d_receiverId'],
      receiverName: json['e_receiverName'],
      receiverPic: json['f_receiverPic'],
      callId: json['g_callId'],
      hasDialled: json['h_hasDialled'], );
  }

  Map<String,dynamic>toJson()=>{
    'a_callerId':callerId,
    'b_callerName':callerName,
    'c_callerPic':callerPic,
    'd_receiverId':receiverId,
    'e_receiverName':receiverName,
    'f_receiverPic':receiverPic,
    'g_callId':callId,
    'h_hasDialled':hasDialled,
  };

}