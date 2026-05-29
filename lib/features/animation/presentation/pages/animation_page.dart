import 'package:flutter/material.dart';

/// 动画展示页面 - 展示 Flutter 各种动画能力
class AnimationPage extends StatefulWidget {
  const AnimationPage({Key? key}) : super(key: key);

  @override
  State<AnimationPage> createState() => _AnimationPageState();
}

class _AnimationPageState extends State<AnimationPage>
    with TickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('动画展示'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: '隐式动画', icon: Icon(Icons.auto_awesome)),
            Tab(text: '显式动画', icon: Icon(Icons.play_circle)),
            Tab(text: 'Hero', icon: Icon(Icons.transform)),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _ImplicitAnimationTab(),
          _ExplicitAnimationTab(),
          _HeroAnimationTab(),
        ],
      ),
    );
  }
}

// ─── 隐式动画 Tab ───
class _ImplicitAnimationTab extends StatefulWidget {
  @override
  State<_ImplicitAnimationTab> createState() => _ImplicitAnimationTabState();
}

class _ImplicitAnimationTabState extends State<_ImplicitAnimationTab> {
  bool _expanded = false;
  bool _colorChanged = false;
  double _sliderValue = 0.5;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text(
          'AnimatedContainer',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: () => setState(() {
            _expanded = !_expanded;
            _colorChanged = !_colorChanged;
          }),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInOutCubic,
            width: double.infinity,
            height: _expanded ? 200 : 100,
            decoration: BoxDecoration(
              color: _colorChanged
                  ? colorScheme.primaryContainer
                  : colorScheme.secondaryContainer,
              borderRadius: BorderRadius.circular(_expanded ? 32 : 16),
            ),
            child: Center(
              child: Text(
                '点击我切换动画',
                style: TextStyle(
                  color: _colorChanged
                      ? colorScheme.onPrimaryContainer
                      : colorScheme.onSecondaryContainer,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 24),

        // AnimatedScale
        Text(
          'AnimatedScale',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 8),
        Slider(
          value: _sliderValue,
          min: 0.2,
          max: 2.0,
          onChanged: (v) => setState(() => _sliderValue = v),
        ),
        Center(
          child: AnimatedScale(
            scale: _sliderValue,
            duration: const Duration(milliseconds: 200),
            child: Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: colorScheme.tertiary,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(Icons.star, color: colorScheme.onTertiary, size: 40),
            ),
          ),
        ),
        const SizedBox(height: 24),

        // AnimatedOpacity
        Text(
          'AnimatedOpacity',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 8),
        _AnimatedOpacityDemo(),
      ],
    );
  }
}

class _AnimatedOpacityDemo extends StatefulWidget {
  @override
  State<_AnimatedOpacityDemo> createState() => _AnimatedOpacityDemoState();
}

class _AnimatedOpacityDemoState extends State<_AnimatedOpacityDemo> {
  bool _visible = true;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        AnimatedOpacity(
          opacity: _visible ? 1.0 : 0.2,
          duration: const Duration(milliseconds: 500),
          child: Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.error,
              shape: BoxShape.circle,
            ),
          ),
        ),
        const SizedBox(width: 16),
        ElevatedButton(
          onPressed: () => setState(() => _visible = !_visible),
          child: Text(_visible ? '隐藏' : '显示'),
        ),
      ],
    );
  }
}

// ─── 显式动画 Tab ───
class _ExplicitAnimationTab extends StatefulWidget {
  @override
  State<_ExplicitAnimationTab> createState() => _ExplicitAnimationTabState();
}

class _ExplicitAnimationTabState extends State<_ExplicitAnimationTab>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.elasticInOut,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AnimatedBuilder(
            animation: _animation,
            builder: (context, child) {
              return Transform.rotate(
                angle: _animation.value * 2 * 3.14159,
                child: Transform.scale(
                  scale: 0.5 + _animation.value * 0.5,
                  child: child,
                ),
              );
            },
            child: Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    colorScheme.primary,
                    colorScheme.tertiary,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: colorScheme.primary.withOpacity(0.3),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Icon(
                Icons.flutter_dash,
                size: 60,
                color: colorScheme.onPrimary,
              ),
            ),
          ),
          const SizedBox(height: 32),
          Text(
            '旋转 + 缩放动画',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(height: 24),
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 12,
            children: [
              ElevatedButton(
                onPressed: () => _controller.forward(from: 0),
                child: const Text('播放'),
              ),
              ElevatedButton(
                onPressed: () => _controller.reverse(),
                child: const Text('反向'),
              ),
              ElevatedButton(
                onPressed: () => _controller.repeat(),
                child: const Text('循环'),
              ),
              OutlinedButton(
                onPressed: () => _controller.stop(),
                child: const Text('停止'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ─── Hero 动画 Tab ───
class _HeroAnimationTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            '点击图片查看 Hero 过渡动画',
            style: TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 24),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                PageRouteBuilder(
                  pageBuilder: (context, animation, secondaryAnimation) {
                    return const _HeroDetailPage();
                  },
                  transitionsBuilder:
                      (context, animation, secondaryAnimation, child) {
                    return FadeTransition(opacity: animation, child: child);
                  },
                ),
              );
            },
            child: Hero(
              tag: 'hero-logo',
              child: Container(
                width: 150,
                height: 150,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      colorScheme.primary,
                      colorScheme.secondary,
                      colorScheme.tertiary,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: colorScheme.primary.withOpacity(0.4),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Icon(
                  Icons.flutter_dash,
                  size: 80,
                  color: colorScheme.onPrimary,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Flutter Dash',
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ],
      ),
    );
  }
}

class _HeroDetailPage extends StatelessWidget {
  const _HeroDetailPage();

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Hero 详情')),
      body: Center(
        child: Hero(
          tag: 'hero-logo',
          child: Container(
            width: 250,
            height: 250,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  colorScheme.primary,
                  colorScheme.secondary,
                  colorScheme.tertiary,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(48),
              boxShadow: [
                BoxShadow(
                  color: colorScheme.primary.withOpacity(0.4),
                  blurRadius: 30,
                  offset: const Offset(0, 16),
                ),
              ],
            ),
            child: Icon(
              Icons.flutter_dash,
              size: 140,
              color: colorScheme.onPrimary,
            ),
          ),
        ),
      ),
    );
  }
}
