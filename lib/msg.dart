import 'package:json_annotation/json_annotation.dart';
part 'msg.g.dart';

@JsonSerializable()
class message {
  @JsonKey(name: "message")
  String? messag;

  @JsonKey(name: "sender")
  String? send;

  message({required this.messag, required this.send});

  factory message.fromjson(Map<String, dynamic> json) =>
      _$messageFromJson(json);
}
