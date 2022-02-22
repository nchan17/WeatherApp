//
//  TransparentNavBarController.swift
//  WeatherApp
//
//  Created by Nino Chanturia on 2/6/21.
//

import Foundation
import UIKit

class TransparentNavBarController: UINavigationController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let navBarAppearence = UINavigationBarAppearance()
        navBarAppearence.configureWithTransparentBackground()
        navBarAppearence.backgroundImage = UIImage()
        navBarAppearence.shadowImage = UIImage()
        navBarAppearence.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white]
        navBarAppearence.titleTextAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white]
        
        navigationBar.compactAppearance = navBarAppearence
        navigationBar.standardAppearance = navBarAppearence
        navigationBar.scrollEdgeAppearance = navBarAppearence
        
    }
}
