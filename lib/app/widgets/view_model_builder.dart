import 'package:flutter/widgets.dart';

class ViewModelBuilder<T extends ChangeNotifier> extends StatefulWidget {
  const ViewModelBuilder({
    super.key,
    required this.create,
    required this.builder,
    this.dispose,
  });

  final T Function() create;
  final Widget Function(BuildContext context, T viewModel) builder;
  final void Function(T viewModel)? dispose;

  @override
  State<ViewModelBuilder<T>> createState() => _ViewModelBuilderState<T>();
}

class _ViewModelBuilderState<T extends ChangeNotifier>
    extends State<ViewModelBuilder<T>> {
  late T _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = widget.create();
    _viewModel.addListener(_listener);
  }

  void _listener() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(context, _viewModel);
  }

  @override
  void dispose() {
    _viewModel.removeListener(_listener);
    widget.dispose?.call(_viewModel);
    _viewModel.dispose();
    super.dispose();
  }
}
