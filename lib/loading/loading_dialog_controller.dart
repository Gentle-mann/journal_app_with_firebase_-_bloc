typedef CloseLoadingDialog = bool Function();
typedef UpdateLoadingDialog = bool Function(String text);

class LoadingDialogController {
  final CloseLoadingDialog close;
  final UpdateLoadingDialog update;

  LoadingDialogController({required this.close, required this.update});
}
