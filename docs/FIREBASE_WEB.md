# Firebase Web Configuration

This app uses Firebase (Firestore, Storage) on web. Follow this checklist to ensure it works.

## 1. Project setup (already done)

- `lib/firebase_options.dart` – contains web config (apiKey, appId, projectId, etc.)
- `lib/main.dart` – initializes Firebase with `DefaultFirebaseOptions.currentPlatform`
- `web/index.html` – includes Firebase JS SDK scripts (app, firestore, storage)

## 2. Firebase Console – Web app

1. Open [Firebase Console](https://console.firebase.google.com/) → your project **task-60403**.
2. **Project settings** (gear) → **General** → under "Your apps" you should see a **Web** app with App ID like `1:284225918938:web:7c50a1186c8d28c848d2e3`.
3. If there is no web app, click **Add app** → **Web** and register the app; then run `dart run flutterfire_cli:flutterfire configure` and select Web to regenerate `firebase_options.dart`.

## 3. Authorized domains (required for web)

1. In Firebase Console go to **Authentication** → **Settings** → **Authorized domains**.
2. Ensure these are listed:
   - `localhost` (for `flutter run -d chrome`)
   - Your production domain (e.g. `your-app.web.app` or custom domain)

Without these, Firebase will block requests from the browser.

## 4. Firestore rules

1. Go to **Firestore Database** → **Rules**.
2. For development you can use:

   ```
   rules_version = '2';
   service cloud.firestore {
     match /databases/{database}/documents {
       match /{document=**} {
         allow read, write: if request.auth != null;
       }
     }
   }
   ```

   For a dashboard with no auth, you might temporarily allow read/write for testing (then lock down with proper rules):

   ```
   allow read, write: if true;
   ```

3. Click **Publish**.

## 5. Storage rules (if using Firebase Storage)

1. Go to **Storage** → **Rules**.
2. Adjust rules as needed for your app (e.g. allow read/write for authenticated users or for testing).

## 6. Run on web

```bash
flutter run -d chrome
```

Or build:

```bash
flutter build web
```

Then serve the `build/web` folder (e.g. with Firebase Hosting or any static host).

## 7. Regenerating config

If you add a new platform or change Firebase project:

```bash
dart run flutterfire_cli:flutterfire configure
```

This updates `lib/firebase_options.dart` and keeps web (and other platforms) in sync.

---

## 8. Hosting the dashboard on Firebase

The project is set up for **Firebase Hosting**. Your app will be available at `https://task-60403.web.app` (and `https://task-60403.firebaseapp.com`).

### One-time setup

1. **Install Firebase CLI** (if not already):
   ```bash
   npm install -g firebase-tools
   ```
2. **Log in** to your Google account:
   ```bash
   firebase login
   ```
3. **Confirm project** – `.firebaserc` is already set to project `task-60403`. To use another project:
   ```bash
   firebase use task-60403
   ```

### Deploy

1. **Build** the Flutter web app:
   ```bash
   flutter build web --no-tree-shake-icons
   ```
   This creates the `build/web` folder. (We use `--no-tree-shake-icons` to avoid the icon font subsetting step that can fail on some systems.)

2. **Deploy** to Firebase Hosting:
   ```bash
   firebase deploy
   ```
   Or deploy only hosting (skip other Firebase features):
   ```bash
   firebase deploy --only hosting
   ```

3. After deploy, open:
   - **Hosting URL**: https://task-60403.web.app  
   (or the URL shown in the terminal)

### Optional: one-command deploy

From the project root you can run:

```bash
./scripts/deploy.sh
```

Or manually:

```bash
flutter build web --no-tree-shake-icons && firebase deploy --only hosting
```

### Add your domain to Authorized domains

After the first deploy, add the Hosting domain to Firebase so the app can use Firestore/Storage from production:

1. **Authentication** → **Settings** → **Authorized domains**.
2. Add:
   - `task-60403.web.app`
   - `task-60403.firebaseapp.com`
   (and any custom domain you attach later in Hosting).
