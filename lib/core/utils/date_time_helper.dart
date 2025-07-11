import 'package:intl/intl.dart';

/// 統一的時間處理工具類
class DateTimeHelper {
  // 私有建構子，防止實例化
  DateTimeHelper._();

  /// 格式化常數
  static const String _defaultDateFormat = 'yyyy-MM-dd';
  static const String _defaultDateTimeFormat = 'yyyy-MM-dd HH:mm';
  static const String _displayDateFormat = 'yyyy年MM月dd日';

  /// 獲取當前時間
  static DateTime get now => DateTime.now();

  /// 獲取今天的開始時間 (00:00:00)
  static DateTime get todayStart {
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day);
  }

  /// 獲取今天的結束時間 (23:59:59)
  static DateTime get todayEnd {
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day, 23, 59, 59);
  }

  /// 毫秒時間戳轉DateTime
  static DateTime fromMilliseconds(int milliseconds) {
    return DateTime.fromMillisecondsSinceEpoch(milliseconds);
  }

  /// 秒時間戳轉DateTime
  static DateTime fromSeconds(int seconds) {
    return DateTime.fromMillisecondsSinceEpoch(seconds * 1000);
  }

  /// DateTime轉毫秒時間戳
  static int toMilliseconds(DateTime dateTime) {
    return dateTime.millisecondsSinceEpoch;
  }

  /// DateTime轉秒時間戳
  static int toSeconds(DateTime dateTime) {
    return dateTime.millisecondsSinceEpoch ~/ 1000;
  }

  /// 格式化日期 (yyyy-MM-dd)
  static String formatDate(DateTime dateTime) {
    return DateFormat(_defaultDateFormat).format(dateTime);
  }

  /// 格式化日期時間 (yyyy-MM-dd HH:mm)
  static String formatDateTime(DateTime dateTime) {
    return DateFormat(_defaultDateTimeFormat).format(dateTime);
  }

  /// 格式化顯示日期 (yyyy年MM月dd日)
  static String formatDisplayDate(DateTime dateTime) {
    return DateFormat(_displayDateFormat).format(dateTime);
  }

  /// 自定義格式化
  static String formatCustom(DateTime dateTime, String pattern) {
    return DateFormat(pattern).format(dateTime);
  }

  /// 毫秒時間戳格式化為日期
  static String formatMillisecondsToDate(int milliseconds) {
    return formatDate(fromMilliseconds(milliseconds));
  }

  /// 毫秒時間戳格式化為日期時間
  static String formatMillisecondsToDateTime(int milliseconds) {
    return formatDateTime(fromMilliseconds(milliseconds));
  }

  /// 秒時間戳格式化為日期時間
  static String formatSecondsToDateTime(int seconds) {
    return formatDateTime(fromSeconds(seconds));
  }

  /// 檢查是否過期
  static bool isExpired(int expiryMilliseconds) {
    return now.millisecondsSinceEpoch > expiryMilliseconds;
  }

  /// 檢查是否在指定天數內過期
  static bool isExpiringWithinDays(int expiryMilliseconds, int days) {
    final expiryDate = fromMilliseconds(expiryMilliseconds);
    final checkDate = now.add(Duration(days: days));
    return expiryDate.isBefore(checkDate) || expiryDate.isAtSameMomentAs(checkDate);
  }

  /// 計算距離過期的天數
  static int daysUntilExpiry(int expiryMilliseconds) {
    final expiryDate = fromMilliseconds(expiryMilliseconds);
    final difference = expiryDate.difference(todayStart).inDays;
    return difference;
  }

  /// 計算過期了多少天
  static int daysExpired(int expiryMilliseconds) {
    final expiryDate = fromMilliseconds(expiryMilliseconds);
    final difference = todayStart.difference(expiryDate).inDays;
    return difference;
  }

  /// 獲取過期狀態描述
  static String getExpiryStatus(int expiryMilliseconds) {
    if (isExpired(expiryMilliseconds)) {
      final days = daysExpired(expiryMilliseconds);
      return days == 0 ? '今天過期' : '過期 $days 天';
    } else {
      final days = daysUntilExpiry(expiryMilliseconds);
      return days == 0 ? '今天到期' : '$days 天後到期';
    }
  }

  /// 創建指定日期的開始時間
  static DateTime startOfDay(DateTime dateTime) {
    return DateTime(dateTime.year, dateTime.month, dateTime.day);
  }

  /// 創建指定日期的結束時間
  static DateTime endOfDay(DateTime dateTime) {
    return DateTime(dateTime.year, dateTime.month, dateTime.day, 23, 59, 59);
  }

  /// 創建通知時間 (指定日期的9:00)
  static DateTime createNotificationTime(DateTime date) {
    return DateTime(date.year, date.month, date.day, 9, 0, 0);
  }
}