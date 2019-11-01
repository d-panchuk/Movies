# Movies

Application to discover, search and bookmark movies.  
It's iOS application working with [The Movie DB API](https://www.themoviedb.org/documentation/api).

## Flows
* **Discover**: get familiar with movies of 4 categories in horizontal or vertical scrolling list views; navigate to movie details.
* **Search**: search movie by keyword, keep search history; navigate to movie details.
* **My Lists**: observe movies of 3 lists – Watched, Favorite and Watch Later – which you fill during discovering and searching; navigate to movie details.
* **Movie Detail**: check out extended information about specific movie; add movie to specific list.

## Architecture
* MVVM as the main design pattern
* RxSwift & RxCocoa for binding between View and ViewModel layers
* Coordinators to separate navigation logic from View and ViewModel layers
* CoreData and UserDefaults for data caching and persistence
* Network layer with the ability to flexibly change implementations

## Third-party dependencies
- [RxSwift](https://github.com/ReactiveX/RxSwift) — Reactive Programming in Swift.
- [RxCocoa](https://github.com/ReactiveX/RxSwift/tree/master/RxCocoa) — Reactive Programming in Swift.
- [Kingfisher](https://github.com/onevcat/Kingfisher) — A lightweight, pure-Swift library for downloading and caching images from the web.

## Demo

#### Discover  
![](discover-part1.gif)
![](discover-part2.gif)

#### Search  
![](search.gif)

#### My Lists  
![](my-lists.gif)
