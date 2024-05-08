class Perf {
  final Stopwatch _stopwatch = Stopwatch();

  void start() {
    _stopwatch.start();
  }

  void stop() {
    if (_stopwatch.isRunning) {
      _stopwatch.stop();
      // print('Elapsed milliseconds 11111111111111111: ${_stopwatch.elapsedMilliseconds}');
      _stopwatch.reset();
    } else {
      print('Stopwatch has not been started.');
    }
  }
}