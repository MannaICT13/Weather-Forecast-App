//
//  UITableView.swift
//  Weather Forecast App
//
//  Created by Md Khaled Hasan Manna on 31/5/23.
//

import Foundation
import UIKit

extension UITableView {
    func registerNibHeaderFooter<T: UITableViewHeaderFooterView>(_ viewClass: T.Type, nibName: String = T.reuseID) {
        register(UINib(nibName: nibName, bundle: nil), forHeaderFooterViewReuseIdentifier: T.reuseID)
    }
    
    public func dequeueReusableHeaderFooterView<T: UITableViewHeaderFooterView>() -> T {
        guard let view = dequeueReusableHeaderFooterView(withIdentifier: T.reuseID) as? T else {
            fatalError("fatalError: Could not dequeue header/footer view with identifier: \(T.reuseID)")
        } 
        return view
    }
}

protocol ReusableView {
    static var reuseID: String { get }
}

extension ReusableView {
    static var reuseID: String {
        return String(describing: Self.self)
    }
}

extension UITableViewCell: ReusableView {}
extension UITableViewHeaderFooterView: ReusableView { }



