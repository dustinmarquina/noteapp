# Note App (Provider)

DEMO:


https://github.com/user-attachments/assets/5fca4fef-4b42-4d60-8c30-2eb3722045c4


Simple Flutter notes app demonstrating app-wide state management with Provider and ChangeNotifier.

Features

- Create, edit, delete notes
- Real-time updates using Provider + ChangeNotifier
- TextField for input and FloatingActionButton to add notes

Run locally

1. Ensure you have Flutter installed: https://flutter.dev/docs/get-started/install
2. From the project root run:

```bash
flutter pub get
flutter run
```

Files added

- `lib/main.dart` — app entry + provider wiring
- `lib/models/note.dart` — Note model
- `lib/providers/note_provider.dart` — ChangeNotifier provider (add, update, delete)
- `lib/screens/home_screen.dart` — list of notes + delete
- `lib/screens/edit_note_screen.dart` — create / edit UI
- `pubspec.yaml` — includes `provider` dependency

Notes

- I used a simple timestamp-based id for notes. For production consider UUIDs or database ids.
- I didn't add persistence (shared_preferences / sqlite). If you'd like, I can add local persistence next.
- Notes are now persisted locally using `shared_preferences`. Notes survive app restarts.
- The provider automatically loads saved notes on startup and saves on changes.

Next steps (optional)

- Add persistence (sqflite / hive / shared_preferences)
- Add search and sorting
- Add tests
# noteapp
