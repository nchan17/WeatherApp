//
//  ForecastFiveCell.swift
//  WeatherApp
//
//  Created by Nino Chanturia on 2/6/21.
//

import UIKit

class ForecastFiveCell: UITableViewCell {
    @IBOutlet var iconImage: UIImageView!
    @IBOutlet var timeLabel: UILabel!
    @IBOutlet var descLabel: UILabel!
    @IBOutlet var tempLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
