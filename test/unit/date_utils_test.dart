import 'package:flutter_test/flutter_test.dart';
import 'package:appointment_booking_app/core/utils/date_utils.dart';

void main() {
  group('AppDateUtils Tests', () {
    test('should format date correctly', () {
      final date = DateTime(2024, 1, 15);
      final result = AppDateUtils.formatDate(date);
      expect(result, 'Jan 15, 2024');
    });

    test('should format time correctly', () {
      final time = DateTime(2024, 1, 15, 14, 30);
      final result = AppDateUtils.formatTime(time);
      expect(result, '2:30 PM');
    });

    test('should format date time correctly', () {
      final dateTime = DateTime(2024, 1, 15, 14, 30);
      final result = AppDateUtils.formatDateTime(dateTime);
      expect(result, 'Jan 15, 2024 2:30 PM');
    });

    test('should format duration correctly', () {
      expect(AppDateUtils.formatDuration(const Duration(minutes: 30)), '30m');
      expect(AppDateUtils.formatDuration(const Duration(hours: 1)), '1h');
      expect(AppDateUtils.formatDuration(const Duration(hours: 1, minutes: 30)), '1h 30m');
      expect(AppDateUtils.formatDuration(const Duration(hours: 2)), '2h');
      expect(AppDateUtils.formatDuration(const Duration(hours: 2, minutes: 15)), '2h 15m');
    });

    test('should get relative date for today', () {
      final today = DateTime.now();
      final result = AppDateUtils.getRelativeDate(today);
      expect(result, 'Today');
    });

    test('should get relative date for tomorrow', () {
      final tomorrow = DateTime.now().add(const Duration(days: 1));
      final result = AppDateUtils.getRelativeDate(tomorrow);
      expect(result, 'Tomorrow');
    });

    test('should get relative date for yesterday', () {
      final yesterday = DateTime.now().subtract(const Duration(days: 1));
      final result = AppDateUtils.getRelativeDate(yesterday);
      expect(result, 'Yesterday');
    });

    test('should get formatted date for other dates', () {
      final date = DateTime(2024, 1, 15);
      final result = AppDateUtils.getRelativeDate(date);
      expect(result, 'Jan 15, 2024');
    });

    test('should check if date is same day', () {
      final date1 = DateTime(2024, 1, 15, 10, 0);
      final date2 = DateTime(2024, 1, 15, 14, 30);
      final date3 = DateTime(2024, 1, 16, 10, 0);

      expect(AppDateUtils.isSameDay(date1, date2), true);
      expect(AppDateUtils.isSameDay(date1, date3), false);
    });

    test('should check if date is today', () {
      final today = DateTime.now();
      final yesterday = DateTime.now().subtract(const Duration(days: 1));

      expect(AppDateUtils.isToday(today), true);
      expect(AppDateUtils.isToday(yesterday), false);
    });

    test('should check if date is in past', () {
      final past = DateTime.now().subtract(const Duration(hours: 1));
      final future = DateTime.now().add(const Duration(hours: 1));

      expect(past.isBefore(DateTime.now()), true);
      expect(future.isBefore(DateTime.now()), false);
    });

    test('should get start of day', () {
      final dateTime = DateTime(2024, 1, 15, 14, 30, 45);
      final result = AppDateUtils.startOfDay(dateTime);
      
      expect(result.year, 2024);
      expect(result.month, 1);
      expect(result.day, 15);
      expect(result.hour, 0);
      expect(result.minute, 0);
      expect(result.second, 0);
      expect(result.millisecond, 0);
    });

    test('should get end of day', () {
      final dateTime = DateTime(2024, 1, 15, 14, 30, 45);
      final result = AppDateUtils.endOfDay(dateTime);
      
      expect(result.year, 2024);
      expect(result.month, 1);
      expect(result.day, 15);
      expect(result.hour, 23);
      expect(result.minute, 59);
      expect(result.second, 59);
      expect(result.millisecond, 999);
    });
  });
}