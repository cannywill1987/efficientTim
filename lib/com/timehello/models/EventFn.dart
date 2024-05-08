/**
 * 用于跨组件通信
 */
// 引入 eventBus 包文件
import 'package:event_bus/event_bus.dart';

// 创建EventBus
EventBus eventBus = new EventBus();

// event 监听
class EventFn{
  // 想要接收的数据时什么类型的，就定义相同类型的变量
  dynamic obj;
  String type;
  EventFn(this.type, this.obj);
}

class ComEvent {
  int id;
  Object data;

  ComEvent({
    required this.id,
    required this.data,
  });
}
//
// class Event {
//   static void sendAppComEvent(BuildContext context, ComEvent event) {
//     // BlocProvider.of<ApplicationBloc>(context).sendAppComEvent(event);
//   }
//
//   static void sendAppEvent(BuildContext context, int id) {
//     BlocProvider.of<ApplicationBloc>(context).sendAppEvent(id);
//   }
// }