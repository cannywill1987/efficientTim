import 'dart:convert';

/// OCR 文本清洗服务（MVP 规则版）。
///
/// 处理流程：
/// 1. 行切分 + 去空白
/// 2. 过滤按钮词/系统词/时间日期分隔行
/// 3. 启发式合并断行
/// 4. 连续重复去重
/// 5. 截断最近 N 条
class ParseService {
  /// 微信界面常见功能词、系统提示词。
  static final List<String> _keywordFilters = <String>[
    '发送',
    '语音',
    '表情',
    '更多',
    '转账',
    '红包',
    '相册',
    '拍摄',
    '位置',
    '名片',
    '文件',
    '已读',
    '未读',
    '对方正在输入',
    '撤回了一条消息',
    '你已添加了',
    '通过了你的好友验证',
  ];

  /// 纯时间行，如 `12:30`。
  static final RegExp _timeOnlyRegExp = RegExp(r'^\d{1,2}:\d{2}$');

  /// 日期分割行，如 `2026-02-18 ...`。
  static final RegExp _dateLineRegExp =
      RegExp(r'^\d{4}[-/.]\d{1,2}[-/.]\d{1,2}.*$');

  /// 简化版“新消息开头”检测（中文/英文字符开头）。
  static final RegExp _newMsgHeadRegExp = RegExp(r'^[\u4e00-\u9fa5A-Za-z]');

  /// 去重时用到的标点过滤。
  static final RegExp _punctuationRegExp =
      RegExp("[，。！？、,.!?~\"'()\\[\\]{}<>《》【】“”‘’：:；;]");

  /// 执行清洗并返回“从旧到新”的最近消息列表。
  List<String> clean(String rawText, {int maxTurns = 12}) {
    if (rawText.trim().isEmpty) {
      return <String>[];
    }

    // 第 1 步：标准化空白并按行切分。
    final List<String> lines = rawText
        .split(RegExp(r'\r?\n'))
        .map((String e) => _normalizeSpaces(e))
        .where((String e) => e.isNotEmpty)
        .toList();

    // 第 2 步：过滤明显噪声行。
    final List<String> filtered = lines.where((String line) {
      if (_timeOnlyRegExp.hasMatch(line)) {
        return false;
      }
      if (_dateLineRegExp.hasMatch(line)) {
        return false;
      }
      for (final String k in _keywordFilters) {
        if (line.contains(k)) {
          return false;
        }
      }
      return true;
    }).toList();

    // 第 3 步：启发式合并断行，尽量把同一条消息拼回去。
    final List<String> merged = <String>[];
    for (final String line in filtered) {
      if (merged.isEmpty) {
        merged.add(line);
        continue;
      }

      if (_isLikelyNewMessageStart(line)) {
        merged.add(line);
      } else {
        merged[merged.length - 1] = '${merged.last}$line';
      }
    }

    // 第 4 步：仅去掉“连续重复”，避免误伤历史复读。
    final List<String> deduped = <String>[];
    String? prevHash;
    for (final String msg in merged) {
      final String normalized = _normalizeForDedup(msg);
      final String curHash = base64Encode(utf8.encode(normalized));
      if (curHash == prevHash) {
        continue;
      }
      deduped.add(msg);
      prevHash = curHash;
    }

    // 第 5 步：只保留最近 maxTurns 条。
    if (deduped.length <= maxTurns) {
      return deduped;
    }
    return deduped.sublist(deduped.length - maxTurns);
  }

  /// 断行是否更像一条“新消息”的开头。
  ///
  /// 当前规则偏保守：
  /// - 太短（<=2）不认为是新开头
  /// - 标点/emoji 开头不认为是新开头
  /// - 长度较长且中英文字符开头时认为是新开头
  bool _isLikelyNewMessageStart(String line) {
    if (line.isEmpty) {
      return false;
    }
    if (line.length <= 2) {
      return false;
    }

    final int first = line.runes.first;
    if (_isPunctuationOrEmoji(first)) {
      return false;
    }

    return line.length > 18 && _newMsgHeadRegExp.hasMatch(line);
  }

  /// 判断首字符是否标点或 emoji。
  bool _isPunctuationOrEmoji(int rune) {
    if ((rune >= 0x1F300 && rune <= 0x1FAFF) ||
        (rune >= 0x2600 && rune <= 0x27BF)) {
      return true;
    }
    const String punctuation = '，。！？、,.!?~"\'()[]{}<>《》【】“”‘’：:；;';
    return punctuation.runes.contains(rune);
  }

  /// 把连续空白折叠成一个空格。
  String _normalizeSpaces(String input) {
    return input.replaceAll(RegExp(r'\s+'), ' ').trim();
  }

  /// 用于去重的归一化：小写 + 去空白 + 去标点。
  String _normalizeForDedup(String input) {
    return input
        .toLowerCase()
        .replaceAll(RegExp(r'\s+'), '')
        .replaceAll(_punctuationRegExp, '');
  }
}
