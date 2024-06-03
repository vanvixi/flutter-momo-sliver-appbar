import 'dart:async';

class Debounce {
  Debounce({this.ms = 500});

  final int ms; // milliseconds
  Timer? _time;

  void run(void Function() action) {
    if (_time?.isActive ?? false) _time?.cancel();
    _time = Timer(Duration(milliseconds: ms), action);
  }

  void dispose() => _time?.cancel();
}
