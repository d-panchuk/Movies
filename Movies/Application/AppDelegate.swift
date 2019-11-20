//
//  AppDelegate.swift
//  Movies
//
//  Copyright © 2019 dpanchuk. All rights reserved.
//

import RxSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    var coordinator: MainCoordinator?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        initialSetup() {
            self.startApplicationWithCoordinator()
        }
        
        return true
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        CoreDataManager.shared.saveContext()
    }
    
}

// MARK: - Application start
extension AppDelegate {
    
    func startApplicationWithCoordinator() {
        window = UIWindow(frame: UIScreen.main.bounds)
        coordinator = MainCoordinator(window: window)
        coordinator?.start()
    }
    
    func initialSetup(completion: @escaping () -> Void) {
        #if DEBUG
//        setupRxResourceLogging()
        #endif
        
        updateGenresFromNetwork() { completion() }
    }
    
    private func updateGenresFromNetwork(completion: @escaping () -> Void) {
        let remoteDataSource = RemoteDataSource()
        let group = DispatchGroup()
        
        group.enter()
        remoteDataSource.getGenres { genres in
            DispatchQueue.main.async {
                do {
                    try self.removeCachedGenres()
                } catch let error as NSError {
                    print("Error during cached genres deletion: \(error)")
                    return
                }
                
                genres.forEach { genre in
                    let entity = GenreEntity(context: CoreDataManager.shared.context)
                    genre.setupGenreEntity(entity)
                }
                
                CoreDataManager.shared.saveContext()
                group.leave()
            }
        }
        group.notify(queue: .main, execute: completion)
    }
    
    private func removeCachedGenres() throws {
        CoreDataManager.shared.removeAllGenres()
    }
    
    private func setupRxResourceLogging() {
      _ = Observable<Int>
        .interval(DispatchTimeInterval.seconds(1), scheduler: MainScheduler.instance)
        .subscribe { _ in
          print("RxSwift resources count: \(RxSwift.Resources.total).")
      }
    }
    
}
