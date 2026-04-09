# CarSearch

A SwiftUI iOS app that allows users to search for cars available for rent in cities across the Netherlands, Germany, and Sweden using the SnappCar API.

## How It Works

1. **Search for a city** — Type a city name in the search field. After 500ms of inactivity, matching cities appear in a dropdown. Selecting a city triggers a car search.
2. **Apply filters** — Use the distance picker (3 km, 5 km, 7 km) and sort picker (Price, Recommended, Distance) to refine results. Changing a filter automatically refreshes the list.
3. **Scroll for more** — As you scroll through results, new pages of 10 cars are fetched automatically before you reach the end of the list (prefetch threshold of 3 items).

## Third party

To have as little dependencies as possible, I tried to develop the app only using Apple's framework packages like 'Foundation' and 'SwiftUI'.

- **Kingfisher** is used for efficient image downloading and caching, ensuring smooth performance when loading car images in the app.
- **Pulse** is integrated for logging network requests and responses, which helps in debugging and monitoring the app's interactions with the SnappCar API.
