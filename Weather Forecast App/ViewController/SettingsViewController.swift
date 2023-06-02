//
//  SettingsViewController.swift
//  Weather Forecast App
//
//  Created by Md Khaled Hasan Manna on 2/6/23.
//

import UIKit

class SettingsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    private let tableView = UITableView()
    private let viewMModel = SettingsViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Settings"
        tableView.frame = view.bounds
        tableView.dataSource = self
        tableView.delegate = self
        tableView.isScrollEnabled = false
        view.addSubview(tableView)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewMModel.sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewMModel.sections[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellType = viewMModel.sections[indexPath.section][indexPath.row]
        let cell = UITableViewCell(style: .value1, reuseIdentifier: nil)
        
        switch cellType {
        default:
            cell.textLabel?.text = cellType.title
            cell.detailTextLabel?.text = cellType.detail
            
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
         if section == 0 { return "Tempareture Units"
         } else if section == 1 { return "Mode"
         } else if section == 2 { return "Others"
         }
         return nil
     }
}
