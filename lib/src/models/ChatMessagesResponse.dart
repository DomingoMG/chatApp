// To parse this JSON data, do
//
//     final chatMessagesResponse = chatMessagesResponseFromJson(jsonString);

import 'dart:convert';

ChatMessagesResponse chatMessagesResponseFromJson(String str) => ChatMessagesResponse.fromJson(json.decode(str));

String chatMessagesResponseToJson(ChatMessagesResponse data) => json.encode(data.toJson());

class ChatMessagesResponse {
    ChatMessagesResponse({
        this.ok,
        this.messages,
    });

    bool ok;
    List<Message> messages;

    factory ChatMessagesResponse.fromJson(Map<String, dynamic> json) => ChatMessagesResponse(
        ok: json["ok"],
        messages: List<Message>.from(json["messages"].map((x) => Message.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "ok": ok,
        "messages": List<dynamic>.from(messages.map((x) => x.toJson())),
    };
}

class Message {
    Message({
        this.my,
        this.to,
        this.message,
        this.createdAt,
        this.updatedAt,
        this.uid,
    });

    String my;
    String to;
    String message;
    DateTime createdAt;
    DateTime updatedAt;
    String uid;

    factory Message.fromJson(Map<String, dynamic> json) => Message(
        my: json["my"],
        to: json["to"],
        message: json["message"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
        uid: json["uid"],
    );

    Map<String, dynamic> toJson() => {
        "my": my,
        "to": to,
        "message": message,
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
        "uid": uid,
    };
}
