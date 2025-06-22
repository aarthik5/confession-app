# 🕶️ Anonymous Confession Wall App
A stylish and secure full-stack Flutter application that allows users to anonymously post confessions, interact with posts, and manage flagged content with a dedicated moderator panel. Built using **Flutter (Dart)** and **Firebase (Auth + Firestore)**.

## 🚀 Features
### 👤 User Module
- 🔐 Login / Signup with Firebase Authentication
- 🕵️ Anonymous posting with UUID
- ❤️ Like posts
- 🚩 Flag inappropriate content (3 flags = auto-hide)
- ⏱️ Time-ago display for each post

### 🛡️ Admin / Moderator Panel
- 🔑 Access via `admin@confess.com`
- 🔍 View highly flagged posts
- 🗑️ Delete posts with confirmation prompt
- 
## 🎨 UI Highlights
- Dark neon-glass inspired theme  
- Gradient cards, animated interactions  
- Consistent color scheme:
  - Background: `#0D0F23`
  - Cards: `#2D2D54 → #191927`
  - FAB: `purpleAccent`
  - Icons: `greenAccent / redAccent / cyanAccent`
  - 
## 📦 Tech Stack
- **Frontend**: Flutter (Dart)
- **Backend**: Firebase (Auth, Firestore)
- **Packages Used**:
  - `firebase_core`
  - `firebase_auth`
  - `cloud_firestore`
  - `uuid`
  - `timeago`

## 🛠️ Setup Instructions
flutter pub get

flutterfire configure

flutter run

✍️ Author
	•	👨‍💻 Developed by Aarthik
	•	🔗 GitHub Profile

📄 License
This project is licensed under the MIT License.
