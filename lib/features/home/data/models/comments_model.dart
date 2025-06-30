import 'package:equatable/equatable.dart';

class CommentsModel extends Equatable {
  CommentsModel({
    required this.comment,
    required this.dacha,
    required this.user,
  });

  final String comment;
  final String dacha;
  final String user;

  CommentsModel copyWith({
    String? comment,
    String? dacha,
    String? user,
  }) {
    return CommentsModel(
      comment: comment ?? this.comment,
      dacha: dacha ?? this.dacha,
      user: user ?? this.user,
    );
  }

  factory CommentsModel.fromJson(Map<String, dynamic> json) {
    return CommentsModel(
      comment: json["comment"]?.toString() ?? "",
      dacha: json["dacha"]?.toString() ?? "",
      user: json["user"]?.toString() ?? "",
    );
  }

  @override
  List<Object?> get props => [
        comment,
        dacha,
        user,
      ];
}
