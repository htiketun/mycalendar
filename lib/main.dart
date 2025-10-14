import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'screens/calendar_screen.dart';
import 'services/event_service.dart';
import 'services/notification_service.dart';
import 'utils/constants.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize services
  await EventService.instance.init();
  await NotificationService().initialize();
  
  runApp(const CalendarApp());
}

class CalendarApp extends StatelessWidget {
  const CalendarApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppStrings.appName,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primaryColor,
          brightness: Brightness.dark,
        ).copyWith(
          surface: AppColors.surfaceColor,
          primary: AppColors.primaryColor,
          secondary: AppColors.secondaryColor,
          tertiary: AppColors.accentColor,
          error: AppColors.errorColor,
        ),
        scaffoldBackgroundColor: AppColors.backgroundColor,
        
        // Custom text theme with Google Fonts
        textTheme: GoogleFonts.exoTextTheme(
          ThemeData.dark().textTheme.copyWith(
            displayLarge: AppTextStyles.heading1,
            displayMedium: AppTextStyles.heading2,
            displaySmall: AppTextStyles.heading3,
            bodyLarge: AppTextStyles.bodyText,
            bodyMedium: AppTextStyles.bodyText,
            bodySmall: AppTextStyles.caption,
            labelLarge: AppTextStyles.button,
          ),
        ),
        
        // App Bar Theme
        appBarTheme: AppBarTheme(
          backgroundColor: AppColors.backgroundColor,
          foregroundColor: AppColors.textPrimary,
          elevation: 0,
          centerTitle: true,
          titleTextStyle: AppTextStyles.arcadeTitle.copyWith(fontSize: 24),
          iconTheme: const IconThemeData(
            color: AppColors.primaryColor,
            size: 28,
          ),
        ),
        
        // Card Theme
        cardTheme: CardThemeData(
          elevation: AppDimensions.elevationHigh,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDimensions.borderRadiusLarge),
          ),
          color: AppColors.cardColor,
          shadowColor: AppColors.primaryColor.withValues(alpha: 0.3),
        ),
        
        // Elevated Button Theme
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primaryColor,
            foregroundColor: AppColors.backgroundColor,
            elevation: AppDimensions.elevationHigh,
            shadowColor: AppColors.primaryColor.withValues(alpha: 0.5),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppDimensions.borderRadius),
            ),
            padding: const EdgeInsets.symmetric(
              horizontal: AppDimensions.paddingLarge,
              vertical: AppDimensions.paddingMedium,
            ),
            textStyle: AppTextStyles.button,
          ),
        ),
        
        // Outlined Button Theme
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            foregroundColor: AppColors.primaryColor,
            side: const BorderSide(color: AppColors.primaryColor),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppDimensions.borderRadius),
            ),
            padding: const EdgeInsets.symmetric(
              horizontal: AppDimensions.paddingLarge,
              vertical: AppDimensions.paddingMedium,
            ),
          ),
        ),
        
        // Text Button Theme
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: AppColors.primaryColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppDimensions.borderRadius),
            ),
            padding: const EdgeInsets.symmetric(
              horizontal: AppDimensions.paddingLarge,
              vertical: AppDimensions.paddingMedium,
            ),
          ),
        ),
        
        // Input Decoration Theme
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppDimensions.borderRadius),
            borderSide: const BorderSide(color: AppColors.dividerColor),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppDimensions.borderRadius),
            borderSide: const BorderSide(color: AppColors.dividerColor),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppDimensions.borderRadius),
            borderSide: const BorderSide(color: AppColors.primaryColor, width: 2),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppDimensions.borderRadius),
            borderSide: const BorderSide(color: AppColors.errorColor),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppDimensions.borderRadius),
            borderSide: const BorderSide(color: AppColors.errorColor, width: 2),
          ),
          contentPadding: const EdgeInsets.all(AppDimensions.paddingMedium),
          labelStyle: const TextStyle(color: AppColors.textSecondary),
          hintStyle: const TextStyle(color: AppColors.textSecondary),
        ),
        
        // Dialog Theme
        dialogTheme: DialogThemeData(
          backgroundColor: AppColors.surfaceColor,
          elevation: AppDimensions.elevationHigh,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDimensions.borderRadiusLarge),
          ),
        ),
        
        // Bottom Sheet Theme
        bottomSheetTheme: const BottomSheetThemeData(
          backgroundColor: AppColors.surfaceColor,
          elevation: AppDimensions.elevationHigh,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(AppDimensions.borderRadiusLarge),
            ),
          ),
        ),
        
        // Snack Bar Theme
        snackBarTheme: SnackBarThemeData(
          backgroundColor: AppColors.textPrimary,
          contentTextStyle: const TextStyle(color: Colors.white),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDimensions.borderRadius),
          ),
          behavior: SnackBarBehavior.floating,
        ),
        
        // Icon Theme
        iconTheme: const IconThemeData(
          color: AppColors.textSecondary,
          size: 24,
        ),
        
        // Divider Theme
        dividerTheme: const DividerThemeData(
          color: AppColors.dividerColor,
          thickness: 1,
          space: 1,
        ),
      ),
      home: const CalendarScreen(),
    );
  }
}

