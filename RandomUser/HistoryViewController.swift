//
//  HistoryViewController.swift
//  RandomUser
//
//  Created by Krzysztof Ignac on 15.02.2017.
//  Copyright © 2017 EXTENDED. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxRealmDataSources
import RxDataSources
import SnapKit

class HistoryViewController: UIViewController {
    
    var viewModel: HistoryViewModel
    
    fileprivate let disposeBag = DisposeBag()
    fileprivate let tableView = UITableView(frame: .zero, style: .plain)
    
    // MARK: - INIT
    
    init(viewModel: HistoryViewModel) {
        
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
        
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        initUI()
        initRX()
        
    }
    
    // MARK: - UI
    
    fileprivate func initUI(){
        
        self.automaticallyAdjustsScrollViewInsets = false
        self.view.backgroundColor = .white
        self.title = viewModel.navigationBarTitle
        
        initNavigationBar()
        initTableView()
        setConstraints()
        
    }
    
    fileprivate func initNavigationBar() {
        
        self.title = viewModel.navigationBarTitle
        
    }
    
    fileprivate func initTableView() {
        
        tableView.register(HistoryTableViewCell.self, forCellReuseIdentifier: HistoryTableViewCell.className)
        tableView.backgroundColor = .white
        tableView.allowsSelection = false
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 60
        tableView.separatorStyle = .none
        self.view.addSubview(tableView)
        self.view.sendSubview(toBack: tableView)
        
    }

    // MARK: - RX
    
    fileprivate func initRX() {
        
        guard let snapshots = viewModel.snapshots else { return }

        Observable.collection(from: snapshots)
            .subscribe(onNext: { [weak self] _ in
                self?.updateDataSource()
            }).addDisposableTo(disposeBag)
        
    }
    
    // MARK: - CONSTRAINTS
    
    func setConstraints() {
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(topLayoutGuide.snp.bottom)
            make.bottom.left.right.equalTo(view)
        }
        
    }
    
}

// MARK: - TABLE VIEW DATA SOURCE

extension HistoryViewController {
    
    fileprivate func updateDataSource() {

        tableView.dataSource = nil
        let dataSource = RxTableViewRealmDataSource<UserSnapshot>(cellIdentifier: HistoryTableViewCell.className, cellType: HistoryTableViewCell.self) {
            [weak self] cell, indexPath, snapshot in
            self?.update(cell, for: snapshot)
        }
        dataSource.animated = false
        if let snapshots = viewModel.snapshots {
            Observable.changeset(from: snapshots.sorted(byKeyPath: "timestamp", ascending: false))
                .bindTo(tableView.rx.realmChanges(dataSource))
                .addDisposableTo(disposeBag)
        }
        
    }
    
    fileprivate func update(_ cell: HistoryTableViewCell, for snapshot: UserSnapshot) {
        
        let texts = viewModel.getCellTexts(for: snapshot)
        cell.dateLabel.text = texts.date
        cell.nameLabel.text = texts.name
        cell.detailLabel.text = texts.detail
        cell.genderLabel.text = texts.gender

    }
    
}
