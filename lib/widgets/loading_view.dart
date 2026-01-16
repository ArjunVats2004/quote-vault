import 'package:flutter/material.dart';

class LoadingView extends StatelessWidget {
  final String? message;
  final bool fullscreen;

  const LoadingView({
    super.key,
    this.message,
    this.fullscreen = true,
  });

  @override
  Widget build(BuildContext context) {
    final content = Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const CircularProgressIndicator(),
        if (message != null) ...[
          const SizedBox(height: 16),
          Text(
            message!,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ],
    );

    if (fullscreen) {
      return Scaffold(
        body: Center(child: content),
      );
    } else {
      return Center(child: content);
    }
  }
}
