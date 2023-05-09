//
//  SceneDelegate.swift
//  FirstObserver
//
//  Created by Evgenyi on 8.08.22.
//

import UIKit
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth
import Firebase

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    static var flag = false
    // ARC static weak var?
    static var mapVC: MapViewController?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        FirebaseApp.configure()
        Database.database().isPersistenceEnabled = true
        
        guard let windowScene = (scene as? UIWindowScene) else { return }
//        NewHomeViewController.userDefaults.set(false, forKey: "isFinishPresentation")
        let appAlreadeSeen = NewHomeViewController.userDefaults.bool(forKey: "isFinishPresentation")

        if appAlreadeSeen {
            window = UIWindow(frame: windowScene.coordinateSpace.bounds)
            window?.windowScene = windowScene
            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MainTabBarController") as! MainTabBarController
            window?.rootViewController = vc
            window?.makeKeyAndVisible()
        } else {
            window = UIWindow(frame: windowScene.coordinateSpace.bounds)
            window?.windowScene = windowScene
            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PresentViewController") as! PresentViewController
            window?.rootViewController = vc
            window?.makeKeyAndVisible()
        }
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    
    // когда вернулись в App из Settings нам нужно вызвать setupManager() и checkAuthorization() которые еще небыли вызваны
    func sceneDidBecomeActive(_ scene: UIScene) {
        
        if SceneDelegate.flag {
            DispatchQueue.main.async {
                SceneDelegate.mapVC?.setupManager()
                SceneDelegate.mapVC?.checkAuthorization()
                SceneDelegate.flag = false
            }
        }
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }


}

