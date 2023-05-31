//
//  CustomHeaderView.swift
//  Weather Forecast App
//
//  Created by Md Khaled Hasan Manna on 31/5/23.
//

import UIKit

extension CustomHeaderView {
    class Callback {
        var didTappedMap: () -> Void = { }
        var didTappedSetting: () -> Void = { }
    }
}

class CustomHeaderView: UITableViewHeaderFooterView {
    @IBOutlet private weak var mapButtonOutlet: UIButton!
    @IBOutlet private weak var settingButtonOutlet: UIButton!
    @IBOutlet private weak var titleLabel: UILabel!
    
    let callback = Callback()
    @IBAction func mapButtonTapped(_ sender: UIButton) {
        callback.didTappedMap()
        print("Map")
    }
    
    @IBAction func settingButtonTapped(_ sender: UIButton) {
        callback.didTappedSetting()
        print("Setting")
    }
}
