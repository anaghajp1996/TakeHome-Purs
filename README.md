# TakeHome-Purs

## Tech Specifications

- Xcode
- Swift
- SwiftUI

## Installation

### Steps to set up and run the project:

#### Clone the Repository:

https://github.com/anaghajp1996/TakeHome-Purs.git

#### Open Project in Xcode:

- Launch Xcode.
- Open the .xcodeproj file located in the repository.
- Go to the project settings by clicking on the project file in the left sidebar.
- Select the target and navigate to the "Deployment Info" section.
- Set the "Deployment Target" to iOS 17.
- In the "Signing and Capabilities" section, choose the desired team.

#### Build and Run:

Choose a simulator or connect a device with iOS 17 installed. Press the play button (or ⌘ + R) in Xcode to build and run the project.

### Architecture

The project follows the MVVM pattern.
- Networking is handled in a separate "Network" file
- All UI components can be found in the View folder
- The ViewModel folder contains files that handle how data from the backend is displayed in the UI
- The Model folder contains all the models used through the project- Business, Hours, and Timings
