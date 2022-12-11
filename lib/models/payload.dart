import 'dart:convert';

import 'package:crypto/models/data.dart';
import 'package:crypto/models/status.dart';

Payload payloadFromJson(String str) => Payload.fromJson(json.decode(str));

String payloadToJson(Payload data) => json.encode(data.toJson());

class Payload {
  Payload({
    this.status,
    this.data,
  });

  Status? status;
  List<Data>? data;

  factory Payload.fromJson(Map<String, dynamic> json) => Payload(
        status: Status.fromJson(json["status"]),
        data: List<Data>.from(json["data"].map((x) => Data.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status!.toJson(),
        "data": List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}
