import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // ── Premium Colors ────────────────────────────────────────────────────
  static const Color bgPrimary   = Color(0xFF09090B); // Ultra dark, sleek zinc
  static const Color bgSecondary = Color(0xFF131316); 
  static const Color bgCard      = Color(0xFF18181C); 
  static const Color bgCardLight = Color(0xFF222228); 
  
  static const Color gold        = Color(0xFFF4D06F); // Premium Champagne Gold
  static const Color goldDark    = Color(0xFFCBA142);
  static const Color ember       = Color(0xFFFF6B4A);
  
  static const Color textPrimary = Color(0xFFFAFAFA);
  static const Color textMuted   = Color(0xFFA1A1AA);
  
  static const Color lightBgPrimary = Color(0xFFF8FAFC);
  static const Color lightTextPrimary = Color(0xFF0F172A); // Slate 900
  static const Color lightTextMuted   = Color(0xFF64748B); // Slate 500
  
  static const Color success     = Color(0xFF34D399);
  static const Color danger      = Color(0xFFFB7185);
  static const Color warning     = Color(0xFFFBBF24);
  static const Color info        = Color(0xFF60A5FA);
  static const Color cardBorder  = Color(0xFF27272A);
  static const Color lightCardBorder = Color(0xFFE2E8F0);

  static Color mutedColor(bool isDark) => isDark ? textMuted : lightTextMuted;
  static Color primaryColor(bool isDark) => isDark ? textPrimary : lightTextPrimary;
  static Color cardColor(bool isDark) => isDark ? bgCard : Colors.white;
  static Color borderColor(bool isDark) => isDark ? cardBorder : lightCardBorder;

  // ── Refined Gradients ──────────────────────────────────────────
  static const LinearGradient goldGradient = LinearGradient(
    colors: [gold, goldDark],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient heroGradient = LinearGradient(
    colors: [Color(0xFF09090B), Color(0xFF1E1E28), Color(0xFF131316)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static const LinearGradient lightHeroGradient = LinearGradient(
    colors: [Color(0xFFFFFFFF), Color(0xFFF1F5F9), Color(0xFFF8FAFC)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static const LinearGradient successGradient = LinearGradient(
    colors: [Color(0xFF065F46), Color(0xFF047857)],
  );

  static const LinearGradient dangerGradient = LinearGradient(
    colors: [Color(0xFF991B1B), Color(0xFFB91C1C)],
  );

  static const LinearGradient goldCardGradient = LinearGradient(
    colors: [Color(0xFF2D2412), Color(0xFF161105)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // ── Glassmorphism & Decorations ───────────────────────────────
  static BoxDecoration glassCard({Color? borderColor, double radius = 20, bool isDark = true}) =>
      BoxDecoration(
        color: (isDark ? bgCard : Colors.white).withOpacity(0.7),
        borderRadius: BorderRadius.circular(radius),
        border: Border.all(
          color: (borderColor ?? (isDark ? cardBorder : lightCardBorder)),
          width: 1,
        ),
        boxShadow: isDark ? [
          BoxShadow(
            color: Colors.black.withOpacity(0.4),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ] : [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      );

  static BoxDecoration goldGlassCard({double radius = 20, bool isDark = true}) => 
    BoxDecoration(
      gradient: isDark ? goldCardGradient : LinearGradient(colors: [Color(0xFFFFFBEB), Colors.white]),
      borderRadius: BorderRadius.circular(radius),
      border: Border.all(color: gold.withOpacity(0.4), width: 1.5),
      boxShadow: [
        BoxShadow(
          color: gold.withOpacity(isDark ? 0.12 : 0.25),
          blurRadius: 24,
          spreadRadius: 2,
          offset: const Offset(0, 6),
        ),
      ],
    );

  // ── Premium Typography ──────────────────────────────────────────
  static TextStyle get displayLarge => GoogleFonts.outfit(
        fontSize: 38, fontWeight: FontWeight.w800, letterSpacing: -0.8, height: 1.1);

  static TextStyle get heading1 => GoogleFonts.outfit(
        fontSize: 28, fontWeight: FontWeight.w700, letterSpacing: -0.5);

  static TextStyle get heading2 => GoogleFonts.outfit(
        fontSize: 22, fontWeight: FontWeight.w700, letterSpacing: -0.3);

  static TextStyle get heading3 => GoogleFonts.outfit(
        fontSize: 18, fontWeight: FontWeight.w600, letterSpacing: -0.2);

  static TextStyle get bodyLarge => GoogleFonts.inter(
        fontSize: 16, fontWeight: FontWeight.w400, height: 1.6);

  static TextStyle get bodySmall => GoogleFonts.inter(
        fontSize: 14, fontWeight: FontWeight.w400, height: 1.5);

  static TextStyle get labelGold => GoogleFonts.outfit(
        fontSize: 13, fontWeight: FontWeight.w700,
        color: gold, letterSpacing: 1.2);

  static TextStyle get monoLarge => GoogleFonts.jetBrainsMono(
        fontSize: 32, fontWeight: FontWeight.w700, letterSpacing: -1.0);

  // ── Full ThemeData ─────────────────────────────────────────────
  static ThemeData get darkTheme => ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: bgPrimary,
        colorScheme: const ColorScheme.dark(
          primary: gold,
          onPrimary: Color(0xFF1A140A),
          secondary: ember,
          surface: bgCard,
          onSurface: textPrimary,
          error: danger,
          outline: cardBorder,
        ),
        textTheme: TextTheme(
          displayLarge: displayLarge.copyWith(color: textPrimary),
          headlineLarge: heading1.copyWith(color: textPrimary),
          headlineMedium: heading2.copyWith(color: textPrimary),
          headlineSmall: heading3.copyWith(color: textPrimary),
          bodyLarge: bodyLarge.copyWith(color: textPrimary),
          bodyMedium: bodyLarge.copyWith(color: textPrimary),
          bodySmall: bodySmall.copyWith(color: textMuted),
          labelSmall: labelGold,
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0,
          scrolledUnderElevation: 0,
          centerTitle: false,
          titleTextStyle: GoogleFonts.outfit(
            fontSize: 22,
            fontWeight: FontWeight.w700,
            color: textPrimary,
            letterSpacing: -0.3,
          ),
          iconTheme: const IconThemeData(color: textPrimary),
        ),
        cardTheme: CardThemeData(
          color: bgCard,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: const BorderSide(color: cardBorder, width: 1),
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: gold,
            foregroundColor: const Color(0xFF140F05),
            elevation: 4,
            shadowColor: gold.withOpacity(0.4),
            padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
            textStyle: GoogleFonts.outfit(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.3,
            ),
          ),
        ),
        sliderTheme: SliderThemeData(
          activeTrackColor: gold,
          thumbColor: gold,
          inactiveTrackColor: cardBorder,
          overlayColor: gold.withOpacity(0.2),
          trackHeight: 6,
        ),
        dividerTheme: const DividerThemeData(
          color: cardBorder,
          thickness: 1,
        ),
        useMaterial3: true,
      );

  static ThemeData get lightTheme => ThemeData(
        brightness: Brightness.light,
        scaffoldBackgroundColor: lightBgPrimary,
        colorScheme: const ColorScheme.light(
          primary: goldDark,
          secondary: ember,
          surface: Colors.white,
          onSurface: lightTextPrimary,
          error: danger,
          outline: lightCardBorder,
        ),
        textTheme: TextTheme(
          displayLarge: displayLarge.copyWith(color: lightTextPrimary),
          headlineLarge: heading1.copyWith(color: lightTextPrimary),
          headlineMedium: heading2.copyWith(color: lightTextPrimary),
          headlineSmall: heading3.copyWith(color: lightTextPrimary),
          bodyLarge: bodyLarge.copyWith(color: lightTextPrimary),
          bodyMedium: bodyLarge.copyWith(color: lightTextPrimary),
          bodySmall: bodySmall.copyWith(color: lightTextMuted),
          labelSmall: labelGold.copyWith(color: goldDark),
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0,
          scrolledUnderElevation: 0,
          centerTitle: false,
          titleTextStyle: GoogleFonts.outfit(
            fontSize: 22,
            fontWeight: FontWeight.w700,
            color: lightTextPrimary,
            letterSpacing: -0.3,
          ),
          iconTheme: const IconThemeData(color: lightTextPrimary),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: goldDark,
            foregroundColor: Colors.white,
            elevation: 4,
            shadowColor: goldDark.withOpacity(0.4),
            padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
            textStyle: GoogleFonts.outfit(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.3,
            ),
          ),
        ),
        useMaterial3: true,
      );
}

// ── Reusable Premium Widgets ──────────────────────────────────────────

class FrostedBackground extends StatelessWidget {
  final Widget child;
  final double blur;
  final BorderRadius? borderRadius;
  final Color color;

  const FrostedBackground({
    super.key, 
    required this.child, 
    this.blur = 20.0,
    this.borderRadius,
    this.color = Colors.transparent,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: borderRadius ?? BorderRadius.zero,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
        child: Container(
          color: color,
          child: child,
        ),
      ),
    );
  }
}

class MoveBadge extends StatelessWidget {
  final String label;
  final Color color;
  const MoveBadge({super.key, required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: color.withOpacity(0.3), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.1),
            blurRadius: 8,
            spreadRadius: 0,
          )
        ],
      ),
      child: Text(
        label,
        style: GoogleFonts.outfit(
          fontSize: 12,
          fontWeight: FontWeight.w700,
          color: color,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}

class SectionLabel extends StatelessWidget {
  final String text;
  const SectionLabel(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 4,
          height: 20,
          decoration: BoxDecoration(
            gradient: AppTheme.goldGradient,
            borderRadius: BorderRadius.circular(4),
            boxShadow: [
              BoxShadow(
                color: AppTheme.gold.withOpacity(0.4),
                blurRadius: 6,
                offset: const Offset(0, 0),
              )
            ]
          ),
        ),
        const SizedBox(width: 12),
        Text(
          text.toUpperCase(),
          style: AppTheme.labelGold.copyWith(
            fontSize: 13,
            color: Theme.of(context).brightness == Brightness.light ? AppTheme.goldDark : AppTheme.gold,
          ),
        ),
      ],
    );
  }
}

class GlowIcon extends StatelessWidget {
  final IconData icon;
  final Color color;
  final double size;
  const GlowIcon({
    super.key,
    required this.icon,
    required this.color,
    this.size = 24,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size + 24,
      height: size + 24,
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        shape: BoxShape.circle,
        border: Border.all(color: color.withOpacity(0.2), width: 1),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.15),
            blurRadius: 16,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Icon(icon, color: color, size: size),
    );
  }
}

class TappableCard extends StatefulWidget {
  final Widget child;
  final VoidCallback onTap;
  final EdgeInsetsGeometry? padding;
  final BoxDecoration? decoration;

  const TappableCard({
    super.key,
    required this.child,
    required this.onTap,
    this.padding,
    this.decoration,
  });

  @override
  State<TappableCard> createState() => _TappableCardState();
}

class _TappableCardState extends State<TappableCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scale;
  late Animation<double> _glow;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _scale = Tween<double>(begin: 1.0, end: 0.98).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic),
    );
    _glow = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    
    return GestureDetector(
      onTapDown: (_) => _controller.forward(),
      onTapUp: (_) {
        _controller.reverse();
        widget.onTap();
      },
      onTapCancel: () => _controller.reverse(),
      child: ScaleTransition(
        scale: _scale,
        child: AnimatedBuilder(
          animation: _glow,
          builder: (context, child) {
            final defaultDecoration = AppTheme.glassCard(isDark: isDark);
            BoxDecoration baseDeco = widget.decoration ?? defaultDecoration;
            
            // Add subtle active glow
            if (baseDeco.boxShadow != null) {
               List<BoxShadow> shadows = List.from(baseDeco.boxShadow!);
               shadows.add(BoxShadow(
                 color: (isDark ? AppTheme.gold : AppTheme.goldDark).withOpacity(0.1 * _glow.value),
                 blurRadius: 20 * _glow.value,
                 spreadRadius: 2 * _glow.value,
               ));
               baseDeco = baseDeco.copyWith(boxShadow: shadows);
            }
            
            return Container(
              padding: widget.padding ?? const EdgeInsets.all(20),
              decoration: baseDeco,
              child: widget.child,
            );
          }
        ),
      ),
    );
  }
}
