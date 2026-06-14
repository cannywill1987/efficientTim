import 'dart:convert';

import 'continue_history_store.dart';

class ContinueHistoryMemoryManager implements ContinueHistoryStore {
  ContinueHistoryMemoryManager._();

  static ContinueHistoryMemoryManager? _instance;

  static ContinueHistoryMemoryManager getInstance() {
    _instance ??= ContinueHistoryMemoryManager._();
    return _instance!;
  }

  final Map<String, Map<String, Object?>> _sessions =
      <String, Map<String, Object?>>{};

  @override
  Future<void> init() async {}

  @override
  Future<List<Map<String, Object?>>> list({
    int? limit,
    int? offset,
    String? workspaceDirectory,
  }) async {
    var items = _sessions.values.toList(growable: false);

    if (workspaceDirectory != null && workspaceDirectory.isNotEmpty) {
      final normalized = workspaceDirectory.toLowerCase();
      items = items.where((session) {
        final workspace = (session['workspaceDirectory'] as String?) ?? '';
        return workspace.toLowerCase() == normalized;
      }).toList(growable: false);
    }

    items.sort((a, b) {
      final aDate = DateTime.tryParse((a['dateCreated'] as String?) ?? '') ??
          DateTime.fromMillisecondsSinceEpoch(0, isUtc: true);
      final bDate = DateTime.tryParse((b['dateCreated'] as String?) ?? '') ??
          DateTime.fromMillisecondsSinceEpoch(0, isUtc: true);
      return bDate.compareTo(aDate);
    });

    final start = offset == null || offset < 0 ? 0 : offset;
    final end = limit == null || limit < 0
        ? items.length
        : (start + limit > items.length ? items.length : start + limit);
    if (start >= items.length) {
      return const <Map<String, Object?>>[];
    }

    return items
        .sublist(start, end)
        .map((session) => <String, Object?>{
              'sessionId': session['sessionId'],
              'title': session['title'],
              'dateCreated': session['dateCreated'],
              'workspaceDirectory': session['workspaceDirectory'],
              'messageCount': session['messageCount'],
            })
        .toList(growable: false);
  }

  @override
  Future<Map<String, Object?>> load(String sessionId) async {
    final session = _sessions[sessionId];
    if (session == null) {
      return <String, Object?>{
        'sessionId': sessionId,
        'title': 'New Session',
        'workspaceDirectory': '',
        'history': const <Object?>[],
      };
    }
    return _deepCopy(session);
  }

  @override
  Future<Map<String, Object?>> loadRemote(String remoteId) async {
    return <String, Object?>{
      'sessionId': remoteId,
      'title': 'Remote Session',
      'workspaceDirectory': '',
      'history': const <Object?>[],
    };
  }

  @override
  Future<void> save(Map<String, Object?> session) async {
    final sessionId = session['sessionId'] as String?;
    if (sessionId == null || sessionId.isEmpty) {
      throw ArgumentError('history/save requires a non-empty sessionId.');
    }

    final history = _sessionHistory(session);
    final existing = _sessions[sessionId];
    final dateCreated = (existing?['dateCreated'] as String?) ??
        (session['dateCreated'] as String?) ??
        DateTime.now().toUtc().toIso8601String();

    _sessions[sessionId] = <String, Object?>{
      'sessionId': sessionId,
      'title': (session['title'] as String?) ?? 'New Session',
      'workspaceDirectory': (session['workspaceDirectory'] as String?) ?? '',
      'dateCreated': dateCreated,
      'messageCount': history.where((item) {
        if (item is! Map) {
          return false;
        }
        final message = item['message'];
        return message is Map && message['role'] == 'assistant';
      }).length,
      'history': _normalizeJsonValue(history),
    };
  }

  @override
  Future<void> delete(String sessionId) async {
    _sessions.remove(sessionId);
  }

  @override
  Future<void> clear() async {
    _sessions.clear();
  }

  List<Object?> _sessionHistory(Map<String, Object?> session) {
    final history = session['history'];
    if (history is List<Object?>) {
      return history;
    }
    if (history is List) {
      return history.cast<Object?>();
    }
    return const <Object?>[];
  }

  Map<String, Object?> _deepCopy(Map<String, Object?> source) {
    final encoded = jsonEncode(_normalizeJsonValue(source));
    return (jsonDecode(encoded) as Map).cast<String, Object?>();
  }

  Object? _normalizeJsonValue(Object? value) {
    if (value is Map) {
      return value.map<String, Object?>(
        (key, nestedValue) => MapEntry('$key', _normalizeJsonValue(nestedValue)),
      );
    }
    if (value is List) {
      return value.map(_normalizeJsonValue).toList(growable: false);
    }
    return value;
  }
}
