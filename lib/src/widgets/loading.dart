import 'package:flutter/material.dart';
import 'package:snacknload/src/utility/snacknload_container.dart';
import 'package:snacknload/src/widgets/overlay_entry.dart';

class LoadingWidget extends StatefulWidget {
  final Widget? child;

  const LoadingWidget({
    super.key,
    required this.child,
  })  : assert(child != null);

  @override
  LoadingWidgetState createState() => LoadingWidgetState();
}

class LoadingWidgetState extends State<LoadingWidget> {
  late SnackNLoadOverlayEntry _overlayEntry;

  @override
  void initState() {
    super.initState();
    _overlayEntry = SnackNLoadOverlayEntry(
      builder: (BuildContext context) => SnackNLoad.instance.w ?? Container(),
    );
    SnackNLoad.instance.overlayEntry = _overlayEntry;
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Overlay(
        initialEntries: [
          SnackNLoadOverlayEntry(
            builder: (BuildContext context) {
              if (widget.child != null) {
                return widget.child!;
              } else {
                return Container();
              }
            },
          ),
          _overlayEntry,
        ],
      ),
    );
  }
}
