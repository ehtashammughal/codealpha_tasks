import 'package:flutter/material.dart';
import 'app_theme.dart';

class SettingPage extends StatelessWidget {
  const SettingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<AppThemeType>(
      valueListenable: AppTheme.selectedTheme,
      builder: (context, selectedTheme, child) {
        final theme = Theme.of(context);
        final colors = theme.colorScheme;

        return Scaffold(
          // ----------------------------------------------------------
          // APP BAR
          // ----------------------------------------------------------
          appBar: AppBar(
            elevation: 0,
            scrolledUnderElevation: 0,
            backgroundColor: Colors.transparent,
            surfaceTintColor: Colors.transparent,
            toolbarHeight: 76,
            automaticallyImplyLeading: false,
            titleSpacing: 20,
            title: Row(
              children: [
                Container(
                  width: 46,
                  height: 46,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        colors.primary,
                        colors.secondary,
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: colors.primary.withValues(alpha: 0.20),
                        blurRadius: 12,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.settings_rounded,
                    color: Colors.white,
                    size: 23,
                  ),
                ),
                const SizedBox(width: 13),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Settings',
                      style: TextStyle(
                        color: colors.onSurface,
                        fontSize: 24,
                        fontWeight: FontWeight.w900,
                        letterSpacing: -0.5,
                      ),
                    ),
                    Text(
                      'Customize your experience',
                      style: TextStyle(
                        color: colors.onSurfaceVariant,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          body: SafeArea(
            top: false,
            child: ListView(
              padding: const EdgeInsets.fromLTRB(
                20,
                8,
                20,
                120,
              ),
              children: [
                // ----------------------------------------------------------
                // HEADER
                // ----------------------------------------------------------
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        colors.primary,
                        colors.secondary,
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(28),
                    boxShadow: [
                      BoxShadow(
                        color: colors.primary.withValues(alpha: 0.18),
                        blurRadius: 25,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.auto_awesome_rounded,
                        color: Colors.white,
                        size: 42,
                      ),
                      SizedBox(height: 18),
                      Text(
                        'Make it yours!',
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.w900,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Personalize your flashcard experience '
                        'with colors that inspire you to learn.',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 30),

                // ----------------------------------------------------------
                // APPEARANCE
                // ----------------------------------------------------------
                Text(
                  'APPEARANCE',
                  style: TextStyle(
                    fontSize: 12,
                    letterSpacing: 2,
                    fontWeight: FontWeight.w800,
                    color: colors.primary,
                  ),
                ),

                const SizedBox(height: 14),

                // ----------------------------------------------------------
                // THEME CARD
                // ----------------------------------------------------------
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: colors.surface,
                    borderRadius: BorderRadius.circular(26),
                    boxShadow: [
                      BoxShadow(
                        color: colors.shadow.withValues(alpha: 0.08),
                        blurRadius: 20,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: colors.primary.withValues(alpha: 0.10),
                              borderRadius: BorderRadius.circular(13),
                            ),
                            child: Icon(
                              Icons.palette_rounded,
                              color: colors.primary,
                              size: 24,
                            ),
                          ),
                          const SizedBox(width: 12),
                          const Expanded(
                            child: Text(
                              'App Theme',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 8),

                      Text(
                        'Choose your favorite look for the entire app.',
                        style: TextStyle(
                          fontSize: 13,
                          color: colors.onSurface.withValues(alpha: 0.65),
                        ),
                      ),

                      const SizedBox(height: 20),

                      // ----------------------------------------------------
                      // THEME DROPDOWN
                      // ----------------------------------------------------
                      DropdownButtonFormField<AppThemeType>(
                        initialValue: selectedTheme,
                        isExpanded: true,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor:
                              colors.primary.withValues(alpha: 0.06),
                          prefixIcon: Icon(
                            Icons.brush_rounded,
                            color: colors.primary,
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 16,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(18),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        borderRadius: BorderRadius.circular(18),
                        items: const [
                          DropdownMenuItem(
                            value: AppThemeType.light,
                            child: Row(
                              children: [
                                Icon(
                                  Icons.wb_sunny_rounded,
                                  color: Color(0xFF6C3BFF),
                                ),
                                SizedBox(width: 12),
                                Text('Light - Violet'),
                              ],
                            ),
                          ),
                          DropdownMenuItem(
                            value: AppThemeType.dark,
                            child: Row(
                              children: [
                                Icon(
                                  Icons.dark_mode_rounded,
                                  color: Color(0xFF9D80FF),
                                ),
                                SizedBox(width: 12),
                                Text('Dark - Purple'),
                              ],
                            ),
                          ),
                          DropdownMenuItem(
                            value: AppThemeType.blue,
                            child: Row(
                              children: [
                                Icon(
                                  Icons.water_drop_rounded,
                                  color: Color(0xFF087EDE),
                                ),
                                SizedBox(width: 12),
                                Text('Blue - Ocean'),
                              ],
                            ),
                          ),
                        ],
                       onChanged: (AppThemeType? value) async {
                         if (value != null) {
                                await AppTheme.setTheme(value);
                               }
                          },
                      ),

                      const SizedBox(height: 20),

                      // ----------------------------------------------------
                      // PREVIOUS / NEXT BUTTONS
                      // ----------------------------------------------------
                      ValueListenableBuilder<bool>(
                        valueListenable:
                            AppTheme.showCardNavigationButtons,
                        builder: (context, showButtons, child) {
                          return SwitchListTile(
                            contentPadding: EdgeInsets.zero,
                            title: const Text(
                              'Previous / Next buttons',
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            subtitle: const Text(
                              'Show navigation buttons below the cards',
                            ),
                            secondary: Icon(
                              Icons.swap_horiz_rounded,
                              color: colors.primary,
                            ),
                            value: showButtons,
                            onChanged: (value) async {
                                  await AppTheme.setShowCardNavigationButtons(value);
                                      },
                          );
                        },
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 28),

                // ----------------------------------------------------------
                // THEME PREVIEW
                // ----------------------------------------------------------
                Text(
                  'THEME PREVIEW',
                  style: TextStyle(
                    fontSize: 12,
                    letterSpacing: 2,
                    fontWeight: FontWeight.w800,
                    color: colors.primary,
                  ),
                ),

                const SizedBox(height: 14),

                Container(
                  height: 150,
                  padding: const EdgeInsets.all(22),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        colors.primary,
                        colors.secondary,
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(26),
                    boxShadow: [
                      BoxShadow(
                        color: colors.primary.withValues(alpha: 0.18),
                        blurRadius: 22,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Icon(
                        Icons.school_rounded,
                        color: Colors.white,
                        size: 32,
                      ),
                      Text(
                        'Keep learning.\nKeep growing.',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 30),

                // ----------------------------------------------------------
                // FOOTER
                // ----------------------------------------------------------
                Center(
                  child: Text(
                    'Flashcard Quiz App',
                    style: TextStyle(
                      color: colors.onSurface.withValues(alpha: 0.5),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),

                const SizedBox(height: 20),
              ],
            ),
          ),
        );
      },
    );
  }
}