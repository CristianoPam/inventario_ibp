import 'dart:async';

abstract class StateX<T> {
  late T _state;
  late StreamController<T> _streamController;

  StateX(T initState) {
    _create(initState);
  }

  StateX.autoDispose(T initState) {
    _create(initState);
    _streamController.onCancel = () => close();
  }

  _create(T initState) {
    _streamController = StreamController<T>.broadcast();
    _addToSink(initState);
    init();
  }

  _addToSink(T initState) {
    _state = initState;
    _streamController.sink.add(_state);
  }

  T get state => _state;
  set state(T newState) => _addToSink(newState);

  Stream<T> get stream => _streamController.stream;

  void error(Object err) {
    _streamController.addError(err);
    throw err;
  }

  void close() {
    _streamController.close();
    dispose();
  }

  void init() {}
  void dispose() {}
}
