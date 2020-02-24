//
//  ViewController.swift
//  KurnosovWeather
//
//  Created by Admin on 13.02.2020.
//  Copyright © 2020 akthesnipe. All rights reserved.
//

import UIKit
import RxSwift

class CurrentWeatherViewController: UIViewController, DependencyClient {
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        self.commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    public func commonInit () {
        CompositionRoot.shared.setDependencies(client: self)
    }
    
    public var viewModel: CurrentWeatherViewModelProtocol?
    
    private var disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let vm = self.viewModel else {
            return
        }
        
        vm.updateObservable.subscribe(onNext: {
            self._updateModel()
            }, onError: { (err) in }, onCompleted: {}
        ).disposed(by: disposeBag)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        guard let vm = self.viewModel else {
            return
        }
        
        vm.onLoad()
    }
    
    private func _updateModel() {
        let currentCity = self.viewModel?.currentCity ?? ""
        let currentWeather = self.viewModel?.currentWeather ?? ""
        print("<--eventChain-->updateview")
        self.cityLabel?.text = currentCity
        self.currentWeatherTextView?.text = currentWeather
    }


    @IBOutlet weak var cityLabel: UILabel?
    
    @IBOutlet weak var currentWeatherTextView: UITextView?
    
}

