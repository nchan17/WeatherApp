//
//  CurrentWeatherCell.swift
//  WeatherApp
//
//  Created by Nino Chanturia on 2/6/21.
//

import UIKit
//import CollectionViewPagingLayout

class CurrentWeatherCell: UICollectionViewCell {
    @IBOutlet var cloudinessLabel : UILabel!
    @IBOutlet var humidityLabel : UILabel!
    @IBOutlet var windSpeedLabel : UILabel!
    @IBOutlet var windDirectionLabel : UILabel!
    
    @IBOutlet var cityLabel: UILabel!
    @IBOutlet var cityDescriptionLabel: UILabel!
    
    let cellView = UIView()
    let myLabel = UILabel()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.layer.cornerRadius = 30
    }
    


}
