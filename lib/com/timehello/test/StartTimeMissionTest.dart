/**
 * StartTimeMissionTest - 开始时间任务数据透传功能测试
 * 用于验证StartTimeMissionModel和CounterMethodChannelManager的功能
 */
import 'package:flutter_test/flutter_test.dart';
import '../models/StartTimeMissionModel.dart';
import '../libs/methodChannel/CounterMethodChannelManager.dart';

void main() {
  group('StartTimeMissionModel 测试', () {
    test('创建StartTimeMissionModel实例', () {
      // 创建测试实例
      final mission = StartTimeMissionModel(
        title: '测试任务',
        time_format: 'HH:mm',
        device_id: 'test_device',
        start_time: 1703123456789,
        finish_time: 1703127056789,
        isFinished: false,
        uid: 'test_user',
        background_url: 'https://example.com/test.jpg',
        message: '这是一个测试任务',
      );

      // 验证字段值
      expect(mission.title, equals('测试任务'));
      expect(mission.time_format, equals('HH:mm'));
      expect(mission.device_id, equals('test_device'));
      expect(mission.start_time, equals(1703123456789));
      expect(mission.finish_time, equals(1703127056789));
      expect(mission.isFinished, equals(false));
      expect(mission.uid, equals('test_user'));
      expect(mission.background_url, equals('https://example.com/test.jpg'));
      expect(mission.message, equals('这是一个测试任务'));
    });

    test('JSON序列化和反序列化', () {
      // 创建原始实例
      final originalMission = StartTimeMissionModel(
        title: 'JSON测试任务',
        time_format: 'MM-dd',
        device_id: 'json_test_device',
        start_time: 1703123456789,
        finish_time: 1703127056789,
        isFinished: true,
        uid: 'json_test_user',
        background_url: 'https://example.com/json_test.jpg',
        message: 'JSON序列化测试',
      );

      // 转换为JSON
      final json = originalMission.toJson();

      // 验证JSON结构
      expect(json['title'], equals('JSON测试任务'));
      expect(json['time_format'], equals('MM-dd'));
      expect(json['device_id'], equals('json_test_device'));
      expect(json['start_time'], equals(1703123456789));
      expect(json['finish_time'], equals(1703127056789));
      expect(json['isFinished'], equals(true));
      expect(json['uid'], equals('json_test_user'));
      expect(
          json['background_url'], equals('https://example.com/json_test.jpg'));
      expect(json['message'], equals('JSON序列化测试'));

      // 从JSON创建新实例
      final newMission = StartTimeMissionModel.fromJson(json);

      // 验证反序列化结果
      expect(newMission.title, equals(originalMission.title));
      expect(newMission.time_format, equals(originalMission.time_format));
      expect(newMission.device_id, equals(originalMission.device_id));
      expect(newMission.start_time, equals(originalMission.start_time));
      expect(newMission.finish_time, equals(originalMission.finish_time));
      expect(newMission.isFinished, equals(originalMission.isFinished));
      expect(newMission.uid, equals(originalMission.uid));
      expect(newMission.background_url, equals(originalMission.background_url));
      expect(newMission.message, equals(originalMission.message));
    });

    test('getParams方法返回toJson结果', () {
      final mission = StartTimeMissionModel(
        title: '参数测试任务',
        message: '测试getParams方法',
      );

      final params = mission.getParams();
      final json = mission.toJson();

      // 验证getParams返回与toJson相同的结果
      expect(params, equals(json));
    });
  });

  group('CounterMethodChannelManager 测试', () {
    test('parseStartTimeMissionModelList 解析测试', () {
      // 创建测试任务列表
      final missions = [
        StartTimeMissionModel(
          title: '任务1',
          isFinished: false,
          message: '未完成任务1',
        ),
        StartTimeMissionModel(
          title: '任务2',
          isFinished: true,
          message: '已完成任务2',
        ),
        StartTimeMissionModel(
          title: '任务3',
          isFinished: false,
          message: '未完成任务3',
        ),
      ];

      // 获取管理器实例
      final manager = CounterMethodChannelManager.getInstance();

      // 解析任务列表
      final parsedList = manager.parseStartTimeMissionModelList(
        listMissionModels: missions,
      );

      // 验证只返回未完成的任务
      expect(parsedList.length, equals(2));
      expect(parsedList[0]['title'], equals('任务1'));
      expect(parsedList[1]['title'], equals('任务3'));

      // 验证已完成的任务被过滤掉
      expect(parsedList.any((task) => task['title'] == '任务2'), isFalse);
    });

    test('parseStartTimeMissionModelList 空列表测试', () {
      final manager = CounterMethodChannelManager.getInstance();

      final parsedList = manager.parseStartTimeMissionModelList(
        listMissionModels: [],
      );

      expect(parsedList.length, equals(0));
    });

    test('parseStartTimeMissionModelList 空值处理测试', () {
      final missions = [
        StartTimeMissionModel(
          title: '正常任务',
          isFinished: false,
        ),
        StartTimeMissionModel(
          title: '空值任务',
          isFinished: null, // 测试空值处理
        ),
      ];

      final manager = CounterMethodChannelManager.getInstance();

      final parsedList = manager.parseStartTimeMissionModelList(
        listMissionModels: missions,
      );

      // 验证空值被正确处理
      expect(parsedList.length, equals(1));
      expect(parsedList[0]['title'], equals('正常任务'));
    });
  });

  group('数据透传集成测试', () {
    test('完整的StartTimeMission数据流测试', () {
      // 1. 创建任务数据
      final missions = [
        StartTimeMissionModel(
          title: '集成测试任务1',
          time_format: 'HH:mm',
          device_id: 'integration_test_device',
          start_time: DateTime.now().millisecondsSinceEpoch,
          finish_time:
              DateTime.now().add(Duration(hours: 1)).millisecondsSinceEpoch,
          isFinished: false,
          uid: 'integration_test_user',
          background_url: 'https://example.com/integration1.jpg',
          message: '集成测试任务1的描述',
        ),
        StartTimeMissionModel(
          title: '集成测试任务2',
          time_format: 'MM-dd',
          device_id: 'integration_test_device',
          start_time:
              DateTime.now().add(Duration(hours: 2)).millisecondsSinceEpoch,
          finish_time:
              DateTime.now().add(Duration(hours: 3)).millisecondsSinceEpoch,
          isFinished: false,
          uid: 'integration_test_user',
          background_url: 'https://example.com/integration2.jpg',
          message: '集成测试任务2的描述',
        ),
      ];

      // 2. 验证数据完整性
      expect(missions.length, equals(2));
      expect(missions[0].title, equals('集成测试任务1'));
      expect(missions[1].title, equals('集成测试任务2'));
      expect(missions.every((task) => task.isFinished == false), isTrue);

      // 3. 测试JSON序列化
      final jsonList = missions.map((task) => task.toJson()).toList();
      expect(jsonList.length, equals(2));
      expect(jsonList[0]['title'], equals('集成测试任务1'));
      expect(jsonList[1]['title'], equals('集成测试任务2'));

      // 4. 测试数据解析
      final manager = CounterMethodChannelManager.getInstance();
      final parsedList = manager.parseStartTimeMissionModelList(
        listMissionModels: missions,
      );

      expect(parsedList.length, equals(2));
      expect(parsedList[0]['title'], equals('集成测试任务1'));
      expect(parsedList[1]['title'], equals('集成测试任务2'));

      // 5. 验证数据字段完整性
      for (int i = 0; i < parsedList.length; i++) {
        final parsed = parsedList[i];
        final original = missions[i];

        expect(parsed['title'], equals(original.title));
        expect(parsed['time_format'], equals(original.time_format));
        expect(parsed['device_id'], equals(original.device_id));
        expect(parsed['start_time'], equals(original.start_time));
        expect(parsed['finish_time'], equals(original.finish_time));
        expect(parsed['isFinished'], equals(original.isFinished));
        expect(parsed['uid'], equals(original.uid));
        expect(parsed['background_url'], equals(original.background_url));
        expect(parsed['message'], equals(original.message));
      }
    });
  });
}
