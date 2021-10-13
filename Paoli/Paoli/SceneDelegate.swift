//
//  SceneDelegate.swift
//  Paoli
//
//  Created by 1 on 2021/9/23.
//

/*
 sceneDidDisconnect(_:) 当场景与app断开连接是调用（注意，以后它可能被重新连接）
 sceneDidBecomeActive(_:) 当用户开始与场景进行交互（例如从应用切换器中选择场景）时，会调用
 sceneWillResignActive(_:) 当用户停止与场景交互（例如通过切换器切换到另一个场景）时调用
 sceneWillEnterForeground(_:) 当场景变成活动窗口时调用，即从后台状态变成开始或恢复状态
 sceneDidEnterBackground(_:) 当场景进入后台时调用，即该应用已最小化但仍存活在后台中

 */

import UIKit

@available(iOS 13.0, *)
class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

//    当将场景添加到app中时scene(_:willConnectTo:options:)函数会被调用的，因此这里是配置场景的最理想地方
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
//        NSLog(@"%s", __func__);
        
        guard let _ = (scene as? UIWindowScene) else { return }
        
        let windowScene = scene as! UIWindowScene
        window = UIWindow(windowScene: windowScene)
        window?.frame = UIScreen.main.bounds
        window?.rootViewController = UINavigationController(rootViewController: PLLoginViewController())
//        if AGUserDefaults().getUserDefaults(AGAccount) != nil && AGUserDefaults().getUserDefaults(AGPassword) != nil {
//            window?.rootViewController = PLRootController(arr: [])
//        } else {
//        window?.rootViewController = UINavigationController(rootViewController: PLLoginViewController())

//        }
        
        window?.makeKeyAndVisible()
        
    }

    
    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
        
        
        
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
        
        
        
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

        // Save changes in the application's managed object context when the application transitions to the background.
        (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
        
    }


}

