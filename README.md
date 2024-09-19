# Github Repo List View

## Technologies Used

- **SwiftUI**: For building the user interface.
- **Core Data**: For local data storage.
- **Combine Framework**: For handling asynchronous data streams.

## Localization

The project supports localization in both Turkish and English through a localizable file.

## Core Data Entities

The project uses Core Data with the following entities:
- **User**: Represents GitHub user details.
- **Repository**: Represents GitHub repository details.

## API Key Management

For security reasons, the GitHub API Key is not stored directly within the project. Instead, users are required to create a config file and set the `GITHUB_API_KEY` to access the API.

Here’s how to retrieve the API Key from the app's `Info.plist` file:
```swift
final class APIKeyManager {
    
    static let shared = APIKeyManager()
    
    private init() { }
    
    func getGithubAPIKey() -> String? {
        if let APIKey = Bundle.main.infoDictionary?["GITHUB_API_KEY"] as? String {
            return APIKey
        }
        return nil
    }
}
```

## Network Requests

The project makes use of the following network requests:
1. Fetch user data:
```swift
   networkManager.fetch(from: "/" + Path.users.rawValue + "/" + model.username, queryParameters: nil)
```
2. Fetch user repositories:
```swift
networkManager.fetch(from: "/" + Path.users.rawValue + "/" + model.username + "/" + Path.repos.rawValue,
                     queryParameters: ["per_page": "\(model.maxReposPerPage)",
                                       "page": "\(model.page)"])
```

## Repository Listing and Sorting

Users can list repositories with various columns and sort them based on:
- **Star Count**
- **Created At**
- **Updated At**

<img src="https://github.com/user-attachments/assets/28e4ca1c-7433-4679-83c2-e09761bbf932" width="200" alt="Screenshot">

## Testing

The project includes unit tests for the following components:

- **NetworkManagerTests**: Tests the `NetworkManager` class using mock data. Includes:
  - **`testFetchSuccess`**: Verifies successful data fetching from the mock API.
  - **`testPostSuccess`**: Verifies successful posting of data to the mock API.

- **SearchUserViewModelTests**: Tests the `SearchUserViewModel` class, covering:
  - **`testGetUserSuccess`**: Checks successful user retrieval and handling.
  - **`testGetUserFailure`**: Verifies the handling of user retrieval failure.
  - **`testSaveUserSuccess`**: Validates successful saving of user data to Core Data.
  - **`testSaveUserFailure`**: Tests the handling of save failure scenarios.

## Security

For security purposes, the API key is not stored directly in the project. Users must manage their own API key through a configuration file. Other potential security concerns include:

- **Core Data**: Core Data does not encrypt data by default. Therefore, storing sensitive information in Core Data without encryption can expose it if the device is compromised.
## To Do

- **Unit Tests**: Add more unit tests to cover additional scenarios and edge cases.
- **Logging**: Implement comprehensive logging to track application behavior and errors for better debugging and monitoring.
