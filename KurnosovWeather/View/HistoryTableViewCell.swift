//
//  HistoryTableViewCell.swift
//  KurnosovWeather
//
//  Created by Admin on 24.02.2020.
//  Copyright © 2020 akthesnipe. All rights reserved.
//

import UIKit

class HistoryTableViewCell: UITableViewCell {
    
    public func configure(state: HistoryCellViewState) {
        self.dateLabel.text = state.date
        self.cityLabel.text = state.city
        self.weatherLabel.text = state.weatherDescription
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var cityLabel: UILabel!
    
    @IBOutlet weak var weatherLabel: UILabel!
}
