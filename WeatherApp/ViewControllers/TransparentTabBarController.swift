//
//  TransparentTabBarController.swift
//  WeatherApp
//
//  Created by Nino Chanturia on 2/6/21.
//

import Foundation
import UIKit

class TransparentTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tabBarAppearence = UITabBarAppearance()
        tabBarAppearence.configureWithTransparentBackground()
        tabBarAppearence.backgroundImage = UIImage()
        tabBarAppearence.shadowImage = UIImage()
        tabBar.unselectedItemTintColor = .white
        
        tabBar.standardAppearance = tabBarAppearence
    }
}
