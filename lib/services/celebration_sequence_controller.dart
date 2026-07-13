class CelebrationSequenceController<T> {
  final List<_QueuedCelebration<T>> _queue = <_QueuedCelebration<T>>[];
  final Set<String> _queuedKeys = <String>{};
  bool _isDraining = false;

  void enqueue(T item, {String? dedupeKey}) {
    if (dedupeKey != null && _queuedKeys.contains(dedupeKey)) {
      return;
    }
    _queue.add(_QueuedCelebration(item: item, dedupeKey: dedupeKey));
    if (dedupeKey != null) {
      _queuedKeys.add(dedupeKey);
    }
  }

  bool get hasItems => _queue.isNotEmpty;

  Future<void> drain(Future<void> Function(T item) handler) async {
    if (_isDraining) return;
    _isDraining = true;
    try {
      while (_queue.isNotEmpty) {
        final next = _queue.removeAt(0);
        await handler(next.item);
        final dedupeKey = next.dedupeKey;
        if (dedupeKey != null) {
          _queuedKeys.remove(dedupeKey);
        }
      }
    } finally {
      _isDraining = false;
    }
  }
}

class _QueuedCelebration<T> {
  final T item;
  final String? dedupeKey;

  const _QueuedCelebration({required this.item, required this.dedupeKey});
}
