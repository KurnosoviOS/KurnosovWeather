//
//  ViewController.swift
//  KurnosovWeather
//
//  Created by Admin on 13.02.2020.
//  Copyright © 2020 akthesnipe. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    private var locationLoader: LocationLoader!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.locationLoader = LocationLoader()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.locationLoader.requestPermission()
        
        self.locationLoader.requestCoordinates()
    }


}

