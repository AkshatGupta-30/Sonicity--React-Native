# Sonicity [![MIT License](https://img.shields.io/badge/License-MIT-green.svg)](https://github.com/AkshatGupta-30/Sonicity--Flutter/blob/main/LICENSE)  
Sonicity is a React Native-based mobile application that leverages the JioSaavn API to provide users with an immersive audio experience. The project is structured to offer a seamless and intuitive user interface, making it easy for users to navigate through different functionalities such as browsing, searching, and playing music tracks available via the JioSaavn API.

----

# Screenshots
| Splash Screen | Home Screen | Queue Screen | Settings Screen | Search Songs Screen |
| --- | --- | --- | --- | --- |
| <img src="https://github.com/AkshatGupta-30/Sonicity--Flutter/blob/main/assets/screenshots/splashScreen.jpg" alt="Splash Screen" height="300"> | <img src="https://github.com/AkshatGupta-30/Sonicity--Flutter/blob/main/assets/screenshots/homeScreen.jpg" alt="Home Screen" height="300" width="135"> | <img src="https://github.com/AkshatGupta-30/Sonicity--Flutter/blob/main/assets/screenshots/queueScreen.jpg" alt="Queue Screen" height="300" width="135"> | <img src="https://github.com/AkshatGupta-30/Sonicity--Flutter/blob/main/assets/screenshots/settingsScreen.jpg" alt="Settings Screen" height="300" width="135"> | <img src="https://github.com/AkshatGupta-30/Sonicity--Flutter/blob/main/assets/screenshots/searchSongScreen.jpg" alt="Search Songs Screen" height="300" width="135"> |

| Mini Player |
| --- |
| <img src="https://github.com/AkshatGupta-30/Sonicity--Flutter/blob/main/assets/screenshots/miniPlayer.jpg" alt="Mini Player" height="135" width="720"> |

| Search Albums Screen | Main Player | Lyrics Screen | Playlist Screen |
| --- | --- | --- | --- |
| <img src="https://github.com/AkshatGupta-30/Sonicity--Flutter/blob/main/assets/screenshots/searchAlbumScreen.jpg" alt="Search Albums Screen" height="300" width="135"> | <img src="https://github.com/AkshatGupta-30/Sonicity--Flutter/blob/main/assets/screenshots/mainPlayer.jpg" alt="Main Player" height="300" width="135"> | <img src="https://github.com/AkshatGupta-30/Sonicity--Flutter/blob/main/assets/screenshots/lyricsScreen.jpg" alt="Lyrics Screen" height="300" width="135"> | <img src="https://github.com/AkshatGupta-30/Sonicity--Flutter/blob/main/assets/screenshots/playlistScreen.jpg" alt="Playlist Screen" height="300" width="135"> |

----

<details>
<summary>Table of content</summary>

# Table of contents  
- [Features](#features)
- [Technical Stack](#technical-stack)
- [Dependencies](#dependencies-used)
- [Installation](#installation)
  - [Prerequisites](#prerequisites)
  - [Clone the Repository](#clone-the-repository)
  - [Configuration](#install-dependencies)
  - [Build and Run](#build-and-run)
- [Folder Structure](#folder-structure)
- [Contributing](#contributing)
- [Special Thanks](#special-thanks)
- [License](#license)
- [Conclusion](#conclusion)
</details>

----

## Features
- **State Management:** The project uses the GetX package for state management, routing, and dependency injection, making it easier to manage the state across different parts of the application without boilerplate.
- **Modular Architecture:** The application is structured into modules like audio, controllers, and views, promoting a clean architecture that separates concerns and enhances maintainability.
- **Playback Controls**: play, pause, stop, skip forward, skip backward, shuffle, repeat, volume control.
- **Media Library:** organize and browse music files.
- **Playlist Management:** create, edit, and manage playlists.
- **Search Functionality:** search for specific songs, albums, artists, or playlists.
- **Metadata Display:** display song title, artist, album, artwork, etc.
- **Lyrics Display:** show synchronized lyrics.
- **Crossfade:** smooth transition between songs.
- **Gapless Playback:** seamless playback between tracks.
- **Smart Queues:** automatically generated queues.
- **Customization Options:** customize UI, themes, etc.
- **Background Playback:** continue playback when app is in background.
- **Song Recommendations:** Personalized recommendations based on current song.

----

## Technical Stack:
- **Flutter:** For building a cross-platform mobile application.
- **GetX:** Used for state management, routing, and dependency injection.
- **JioSaavn API:** For accessing a wide range of music content.

----

## Dependencies Used
| [audio_service](https://pub.dev/packages/audio_service) | [audioplayers](https://pub.dev/packages/audioplayers) | [clipboard](https://pub.dev/packages/clipboard) | [get](https://pub.dev/packages/get) | [get_it](https://pub.dev/packages/get_it) | [http](https://pub.dev/packages/http) | [just_audio](https://pub.dev/packages/just_audio) |
| --- | --- | --- | --- | --- | --- | --- |
| [**path_provider**](https://pub.dev/packages/path_provider) | [**rxdart**](https://pub.dev/packages/rxdart) | [**shared_preferences**](https://pub.dev/packages/shared_preferences) | [**shimmer**](https://pub.dev/packages/shimmer) | [**sleek_circular_slider**](https://pub.dev/packages/sleek_circular_slider) | [**sliver_tools**](https://pub.dev/packages/sliver_tools) | [**sqflite**](https://pub.dev/packages/sqflite) |

----

## Installation
Follow these steps to install and run Sonicity on your system.

### Prerequisites
Before you begin, ensure you have the following dependencies and tools installed:
- Flutter SDK: [Installation Guide](https://flutter.dev/docs/get-started/install)
- Dart SDK
- [Dependencies](#dependencies-used)

### Clone the Repository
1. Open your terminal or command prompt.
2. Use the following command to clone the ProjectName repository:
```git clone https://github.com/AkshatGupta-30/Calculator--Flutter.git```

### Install Dependencies
- Run the following command to install the required dependencies:
~~~bash
flutter pub get
~~~

### Build and Run
1. Connect your device or start an emulator.
2. To build and run the project, use the following command:
~~~bash
flutter run
~~~

This will build the project and install it on your connected device or emulator.

----

## Folder Structure
#### Here is the core folder structure which flutter provides.
```
sonicity/
|- android
|- assets
|- ios
|- lib
|- linux
|- macos
|- web
|- windows
```

#### Now, lets dive into the lib folder which has the main code for the application.
```
lib/
|- src/
|- utils/
|- main.dart
```

#### Src
This directory contains all the application level constants. The folder structure is as follows: 
```
src/
|- audio/
|- controllers/
|- database/
|- models/
|- services/
|- sprefs/
|- views/
```
- **audio** - This folder conatins all the files required for audio.
- **controllers** - This folder containes Getx Controllers for different views.
- **database** - Contains all the database files used. For example, Starred Database, Recents Database etc..
- **models** - Contains all the models of the applications. For example, Song, Album, Artist, Playlist etc.
- **services** - Contains all the files for api calls.
- **sprefs** - Contains all Shared Preferences files.
- **views** - This folder is the main folder that contains the ui for the pages.

#### Utils
This directory contains the common file(s) and utilities used in a project. The folder structure is as follows: 
```
utils/
|- constants/
|- sections/
|- widgets/
```
- **constants** - This directory contains all the application level constants.
- **sections** - Contains sections that are shared in one screen to make code compact.
- **widgets** - Contains the common widgets that are shared across multiple screens. For example, ListTile, Pop Up Buttons, Shimmers, etc.

----

## Contributing
We welcome contributions to ProjectName. If you would like to contribute to the development or report issues, please follow these guidelines:
1. Fork the repository.
2. Create a new branch for your feature or bug fix.
3. Make your changes and commit them with descriptive messages.
4. Push your changes to your fork.
5. Submit a pull request to the main repository.

---

## Special Thanks
We would like to extend our heartfelt gratitude to [saavn.dev](https://github.com/sumitkolhe/jiosaavn-api.git) for providing access to its free API, which has been instrumental in the development of Sonicity. This project leverages the JioSaavn API to offer a vast library of music and audio content, enriching the user experience by providing high-quality songs and playlists.  
A special mention to the GitHub repository [JioSaavn-API](https://github.com/sumitkolhe/jiosaavn-api.git) for making the unofficial JioSaavn API accessible and easy to integrate. The open-source community around this project has been incredibly supportive, contributing to the continuous improvement and reliability of the API.  
The collaboration and resources provided by these platforms have been invaluable to the success and functionality of Sonicity. We are immensely thankful for their contribution to the open-source community and their support in fostering innovation in music streaming applications.

----

## License
Sonicity is licensed under the [**MIT License**](https://github.com/AkshatGupta-30/Sonicity--Flutter/blob/main/LICENSE)

----

## Conclusion  
Thank you for choosing Sonicity! If you encounter any issues or have suggestions for improvements, please don't hesitate to [create an issue](https://github.com/AkshatGupta-30/Sonicity--Flutter/issues) or [contribute to the project](#contributing). We look forward to your feedback and collaboration.
