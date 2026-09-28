import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const Final60GalleryApp());
}

class Final60GalleryApp extends StatelessWidget {
  const Final60GalleryApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Final60GalleryScreen(),
    );
  }
}

class Final60GalleryScreen extends StatefulWidget {
  const Final60GalleryScreen({super.key});

  @override
  State<Final60GalleryScreen> createState() => _Final60GalleryScreenState();
}

class _Final60GalleryScreenState extends State<Final60GalleryScreen> {
  static const _prefix = 'assets/ui/clean_base_final_60/';

  final PageController _controller = PageController();
  List<String>? _assets;
  Object? _loadError;
  int _index = 0;

  @override
  void initState() {
    super.initState();
    _loadAssets();
  }

  Future<void> _loadAssets() async {
    try {
      final manifest = await AssetManifest.loadFromAssetBundle(rootBundle);
      final assets = manifest
          .listAssets()
          .where((path) => path.startsWith(_prefix) && path.endsWith('.png'))
          .toList()
        ..sort();
      if (!mounted) return;
      setState(() => _assets = assets);
    } catch (error) {
      if (!mounted) return;
      setState(() => _loadError = error);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _go(int delta) {
    final assets = _assets;
    if (assets == null || assets.isEmpty) return;
    final next = (_index + delta).clamp(0, assets.length - 1).toInt();
    _controller.animateToPage(
      next,
      duration: const Duration(milliseconds: 180),
      curve: Curves.easeOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    final assets = _assets;
    if (_loadError != null) {
      return _StatusScreen(
        title: 'FINAL60 LOAD ERROR',
        detail: '$_loadError',
      );
    }
    if (assets == null) {
      return const _StatusScreen(
        title: 'FINAL60',
        detail: 'Loading APK asset manifest…',
      );
    }
    if (assets.length != 60) {
      return _StatusScreen(
        title: 'FINAL60 ASSET COUNT ERROR',
        detail: 'Expected 60 PNG files, found ${assets.length}.',
      );
    }

    final current = assets[_index];
    final filename = current.substring(_prefix.length);

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        fit: StackFit.expand,
        children: [
          PageView.builder(
            controller: _controller,
            itemCount: assets.length,
            onPageChanged: (value) => setState(() => _index = value),
            itemBuilder: (context, index) {
              return Center(
                child: Image.asset(
                  assets[index],
                  fit: BoxFit.contain,
                  filterQuality: FilterQuality.high,
                  errorBuilder: (context, error, stackTrace) => _StatusScreen(
                    title: 'IMAGE LOAD ERROR',
                    detail: '${index + 1}/60\n${assets[index]}\n$error',
                  ),
                ),
              );
            },
          ),
          SafeArea(
            child: Align(
              alignment: Alignment.topCenter,
              child: Container(
                margin: const EdgeInsets.all(10),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.72),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  'FINAL60  ${_index + 1}/60',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ),
          SafeArea(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                margin: const EdgeInsets.all(10),
                padding: const EdgeInsets.fromLTRB(10, 8, 10, 8),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.78),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: _index == 0 ? null : () => _go(-1),
                      icon: const Icon(Icons.chevron_left),
                      color: Colors.white,
                      disabledColor: Colors.white30,
                    ),
                    Expanded(
                      child: Text(
                        filename,
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(color: Colors.white, fontSize: 11),
                      ),
                    ),
                    IconButton(
                      onPressed: _index == assets.length - 1 ? null : () => _go(1),
                      icon: const Icon(Icons.chevron_right),
                      color: Colors.white,
                      disabledColor: Colors.white30,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatusScreen extends StatelessWidget {
  const _StatusScreen({required this.title, required this.detail});

  final String title;
  final String detail;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                detail,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.white70, fontSize: 14),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
