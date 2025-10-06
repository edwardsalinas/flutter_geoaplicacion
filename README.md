# Flutter Geolocation App

This Flutter application displays two geographic locations (home and work) on a map using Google Maps integration. The app demonstrates secure handling of API keys using environment variables.

## Features

- Displays two geographic locations (home and work) on a map
- Uses Google Maps Flutter plugin
- Securely manages API keys using environment variables
- Properly configured .gitignore to prevent sensitive data exposure

## Security Implementation

- API key is stored in `api_key.env` file which is excluded from Git
- Geographic coordinates are stored in `coordinates.env` which is included in Git
- The .gitignore file specifically excludes `api_key.env` while allowing `coordinates.env`

## Setup Instructions

1. Create a Google Maps API key from the Google Cloud Console
2. Update `api_key.env` with your actual API key:
   ```
   GOOGLE_MAPS_API_KEY=your_actual_api_key_here
   ```
3. Update the coordinates in `coordinates.env` if desired:
   ```
   HOME_LAT=-33.4489
   HOME_LNG=-70.6693
   WORK_LAT=-33.4295
   WORK_LNG=-70.6033
   ```

## Platform-specific Configuration

### Android
- Add the API key to `android/app/src/main/AndroidManifest.xml`
- Add the following inside the `<application>` tag:
  ```xml
  <meta-data android:name="com.google.android.geo.API_KEY"
             android:value="YOUR_ANDROID_GOOGLE_MAPS_API_KEY" />
  ```

### iOS
- Update `ios/Runner/AppDelegate.swift` with your API key:
  ```swift
  GMSServices.provideAPIKey("YOUR_IOS_GOOGLE_MAPS_API_KEY")
  ```

## Important Security Notes

- The `api_key.env` file is intentionally excluded from Git via .gitignore
- Never commit API keys or other sensitive information to the repository
- The `coordinates.env` file is included in Git as it doesn't contain sensitive information
- Always verify that sensitive files are not being tracked by running: `git ls-files | grep -i key`