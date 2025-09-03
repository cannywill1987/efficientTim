/**
 * StartTimeMissionWidgetExample - 开始时间任务桌面组件数据透传示例
 * 用于演示如何将StartTimeMissionModel数据传递给iOS桌面组件
 */
import 'package:flutter/material.dart';
import '../models/StartTimeMissionModel.dart';
import '../libs/methodChannel/CounterMethodChannelManager.dart';

class StartTimeMissionWidgetExample extends StatefulWidget {
  const StartTimeMissionWidgetExample({Key? key}) : super(key: key);

  @override
  State<StartTimeMissionWidgetExample> createState() =>
      _StartTimeMissionWidgetExampleState();
}

class _StartTimeMissionWidgetExampleState
    extends State<StartTimeMissionWidgetExample> {
  // 模拟的开始时间任务数据
  List<StartTimeMissionModel> _startTimeMissions = [];
  bool _isLoading = false;
  String _statusMessage = '';

  @override
  void initState() {
    super.initState();
    _loadMockData();
  }

  /// 加载模拟数据
  void _loadMockData() {
    setState(() {
      _startTimeMissions = [
        StartTimeMissionModel(
          title: '晨跑计划', // 任务标题
          time_format: 'HH:mm', // 时间格式
          device_id: 'iPhone_001', // 设备ID
          start_time: DateTime.now().millisecondsSinceEpoch, // 开始时间
          finish_time: DateTime.now()
              .add(Duration(hours: 1))
              .millisecondsSinceEpoch, // 预计完成时间
          isFinished: false, // 是否完成
          uid: 'user_123', // 用户ID
          background_url: 'https://example.com/bg1.jpg', // 背景图片URL
          message: '每天早晨6点开始晨跑，保持健康生活', // 任务描述
        ),
        StartTimeMissionModel(
          title: '学习Flutter开发',
          time_format: 'HH:mm',
          device_id: 'iPhone_001',
          start_time:
              DateTime.now().add(Duration(hours: 2)).millisecondsSinceEpoch,
          finish_time:
              DateTime.now().add(Duration(hours: 4)).millisecondsSinceEpoch,
          isFinished: false,
          uid: 'user_123',
          background_url: 'https://example.com/bg2.jpg',
          message: '深入学习Flutter框架，掌握跨平台开发技能',
        ),
        StartTimeMissionModel(
          title: '阅读技术书籍',
          time_format: 'HH:mm',
          device_id: 'iPhone_001',
          start_time:
              DateTime.now().add(Duration(hours: 5)).millisecondsSinceEpoch,
          finish_time:
              DateTime.now().add(Duration(hours: 6)).millisecondsSinceEpoch,
          isFinished: false,
          uid: 'user_123',
          background_url: 'https://example.com/bg3.jpg',
          message: '阅读《Flutter实战》第5-8章',
        ),
      ];
    });
  }

  /// 同步数据到iOS桌面组件
  Future<void> _syncToWidget() async {
    setState(() {
      _isLoading = true;
      _statusMessage = '正在同步数据到桌面组件...';
    });

    try {
      // 获取CounterMethodChannelManager实例
      final manager = CounterMethodChannelManager.getInstance();

      // 调用数据透传方法
      final success =
          await manager.storeStartTimeMissionList(_startTimeMissions);

      setState(() {
        _statusMessage = success ? '数据同步成功！桌面组件已更新' : '数据同步失败，请检查网络连接';
      });

      if (success) {
        // 显示成功提示
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('数据已成功同步到iOS桌面组件'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      setState(() {
        _statusMessage = '同步过程中发生错误: $e';
      });

      // 显示错误提示
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('同步失败: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  /// 添加新任务
  void _addNewTask() {
    final newTask = StartTimeMissionModel(
      title: '新任务 ${_startTimeMissions.length + 1}',
      time_format: 'HH:mm',
      device_id: 'iPhone_001',
      start_time: DateTime.now()
          .add(Duration(hours: _startTimeMissions.length + 1))
          .millisecondsSinceEpoch,
      finish_time: DateTime.now()
          .add(Duration(hours: _startTimeMissions.length + 2))
          .millisecondsSinceEpoch,
      isFinished: false,
      uid: 'user_123',
      background_url:
          'https://example.com/bg${_startTimeMissions.length + 1}.jpg',
      message: '这是一个新添加的任务',
    );

    setState(() {
      _startTimeMissions.add(newTask);
    });
  }

  /// 标记任务为完成
  void _markTaskAsFinished(int index) {
    setState(() {
      _startTimeMissions[index].isFinished = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('开始时间任务桌面组件示例'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          // 状态显示区域
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(16),
            color: Colors.grey[100],
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '状态: $_statusMessage',
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 8),
                Text(
                  '任务总数: ${_startTimeMissions.length}',
                  style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                ),
                Text(
                  '未完成任务: ${_startTimeMissions.where((task) => task.isFinished == false).length}',
                  style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                ),
              ],
            ),
          ),

          // 操作按钮区域
          Padding(
            padding: EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _syncToWidget,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: _isLoading
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: 16,
                                height: 16,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white),
                                ),
                              ),
                              SizedBox(width: 8),
                              Text('同步中...'),
                            ],
                          )
                        : Text('同步到桌面组件'),
                  ),
                ),
                SizedBox(width: 16),
                ElevatedButton(
                  onPressed: _addNewTask,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                  ),
                  child: Text('添加任务'),
                ),
              ],
            ),
          ),

          // 任务列表
          Expanded(
            child: ListView.builder(
              itemCount: _startTimeMissions.length,
              itemBuilder: (context, index) {
                final task = _startTimeMissions[index];
                final isFinished = task.isFinished ?? false;

                return Card(
                  margin: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: isFinished ? Colors.grey : Colors.blue,
                      child: Icon(
                        isFinished ? Icons.check : Icons.schedule,
                        color: Colors.white,
                      ),
                    ),
                    title: Text(
                      task.title ?? '无标题',
                      style: TextStyle(
                        decoration:
                            isFinished ? TextDecoration.lineThrough : null,
                        color: isFinished ? Colors.grey : Colors.black,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(task.message ?? '无描述'),
                        SizedBox(height: 4),
                        Text(
                          '开始时间: ${_formatTime(task.start_time)}',
                          style:
                              TextStyle(fontSize: 12, color: Colors.grey[600]),
                        ),
                        Text(
                          '预计完成: ${_formatTime(task.finish_time)}',
                          style:
                              TextStyle(fontSize: 12, color: Colors.grey[600]),
                        ),
                      ],
                    ),
                    trailing: isFinished
                        ? Icon(Icons.check_circle, color: Colors.green)
                        : IconButton(
                            icon: Icon(Icons.check_circle_outline),
                            onPressed: () => _markTaskAsFinished(index),
                          ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  /// 格式化时间显示
  String _formatTime(int? timestamp) {
    if (timestamp == null) return '未设置';
    final dateTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
    return '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }
}
