import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'features/home/home_page.dart';
import 'features/game/game_page.dart';
import 'features/lessons/lessons_page.dart';
import 'features/coach/coach_page.dart';
import 'providers/theme_provider.dart';
import 'providers/locale_provider.dart';
import 'l10n/app_localizations.dart';
import 'theme/app_theme.dart';

void main() {
  runApp(const ProviderScope(child: ChessLearnerApp()));
}

class ChessLearnerApp extends ConsumerWidget {
  const ChessLearnerApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeProvider);
    final locale = ref.watch(localeProvider);
    final router = GoRouter(
      initialLocation: '/',
      routes: <RouteBase>[
        GoRoute(
          path: '/',
          builder: (context, state) => const MainNavigationPage(),
        ),
      ],
    );

    return MaterialApp.router(
      title: 'Chessdy',
      debugShowCheckedModeBanner: false,
      themeMode: themeMode,
      locale: locale,
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      routerConfig: router,
    );
  }
}

class MainNavigationPage extends StatefulWidget {
  const MainNavigationPage({super.key});

  @override
  State<MainNavigationPage> createState() => _MainNavigationPageState();
}

class _MainNavigationPageState extends State<MainNavigationPage> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const HomePage(),
    GamePage(),
    CoachPage(),
    const LessonsPage(),
  ];

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppTheme.bgPrimary : AppTheme.lightBgPrimary,
      extendBody: true, // Required for floating nav bar
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          child: FrostedBackground(
            blur: 24,
            borderRadius: BorderRadius.circular(24),
            child: Container(
              decoration: BoxDecoration(
                color: isDark
                    ? AppTheme.bgCard.withOpacity(0.65)
                    : Colors.white.withOpacity(0.65),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: isDark
                      ? AppTheme.cardBorder.withOpacity(0.5)
                      : AppTheme.lightCardBorder.withOpacity(0.5),
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(isDark ? 0.3 : 0.05),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(24),
                child: NavigationBar(
                  height: 64,
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  indicatorColor: isDark 
                      ? AppTheme.gold.withOpacity(0.15) 
                      : AppTheme.goldDark.withOpacity(0.12),
                  elevation: 0,
                  selectedIndex: _currentIndex,
                  onDestinationSelected: (int index) {
                    setState(() {
                      _currentIndex = index;
                    });
                  },
                  destinations: [
                    NavigationDestination(
                      icon: Icon(Icons.home_outlined, color: AppTheme.mutedColor(isDark)),
                      selectedIcon: Icon(Icons.home, color: isDark ? AppTheme.gold : AppTheme.goldDark),
                      label: l10n.home,
                    ),
                    NavigationDestination(
                      icon: Icon(Icons.play_circle_outline, color: AppTheme.mutedColor(isDark)),
                      selectedIcon: Icon(Icons.play_circle, color: isDark ? AppTheme.gold : AppTheme.goldDark),
                      label: l10n.play,
                    ),
                    NavigationDestination(
                      icon: Icon(Icons.psychology_outlined, color: AppTheme.mutedColor(isDark)),
                      selectedIcon: Icon(Icons.psychology, color: isDark ? AppTheme.gold : AppTheme.goldDark),
                      label: l10n.train,
                    ),
                    NavigationDestination(
                      icon: Icon(Icons.menu_book_outlined, color: AppTheme.mutedColor(isDark)),
                      selectedIcon: Icon(Icons.menu_book, color: isDark ? AppTheme.gold : AppTheme.goldDark),
                      label: l10n.lesson,
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
