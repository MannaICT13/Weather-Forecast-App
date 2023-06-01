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

struct CustomViewModel {
    let title: String
    let foreCastImageName: String
    let tempareture: String
    let weatherInfo: String
}

class CustomHeaderView: UITableViewHeaderFooterView {
    @IBOutlet private weak var mapButtonOutlet: UIButton!
    @IBOutlet private weak var settingButtonOutlet: UIButton!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var foreCastImageView: UIImageView!
    @IBOutlet private weak var temparatureLabel: UILabel!
    @IBOutlet private weak var weatherInfoLabel: UILabel!
    
    let callback = Callback()
    
    
    var model: CustomViewModel? {
        didSet {
            guard let model = model else { return }
            titleLabel.text = model.title
            foreCastImageView.image = UIImage(named: model.foreCastImageName)
            temparatureLabel.text = model.tempareture
            weatherInfoLabel.text = model.weatherInfo
        }
    }
    
    @IBAction func mapButtonTapped(_ sender: UIButton) {
        callback.didTappedMap()
        print("Map")
    }
    
    @IBAction func settingButtonTapped(_ sender: UIButton) {
        callback.didTappedSetting()
        print("Setting")
    }
}
