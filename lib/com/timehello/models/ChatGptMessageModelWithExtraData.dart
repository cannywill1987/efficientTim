import 'package:time_hello/com/timehello/models/ChatGptMessageModel.dart';

class ChatGptMessageModelWithExtraData {
  String timeAgo = ""; // 用于显示时间 如 1小时 3小时 1天前
  List<ChatGptMessageModel> list = []; //这个都是folder
  ChatGptMessageModelWithExtraData({required this.timeAgo, required this.list});
}