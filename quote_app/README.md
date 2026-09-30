# Random Quote Generator

A clean, minimal Flutter app that shows a random quote every time you open it. Save the quotes you love to Favorites, and use it on **Android, iOS, and Web**.

## Features

- **Random quote on launch**: text and author shown instantly
- **New Quote button**: fetch another quote with one tap
- **Keyboard shortcut (desktop/web)**: press **Space** to get a new quote
- **Favorites**: tap the heart to save a quote and view all saved quotes in the Favorites screen
- **Remove from favorites**: unfavorite from the quote screen or the Favorites list
- **Offline favorites**: saved quotes are stored locally with Drift (SQLite), so they stay available without internet
- **Settings screen**
- **Cross-platform**: runs on mobile and web

## Tech Stack

| Area | Technology |
|------|-----------|
| Framework | Flutter |
| Local database | Drift (SQLite) |
| Networking | Dio |
| State management | Providers (`core/providers.dart`) |
| Architecture | Feature-based, with data / logic / UI separated |

## Getting Started

### Prerequisites
- Flutter SDK (stable channel)
- VS Code or Android Studio

### Installation

```bash
git clone <your-repo-url>
cd <project-folder>
flutter pub get
```

### Generate Drift code

```bash
dart run build_runner build --delete-conflicting-outputs
```

### Run

```bash
# Mobile (connected device or emulator)
flutter run

# Web
flutter run -d chrome
```

### Build for web

```bash
flutter build web
```

## Usage

| Action | Mobile | Web / Desktop |
|--------|--------|---------------|
| New quote | Tap **New Quote** | Tap **New Quote** or press **Space** |
| Add to favorites | Tap the heart icon | Click the heart icon |
| View favorites | Open the Favorites tab | Open the Favorites tab |

## Web Support Notes

Drift needs extra setup on web (WASM/SQLite worker files in the `web/` folder). If favorites don't persist in the browser, check that `sqlite3.wasm` and the Drift worker are present in `web/` and match your package versions. See the [Drift web docs](https://drift.simonbinder.eu/platforms/web/).

## Project Structure

```
lib/
├── core/
│   ├── database/
│   │   ├── tables/
│   │   │   └── quotes_table.dart      # Quotes table definition
│   │   ├── app_database.dart          # Drift database class
│   │   └── app_database.g.dart        # Generated
│   ├── network/
│   │   └── dio_client.dart            # Dio HTTP client setup
│   └── providers.dart                 # App-wide providers
├── features/
│   └── quotes/
│       ├── data/
│       │   ├── quotes_api.dart        # Fetches quotes from the API
│       │   ├── quotes_dao.dart        # Database queries (favorites)
│       │   ├── quotes_dao.g.dart      # Generated
│       │   └── quotes_repository.dart # Combines API + local DB
│       ├── logic/
│       │   ├── quote_controller.dart      # Current quote, new quote
│       │   └── favorites_controller.dart  # Add / remove / list favorites
│       └── ui/
│           ├── home_shell.dart        # Navigation shell
│           ├── quote_screen.dart      # Main quote view + Space shortcut
│           ├── favorites_screen.dart  # Saved quotes list
│           └── settings_screen.dart   # Settings
├── app.dart                           # MaterialApp setup
└── main.dart                          # Entry point (kept minimal)
```

## Architecture

- **Data layer**: API client, DAO, and repository. The repository is the single source of truth for the UI.
- **Logic layer**: controllers hold state and business logic, with no UI code.
- **UI layer**: screens only display state and forward user actions.

This keeps `main.dart` minimal and each file focused on one job.

## Roadmap

- [ ] Share quote
- [ ] Copy quote to clipboard
- [ ] Dark / light theme toggle in Settings

## License

This project is for learning and internship purposes.