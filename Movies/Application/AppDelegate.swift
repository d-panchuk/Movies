//
//  AppDelegate.swift
//  Movies
//
//  Copyright © 2019 dpanchuk. All rights reserved.
//

#if DEBUG
import RxSwift
#endif

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    var coordinator: MainCoordinator?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        startApplicationWithCoordinator()
        initialSetup()
        
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
    
    func initialSetup() {
        #if DEBUG
//        setupRxResourceLogging()
        #endif
        
        updateGenresFromNetwork()
    }
    
    private func updateGenresFromNetwork() {
        let remoteDataSource = RemoteDataSource()
        
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
            }
        }
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
