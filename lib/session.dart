class SessionData {
  static final SessionData _instance = SessionData._internal();
  factory SessionData() => _instance;
  SessionData._internal();

// Shared app state will go here later
}