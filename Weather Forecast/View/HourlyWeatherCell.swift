//
//  HourlyWeatherCell.swift
//  Weather Forecast
//
//  Created by Elif Kasapoğlu on 17.11.2021.
//

import UIKit

class HourlyWeatherCell: UITableViewCell {

    @IBOutlet weak var weatherColorView: UIView!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
