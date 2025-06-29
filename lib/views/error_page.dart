import 'package:flutter/material.dart';
import 'package:meal_tracker_2/helpers/restart_widget.dart';

/// A simple UI screen that shows when an unexpected app error occurs.
class ErrorPage extends StatelessWidget {
  const ErrorPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Force a finite full‐screen size
    return SizedBox.expand(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Oops — Something broke'),
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.error_outline,
                  size: 80,
                  color: theme.colorScheme.error,
                ),
                const SizedBox(height: 16),
                Text(
                  'An unexpected error occurred.',
                  style: theme.textTheme.titleLarge!
                      .copyWith(color: theme.colorScheme.error),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                ElevatedButton.icon(
                  icon: const Icon(Icons.refresh),
                  label: const Text('Refresh App'),
                  onPressed: () => RestartWidget.restartApp(context),
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(160, 44),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
