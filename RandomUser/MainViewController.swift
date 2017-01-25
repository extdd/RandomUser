//
//  MainViewController.swift
//  RandomUser
//
//  Created by Krzysztof Ignac on 16.01.2017.
//  Copyright © 2017 EXTENDED. All rights reserved.
//

import UIKit
import RealmSwift
import RxSwift
import RxCocoa
import RxRealm
import RxRealmDataSources
import SDWebImage
import SnapKit

class MainViewController: UIViewController {
    
    let navigationBarTitle = "Users" // title of the NavigationBar
    let cellId = "mainTableViewCell" // unique id of a TableView cell
    let disposeBag = DisposeBag()
    
    var mainViewModel: MainViewModel?
    var sortingBar: SortingBar?
    var buttonAdd: UIBarButtonItem?
    var tableView: UITableView?

    var userDefaultThumbnail: UIImage? {
        return UIImage(named: "UserDefaultThumbnail")
    }
    
    // MARK: - INIT
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        initUI()
        initRX()
        mainViewModel?.initData()
        
    }

    // MARK: - RX
    
    fileprivate func initRX() {
        
        // BUTTON ADD
        
        buttonAdd?.rx.tap.subscribe(onNext: { _ in
            
            print("add")
            
        }).addDisposableTo(disposeBag)
        
        // SORTING CONTROL
        
        sortingBar?.segmentedControl.rx.value.subscribe(onNext: { [weak self] value in
            
            switch (value) {
            case 0:
                self?.updateDataSource(sorted: .firstName)
            case 1:
                self?.updateDataSource(sorted: .lastName)
            default:
                return
            }

        }).addDisposableTo(disposeBag)
        
    }
    
    // MARK: - TABLE VIEW DATA SOURCE
    
    fileprivate func updateDataSource(sorted: SortingMode) {
        
        guard tableView != nil else {return}
        
        tableView!.dataSource = nil
        
        let dataSource = RxTableViewRealmDataSource<User>(cellIdentifier: cellId, cellType: UITableViewCell.self) { [weak self] cell, index, user in
            self?.updateCell(cell, forUser: user)
        }
        
        dataSource.animated = false
        
        let realm = try! Realm()
        let users = Observable.changesetFrom(realm.objects(User.self).sorted(byKeyPath: sorted.rawValue))
        users.bindTo(tableView!.rx.realmChanges(dataSource)).addDisposableTo(disposeBag)
        
    }
    
    fileprivate func updateCell(_ cell: UITableViewCell, forUser user: User) {
        
        cell.textLabel?.text = mainViewModel?.getCellLabel(forUser: user)
        
        if let thumbnailURL = user.thumbnailURL {
            cell.imageView?.sd_setImage(with: URL(string: thumbnailURL), placeholderImage: userDefaultThumbnail)
        }
        
    }
    
    // MARK: - UI
    
    fileprivate func initUI(){
        
        self.view.backgroundColor = .white
        self.title = navigationBarTitle

        initNavigationBar()
        initTableView()
        setConstraints()

    }
    
    fileprivate func initNavigationBar() {
        
        buttonAdd = UIBarButtonItem(barButtonSystemItem: .add, target: nil, action: nil)
        navigationItem.rightBarButtonItems = [buttonAdd!]
        
        sortingBar = SortingBar(frame: .zero, withItems: [SortingMode.firstName.rawValue, SortingMode.lastName.rawValue])
        self.view.addSubview(sortingBar!)
        
    }
    
    fileprivate func initTableView() {
        
        tableView = UITableView(frame: .zero, style: .plain)
        tableView!.register(UITableViewCell.self, forCellReuseIdentifier: cellId)
        tableView!.backgroundColor = .white
        self.view.addSubview(tableView!)
        self.view.sendSubview(toBack: tableView!)

    }
    
    // MARK: - CONSTRAINTS
    
    func setConstraints() {
        
        sortingBar?.snp.makeConstraints { make in
            make.top.equalTo(self.topLayoutGuide.snp.bottom)
            make.left.right.equalToSuperview()
        }
        
        tableView?.snp.makeConstraints { make in
            make.top.equalTo(self.topLayoutGuide.snp.bottom)
            make.bottom.left.right.equalTo(self.view)
        }
        
    }

    // MARK: - LAYOUT
    
    override func viewDidLayoutSubviews() {
        
        guard sortingBar != nil else {return}
        
        let sortingBarHeight = sortingBar!.frame.height
        tableView?.contentInset.top = sortingBarHeight
        tableView?.scrollIndicatorInsets.top = sortingBarHeight
        
    }
    
}
