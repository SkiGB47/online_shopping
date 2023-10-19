import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';

class CustomDialog extends StatelessWidget {
  final String? title, content, textConfirm, textCancel;
  final bool success, closeAvatar, buttonConfirm, buttonCancel, exclamation;
  final VoidCallback? onPressedConfirm, onPressedCancel;
  final Widget? multiplyWidget, contentWidget;
  final double titleSize;

  const CustomDialog({
    Key? key,
    this.title,
    this.titleSize = 20,
    this.content,
    this.success = true,
    this.closeAvatar = false,
    this.buttonConfirm = true,
    this.buttonCancel = false,
    this.exclamation = false,
    this.textConfirm,
    this.textCancel,
    this.onPressedConfirm,
    this.onPressedCancel,
    this.multiplyWidget,
    this.contentWidget,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: _buildDialogContent(context),
    );
  }

  Widget _buildDialogContent(BuildContext context) {
    return Stack(alignment: Alignment.topCenter, children: [
      Container(
        margin: const EdgeInsets.only(top: 30, left: 10, right: 10),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
        padding: EdgeInsets.fromLTRB(20, (closeAvatar == true) ? 20 : 40, 20, 20),
        child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
          Column(children: [
            Text(
              title ?? '',
              style: TextStyle(fontSize: titleSize),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 5),
            if (multiplyWidget == null)
              if (content != null)
                Text(
                  content ?? '',
                  style: const TextStyle(color: Colors.grey, fontSize: 16),
                  textAlign: TextAlign.center,
                ),
            if (contentWidget != null)
              Container(
                child: contentWidget,
              )
          ]),
          if (multiplyWidget != null) multiplyWidget!,
          const SizedBox(height: 20),
          Row(
            children: [
              if (buttonConfirm)
                Expanded(
                  child: MaterialButton(
                    minWidth: double.infinity,
                    color: Colors.orange,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                      side: const BorderSide(color: Colors.orange),
                    ),
                    onPressed: onPressedConfirm ?? () => Navigator.pop(context),
                    child: Text(
                      textConfirm ?? 'Confirm'.tr,
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              if (buttonConfirm)
                const SizedBox(
                  width: 8,
                ),
              if (buttonCancel)
                Expanded(
                  child: MaterialButton(
                    minWidth: double.infinity,
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                      side: const BorderSide(color: Colors.orange),
                    ),
                    onPressed: onPressedCancel ?? () => Navigator.pop(context),
                    child: Text(
                      textCancel ?? "Cancel".tr,
                      style: const TextStyle(color: Colors.orange),
                    ),
                  ),
                ),
            ],
          ),
        ]),
      ),
      if (!closeAvatar)
        success
            ? const CircleAvatar(
                maxRadius: 32,
                backgroundColor: Colors.white,
                child: Icon(
                  Icons.check_circle,
                  size: 48,
                  color: Colors.green,
                ),
              )
            : exclamation
                ? const CircleAvatar(
                    maxRadius: 32,
                    backgroundColor: Colors.white,
                    child: Icon(
                      Icons.warning_rounded,
                      size: 48,
                      color: Colors.orange,
                    ),
                  )
                : CircleAvatar(
                    maxRadius: 32,
                    backgroundColor: Colors.white,
                    child: Image.asset(
                      'assets/images/Close.png',
                      height: 48,
                      width: 48,
                    ),
                  ),
    ]);
  }
}
