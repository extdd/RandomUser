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
import SnapKit

class MainViewController: UIViewController {
    
    let navigationBarTitle = "Users" // title of the NavigationBar
    let cellId = "mainTableViewCell" // unique id of a TableView cell
    let padding:CGFloat = 8
    let disposeBag = DisposeBag()
    
    var mainViewModel:MainViewModel?
    var buttonAdd:UIBarButtonItem?
    var tableView:UITableView?
    var sortingControl:UISegmentedControl?
    
    // MARK: - INIT
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        initUI()
        initRX()
        mainViewModel?.initData()
        
    }

    // MARK: - TABLE VIEW DATA SOURCE
    
    fileprivate func updateDataSource(sorted:SortingMode) {

        tableView?.dataSource = nil
        
        let dataSource = RxTableViewRealmDataSource<User>(cellIdentifier: cellId, cellType: UITableViewCell.self) { [weak self] cell, index, user in
            
            self?.updateCell(cell, forUser: user)
            
        }
        
        dataSource.animated = false

        let realm = try! Realm()
        let users = Observable.changesetFrom(realm.objects(User.self).sorted(byKeyPath: sorted.rawValue))
        users.bindTo(tableView!.rx.realmChanges(dataSource)).addDisposableTo(disposeBag)
  
    }
    
    fileprivate func updateCell(_ cell:UITableViewCell, forUser user:User) {
        
        cell.textLabel?.text = mainViewModel?.getCellLabel(forUser: user)

    }
    
    // MARK: - RX
    
    fileprivate func initRX() {
        
        // buttonAdd
        
        buttonAdd?.rx.tap.subscribe(onNext: { _ in
            
            print("add")
            
        }).addDisposableTo(disposeBag)
        
        // sortingControl
        
        sortingControl?.rx.value.subscribe(onNext: { [weak self] value in
            
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
    
    // MARK: - UI
    
    fileprivate func initUI(){
        
        self.view.backgroundColor = .white
        self.title = navigationBarTitle

        initNavigationBar()
        initSortingControl()
        initTableView()

    }
    
    fileprivate func initNavigationBar() {
        
        buttonAdd = UIBarButtonItem(barButtonSystemItem: .add, target: nil, action: nil)
        navigationItem.rightBarButtonItems = [buttonAdd!]
        
    }
    
    fileprivate func initSortingControl() {
        
        sortingControl = UISegmentedControl(items: [SortingMode.firstName.rawValue, SortingMode.lastName.rawValue])
        sortingControl!.backgroundColor = UIColor.white
        sortingControl!.selectedSegmentIndex = 0
        self.view.addSubview(sortingControl!)
        
        sortingControl!.snp.makeConstraints { make in
            make.top.equalTo(self.topLayoutGuide.snp.bottom).offset(padding)
            make.width.lessThanOrEqualTo(self.view).inset(padding)
            make.centerX.equalToSuperview()
        }
        
    }
    
    fileprivate func initTableView() {
        
        tableView = UITableView(frame: CGRect.zero, style: .plain)
        tableView!.register(UITableViewCell.self, forCellReuseIdentifier: cellId)
        self.view.addSubview(tableView!)
        
        tableView!.snp.makeConstraints { make in
            make.top.equalTo(sortingControl!.snp.bottom).offset(padding)
            make.bottom.left.right.equalTo(self.view)
        }
        
    }
    
}
