# Frontend

Flutter web project placeholder for *오늘점심 뭐 먹지*.

## Project Structure
- `lib/screens`
- `lib/widgets`
- `lib/services/apis`

## Setup

A full Flutter environment is required to build and run this project.

```
flutter create .
```

> Note: Flutter SDK is not installed in this environment. This directory contains a placeholder structure.

## Banner Guidelines

- Use `BannerPlaceholder` (`lib/widgets/banner_placeholder.dart`) as the `bottomNavigationBar` of major screens to reserve space for ads.
- Replace this widget with a real banner implementation when integrating advertising.
## Deployment

To build and host the web app:

1. Install the Flutter SDK and ensure `flutter` is on your `PATH`.
2. Build the static site:

   ```bash
   flutter build web
   ```

   This generates the compiled site in `build/web`.
3. Install the [Vercel CLI](https://vercel.com/docs/cli):

   ```bash
   npm install -g vercel
   ```

4. Deploy the compiled site:

   ```bash
   vercel deploy --prod build/web
   ```

   The CLI will prompt you to link a project and will upload the contents of `build/web` to Vercel.
