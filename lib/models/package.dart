import 'package:courier_app/models/position.dart';
import 'package:courier_app/models/user.dart';

class Package {
  final String id;
  final String packageNumber;
  final String sendDate;
  final User receiver;
  final User sender;
  final Position position;
  final String comments;
  final String status;

  Package(
      {required this.id,
      required this.packageNumber,
      required this.sendDate,
      required this.receiver,
      required this.sender,
      required this.position,
      required this.comments,
      required this.status});
}
