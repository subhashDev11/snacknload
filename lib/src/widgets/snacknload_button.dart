import 'package:flutter/material.dart';

class SnackNLoadButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final ButtonVariant variant;
  final ButtonSize size;
  final bool disabled;
  final IconData? icon;
  final bool fullWidth;

  const SnackNLoadButton({
    super.key,
    required this.text,
    this.onPressed,
    this.variant = ButtonVariant.primary,
    this.size = ButtonSize.medium,
    this.disabled = false,
    this.icon,
    this.fullWidth = false,
    bool? isLoading,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    Color backgroundColor;
    Color textColor;
    Color borderColor;

    switch (variant) {
      case ButtonVariant.primary:
        backgroundColor = disabled
            ? colorScheme.primary.withOpacity(0.5)
            : colorScheme.primary;
        textColor = colorScheme.onPrimary;
        borderColor = Colors.transparent;
        break;
      case ButtonVariant.secondary:
        backgroundColor = disabled
            ? colorScheme.secondary.withOpacity(0.5)
            : colorScheme.secondary;
        textColor = colorScheme.onSecondary;
        borderColor = Colors.transparent;
        break;
      case ButtonVariant.outline:
        backgroundColor = Colors.transparent;
        textColor = disabled ? theme.disabledColor : theme.primaryColor;
        borderColor = disabled ? theme.disabledColor : theme.primaryColor;
        break;
      case ButtonVariant.danger:
        backgroundColor = disabled ? Colors.red.withOpacity(0.5) : Colors.red;
        textColor = Colors.white;
        borderColor = Colors.transparent;
        break;
      case ButtonVariant.ghost:
        backgroundColor = Colors.transparent;
        textColor = disabled ? theme.disabledColor : theme.primaryColor;
        borderColor = Colors.transparent;
        break;
    }

    double padding;
    double fontSize;

    switch (size) {
      case ButtonSize.small:
        padding = 8;
        fontSize = 12;
        break;
      case ButtonSize.medium:
        padding = 12;
        fontSize = 14;
        break;
      case ButtonSize.large:
        padding = 16;
        fontSize = 16;
        break;
    }

    return SizedBox(
      width: fullWidth ? double.infinity : null,
      child: ElevatedButton(
        onPressed: disabled ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          foregroundColor: textColor,
          padding: EdgeInsets.symmetric(
            horizontal: padding * 1.5,
            vertical: padding,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
            side: BorderSide(color: borderColor),
          ),
          elevation: variant == ButtonVariant.ghost ? 0 : 2,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null)
              Padding(
                padding: const EdgeInsets.only(right: 8),
                child: Icon(icon, size: fontSize + 2),
              ),
            Text(
              text,
              style: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

enum ButtonVariant { primary, secondary, outline, danger, ghost }

enum ButtonSize { small, medium, large }
