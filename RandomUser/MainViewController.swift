//
//  MainViewController.swift
//  RandomUser
//
//  Created by Krzysztof Ignac on 16.01.2017.
//  Copyright © 2017 EXTENDED. All rights reserved.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

enum SortingMode: String {
    
    case firstName = "firstName", lastName = "lastName"
    
}

class MainViewController: UIViewController {
    
    let navigationBarTitle = "Users" // title of the NavigationBar
    let cellId = "mainTableViewCell" // unique id of a TableView cell
    let padding:CGFloat = 8
    let disposeBag = DisposeBag()
    
    var mainViewModel:MainViewModel?
    var apiManager:APIManager?
    
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
    
    func updateTableData(sorted:SortingMode){
        
        print("sorted: \(sorted.rawValue)")
        
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
                self?.updateTableData(sorted: SortingMode.firstName)
            case 1:
                self?.updateTableData(sorted: SortingMode.lastName)
            default:
                return
            }
            
        }).addDisposableTo(disposeBag)
        
    }
    
    // MARK: - UI
    
    fileprivate func initUI(){
        
        self.view.backgroundColor = UIColor.white
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
