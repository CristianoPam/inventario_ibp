import 'package:flutter/material.dart';
import 'package:inventario_ibp/sm/statex.dart';


class StateXWidget<T extends StateX, StateXType> extends StatelessWidget {
  final T state;
  final Widget Function(StateXType) builder;
  final Widget Function(StateXType)? onClose;
  final Widget Function(dynamic)? onError;

  const StateXWidget({
    required this.state,
    required this.builder,
    this.onClose,
    this.onError,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      initialData: state.state,
      stream: state.stream,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return onError?.call(snapshot.error) ?? const SizedBox.shrink();
        }
        if (snapshot.hasData) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
            case ConnectionState.active:
              return builder(snapshot.data as StateXType);
            case ConnectionState.done:
              return onClose?.call(snapshot.data as StateXType) ?? const SizedBox.shrink();
          }
        }
        return const SizedBox.shrink();
      },
    );
  }
}
