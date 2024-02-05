import 'dart:async';

import 'package:firebase_journal_app_with_bloc/loading/loading_dialog_controller.dart';
import 'package:flutter/material.dart';

class LoadingDialog {
  LoadingDialog._sharedInstance();
  static final LoadingDialog _shared = LoadingDialog._sharedInstance();
  factory LoadingDialog.instance() => _shared;

  LoadingDialogController? _controller;

  void showOverlayDialog(
      {required BuildContext context, required String message}) {
    if (_controller?.update(message) ?? false) {
      return;
    } else {
      _controller = _showOverLay(
        context: context,
        message: message,
      );
    }
  }

  void hideDialog() {
    _controller?.close();
    _controller = null;
  }

  LoadingDialogController _showOverLay({
    required BuildContext context,
    required String message,
  }) {
    final message0 = StreamController<String>();
    message0.add(message);
    final state = Overlay.of(context);
    final size = MediaQuery.of(context).size;
    final entry = OverlayEntry(builder: (context) {
      return Material(
        color: Colors.black54,
        child: Center(
          child: Container(
            padding: const EdgeInsets.all(16),
            constraints: BoxConstraints(
              maxHeight: size.height * 0.5,
              maxWidth: size.width * 0.8,
              minWidth: size.width * 0.5,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
            ),
            child: SingleChildScrollView(
                child: Column(
              children: [
                const CircularProgressIndicator(),
                const SizedBox(
                  height: 20,
                ),
                StreamBuilder(
                  stream: message0.stream,
                  builder: ((context, snapshot) {
                    if (snapshot.hasData) {
                      return Text(snapshot.data!);
                    } else {
                      return const SizedBox.shrink();
                    }
                  }),
                ),
              ],
            )),
          ),
        ),
      );
    });
    state.insert(entry);
    return LoadingDialogController(
      close: () {
        message0.close();
        entry.remove();
        return true;
      },
      update: (message) {
        message0.add(message);
        return true;
      },
    );
  }
}
