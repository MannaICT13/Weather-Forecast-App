//
//  CustomHeaderView.swift
//  Weather Forecast App
//
//  Created by Md Khaled Hasan Manna on 31/5/23.
//

import UIKit

class CustomHeaderView: UITableViewHeaderFooterView {
    @IBOutlet weak var mapButtonOutlet: UIButton!
    @IBOutlet weak var settingButtonOutlet: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBAction func mapButtonTapped(_ sender: UIButton) {
        print("Map")
    }
    
    @IBAction func settingButtonTapped(_ sender: UIButton) {
        print("Setting")
    }
    
}
