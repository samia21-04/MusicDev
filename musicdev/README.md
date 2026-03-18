# Adaptive Focus Studio & Mood Soundscapes

A Flutter app that helps users stay focused while studying or working 
through personalized soundscapes and Pomodoro-style focus sessions.

## Features
- Personalized focus sessions based on mood and energy level
- Pomodoro timer with adaptive breaks
- Soundscape builder with AI Focus DJ
- Productivity analytics and charts
- Saved session blueprints and audio presets

## Screens
- Home Screen
- Focus Session Screen
- Soundscape Builder
- Analytics
- Settings

## Setup Instructions
1. Clone the repo: `git clone https://github.com/samia21-04/AdaptiveFocusStudio.git`
2. Navigate into the folder: `cd AdaptiveFocusStudio`
3. Install dependencies: `flutter pub get`
4. Run the app: `flutter run`

## Dependencies
- sqflite — local SQLite database
- shared_preferences — user settings storage
- just_audio — background sound playback
- fl_chart — analytics charts
- provider — state management

## Known Issues / Limitations
- Audio files require manual addition to assets/sounds/ folder
- AI Focus DJ uses rule-based logic (no external API)