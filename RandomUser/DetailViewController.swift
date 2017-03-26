//
//  DetailViewController.swift
//  RandomUser
//
//  Created by Krzysztof Ignac on 05.02.2017.
//  Copyright © 2017 EXTENDED. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxKeyboard
import SDWebImage
import SnapKit

class DetailViewController: UIViewController {
    
    var viewModel: DetailViewModel
    var apiManager: APIManager
    
    fileprivate let content: DetailViewContent = DetailViewContent()
    fileprivate let scrollViewContainer = UIView(frame: .zero)
    fileprivate let scrollView = UIScrollView(frame: .zero) // for auto scrolling content when the keyboard appears
    fileprivate let sharedDisposeBag = DisposeBag() // shared for all display modes
    
    fileprivate var editButton: UIBarButtonItem?
    fileprivate var saveButton: UIBarButtonItem?
    fileprivate var cancelButton: UIBarButtonItem?
    fileprivate var disposeBag: DisposeBag! = DisposeBag()
    fileprivate var didSetupConstraints: Bool = false
    
    fileprivate var displayMode: DisplayMode! {
        didSet {
            updateUI(for: displayMode)
            updateRX(for: displayMode)
        }
    }
    
    // MARK: - INIT
    
    init(viewModel: DetailViewModel, apiManager: APIManager) {
        
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

    }
    
    // MARK: - UI
    
    fileprivate func initUI(){
        
        initContent()
        if self.presentingViewController != nil {
            displayMode = .add // view controller is presented (adding new user)
        } else {
            displayMode = .show // view controller is pushed (showing details)
        }
        
        self.automaticallyAdjustsScrollViewInsets = false
        self.view.backgroundColor = .white
        
    }
    
    fileprivate func updateUI(for displayMode: DisplayMode) {
        
        updateNavigationBar(for: displayMode)
        guard let user = viewModel.activeUser else { return }
        
        content.updateUI(for: displayMode, with: user)
        content.genderPickerView?.delegate = self
        content.genderPickerView?.dataSource = self
        content.genderPickerView?.selectRow(Gender.from(string: user.gender).hashValue, inComponent: 0, animated: false)
        self.view.setNeedsUpdateConstraints()
        
    }
    
    // MARK: - RX
    
    fileprivate func initRX() {
        
        // shared
        RxKeyboard.instance.visibleHeight
            .drive(onNext: { [weak self] keyboardVisibleHeight in
                self?.scrollView.contentInset.bottom = keyboardVisibleHeight + Layout.keyboardTopInset
            }).addDisposableTo(sharedDisposeBag)
        
    }
    
    fileprivate func updateRX(for displayMode: DisplayMode) {

        disposeBag = nil // disposing all observables in a previous bag
        disposeBag = DisposeBag()

        switch displayMode {
        // showing details
        case .show:
            
            // tap events
            editButton?.rx.tap
                .subscribe(onNext: { [unowned self] in
                    self.displayMode = .edit
                }).addDisposableTo(disposeBag)
            
            content.historyButton?.rx.tap
                .subscribe(onNext: { [unowned self] in
                    self.showChangeHistory()
                }).addDisposableTo(disposeBag)
            
        // editing or adding new user
        case .edit, .add:
            
            // tap events
            saveButton?.rx.tap
                .subscribe(onNext: { [unowned self] in
                    if displayMode == .edit {
                        self.saveActiveUser()
                        self.displayMode = .show
                    } else {
                        self.saveActiveUser(isNew: true)
                        self.dismiss(animated: true)
                    }
                    self.view.endEditing(true)
                }).addDisposableTo(disposeBag)
            
            cancelButton?.rx.tap
                .subscribe(onNext: { [unowned self] in
                    if displayMode == .edit {
                        self.displayMode = .show
                    } else {
                        self.dismiss(animated: true)
                    }
                    self.view.endEditing(true)
                }).addDisposableTo(disposeBag)
            
            // binding
            content.firstNameInput?.rx.text
                .asObservable()
                .bindTo(viewModel.firstName)
                .addDisposableTo(disposeBag)
            
            content.lastNameInput?.rx.text
                .asObservable()
                .bindTo(viewModel.lastName)
                .addDisposableTo(disposeBag)
            
            content.emailInput?.rx.text
                .asObservable()
                .bindTo(viewModel.email)
                .addDisposableTo(disposeBag)
            
            content.phoneInput?.rx.text
                .asObservable()
                .bindTo(viewModel.phone)
                .addDisposableTo(disposeBag)

            content.genderPickerView?.rx.itemSelected
                .map {
                    return Gender.all[$0.0]
                }.bindTo(viewModel.gender)
                .addDisposableTo(disposeBag)

            // validation
            viewModel.emailValidation.asObservable()
                .subscribe(onNext: { [unowned self] in
                    self.content.emailValidationInfo?.isHidden = $0
                }).addDisposableTo(disposeBag)
            
            viewModel.phoneValidation.asObservable()
                .subscribe(onNext: { [unowned self] in
                    self.content.phoneValidationInfo?.isHidden = $0
                }).addDisposableTo(disposeBag)
            
            viewModel.saveValidation.asObservable()
                .subscribe(onNext: { [unowned self] in
                    self.saveButton?.isEnabled = $0
                }).addDisposableTo(disposeBag)
            
            // edit events
            content.firstNameInput?.rx.controlEvent(UIControlEvents.editingDidEndOnExit)
                .subscribe(onNext: { [unowned self] in
                    self.content.lastNameInput?.becomeFirstResponder()
                }).addDisposableTo(disposeBag)
            
            content.lastNameInput?.rx.controlEvent(UIControlEvents.editingDidEndOnExit)
                .subscribe(onNext: { [unowned self] in
                    self.content.emailInput?.becomeFirstResponder()
                }).addDisposableTo(disposeBag)
            
            content.emailInput?.rx.controlEvent(UIControlEvents.editingDidEndOnExit)
                .subscribe(onNext: { [unowned self] in
                    self.content.phoneInput?.becomeFirstResponder()
                }).addDisposableTo(disposeBag)
            
        }

    }
    
    // MARK: - ACTIONS
    
    fileprivate func saveActiveUser(isNew: Bool = false) {
        
        guard let user = viewModel.activeUser else { return }
        guard let firstName = viewModel.firstName.value else { return }
        guard let lastName = viewModel.lastName.value else { return }
        guard let gender = viewModel.gender.value else { return }

        apiManager.save(user: user,
                        isNew: isNew,
                        gender: gender,
                        firstName: firstName,
                        lastName: lastName,
                        email: viewModel.email.value,
                        phone: viewModel.phone.value)
        
    }
    
    fileprivate func showChangeHistory() {
        
        guard let user = viewModel.activeUser else { return }
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        guard let historyViewController = appDelegate.assembler.resolver.resolve(HistoryViewController.self) else { return }
        
        historyViewController.viewModel.snapshots = user.snapshots
        self.navigationController?.pushViewController(historyViewController, animated: true)

    }
    
    // MARK: - NAVIGATION BAR

    fileprivate func updateNavigationBar(for displayMode: DisplayMode) {
    
        (editButton, saveButton, cancelButton)  = (nil, nil, nil)
        
        switch displayMode {
        // showing details
        case .show:
            
            editButton = UIBarButtonItem(barButtonSystemItem: .edit, target: nil, action: nil)
            self.navigationItem.leftBarButtonItems = []
            self.navigationItem.rightBarButtonItems = [editButton!]
        
        // editing or adding new user
        case .edit, .add:
            
            if displayMode == .edit {
                saveButton = UIBarButtonItem(barButtonSystemItem: .save, target: nil, action: nil)
            } else {
                saveButton = UIBarButtonItem(title: "Add", style: .done, target: nil, action: nil)
            }

            cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: nil, action: nil)
            self.navigationItem.leftBarButtonItems = [cancelButton!]
            self.navigationItem.rightBarButtonItems = [saveButton!]
            self.view.backgroundColor = CustomColor.light
            
        }
        
        self.title = viewModel.getTitle(for: displayMode)
        
    }
    
    // MARK: - CONTENT
    
    fileprivate func initContent() {
        
        scrollView.addSubview(content)
        scrollViewContainer.addSubview(scrollView)
        self.view.addSubview(scrollViewContainer)
        
    }

    fileprivate func updateContentSize() {
        
        // calculating real content size for proper scrolling when the keyboard appears
        var contentSize = self.content.realContentSize
        contentSize.height += Layout.margin
        self.scrollView.contentSize = contentSize
        
    }
    
    // MARK: - CONSTRAINTS
    
    override func updateViewConstraints() {
    
        setupConstraints()
        content.updateConstraints(for: displayMode)
        super.updateViewConstraints()
        
    }
    
    fileprivate func setupConstraints() {
        
        guard !didSetupConstraints else { return }
        
        scrollViewContainer.snp.makeConstraints { make in
            make.top.equalTo(topLayoutGuide.snp.bottom)
            make.left.right.bottom.equalTo(view)
        }
        scrollView.snp.makeConstraints { make in
            make.edges.equalTo(scrollViewContainer)
            make.size.equalTo(scrollViewContainer)
        }
        content.snp.makeConstraints { make in
            make.edges.equalTo(scrollView)
            make.size.equalTo(scrollViewContainer)
        }
        
        didSetupConstraints = true
        
    }
    
    // MARK: - EVENTS
    
    override func viewDidAppear(_ animated: Bool) {
        
        updateContentSize()
        
    }
    
    override func viewDidLayoutSubviews() {
        
        updateContentSize()
        
    }
    
}

// MARK: - PICKER VIEW DELEGATE & DATA SOURCE

extension DetailViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        
        return 1
        
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        return Gender.all.count
        
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        
        let textColor = CustomColor.text
        let value = Gender.all[row].rawValue
        return NSAttributedString(string: value, attributes: [NSForegroundColorAttributeName:textColor])
        
    }
    
}

