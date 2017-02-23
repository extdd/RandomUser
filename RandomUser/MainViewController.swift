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
    var apiManager: APIManager?

    fileprivate let disposeBag = DisposeBag()
    fileprivate let tableView = UITableView(frame: .zero, style: .plain)
    fileprivate var sortingBar: SortingBar?
    fileprivate var addButton: UIBarButtonItem?
    fileprivate var userDefaultThumbnail: UIImage? = UIImage(named: CustomImage.userDefaultThumbnailName)

    // MARK: - INIT
    
    override func viewDidLoad() {
        
        super.viewDidLoad() 
        initUI()
        initRX()
        apiManager?.loadUsers()

    }

    // MARK: - UI
    
    fileprivate func initUI(){
        
        self.view.backgroundColor = .white
        initNavigationBar()
        initTableView()
        setConstraints()

    }
    
    fileprivate func initNavigationBar() {
        
        addButton = UIBarButtonItem(barButtonSystemItem: .add, target: nil, action: nil)
        sortingBar = SortingBar(frame: .zero, withItems: self.viewModel?.getSortingBarItems())
        navigationItem.rightBarButtonItems = [addButton!]
        self.view.addSubview(sortingBar!)
        self.title = viewModel?.navigationBarTitle

    }
    
    fileprivate func initTableView() {

        tableView.register(UITableViewCell.self, forCellReuseIdentifier: UITableViewCell.className)
        tableView.backgroundColor = .white
        self.view.addSubview(tableView)
        self.view.sendSubview(toBack: tableView)

    }
    
    // MARK: - RX
    
    fileprivate func initRX() {

        // addButton
        addButton?.rx.tap
            .subscribe(onNext: { [unowned self] in
                self.showDetail(isNewUser: true)
            }).addDisposableTo(disposeBag)
        
        // sortingBar
        sortingBar?.segmentedControl.rx.value
            .subscribe(onNext: { [unowned self] value in
                self.viewModel?.updateUsers(sorted: SortingMode.all[value])
                self.updateDataSource()
            }).addDisposableTo(disposeBag)
        
        // tableView
        tableView.rx.itemSelected
            .subscribe(onNext: { [unowned self] indexPath in
                self.showDetail(forRowAt: indexPath)
            }).addDisposableTo(disposeBag)
        
    }
    
    // MARK: - ACTIONS
    
    fileprivate func showDetail(forRowAt indexPath: IndexPath? = nil, isNewUser: Bool? = false) {
        
        guard let users = self.viewModel?.users else { return }
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        guard let detailViewController = appDelegate.assembler.resolver.resolve(DetailViewController.self) else { return }
        
        if indexPath != nil {
            // show detail for the selected user
            detailViewController.viewModel?.activeUser = users[indexPath!.row]
            self.navigationController?.pushViewController(detailViewController, animated: true)
        } else if isNewUser == true {
            // show detail with edit mode for the new user
            detailViewController.viewModel?.activeUser = apiManager?.getNewUser()
            let navigationController = UINavigationController(rootViewController: detailViewController, customized: true)
            self.present(navigationController, animated: true)
        }
        
    }
    
    // MARK: - CONSTRAINTS
    
    func setConstraints() {
        
        sortingBar?.snp.makeConstraints { make in
            make.top.equalTo(topLayoutGuide.snp.bottom)
            make.left.right.equalToSuperview()
        }
        tableView.snp.makeConstraints { make in
            make.top.equalTo(topLayoutGuide.snp.bottom)
            make.bottom.left.right.equalTo(view)
        }
        
    }

    // MARK: - EVENTS
    
    override func viewWillAppear(_ animated: Bool) {
        
        guard let indexPath = tableView.indexPathForSelectedRow else { return }
        self.tableView.deselectRow(at: indexPath, animated: false)
        
    }
    
    override func viewDidLayoutSubviews() {

        guard let sortingBarHeight = sortingBar?.frame.height else { return }
        tableView.contentInset.top = sortingBarHeight
        tableView.scrollIndicatorInsets.top = sortingBarHeight
        
    }
    
}

// MARK: - TABLE VIEW DATA SOURCE

extension MainViewController {
    
    fileprivate func updateDataSource() {

        tableView.dataSource = nil
        let dataSource = RxTableViewRealmDataSource<User>(cellIdentifier: UITableViewCell.className, cellType: UITableViewCell.self) {
            [weak self] cell, indexPath, user in
            cell.accessoryType = .disclosureIndicator
            self?.updateCell(cell, for: user)
        }
        dataSource.animated = false
        if let users = viewModel?.users {
            Observable.changeset(from: users)
                .bindTo(tableView.rx.realmChanges(dataSource))
                .addDisposableTo(disposeBag)
        }
        
    }
    
    fileprivate func updateCell(_ cell: UITableViewCell, for user: User) {
        
        cell.textLabel?.text = viewModel?.getCellText(for: user)
        cell.textLabel?.textColor = CustomColor.text
        cell.textLabel?.font = CustomFont.text
        if let thumbnailURL = user.thumbnailURL {
            cell.imageView?.sd_setImage(with: URL(string: thumbnailURL), placeholderImage: userDefaultThumbnail)
        } else {
            cell.imageView?.image = userDefaultThumbnail
        }
        
    }
    
}
