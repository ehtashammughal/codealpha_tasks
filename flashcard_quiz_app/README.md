# 📚 Flashcard App

A clean and responsive Flutter-based flashcard application designed to help users create, manage, and review their own flashcards.

The application provides a simple learning experience where users can create flashcards containing questions and answers, navigate between cards, and manage their flashcard collection through CRUD operations.

---

## ✨ Features

- 📖 **Flashcard Learning**
  - View questions and reveal their answers.
  - Navigate between flashcards using Next and Previous controls.

- ➕ **Create Flashcards**
  - Add custom questions and answers.
  - Input validation to prevent empty flashcards.

- ✏️ **Edit Flashcards**
  - Update existing questions and answers.

- 🗑️ **Delete Flashcards**
  - Remove flashcards from the collection.

- 💾 **Local Database**
  - Flashcards are stored locally using **Drift (SQLite)**.
  - Data remains available after restarting the application.

- 🌐 **Web Support**
  - Runs in the browser using Flutter Web.
  - Uses Drift's WebAssembly-based SQLite support.

- 📱 **Responsive UI**
  - Designed to work across different screen sizes.
  - Clean and simple interface for a focused learning experience.

---

## 🛠️ Technologies Used

| Technology | Purpose |
|------------|---------|
| Flutter | Application framework |
| Dart | Programming language |
| Drift | Local database and ORM |
| SQLite | Local data storage |
| WebAssembly | SQLite support on Flutter Web |
| Git & GitHub | Version control and project hosting |

---
# Project Structure

```
lib/
├── database
│   ├── daos
│   │   ├── flashcard_dao.dart
│   │   └── flashcard_dao.g.dart
│   ├── database_connection
│   │   ├── native.dart
│   │   ├── shared.dart
│   │   ├── unsupported.dart
│   │   └── web.dart
│   ├── tables
│   │   └── flashcards_table.dart
│   ├── app_database.dart
│   └── app_database.g.dart
├── app_preferences.dart
├── app_theme.dart
├── flashcard_stack.dart
├── flashcard.dart
├── homepage.dart
├── main.dart
└── setting.dart
```
