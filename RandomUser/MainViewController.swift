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
    
    var viewModel: MainViewModel
    var apiManager: APIManager

    fileprivate let disposeBag = DisposeBag()
    fileprivate let tableView = UITableView(frame: .zero, style: .plain)
    fileprivate var sortingBar: SortingBar?
    fileprivate var preloader: Preloader?
    fileprivate var refreshButton: UIBarButtonItem?
    fileprivate var addButton: UIBarButtonItem?
    fileprivate var userDefaultThumbnail: UIImage? = UIImage(named: CustomImage.userDefaultThumbnailName)
    fileprivate var didSetupConstraints: Bool = false
    
    // MARK: - INIT
    
    init(viewModel: MainViewModel, apiManager: APIManager) {
        
        self.viewModel = viewModel
        self.apiManager = apiManager
        super.init(nibName: nil, bundle: nil)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
        
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        initUI()
        initRX()
        refresh()

    }

    // MARK: - UI
    
    fileprivate func initUI(){
        
        initNavigationBar()
        initTableView()
        self.view.backgroundColor = .white
        self.view.setNeedsUpdateConstraints()
        
    }
    
    fileprivate func initNavigationBar() {
        
        refreshButton = UIBarButtonItem(barButtonSystemItem: .refresh, target: nil, action: nil)
        addButton = UIBarButtonItem(barButtonSystemItem: .add, target: nil, action: nil)
        sortingBar = SortingBar(frame: .zero, withItems: self.viewModel.sortingBarItems)
        navigationItem.leftBarButtonItems = [refreshButton!]
        navigationItem.rightBarButtonItems = [addButton!]
        self.view.addSubview(sortingBar!)
        self.title = viewModel.navigationBarTitle

    }
    
    fileprivate func initTableView() {

        tableView.register(UITableViewCell.self, forCellReuseIdentifier: UITableViewCell.className)
        tableView.backgroundColor = .white
        self.view.addSubview(tableView)
        self.view.sendSubview(toBack: tableView)

    }
    
    fileprivate func setPreloader(_ visible: Bool, withInfo info: PreloaderInfo? = nil) {
        
        refreshButton?.isEnabled = !visible
        addButton?.isEnabled = !visible
        
        guard visible || preloader == nil else {
            preloader?.snp.removeConstraints()
            preloader?.removeFromSuperview()
            preloader = nil
            return
        }
        
        preloader = Preloader(info: info, snapsToSuperview: true)
        self.view.addSubview(preloader!)
        
    }
    
    // MARK: - RX
    
    fileprivate func initRX() {

        // refreshButton
        refreshButton?.rx.tap
            .subscribe(onNext: { [unowned self] in
                self.refresh()
            }).addDisposableTo(disposeBag)
        
        // addButton
        addButton?.rx.tap
            .subscribe(onNext: { [unowned self] in
                self.showDetail(isNewUser: true)
            }).addDisposableTo(disposeBag)
        
        // sortingBar
        sortingBar?.segmentedControl.rx.value
            .subscribe(onNext: { [unowned self] in
                self.viewModel.updateUsers(sorted: SortingMode.all[$0])
                self.updateDataSource()
            }).addDisposableTo(disposeBag)
        
        // tableView
        tableView.rx.itemSelected
            .subscribe(onNext: { [unowned self] in
                self.showDetail(forRowAt: $0)
            }).addDisposableTo(disposeBag)
        
    }
    
    // MARK: - ACTIONS
    
    fileprivate func refresh() {
        
        setPreloader(true, withInfo: viewModel.preloaderInfo)
        
        apiManager.loadUsers()
            .asObservable()
            .subscribe(onError: { [weak self] _ in
                    self?.setPreloader(false)
                }, onCompleted: { [weak self] in
                    self?.setPreloader(false)
            }).addDisposableTo(disposeBag)
        
    }
    
    fileprivate func showDetail(forRowAt indexPath: IndexPath? = nil, isNewUser: Bool? = false) {
        
        guard let users = self.viewModel.users else { return }
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        guard let detailViewController = appDelegate.assembler.resolver.resolve(DetailViewController.self) else { return }

        if indexPath != nil {
            // show detail for the selected user
            detailViewController.viewModel.activeUser = users[indexPath!.row]
            self.navigationController?.pushViewController(detailViewController, animated: true)
        } else if isNewUser == true {
            // show detail with edit mode for the new user
            detailViewController.viewModel.activeUser = apiManager.getNewUser()
            let navigationController = UINavigationController(rootViewController: detailViewController, customized: true)
            self.present(navigationController, animated: true)
        }
        
    }
    
    // MARK: - CONSTRAINTS
    
    override func updateViewConstraints() {
        
        setupConstraints()
        super.updateViewConstraints()
        
    }
    
    fileprivate func setupConstraints() {
        
        guard !didSetupConstraints else { return }
        
        sortingBar?.snp.makeConstraints { make in
            make.top.equalTo(topLayoutGuide.snp.bottom)
            make.left.right.equalToSuperview()
        }
        tableView.snp.makeConstraints { make in
            make.top.equalTo(topLayoutGuide.snp.bottom)
            make.bottom.left.right.equalTo(view)
        }
        
        didSetupConstraints = true
        
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
            self?.update(cell, for: user)
        }
        dataSource.animated = false
        
        guard let users = viewModel.users else { return }
        Observable.changeset(from: users)
            .bindTo(tableView.rx.realmChanges(dataSource))
            .addDisposableTo(disposeBag)
        
    }
    
    fileprivate func update(_ cell: UITableViewCell, for user: User) {
        
        cell.accessoryType = .disclosureIndicator
        cell.textLabel?.text = viewModel.getCellText(for: user)
        cell.textLabel?.textColor = CustomColor.text
        cell.textLabel?.font = CustomFont.text
        if let thumbnailURL = user.thumbnailURL {
            cell.imageView?.sd_setImage(with: URL(string: thumbnailURL), placeholderImage: userDefaultThumbnail)
        } else {
            cell.imageView?.image = userDefaultThumbnail
        }
        
    }
    
}
