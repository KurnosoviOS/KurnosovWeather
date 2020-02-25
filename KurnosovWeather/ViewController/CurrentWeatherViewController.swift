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
        
        vm.updateObservable.subscribe(onNext: { viewState in
            self._handleEvent(event: viewState)
            }, onError: { (err) in
                self._showError(err)
            }, onCompleted: {}
        ).disposed(by: disposeBag)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        guard let vm = self.viewModel else {
            return
        }
        
        self.loadingSpinner?.startAnimating()
        vm.onLoad()
    }
    
    private func _updateModel() {
        self.loadingSpinner?.stopAnimating()
        
        //TODO: Показывать где-то дату?
        
        let currentCity = self.viewModel?.currentCity ?? ""
        let currentWeather = self.viewModel?.currentWeather ?? ""
        
        print("<--eventChain-->updateview")
        
        self.cityLabel?.text = currentCity
        self.currentWeatherTextView?.text = currentWeather
    }

    private func _handleEvent(event: CurrentWeatherViewState) {
        switch event {
        case .success:
            self._updateModel()
            break;
        case .error(error: let err):
            self._showError(err)
            break;
        default:
            self._updateModel()
        }
    }
    
    private func _showError(_ error: Error) {
        DispatchQueue.main.async {
            let alertController = UIAlertController(title: "Ошибка", message: error.localizedDescription, preferredStyle: .alert)
             
            let okAction =  UIAlertAction(title: "Ok", style: .default) { _ in }
                    
            alertController.addAction(okAction)
            
            self.present(alertController, animated: true, completion: nil)
        }
        
    }

    @IBOutlet weak var cityLabel: UILabel?
    
    @IBOutlet weak var currentWeatherTextView: UITextView?
    
    @IBOutlet weak var loadingSpinner: UIActivityIndicatorView?
    
    @IBAction func reloadAction(_ sender: Any) {
        self.loadingSpinner?.startAnimating()
        self.viewModel?.reload()
    }
    
    
}

