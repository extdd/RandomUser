//
//  MainViewController.swift
//  RandomUser
//
//  Created by Krzysztof Ignac on 16.01.2017.
//  Copyright © 2017 EXTENDED. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxRealmDataSources
import SDWebImage
import SnapKit

class MainViewController: UIViewController {
    
    var viewModel: MainViewModel?
    var sortingBar: SortingBar?
    var addButton: UIBarButtonItem?
    var tableView: UITableView?
    
    fileprivate let disposeBag = DisposeBag()
    fileprivate var userDefaultThumbnail: UIImage? {
        return UIImage(named: Images.userDefaultThumbnailName)
    }
    
    // MARK: - INIT
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        initUI()
        initRX()
        viewModel?.initUsers()
        
    }

    // MARK: - UI
    
    fileprivate func initUI(){
        
        self.view.backgroundColor = .white
        
        initNavigationBar()
        initTableView()
        setConstraints()

    }
    
    fileprivate func initNavigationBar() {
        
        self.title = viewModel?.navigationBarTitle
        
        addButton = UIBarButtonItem(barButtonSystemItem: .add, target: nil, action: nil)
        navigationItem.rightBarButtonItems = [addButton!]
        
        sortingBar = SortingBar(frame: .zero, withItems: [SortingMode.firstName.rawValue, SortingMode.lastName.rawValue])
        self.view.addSubview(sortingBar!)
        
    }
    
    fileprivate func initTableView() {
        
        tableView = UITableView(frame: .zero, style: .plain)
        tableView!.register(UITableViewCell.self, forCellReuseIdentifier: UITableViewCell.className)
        tableView!.backgroundColor = .white
        self.view.addSubview(tableView!)
        self.view.sendSubview(toBack: tableView!)

    }
    
    // MARK: - RX
    
    fileprivate func initRX() {
        
        // addButton
        addButton?.rx.tap.subscribe(onNext: { _ in
            print("add")
        }).addDisposableTo(disposeBag)
        
        // sortingBar
        sortingBar?.segmentedControl.rx.value.subscribe(onNext: { [weak self] value in
            switch (value) {
            case 0:
                self?.viewModel?.updateUsers(sorted: .firstName)
            case 1:
                self?.viewModel?.updateUsers(sorted: .lastName)
            default:
                return
            }
            self?.updateDataSource()
        }).addDisposableTo(disposeBag)
        
    }
    
    // MARK: - CONSTRAINTS
    
    func setConstraints() {
        
        sortingBar?.snp.makeConstraints { make in
            make.top.equalTo(topLayoutGuide.snp.bottom)
            make.left.right.equalToSuperview()
        }
        
        tableView?.snp.makeConstraints { make in
            make.top.equalTo(topLayoutGuide.snp.bottom)
            make.bottom.left.right.equalTo(view)
        }
        
    }

    // MARK: - EVENTS
    
    override func viewWillAppear(_ animated: Bool) {
        
        if let indexPath = tableView?.indexPathForSelectedRow {
            self.tableView?.deselectRow(at: indexPath, animated: false)
        }
        
    }
    
    override func viewDidLayoutSubviews() {
        
        guard sortingBar != nil else { return }
        let sortingBarHeight = sortingBar!.frame.height
        tableView?.contentInset.top = sortingBarHeight
        tableView?.scrollIndicatorInsets.top = sortingBarHeight
        
    }
    
}

// MARK: - TABLE VIEW DATA SOURCE

extension MainViewController {
    
    fileprivate func updateDataSource() {
        
        guard tableView != nil else { return }
        tableView!.dataSource = nil
        
        let dataSource = RxTableViewRealmDataSource<User>(cellIdentifier: UITableViewCell.className, cellType: UITableViewCell.self) {
            [weak self] cell, indexPath, user in
            self?.updateCell(cell, forUser: user)
        }
        
        dataSource.animated = false
        
        if let users = viewModel?.users {
            Observable.changeset(from: users).bindTo(tableView!.rx.realmChanges(dataSource)).addDisposableTo(disposeBag)
        }
        
    }
    
    fileprivate func updateCell(_ cell: UITableViewCell, forUser user: User) {
        
        cell.textLabel?.text = viewModel?.getCellLabel(forUser: user)
        cell.textLabel?.textColor = UIColor(hex: CustomColor.text)
        if let thumbnailURL = user.thumbnailURL {
            cell.imageView?.sd_setImage(with: URL(string: thumbnailURL), placeholderImage: userDefaultThumbnail)
        }
        
    }
    
}
