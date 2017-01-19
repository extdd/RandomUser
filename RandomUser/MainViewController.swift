//
//  MainViewController.swift
//  RandomUser
//
//  Created by Krzysztof Ignac on 16.01.2017.
//  Copyright © 2017 EXTENDED. All rights reserved.
//

import UIKit
import SnapKit

enum SortingMode: String {
    
    case firstName = "firstName", lastName = "lastName"
    
}

class MainViewController: UIViewController {
    
    let navigationBarTitle = "Users" // title of the NavigationBar
    let cellId = "mainTableViewCell" // unique id of a TableView cell
    let padding:CGFloat = 8
    
    var mainViewModel:MainViewModel?
    var apiManager:APIManager?
    
    var buttonAdd:UIBarButtonItem?
    var tableView:UITableView?
    var sortingControl:UISegmentedControl?
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        initUI()
        mainViewModel?.initData()
        
    }
    
    // MARK: - ACTIONS
    
    func add() {
        
        print("add")
        
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
        
        buttonAdd = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(add))
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
