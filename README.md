# Building an iOS App with Rick and Morty API

The project was built with the following:

- UIKit with programmatic UI (no Storyboards except LaunchScreen)
- URLSession with completion handlers
- MVVM with service layer
- Image caching via NSCache
- Unit testing with CI/CD via GitHub Actions

API [documentation](https://rickandmortyapi.com/documentation) for Rick and Morty:

- base URL: `https://rickandmortyapi.com/api`
- endpoints used: `/character` `/episode` `/location`
- no authentication required

## Features

- TabBar with Characters, Episodes, Locations and Settings tabs
- List screens with infinite pagination
- Detail screens with full character info, episodes, and locations
- Search with dynamic filters (status, gender, location type)
- Settings screen built with SwiftUI embedded in UIKit
- Adaptive UI for light and dark mode
- CI/CD pipeline with GitHub Actions — build and unit tests on every push

## Characters

List of all characters with status color indicator, pagination, and search with filters by status and gender.

<p float="left">
  <img width="369" height="800" alt="Image" src="https://github.com/user-attachments/assets/4430caf3-4fed-4306-9cf9-8b3c20bff8bf" />
  &nbsp; &nbsp; &nbsp;
  <img width="369" height="800" alt="Image" src="https://github.com/user-attachments/assets/d35d4258-fcdc-40e2-8d79-5c436d4096f2" />
</p>


## Episodes

List of all episodes with pagination, detail screen showing all characters in the episode.

<p float="left">
  <img width="369" height="800" alt="Image" src="https://github.com/user-attachments/assets/df8d3fb1-244e-4567-b4b9-ac7799d064cf" />
  &nbsp; &nbsp; &nbsp;
  <img width="369" height="800" alt="Image" src="https://github.com/user-attachments/assets/c69bbc58-f6c0-4524-aebf-b062e4985b44" />
</p>

## Locations

List of all locations with pagination, detail screen showing all residents.

<p float="left">
  <img width="369" height="800" alt="Image" src="https://github.com/user-attachments/assets/87e1124f-fcb7-4f72-b882-e828777f239c" />
  &nbsp; &nbsp; &nbsp;
  <img width="369" height="800" alt="Image" src="https://github.com/user-attachments/assets/5f531391-166f-44c0-bb6d-52d7dff54c13" />
</p>

## Search

Search across characters, episodes, and locations with dynamic filter buttons per category.

<p float="left">
  <img width="369" height="800" alt="Image" src="https://github.com/user-attachments/assets/649c34b5-eca3-4598-91ff-0add84b2ca20" />
  &nbsp; &nbsp; &nbsp;
  <img width="369" height="800" alt="Image" src="https://github.com/user-attachments/assets/f88774ef-be51-4eea-8d79-b85d17dc946b" />
</p>

## Settings

Settings screen built with SwiftUI, embedded into UIKit via `UIHostingController`.

<img width="369" height="800" alt="Image" src="https://github.com/user-attachments/assets/30d8dbf8-da78-4ae4-8345-a94e84a6dc5c" />

## Architecture

`APIClient` — RMRequest, RMService, RMEndpoint  
`Controllers` — UIViewControllers (Core + Other)  
`Views` — UIViews, UICollectionViewCells, UITableViewCells  
`ViewModels` — One ViewModel per View  
`Models` — Codable data models  
`Managers` — RMImageLoader, RMAPICacheManager

## CI/CD

GitHub Actions runs on every push to `main` and `feature/*` branches:
- Builds the project for iOS Simulator
- Runs unit tests

## Unit Tests

Tests cover the most critical logic:
- URL building for all endpoints and query parameters
- Search options and query arguments per category
- Character status text and color
- Date formatting for character detail view
