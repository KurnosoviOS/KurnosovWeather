//
//  WeatherHistoryViewController.swift
//  KurnosovWeather
//
//  Created by Admin on 24.02.2020.
//  Copyright © 2020 akthesnipe. All rights reserved.
//

import UIKit
import RxSwift

class WeatherHistoryViewController: UIViewController, DependencyClient, UITableViewDataSource, UITableViewDelegate {
    
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
    
    public var viewModel: HistoryViewModelProtocol!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self._configureTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.viewModel.reloadAll().subscribe { (event) in
            self.historyTableView.reloadData()
        }.disposed(by: self.disposeBag)
    }
    
    private let _historyCellIdentifier = "AKhistoryCellIdentifier"
    
    private func _configureTableView() {
        self.historyTableView.dataSource = self;
        self.historyTableView.delegate = self;
        
        let nib = UINib.init(nibName: "HistoryTableViewCell", bundle: nil)
        
        self.historyTableView.register(nib, forCellReuseIdentifier: self._historyCellIdentifier)
    }
    
    
    
    // MARK:-------------UITableViewDataSource-------------
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count = self.viewModel.getHistoryCount()
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = self.historyTableView.dequeueReusableCell(withIdentifier: self._historyCellIdentifier), let historyCell = cell as? HistoryTableViewCell, let state = self.viewModel.getHistoryItem(row: indexPath.row) {
            historyCell.configure(state: state)
            return historyCell
        }
        return UITableViewCell()
    }
    
    
    @IBAction func clearAction(_ sender: Any) {
        self.viewModel.clear().subscribe { (event) in
            self.historyTableView.reloadData()
        }.disposed(by: disposeBag)
    }
    
    @IBOutlet weak var historyTableView: UITableView!
    
    private let disposeBag = DisposeBag()
}
