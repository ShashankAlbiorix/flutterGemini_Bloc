class ChatMessageModel {
  String? msgContent;
  bool? isUser;
  int? timestamp;

  ChatMessageModel({
    this.msgContent,
    this.isUser,
    this.timestamp,
  });

  factory ChatMessageModel.fromJson(Map<String, dynamic> json) => ChatMessageModel(
    msgContent: json["msg_content"],
    isUser: json["isUser"],
    timestamp: json["timestamp"],
  );

  Map<String, dynamic> toJson() => {
    "msg_content": msgContent,
    "isUser": isUser,
    "timestamp": timestamp,
  };
}
