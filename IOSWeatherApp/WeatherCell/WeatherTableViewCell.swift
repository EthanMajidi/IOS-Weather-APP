//
//  WeatherTableViewCell.swift
//  IOSWeatherApp
//
//  Created by Ethan Majidi on 2020-09-01.
//  Copyright © 2020 Ethan Majidi. All rights reserved.
//

import UIKit

class WeatherTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    static let identifier = "WeatherTableViewCell"
    static func nib() -> UINib{
        return UINib(nibName: "WeatherTableViewCell", bundle: nil)
    }
    
}
