# Flutter Calendar App

A comprehensive and modern Flutter calendar application with event management capabilities. This app features a beautiful Material Design interface, responsive layout, and persistent event storage.

![Flutter Calendar App](https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white)
![Dart](https://img.shields.io/badge/Dart-0175C2?style=for-the-badge&logo=dart&logoColor=white)

## Features

### 📅 Calendar Features

-   **Monthly Calendar View**: Clean and intuitive monthly calendar grid
-   **Date Navigation**: Easy navigation between months with arrow buttons
-   **Today Highlighting**: Current date is clearly highlighted
-   **Event Indicators**: Visual dots show days with events
-   **Responsive Design**: Adapts to different screen sizes (mobile and desktop)

### 📝 Event Management

-   **Create Events**: Add new events with title, description, date, and color
-   **Edit Events**: Modify existing events with full editing capabilities
-   **Delete Events**: Remove events with confirmation dialog
-   **Event Colors**: Choose from 8 predefined colors for better organization
-   **Event Details**: View complete event information in a bottom sheet

### 💾 Data Persistence

-   **Local Storage**: Events are stored locally using SharedPreferences
-   **Data Persistence**: Events persist between app sessions
-   **JSON Serialization**: Efficient data storage and retrieval

### 🎨 User Interface

-   **Material Design 3**: Modern and consistent UI following Material Design principles
-   **Dark/Light Theme Support**: Adapts to system theme preferences
-   **Smooth Animations**: Polished user experience with smooth transitions
-   **Accessibility**: Built with accessibility in mind

## Screenshots

The app features a clean and modern interface that works beautifully on both mobile and desktop:

-   **Mobile Layout**: Vertical stack with calendar on top and events below
-   **Desktop Layout**: Side-by-side layout with calendar and events panel
-   **Event Creation**: Intuitive dialog with form validation
-   **Event Management**: Easy-to-use bottom sheet for event actions

## Project Structure

```
lib/
├── main.dart                 # App entry point and theme configuration
├── models/
│   └── event.dart           # Event data model with JSON serialization
├── screens/
│   └── calendar_screen.dart # Main calendar screen with responsive layout
├── services/
│   └── event_service.dart   # Event management service with local storage
├── utils/
│   ├── constants.dart       # App constants, colors, and text styles
│   └── date_utils.dart      # Date utility functions and helpers
└── widgets/
    ├── calendar_widget.dart      # Calendar grid widget
    ├── event_form_dialog.dart    # Event creation/editing dialog
    └── event_list_widget.dart    # Event list display widget
```

## Installation and Setup

### Prerequisites

Before running this app, make sure you have:

1. **Flutter SDK** (3.0.0 or higher)

    ```bash
    # Check Flutter installation
    flutter --version
    ```

2. **Dart SDK** (included with Flutter)

3. **VS Code** with Flutter and Dart extensions (recommended)

### Getting Started

1. **Install Flutter**

    - Download Flutter SDK from [flutter.dev](https://flutter.dev/docs/get-started/install)
    - Add Flutter to your system PATH
    - Run `flutter doctor` to verify installation

2. **Install Dependencies**

    ```bash
    flutter pub get
    ```

3. **Run the App**

    ```bash
    # Run on connected device/emulator
    flutter run

    # Run on web
    flutter run -d web

    # Run on specific device
    flutter devices  # List available devices
    flutter run -d <device-id>
    ```

### Dependencies

The app uses the following packages:

```yaml
dependencies:
    flutter:
        sdk: flutter
    cupertino_icons: ^1.0.2 # iOS-style icons
    shared_preferences: ^2.2.2 # Local data persistence
    intl: ^0.18.1 # Internationalization and date formatting

dev_dependencies:
    flutter_test:
        sdk: flutter
    flutter_lints: ^3.0.0 # Dart linting rules
```

## Usage Guide

### Creating Events

1. **Select a Date**: Tap on any date in the calendar
2. **Add Event**: Click the "Add Event" button
3. **Fill Details**: Enter event title, description (optional)
4. **Choose Date**: Confirm or change the event date
5. **Select Color**: Pick a color to categorize your event
6. **Save**: Tap "Add Event" to save

### Managing Events

1. **View Events**: Events for the selected date appear in the events panel
2. **Edit Event**: Tap on any event to open the action menu, then select "Edit Event"
3. **Delete Event**: Tap on an event and select "Delete Event" (requires confirmation)

### Navigation

-   **Month Navigation**: Use left/right arrows to navigate between months
-   **Go to Today**: Tap on the month/year header to quickly jump to today
-   **Date Selection**: Tap any date to view events for that day

## Customization

### Colors and Themes

The app uses a comprehensive theming system defined in `lib/utils/constants.dart`:

```dart
class AppColors {
  static const Color primaryColor = Color(0xFF2196F3);
  static const Color secondaryColor = Color(0xFF03DAC6);
  // ... more colors
}
```

### Event Colors

Users can choose from 8 predefined event colors:

-   Blue (default)
-   Green
-   Orange
-   Purple
-   Red
-   Cyan
-   Yellow
-   Brown

### Responsive Layout

The app automatically adapts to different screen sizes:

-   **Mobile** (<= 800px width): Vertical layout
-   **Desktop** (> 800px width): Horizontal layout

## Development

### Code Structure

The app follows clean architecture principles:

-   **Models**: Data structures and business entities
-   **Services**: Business logic and data management
-   **Widgets**: Reusable UI components
-   **Screens**: Complete screen implementations
-   **Utils**: Helper functions and constants

### Key Components

1. **EventService**: Singleton service managing all event operations
2. **CalendarWidget**: Renders the monthly calendar grid
3. **EventListWidget**: Displays events for selected date
4. **EventFormDialog**: Handles event creation and editing

### Testing

Run tests using:

```bash
# Run all tests
flutter test

# Run tests with coverage
flutter test --coverage
```

## Building for Release

### Android

```bash
# Build APK
flutter build apk --release

# Build App Bundle (recommended for Play Store)
flutter build appbundle --release
```

### iOS

```bash
# Build for iOS
flutter build ios --release
```

### Web

```bash
# Build for web
flutter build web --release
```

## Troubleshooting

### Common Issues

1. **Flutter not found**

    - Ensure Flutter is installed and added to PATH
    - Run `flutter doctor` to check installation

2. **Dependencies issues**

    - Run `flutter pub get` to install dependencies
    - Clear pub cache: `flutter pub cache repair`

3. **Build errors**
    - Clean the project: `flutter clean`
    - Get dependencies again: `flutter pub get`

### Performance Tips

-   Events are cached in memory for better performance
-   Use `flutter run --profile` for performance testing
-   Consider adding pagination for large numbers of events

## Contributing

This project follows Flutter best practices:

1. **Code Style**: Follow official Dart style guide
2. **Documentation**: Document all public APIs
3. **Testing**: Write tests for business logic
4. **Performance**: Profile and optimize critical paths

## Future Enhancements

Potential features for future versions:

-   [ ] Weekly and daily calendar views
-   [ ] Event reminders and notifications
-   [ ] Recurring events support
-   [ ] Event categories and filtering
-   [ ] Cloud synchronization
-   [ ] Event import/export
-   [ ] Multiple calendar support
-   [ ] Time-based events (not just all-day)

## License

This project is available for educational and personal use. Feel free to modify and extend it according to your needs.

## Support

For issues and questions:

1. Check the troubleshooting section above
2. Review Flutter documentation: https://flutter.dev/docs
3. Check pub.dev for package documentation

---

**Enjoy using your Flutter Calendar App!** 📅✨

Update 2025-02-05T20:10:13 [14]

Update 2025-02-09T09:00:15 [26]

Update 2025-02-10T06:15:46 [29]

Update 2025-02-17T22:26:15 [55]

Update 2025-02-21T19:20:46 [68]

Update 2025-02-23T13:00:20 [74]

Update 2025-02-27T16:16:48 [88]

Update 2025-03-04T02:46:49 [103]

Update 2025-03-06T11:12:34 [111]

Update 2025-03-07T22:52:53 [116]

Update 2025-03-11T18:22:14 [129]

Update 2025-03-12T23:29:17 [133]

Update 2025-03-14T17:17:07 [139]

Update 2025-03-15T07:45:41 [141]

Update 2025-03-15T21:29:32 [143]

Update 2025-03-22T09:19:47 [165]

Update 2025-03-25T01:43:12 [174]

Update 2025-02-02T07:33:16 

Update 2025-02-04T02:04:50 

Update 2025-02-10T06:36:29 

Update 2025-02-14T17:12:38 

Update 2025-02-15T21:39:17 

Update 2025-02-17T23:03:14 

Update 2025-02-20T00:40:20 

Update 2025-02-22T23:09:22 

Update 2025-02-27T09:27:34 

Update 2025-02-28T13:19:34 

Update 2025-03-02T00:55:18 

Update 2025-03-02T08:15:02 

Update 2025-03-04T16:23:08 

Update 2025-03-07T01:00:28 

Update 2025-03-10T00:11:27 

Update 2025-03-11T04:27:12 

Update 2025-03-12T08:53:02 

Update 2025-03-13T13:25:01 

Update 2025-03-13T20:19:33 

Update 2025-03-15T07:56:28 

Update 2025-03-15T21:25:51 

Update 2025-03-19T17:39:40 

Update 2025-03-20T07:48:54 

Update 2025-03-22T09:26:48 

Update 2025-03-25T01:03:48 

Update 2025-02-02T00:22:10 

Update 2025-02-02T21:34:30 

Update 2025-02-03T05:01:17 

Update 2025-02-03T12:19:13 

Update 2025-02-03T18:32:58 

Update 2025-02-04T02:16:47 

Update 2025-02-04T09:38:21 

Update 2025-02-04T15:50:57 

Update 2025-02-05T13:44:19 

Update 2025-02-05T20:19:33 

Update 2025-02-06T17:29:27 

Update 2025-02-07T14:56:11 

Update 2025-02-08T05:29:44 

Update 2025-02-08T11:49:40 

Update 2025-02-09T01:57:58 

Update 2025-02-10T13:40:16 

Update 2025-02-10T21:12:19 

Update 2025-02-11T04:22:57 

Update 2025-02-11T11:21:59 

Update 2025-02-12T00:50:20 

Update 2025-02-12T15:06:14 

Update 2025-02-12T22:56:06 

Update 2025-02-14T02:22:10 

Update 2025-02-14T09:40:26 

Update 2025-02-14T17:16:30 

Update 2025-02-14T23:47:20 

Update 2025-02-15T07:00:52 

Update 2025-02-15T14:32:09 

Update 2025-02-15T21:02:38 

Update 2025-02-16T04:29:13 

Update 2025-02-16T11:02:46 

Update 2025-02-17T01:54:08 

Update 2025-02-17T08:21:46 

Update 2025-02-17T16:04:57 

Update 2025-02-17T22:30:18 

Update 2025-02-18T05:37:00 

Update 2025-02-18T12:44:10 

Update 2025-02-18T20:12:55 

Update 2025-02-19T03:33:16 

Update 2025-02-19T16:50:50 

Update 2025-02-20T00:01:02 

Update 2025-02-20T14:57:00 

Update 2025-02-20T21:46:22 

Update 2025-02-21T04:30:24 

Update 2025-02-21T11:40:22 

Update 2025-02-22T15:53:40 

Update 2025-02-22T22:53:56 

Update 2025-02-23T05:57:59 

Update 2025-02-23T13:02:14 

Update 2025-02-23T20:34:37 

Update 2025-02-24T10:14:00 

Update 2025-02-24T17:17:00 

Update 2025-02-25T21:53:57 

Update 2025-02-26T05:02:21 

Update 2025-02-26T12:04:11 

Update 2025-02-27T02:25:28 

Update 2025-02-27T09:52:03 

Update 2025-02-28T06:59:27 

Update 2025-03-02T01:29:23 

Update 2025-03-02T14:49:32 

Update 2025-03-03T05:19:45 

Update 2025-03-03T20:03:03 

Update 2025-03-04T03:08:22 

Update 2025-03-05T00:06:09 

Update 2025-03-05T20:49:47 

Update 2025-03-06T04:14:04 

Update 2025-03-06T18:22:24 

Update 2025-03-07T01:38:54 

Update 2025-03-07T08:16:52 

Update 2025-03-07T15:23:55 

Update 2025-03-07T22:59:22 

Update 2025-03-09T17:13:39 

Update 2025-03-10T07:06:05 

Update 2025-03-11T04:29:53 

Update 2025-03-12T01:44:29 

Update 2025-03-12T09:12:15 

Update 2025-03-12T23:33:25 

Update 2025-03-14T03:01:32 

Update 2025-03-14T17:52:43 

Update 2025-03-16T11:32:30 

Update 2025-03-16T18:52:31 

Update 2025-03-17T16:38:56 

Update 2025-03-17T23:43:52 

Update 2025-03-18T06:58:11 

Update 2025-03-18T20:42:45 

Update 2025-03-19T03:17:42 

Update 2025-03-20T00:57:37 

Update 2025-03-20T15:36:24 

Update 2025-03-20T22:06:17 

Update 2025-03-21T11:57:29 

Update 2025-03-22T10:02:17 

Update 2025-03-24T17:50:22 

Update 2025-03-25T08:09:43 

Update 2025-03-25T15:25:06 

Update 2025-03-25T22:13:50 

Update 2025-03-26T20:02:13 

Update 2025-03-27T02:49:53 

Update 2025-03-27T09:55:16 

Update 2025-03-28T14:27:15 

Update 2025-03-28T21:06:55 

Update 2025-03-29T11:44:24 

Update 2025-03-30T08:24:37 

Update 2025-03-30T15:39:47 

Update 2025-03-31T05:54:55 

Update 2025-03-31T13:08:11 

Update 2025-03-31T20:06:53 

Update 2025-04-01T02:57:34 

Update 2025-04-01T17:04:03 

Update 2025-02-02T07:14:23 

Update 2025-02-02T21:56:17 

Update 2025-02-03T04:25:24 

Update 2025-02-03T12:03:28 

Update 2025-02-03T18:54:45 

Update 2025-02-04T08:39:17 

Update 2025-02-04T23:43:04 

Update 2025-02-05T06:12:31 

Update 2025-02-05T13:12:42 

Update 2025-02-06T03:46:56 

Update 2025-02-06T10:34:47 

Update 2025-02-07T00:27:25 

Update 2025-02-07T07:51:26 

Update 2025-02-07T15:28:29 

Update 2025-02-08T05:09:55 

Update 2025-02-10T06:19:23 

Update 2025-02-10T20:40:32 

Update 2025-02-12T22:44:20 

Update 2025-02-13T05:04:54 

Update 2025-02-14T03:05:38 

Update 2025-02-15T13:42:31 

Update 2025-02-15T21:22:59 

Update 2025-02-17T01:19:20 

Update 2025-02-17T08:11:47 

Update 2025-02-18T05:49:12 

Update 2025-02-18T13:01:45 

Update 2025-02-18T20:01:21 

Update 2025-02-19T03:13:21 

Update 2025-02-21T19:18:14 

Update 2025-02-22T02:18:20 

Update 2025-02-22T23:08:34 

Update 2025-02-25T08:09:56 

Update 2025-02-25T14:58:39 

Update 2025-02-26T12:31:25 

Update 2025-02-27T02:19:35 

Update 2025-02-27T09:23:04 

Update 2025-02-27T16:26:53 

Update 2025-02-27T23:21:26 

Update 2025-02-28T06:24:06 

Update 2025-02-28T13:50:15 

Update 2025-02-28T21:13:09 

Update 2025-03-01T11:14:40 

Update 2025-03-01T18:23:34 

Update 2025-03-02T08:08:09 

Update 2025-03-04T02:32:34 

Update 2025-03-05T13:49:00 

Update 2025-03-05T20:48:24 

Update 2025-03-06T18:07:22 

Update 2025-03-10T07:07:51 

Update 2025-03-10T14:01:13 

Update 2025-03-11T11:25:01 

Update 2025-03-12T01:49:03 

Update 2025-03-12T23:31:16 

Update 2025-03-13T20:10:56 

Update 2025-03-14T03:20:33 

Update 2025-03-15T07:46:05 

Update 2025-03-15T14:32:57 

Update 2025-03-17T16:33:55 

Update 2025-03-18T21:06:29 

Update 2025-03-19T18:04:35 

Update 2025-03-20T00:47:08 

Update 2025-03-20T07:37:17 

Update 2025-03-20T14:55:50 

Update 2025-03-20T22:36:27 

Update 2025-03-21T05:03:28 

Update 2025-03-21T12:34:42 

Update 2025-03-22T02:17:12 

Update 2025-03-22T23:45:12 

Update 2025-03-24T03:43:43 

Update 2025-03-24T11:20:58 

Update 2025-03-26T05:17:51 

Update 2025-03-26T13:02:07 

Update 2025-03-26T19:43:19 

Update 2025-03-27T03:07:39 

Update 2025-03-27T10:07:01 

Update 2025-03-28T06:47:20 

Update 2025-03-29T12:01:23 

Update 2025-03-30T01:49:02 

Update 2025-03-30T15:22:15 

Update 2025-03-31T20:13:41 

Update 2025-04-01T02:57:04 

Update 2025-04-01T17:14:53 

Update 2025-02-02T00:05:00 

Update 2025-02-02T14:53:53 

Update 2025-02-03T04:52:55 

Update 2025-02-03T12:01:12 

Update 2025-02-03T18:37:29 

Update 2025-02-04T01:47:36 

Update 2025-02-04T08:48:16 

Update 2025-02-04T23:16:54 

Update 2025-02-06T03:19:27 

Update 2025-02-06T10:53:57 

Update 2025-02-07T00:54:37 

Update 2025-02-07T07:46:24 

Update 2025-02-07T14:40:59 

Update 2025-02-08T04:56:36 

Update 2025-02-09T02:32:44 

Update 2025-02-09T09:40:06 

Update 2025-02-09T23:34:20 

Update 2025-02-10T07:03:11 

Update 2025-02-10T14:06:24 

Update 2025-02-10T21:20:11 

Update 2025-02-11T10:59:15 

Update 2025-02-11T18:21:18 

Update 2025-02-12T07:52:15 

Update 2025-02-12T15:06:35 

Update 2025-02-13T05:04:08 

Update 2025-02-13T19:38:33 

Update 2025-02-14T17:26:15 

Update 2025-02-14T23:53:06 

Update 2025-02-16T18:36:03 

Update 2025-02-17T08:54:07 

Update 2025-02-17T15:33:47 

Update 2025-02-18T19:36:07 

Update 2025-02-19T03:23:41 

Update 2025-02-19T09:44:55 

Update 2025-02-19T17:44:32 

Update 2025-02-20T21:31:06 

Update 2025-02-21T18:25:29 

Update 2025-02-22T02:25:54 

Update 2025-02-23T13:47:20 

Update 2025-02-24T03:05:12 

Update 2025-02-24T10:46:19 

Update 2025-02-24T18:01:11 

Update 2025-02-25T08:11:22 

Update 2025-02-25T21:52:44 

Update 2025-02-26T12:08:13 

Update 2025-02-27T02:34:56 

Update 2025-02-28T14:03:49 

Update 2025-03-01T11:09:42 

Update 2025-03-01T18:15:00 

Update 2025-03-02T01:29:15 

Update 2025-03-02T15:40:24 

Update 2025-03-04T10:08:13 

Update 2025-03-04T23:30:30 

Update 2025-03-05T07:17:37 

Update 2025-03-05T20:54:07 

Update 2025-03-06T18:35:06 

Update 2025-03-07T01:07:24 

Update 2025-03-07T15:40:02 

Update 2025-03-07T22:55:58 

Update 2025-03-08T05:59:40 

Update 2025-03-09T03:21:42 

Update 2025-03-09T16:42:12 

Update 2025-03-10T07:21:25 

Update 2025-03-10T14:49:48 

Update 2025-03-10T21:28:26 

Update 2025-03-11T04:29:45 

Update 2025-03-11T11:36:17 

Update 2025-03-11T18:33:13 

Update 2025-03-12T16:11:22 

Update 2025-03-12T22:48:31 

Update 2025-03-13T06:34:17 

Update 2025-03-14T10:07:09 

Update 2025-03-15T21:42:50 

Update 2025-03-16T04:46:59 

Update 2025-03-16T19:33:24 

Update 2025-03-17T16:30:57 

Update 2025-03-17T23:36:23 

Update 2025-03-18T13:51:18 

Update 2025-03-19T03:18:59 

Update 2025-03-19T10:39:43 

Update 2025-03-20T01:23:10 

Update 2025-03-20T07:41:12 

Update 2025-03-20T15:37:17 

Update 2025-03-20T22:00:00 

Update 2025-03-21T05:30:43 

Update 2025-03-21T12:44:43 

Update 2025-03-22T09:52:53 

Update 2025-03-22T16:23:23 

Update 2025-03-23T00:07:51 

Update 2025-03-23T14:17:59 

Update 2025-03-24T17:46:30 

Update 2025-03-26T05:44:22 

Update 2025-03-26T19:31:15 

Update 2025-03-27T16:40:46 

Update 2025-03-28T13:54:18 

Update 2025-03-28T21:09:04 

Update 2025-03-29T11:18:10 

Update 2025-03-29T19:06:13 

Update 2025-03-30T08:27:36 

Update 2025-03-31T20:02:10 

Update 2025-04-01T17:04:35 

Update 2025-02-02T00:52:58 

Update 2025-02-03T05:03:06 

Update 2025-02-03T11:34:45 

Update 2025-02-04T02:11:36 

Update 2025-02-04T08:46:05 

Update 2025-02-04T16:00:44 

Update 2025-02-04T23:46:57 

Update 2025-02-05T06:10:12 

Update 2025-02-06T17:32:06 

Update 2025-02-07T00:55:03 

Update 2025-02-07T22:23:44 

Update 2025-02-09T02:13:51 

Update 2025-02-09T09:40:38 

Update 2025-02-09T23:21:43 

Update 2025-02-10T06:53:26 

Update 2025-02-11T11:15:19 

Update 2025-02-12T01:00:52 

Update 2025-02-12T15:25:21 

Update 2025-02-13T12:25:13 

Update 2025-02-14T16:40:01 

Update 2025-02-15T06:55:54 

Update 2025-02-15T21:07:58 

Update 2025-02-17T01:12:59 

Update 2025-02-17T08:48:56 

Update 2025-02-17T15:52:22 

Update 2025-02-18T06:21:39 

Update 2025-02-18T19:53:07 

Update 2025-02-19T03:26:19 

Update 2025-02-19T10:26:23 

Update 2025-02-20T14:34:10 

Update 2025-02-20T21:27:56 

Update 2025-02-21T05:10:09 

Update 2025-02-21T11:30:53 

Update 2025-02-22T02:08:52 

Update 2025-02-22T23:35:26 

Update 2025-02-23T06:25:44 

Update 2025-02-24T03:48:31 

Update 2025-02-24T10:52:24 

Update 2025-02-25T14:41:55 

Update 2025-02-25T22:25:56 

Update 2025-02-26T11:54:52 

Update 2025-02-27T16:18:22 

Update 2025-02-27T23:44:59 

Update 2025-02-28T21:02:35 

Update 2025-03-02T15:01:29 

Update 2025-03-02T22:34:16 

Update 2025-03-03T19:51:52 

Update 2025-03-04T02:47:23 

Update 2025-03-04T09:53:29 

Update 2025-03-05T00:17:20 

Update 2025-03-05T06:44:40 

Update 2025-03-05T21:37:24 

Update 2025-03-06T18:01:44 

Update 2025-03-07T08:44:03 

Update 2025-03-07T22:36:55 

Update 2025-03-08T20:15:07 

Update 2025-03-09T02:39:45 

Update 2025-03-09T23:51:22 

Update 2025-03-10T07:13:11 

Update 2025-03-10T21:29:18 

Update 2025-03-11T19:05:11 

Update 2025-03-12T09:18:38 

Update 2025-03-12T15:49:35 

Update 2025-03-12T22:52:28 

Update 2025-03-13T13:21:51 

Update 2025-03-13T20:22:45 

Update 2025-03-15T00:15:34 

Update 2025-03-15T07:13:57 

Update 2025-03-15T14:20:08 

Update 2025-03-16T11:38:50 

Update 2025-03-16T18:49:19 

Update 2025-03-17T08:53:28 

Update 2025-03-17T16:01:16 

Update 2025-03-17T23:47:57 

Update 2025-03-18T20:38:22 

Update 2025-03-20T15:31:55 

Update 2025-03-20T22:16:44 

Update 2025-03-21T05:41:56 

Update 2025-03-21T12:51:21 

Update 2025-03-22T02:39:25 

Update 2025-03-22T09:45:48 

Update 2025-03-23T06:38:21 

Update 2025-03-23T14:06:34 

Update 2025-03-24T04:01:11 

Update 2025-03-24T10:44:29 

Update 2025-03-24T18:17:50 

Update 2025-03-25T15:07:57 

Update 2025-03-26T12:52:02 

Update 2025-03-28T00:04:12 

Update 2025-03-29T04:56:41 

Update 2025-03-29T11:54:34 

Update 2025-03-30T01:32:44 

Update 2025-03-30T08:21:23 

Update 2025-03-30T15:50:40 

Update 2025-03-30T22:26:54 

Update 2025-03-31T06:01:23 

Update 2025-03-31T13:04:05 

Update 2025-03-31T19:47:02 

Update 2025-04-01T10:43:34 

Update 2025-04-01T17:01:21 

Update 2025-02-02T00:57:40 

Update 2025-02-02T07:16:08 

Update 2025-02-02T15:02:36 

Update 2025-02-02T22:06:24 

Update 2025-02-04T02:07:51 

Update 2025-02-04T16:11:04 

Update 2025-02-04T23:23:13 

Update 2025-02-06T10:28:52 

Update 2025-02-07T07:37:19 

Update 2025-02-07T15:01:11 

Update 2025-02-09T09:20:28 

Update 2025-02-09T16:25:55 

Update 2025-02-10T06:32:35 

Update 2025-02-10T21:12:56 

Update 2025-02-11T04:24:48 

Update 2025-02-11T17:44:56 

Update 2025-02-12T07:51:46 

Update 2025-02-13T05:39:55 

Update 2025-02-13T12:16:55 
