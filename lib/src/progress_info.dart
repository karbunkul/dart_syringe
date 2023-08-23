enum ProgressPhase { init, done }

final class ProgressInfo {
  final int total;
  final int current;
  final Type type;
  final bool export;
  final ProgressPhase phase;

  ProgressInfo({
    required this.total,
    required this.current,
    required this.type,
    required this.phase,
    required this.export,
  });

  bool get isDone => total == current;

  int get percent => 100 * current ~/ total;

  ProgressInfo copyWith({int? current, Type? type, ProgressPhase? phase}) {
    return ProgressInfo(
      total: total,
      export: export,
      current: current ?? this.current,
      type: type ?? this.type,
      phase: phase ?? this.phase,
    );
  }
}
