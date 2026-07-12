import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hable/database/database.dart';
import 'package:hable/theme/app_theme.dart';
import 'package:hable/providers/quote_provider.dart';

/// A dynamic typographic splash screen triggered upon final habit completion.
/// It displays a dynamic congratulation message and the 'Quote of the Day'
/// fetched from the daily sync.
class CompletionSplashScreen extends ConsumerStatefulWidget {
  final Habit habit;
  final String? emoji;

  const CompletionSplashScreen({
    super.key,
    required this.habit,
    this.emoji,
  });

  @override
  ConsumerState<CompletionSplashScreen> createState() => _CompletionSplashScreenState();
}

class _CompletionSplashScreenState extends ConsumerState<CompletionSplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  bool _isDismissing = false;
  Timer? _dismissTimer;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
    
    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutBack),
    );

    _controller.forward();

    // Auto dismiss after 4 seconds
    _dismissTimer = Timer(const Duration(seconds: 4), () {
      if (mounted) {
        _dismiss();
      }
    });
  }

  void _dismiss() {
    if (_isDismissing) return;
    setState(() {
      _isDismissing = true;
      // Reassign scale animation to zoom all the way down to 0 on exit
      _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(parent: _controller, curve: Curves.easeInOutBack),
      );
    });
    _controller.reverse().then((_) {
      if (mounted) {
        Navigator.of(context).pop();
      }
    });
  }

  @override
  void dispose() {
    _dismissTimer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final quoteAsync = ref.watch(quoteProvider);

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: GestureDetector(
        onTap: _dismiss,
        behavior: HitTestBehavior.opaque,
        child: Container(
          width: double.infinity,
          height: double.infinity,
          color: AppTheme.sageGreen.withValues(alpha: 0.98),
          child: AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return Opacity(
                opacity: _fadeAnimation.value,
                child: Transform.scale(
                  alignment: _isDismissing ? const Alignment(0.66, 1.0) : Alignment.center,
                  scale: _scaleAnimation.value,
                  child: child,
                ),
              );
            },
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(32.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (widget.emoji != null && widget.emoji!.isNotEmpty)
                      Text(
                        widget.emoji!,
                        style: const TextStyle(fontSize: 80),
                      )
                    else
                      const Icon(Icons.check_circle_rounded, size: 80, color: Colors.white),
                    
                    const SizedBox(height: 24),
                    
                    Text(
                      'Great job!',
                      style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    
                    const SizedBox(height: 12),
                    
                    Text(
                      'You completed ${widget.habit.title} today.',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: Colors.white.withValues(alpha: 0.9),
                      ),
                      textAlign: TextAlign.center,
                    ),
                    
                    const SizedBox(height: 64),
                    
                    // Quote Section
                    quoteAsync.when(
                      data: (quote) => Text(
                        '"$quote"',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: Colors.white,
                          fontStyle: FontStyle.italic,
                          height: 1.6,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      loading: () => const CircularProgressIndicator(color: Colors.white),
                      error: (_, __) => const SizedBox.shrink(),
                    ),
                    
                    const SizedBox(height: 48),
                    
                    Text(
                      'Tap to continue',
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        color: Colors.white.withValues(alpha: 0.6),
                        letterSpacing: 1.2,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
