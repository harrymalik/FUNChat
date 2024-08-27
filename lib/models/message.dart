class Message {
  Message({
    required this.formid,
    required this.message,
    required this.read,
    required this.sent,
    required this.told,
    required this.type,
  });
  late final String formid;
  late final String message;
  late final String read;
  late final String sent;
  late final String told;
  late final Type type;

  Message.fromJson(Map<String, dynamic> json) {
    formid = json['formid'].toString();
    message = json['message'].toString();
    read = json['read'].toString();
    sent = json['sent'].toString();
    told = json['told'].toString();
    type = json['type'].toString() == Type.image.name ? Type.image : Type.text;
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['formid'] = formid;
    data['message'] = message;
    data['read'] = read;
    data['sent'] = sent;
    data['told'] = told;
    data['type'] = type.name;
    return data;
  }
}

enum Type { text, image }
