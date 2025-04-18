import 'package:habit_tracker/datetime/date_time.dart';
import 'package:mysql1/mysql1.dart';

class HabitDatabases {
  static final HabitDatabases _instance = HabitDatabases._internal();
  factory HabitDatabases() => _instance;
  HabitDatabases._internal();

  List todaysHabitList = [];
  Map<DateTime, int> heatMapDataSet = {};
  late MySqlConnection _connection;

  Future<void> init() async {
    _connection = await MySqlConnection.connect(ConnectionSettings(
        host: '10.0.2.2',
        port: 3306,
        user: 'habits_admin',
        db: 'habits',
        password: 'admin123',
        timeout: Duration(seconds: 3600)));
  }

Future<void> createDefaultData(int userId) async {
  todaysHabitList = [
    ["Read", false],
    ["Run", false],
  ];

  final startDate = todaysDateFormatted();
    print("user id" + userId.toString());

  final checkStartDate = await _connection.query(
    'SELECT 1 FROM start_date WHERE user_id = ? AND date = ?',
    [userId, startDate],
  );
    print(checkStartDate.toString());
  if (checkStartDate.isEmpty) {
    await _connection.query(
      'INSERT INTO start_date (user_id, date) VALUES (?, ?)',
      [userId, startDate],
    );

    for (var habit in todaysHabitList) {
      await _connection.query(
        'INSERT INTO habits (user_id, date, name, completed) VALUES (?, ?, ?, ?)',
        [userId, startDate, habit[0], habit[1] ? 1 : 0],
      );
    }
  }
}

  Future<void> loadData(int userId) async {
    final date = todaysDateFormatted();
    print(userId);
    final result = await _connection.query(
        'SELECT name, completed FROM habits WHERE date = ? AND user_id = ?', [date, userId]);

    if (result.isEmpty) {
      final currentResult = await _connection.query(
          'SELECT DISTINCT name FROM habits WHERE user_id = ? ORDER BY id ASC', [userId]);
      todaysHabitList = currentResult.map((row) => [row[0], false]).toList();
      print("here");
    } else {
      print("here1");
      
      todaysHabitList = result.map((row) => [row[0], row[1] == 1]).toList();
      print(todaysHabitList.toString());
    }
  }

  Future<void> updateDatabase(int userId) async {
    final date = todaysDateFormatted();

    await _connection.query('DELETE FROM habits WHERE date = ? AND user_id = ?', [date, userId]);

    for (var habit in todaysHabitList) {
      await _connection.query(
          'INSERT INTO habits (user_id, date, name, completed) VALUES (?, ?, ?, ?)',
          [userId, date, habit[0], habit[1] ? 1 : 0]);
    }

    await calculateHabitPercentages(userId);
    await loadHeatMap(userId);
  }

Future<void> calculateHabitPercentages(int userId) async {
  int countCompleted = 0;
  for (int i = 0; i < todaysHabitList.length; i++) {
    if (todaysHabitList[i][1] == true) {
      countCompleted++;
    }
  }

  String percent = todaysHabitList.isEmpty
      ? '0.0'
      : (countCompleted / todaysHabitList.length).toStringAsFixed(1);

  final date = todaysDateFormatted();

  final checkResult = await _connection.query(
    'SELECT 1 FROM percentage_summary WHERE user_id = ? AND date = ?',
    [userId, date],
  );

  if (checkResult.isNotEmpty) {
    await _connection.query(
      'UPDATE percentage_summary SET percentage = ? WHERE user_id = ? AND date = ?',
      [percent, userId, date],
    );
  } else {
    await _connection.query(
      'INSERT INTO percentage_summary (user_id, date, percentage) VALUES (?, ?, ?)',
      [userId, date, percent],
    );
  }
}

  Future<void> loadHeatMap(int userId) async {
    final startDateResult = await _connection
        .query('SELECT date FROM start_date WHERE user_id = ?', [userId]);
    if (startDateResult.isEmpty) return;

    final startDateStr = startDateResult.first[0];
    DateTime startDate = createDateTimeObject(startDateStr);
    int daysInBetween = DateTime.now().difference(startDate).inDays;

    for (int i = 0; i <= daysInBetween; i++) {
      DateTime currentDate = startDate.add(Duration(days: i));
      String dateStr = convertDateTimeToString(currentDate);

      final percentResult = await _connection.query(
          'SELECT percentage FROM percentage_summary WHERE date = ? AND user_id = ?',
          [dateStr, userId]);

      double strength = 0.0;
      if (percentResult.isNotEmpty) {
        strength = double.parse(percentResult.first[0].toString());
      }

      int year = currentDate.year;
      int month = currentDate.month;
      int day = currentDate.day;

      final percentForEachDay = <DateTime, int>{
        DateTime(year, month, day): (10 * strength).toInt(),
      };

      heatMapDataSet.addEntries(percentForEachDay.entries);
    }
  }

  Future<bool> register(String username, String email, String password) async {
    try {
      var results = await _connection.query(
        'INSERT INTO users (username, email, password) VALUES (?, ?, ?)',
        [username, email, password],
      );
      return results.affectedRows == 1;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<Map<String, dynamic>?> login(String username, String password) async {
    try {
      var results = await _connection.query(
        'SELECT id, username FROM users WHERE username = ? AND password = ?',
        [username, password],
      );

      if (results.isNotEmpty) {
        final row = results.first;
        return {'id': row['id'], 'username': row['username']};
      } else {
        return null;
      }
    } catch (e) {
      print('Login failed: $e');
      return null;
    }
  }
}
