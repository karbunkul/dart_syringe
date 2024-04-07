import 'package:meta/meta.dart';

/// Enum representing the phases of progress.
enum ProgressPhase {
  /// Initialization phase.
  init,

  /// Done phase.
  done
}

/// Immutable class representing information about progress.
@immutable
class ProgressInfo {
  /// Total count of progress steps.
  final int total;

  /// Current progress step.
  final int current;

  /// Type of progress.
  final Type type;

  /// Whether the progress is for exporting.
  final bool export;

  /// Current phase of progress.
  final ProgressPhase phase;

  /// Constructor for ProgressInfo.
  const ProgressInfo({
    required this.total,
    required this.current,
    required this.type,
    required this.phase,
    required this.export,
  });

  /// Returns true if progress is completed.
  bool get isDone => total == current;

  /// Returns the percentage of progress completed.
  int get percent => 100 * current ~/ total;

  /// Returns a copy of ProgressInfo with optional parameters updated.
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
