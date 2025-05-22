# practical_khazana

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.


## Getting Started with Project

File structure:
```
lib
├── main.dart
├── modules -- screens/features
│   └── screens
├── controllers -- controller to manage business logic
│   └── controllers
├── api_services
│   ├── api_service.dart -- API service
│   └── test_service.dart -- Test Unit Testing
├── models -- data models
│   └── models
├── bindings
│   ├── constants.dart
│   └── theme.dart
├── routes -- routing
│   ├── app_pages.dart
│   └── app_routes.dart
├── config -- configuration
│   └── theme.dart
└── 
```
- `main.dart`: The entry point of the application.
- `modules`: Contains the screens and features of the application.
- `controllers`: Contains the controllers that manage the business logic of the application.
- `api_services`: Contains the API service and test unit testing.
- `models`: Contains the data models used in the application.
- `bindings`: Contains the constants and theme configuration.
- `routes`: Contains the routing configuration of the application.
- `config`: Contains the configuration files for the application.
- `assets`: Contains the assets used in the application.
- `pubspec.yaml`: Contains the dependencies and configuration for the Flutter project.

The API is built using Python Flask with Flask-CORS for handling cross-origin requests.
It performs web scraping to fetch data and serves it in JSON format to the Flutter application.

## Note:
This API currently runs on local machine. Therefore, data fetching from the web scraping service will not function on other devices unless the API is deployed to a publicly accessible server.

Some screens or features relying on live-scraped data might not display content when accessed externally.


## 📋 Features & Requirements
🔐 User Authentication (Supabase)
Implement Login/Signup screens using Supabase Authentication.

On successful login, navigate the user to the Dashboard.

Securely store the user session and maintain login state across app restarts.

📊 Dashboard
The Dashboard consists of two primary sections:

Fund Performance

A detailed view of a selected mutual fund (Round 1 implementation).

My Watchlist

A list of user-added mutual funds for quick tracking.

📈 Mutual Fund Performance Analytics (Charts)
When a user selects a mutual fund:

Display a Line Chart showing NAV trends over time.

Allow switching between different date ranges (e.g., 1M, 3M, 6M, 1Y, 5Y). Allow Filtering by time period.

🗺️ State Management & Navigation

Getx is used for state management and navigation.

Ensure:

Smooth screen transitions.

Loading indicators during async operations.

Navigation backstack management.

📌 Mutual Fund Watchlist Feature
Allow users to:

Create multiple watchlists, each with a unique name.

Each watchlist can only contain mutual funds (no stocks or other assets).

Add and remove funds from watchlists.

Persist watchlists using Hive or SharedPreferences for offline support.

Fetch mutual fund data (like NAV, returns, AUM) from a local JSON file.

Enable basic UI interactions:

Swipe to delete a fund from a watchlist.

Tap to view a fund’s detailed performance.

Show a heatmap feature representing fund returns or AUM visually across funds.