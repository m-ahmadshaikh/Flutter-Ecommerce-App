import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'error_message_widget.dart';

class AsyncValueWidget<T> extends StatelessWidget {
  AsyncValueWidget({Key? key, required this.value, required this.data, loading})
      : loading =
            (loading ?? () => const Center(child: CircularProgressIndicator())),
        super(key: key);

  final AsyncValue value;
  final Widget Function(dynamic) data;
  final Widget Function() loading;
  @override
  Widget build(BuildContext context) {
    return value.when(
      data: data,
      error: ((error, stackTrace) {
        return Center(child: ErrorMessageWidget(error.toString()));
      }),
      loading: loading,
    );
  }
}
