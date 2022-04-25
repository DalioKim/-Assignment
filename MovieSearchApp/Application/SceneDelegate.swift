//
//  SceneDelegate.swift
//  Assignment
//
//  Created by 김동현 on 2022/04/24.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        window = UIWindow(windowScene: windowScene)
        window?.backgroundColor = .white
        
        let navigationController = UINavigationController(rootViewController: MainSearchViewController(viewModel: DefaultSearchViewModel()))
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
    }
}
