import 'package:salsel_express/model/awb.dart';
import 'package:salsel_express/model/user.dart';

class AwbHistory {
  final int? id;
  final String? comment;
  final String? awbStatus;
  final Awb? awb;
  final User? statusUpdateByUser;

  const AwbHistory({
    this.id,
    this.comment,
    this.awb,
    this.statusUpdateByUser,
    this.awbStatus,
  });

  factory AwbHistory.fromJson(Map<String, dynamic> json) {
    return AwbHistory(
      id: json['id'],
      comment: json['comment'],
      awbStatus: json['awbStatus'],
      statusUpdateByUser: json['statusUpdateByUser'] != null ? User.fromJson(json['statusUpdateByUser']) : null,
      awb: json['awb'] != null ? Awb.fromJson(json['awb']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'comment': comment,
      'awb': awb?.toJson(),
      'statusUpdateByUser': statusUpdateByUser?.toJson(),
      'awbStatus': awbStatus,
    };
  }
}
