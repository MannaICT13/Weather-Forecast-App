//
//  SharedProtocols.swift
//  Weather Forecast App
//
//  Created by Md Khaled Hasan Manna on 31/5/23.
//

import Foundation
import UIKit

/// Provide mixins for easy loading of UIViewController from UIStoryboard
protocol StoryboardBased {
    static var storyboardName: String { get }
    static var storyboardIdentifier: String { get }
    static func instantiate() -> Self
}

extension StoryboardBased where Self: UIViewController {
    
    /// Name of the storyboard from which view controller will be instantiated
    /// Must override this property if storyboard name is different from view controller's name
    static var storyboardName: String {
        return "\(Self.self)"
    }
    
    /// Storyboard identifier for the view controller
    /// Must override this property if storyboard identifier is different from view controller's name
    static var storyboardIdentifier: String {
        return "\(Self.self)"
    }
    
    /// This method instantiate a UIViewController from UIStoryboard
    /// - Returns: UIViewController
    static func instantiate() -> Self  {
        let storyboard = UIStoryboard(name: storyboardName , bundle: .main)
        guard let viewController = storyboard.instantiateViewController(withIdentifier: storyboardIdentifier) as? Self else {
            fatalError("Can't load view controller \(Self.self) from storyboard named \(storyboardName)")
        }
        return viewController
    }
}
