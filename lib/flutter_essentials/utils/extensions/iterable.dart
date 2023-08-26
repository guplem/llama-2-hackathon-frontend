import "dart:math";

extension IterableExtensions<E> on Iterable<E> {
  E? firstWhereOrNull(bool Function(E) test) {
    for (E element in this) {
      if (test(element)) return element;
    }
    return null;
  }

  E? firstOrNull() {
    for (E element in this) {
      return element;
    }
    return null;
  }

  E? lastOrNull() {
    if (isNotEmpty) {
      return elementAt(length - 1);
    }

    return null;
  }

  E? randomElement() {
    return elementAt(Random().nextInt(length));
  }
}
