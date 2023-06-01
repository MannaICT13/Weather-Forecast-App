//
//  ForecastCell.swift
//  Weather Forecast App
//
//  Created by Md Khaled Hasan Manna on 1/6/23.
//

import UIKit

struct ForecastModel {
    let temparature: String
    let dayName: String
    let imageStr: String
}

class ForecastCell: UITableViewCell {

    @IBOutlet private weak var forecastImageView: UIImageView!
    @IBOutlet private weak var dayNameLabel: UILabel!
    @IBOutlet private weak var temparatureLabel: UILabel!
    
    var model: ForecastModel? {
        didSet {
            guard let model = model else { return }
            temparatureLabel.text = model.temparature
            dayNameLabel.text = model.dayName
            forecastImageView.image = UIImage(named: model.imageStr)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}

extension ForecastCell {
    static func deque(for tableView: UITableView, at indexPath: IndexPath) -> ForecastCell {
        let cell: ForecastCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
        return cell
    }
}
