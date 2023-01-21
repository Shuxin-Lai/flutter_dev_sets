import 'dart:async';

typedef Resolver<T> = void Function(T value);
typedef Rejector = void Function(Object reason);

typedef Executor<T> = void Function(
    {required Resolver<T> resolve, required Rejector reject});

class WFutureUtils {
  static bool isFuture(dynamic v) {
    return v is Future;
  }

  static bool isNotFuture(dynamic v) {
    return isFuture(v) == false;
  }

  static Future<T> createFuture<T>(Executor<T> executor) {
    final c = Completer<T>();
    return Future(() {
      try {
        executor(resolve: (value) {
          if (c.isCompleted == false) {
            c.complete(value);
          }
        }, reject: (reason) {
          if (c.isCompleted == false) {
            c.completeError(reason);
          }
        });
      } catch (err) {
        if (c.isCompleted == false) {
          c.completeError(err);
        }
      }

      return c.future;
    });
  }
}
