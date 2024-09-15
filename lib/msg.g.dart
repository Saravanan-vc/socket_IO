// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'msg.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

message _$messageFromJson(Map<String, dynamic> json) => message(
      messag: json['message'] as String?,
      send: json['sender'] as String?,
    );

Map<String, dynamic> _$messageToJson(message instance) => <String, dynamic>{
      'message': instance.messag,
      'sender': instance.send,
    };
