//
//  CoreDataManager.swift
//  Movies
//
//  Copyright © 2019 dpanchuk. All rights reserved.
//

import CoreData

class CoreDataManager {
    
    static let shared = CoreDataManager()
    private init() {}
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Movies")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)") // FIXME
            }
        })
        return container
    }()
    
    var context: NSManagedObjectContext {
        persistentContainer.viewContext.mergePolicy = NSOverwriteMergePolicy
        return persistentContainer.viewContext
    }
    
    func saveContext() {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)") // FIXME
            }
        }
    }
    
}

// MARK: -
extension CoreDataManager {
    
    // MARK: Genres
    func getAllGenreEntities() -> [GenreEntity] {
        let fetchRequest = NSFetchRequest<GenreEntity>(entityName: "GenreEntity")
        let result = try? context.fetch(fetchRequest)
        return result ?? []
    }
    
    func removeAllGenres() {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "GenreEntity")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        _ = try? context.execute(deleteRequest)
    }
    
    // MARK: Movies
    func getMovieEntity(by id: Int) -> MovieEntity? {
        let predicate = NSPredicate(format: "id == \(id)")
        return getMovieEntities(using: predicate).first
    }
    
    func saveMoviesIfNeeded(_ movies: [Movie]) {
        let candidateIds = movies.map { $0.id }
        let cachedIds = getMovieEntitiesWithIds(from: candidateIds).compactMap { Int($0.id) }
        let movieIdsToSave = candidateIds.diff(from: cachedIds)
        
        for movie in movies where movieIdsToSave.contains(movie.id) {
            let entity = MovieEntity(context: context)
            movie.setupMovieEntity(entity: entity)
            saveContext()
        }
    }
    
    func saveMovie(_ movie: Movie) {
        let predicate = NSPredicate(format: "id == \(movie.id)")
        if let movieEntity = getMovieEntities(using: predicate).first {
            movieEntity.runtime = Int16(movie.runtime ?? Constants.CoreData.unknownRuntime)
            movieEntity.productionCountries = movie.productionCountries
        } else {
            let movieEntity = MovieEntity(context: context)
            movie.setupMovieEntity(entity: movieEntity)
        }
        saveContext()
    }
    
    // MARK: Categories
    func getMovieEntities(for category: Movie.Category, page: Int) -> [MovieEntity] {
        let predicate = NSPredicate(format: "categoryId = %@ AND page = \(page)", category.rawValue)
        let categoryFetchResult = getCategoryMoviesEntities(using: predicate)

        guard let movieIds = categoryFetchResult.first?.movieIds else { return [] }
        return getMovieEntitiesWithIds(from: movieIds)
    }
    
    func getMaxPageNumber(for category: Movie.Category) -> Int? {
        let predicate = NSPredicate(format: "categoryId == %@ AND page == max(page)", category.rawValue)
        let categoryFetchResult = getCategoryMoviesEntities(using: predicate)
        return categoryFetchResult.first.map { Int($0.page) }
    }
    
    func saveMovieIds(_ movieIds: [Int], category: Movie.Category, page: Int) {
        let entity = CategoryMoviesEntity(context: context)
        entity.categoryId = category.rawValue
        entity.page = Int16(page)
        entity.movieIds = movieIds
        saveContext()
    }
    
    // MARK: Lists
    func getMovieEntities(of list: Movie.List) -> [MovieEntity] {
        let listMovieIds = getMovieIds(of: list)
        return getMovieEntitiesWithIds(from: listMovieIds)
    }
    
    func getMovieIds(of list: Movie.List) -> [Int] {
        let listMovieEntities = getMovieIdsInList(with: list.entityName)
        return listMovieEntities.compactMap { $0.value(forKey: "id") as? Int }
    }
    
    func listStatusOfMovie(with id: Int, list: Movie.List) -> Bool {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: list.entityName)
        fetchRequest.predicate = NSPredicate(format: "id == \(id)")
        let result = try? context.fetch(fetchRequest)
        return (result ?? []).count > 0
    }
    
    func updateListStatusOfMovie(with id: Int, list: Movie.List, status: Bool) {
        let shouldBeInList = status
        if shouldBeInList {
            let entityDescription = NSEntityDescription.entity(forEntityName: list.entityName, in: context)
            guard let description = entityDescription else { return }
            let entity = NSManagedObject(entity: description, insertInto: context)
            entity.setValue(id, forKey: "id")
        } else {
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: list.entityName)
            fetchRequest.predicate = NSPredicate(format: "id == \(id)")
            let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
            _ = try? context.execute(deleteRequest)
        }
        saveContext()
    }
    
    // MARK: Search
    func searchMovies(by keyword: String) -> [MovieEntity] {
        let predicate = NSPredicate(format: "title CONTAINS[c] %@ OR overview CONTAINS[c] %@", keyword, keyword)
        return getMovieEntities(using: predicate)
    }
    
}

// MARK: - Private
private extension CoreDataManager {
    
    func getMovieEntities(using predicate: NSPredicate? = nil) -> [MovieEntity] {
        let fetchRequest = NSFetchRequest<MovieEntity>(entityName: "MovieEntity")
        fetchRequest.predicate = predicate
        let result = try? context.fetch(fetchRequest)
        return result ?? []
    }
    
    func getMovieEntitiesWithIds(from idList: [Int]) -> [MovieEntity] {
        let predicate = NSPredicate(format: "id IN %@", idList)
        return getMovieEntities(using: predicate)
    }
    
    func getMovieIdsInList(with listName: String) -> [NSManagedObject] {
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: listName)
        let result = try? context.fetch(fetchRequest)
        return result ?? []
    }
    
    func getCategoryMoviesEntities(using predicate: NSPredicate? = nil) -> [CategoryMoviesEntity] {
        let fetchRequest = NSFetchRequest<CategoryMoviesEntity>(entityName: "CategoryMoviesEntity")
        fetchRequest.predicate = predicate
        let result = try? context.fetch(fetchRequest)
        return result ?? []
    }
    
}

extension Movie.List {
    var entityName: String {
        switch self {
        case .watched: return "WatchedMovieEntity"
        case .favorite: return "FavoriteMovieEntity"
        case .watchLater: return "WatchLaterMovieEntity"
        }
    }
}

extension Array where Element: Hashable {

    func diff(from other: [Element]) -> [Element] {
        let selfSet = Set(self)
        let otherSet = Set(other)
        return Array(selfSet.symmetricDifference(otherSet))
    }

}
