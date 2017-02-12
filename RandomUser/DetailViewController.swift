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
    
    var viewModel: DetailViewModel?
    var apiManager: APIManager?
    
    var content: DetailViewContent?
    var scrollViewContainer: UIView?
    var scrollView: UIScrollView? // for auto scrolling content when the keyboard appears
    
    fileprivate let disposeBag = DisposeBag()
    fileprivate var editButton: UIBarButtonItem?
    fileprivate var saveButton: UIBarButtonItem?
    fileprivate var cancelButton: UIBarButtonItem?
    fileprivate var addButton: UIBarButtonItem?
    fileprivate var backButton: UIBarButtonItem?
    fileprivate var displayMode: DisplayMode? {
        didSet {
            updateUI()
        }
    }
    
    // MARK: - INIT
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        initUI()
        
    }
    
    // MARK: - UI
    
    fileprivate func initUI(){
        
        self.automaticallyAdjustsScrollViewInsets = false
        self.view.backgroundColor = .white
        self.title = viewModel?.navigationBarTitle
        
        initNavigationBar()
        initContent()
        initRX()
        
        if presentingViewController != nil {
            // view controller is presented (adding new user)
            displayMode = .add
        } else {
            // view controller is pushed (showing details)
            displayMode = .show
        }
        
    }
    
    fileprivate func initNavigationBar() {
        
        editButton = UIBarButtonItem(barButtonSystemItem: .edit, target: nil, action: nil)
        saveButton = UIBarButtonItem(barButtonSystemItem: .save, target: nil, action: nil)
        cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: nil, action: nil)
        
        backButton = UIBarButtonItem(title: "Back", style: .plain, target: nil, action: nil)
        addButton = UIBarButtonItem(title: "Add", style: .done, target: nil, action: nil)
        
        guard viewModel != nil else { return }
        self.title = viewModel!.navigationBarTitle
        
    }
    
    fileprivate func initContent() {
        
        // scrollViewContainer
        scrollViewContainer = UIView(frame: .zero)
        self.view.addSubview(scrollViewContainer!)
        scrollViewContainer!.snp.makeConstraints { make in
            make.top.equalTo(topLayoutGuide.snp.bottom)
            make.left.right.bottom.equalTo(view) }
        
        // scrollView
        scrollView = UIScrollView(frame: .zero)
        scrollViewContainer!.addSubview(scrollView!)
        scrollView!.snp.makeConstraints { make in
            make.edges.equalTo(scrollViewContainer!)
            make.size.equalTo(scrollViewContainer!) }
        
        // content
        content = DetailViewContent()
        scrollView!.addSubview(content!)
        content!.snp.makeConstraints { make in
            make.edges.equalTo(scrollView!)
            make.size.equalTo(scrollViewContainer!) }
        content!.genderPickerView.delegate = self
        content!.genderPickerView.dataSource = self
        content!.initUI()
        
    }
    
    // MARK: - RX
    
    fileprivate func initRX() {
        
        // keyboard
        RxKeyboard.instance.visibleHeight.drive(onNext: { [weak self] keyboardVisibleHeight in
            self?.scrollView?.contentInset.bottom = keyboardVisibleHeight
        }).addDisposableTo(disposeBag)
        
        // navigation bar buttons - show / edit mode
        editButton?.rx.tap.subscribe(onNext: { [weak self] in
            self?.displayMode = .edit
        }).addDisposableTo(disposeBag)
        
        saveButton?.rx.tap.subscribe(onNext: { [weak self] in
            self?.saveActiveUser()
            self?.displayMode = .show
        }).addDisposableTo(disposeBag)
        
        cancelButton?.rx.tap.subscribe(onNext: { [weak self] in
            self?.displayMode = .show
        }).addDisposableTo(disposeBag)
        
        // navigation bar buttons - add mode
        
        addButton?.rx.tap.subscribe(onNext: { [weak self] in
            self?.saveActiveUser(isNew: true)
            self?.dismiss(animated: true)
        }).addDisposableTo(disposeBag)
        
        backButton?.rx.tap.subscribe(onNext: { [weak self] in
            self?.view.endEditing(true)
            self?.dismiss(animated: true)
        }).addDisposableTo(disposeBag)
 
    }
    
    // MARK: - SAVE
    
    fileprivate func saveActiveUser(isNew: Bool = false) {
        
        guard content != nil else { return }
        
        guard let user = viewModel?.activeUser else { return }
        guard let firstName = content!.firstNameInput.text else { return }
        guard let lastName = content!.lastNameInput.text else { return }
        
        apiManager?.save(user: user,
                         isNew: isNew,
                         gender: Gender.all[content!.genderPickerView.selectedRow(inComponent: 0)],
                         firstName: firstName,
                         lastName: lastName,
                         email: content!.emailInput.text,
                         phone: content!.phoneInput.text)
        
    }
    
    // MARK: - UPDATE UI
    
    fileprivate func updateUI() {

        guard displayMode != nil else { return }
        
        switch displayMode! {
        case .show:
            self.navigationItem.leftBarButtonItems = []
            self.navigationItem.rightBarButtonItems = [editButton!]
            self.view.backgroundColor = .white
        case .edit, .add:
            self.view.backgroundColor = UIColor(hex: CustomColor.grayLight)
            fallthrough
        case .edit:
            guard displayMode == .edit else { fallthrough }
            self.navigationItem.leftBarButtonItems = [cancelButton!]
            self.navigationItem.rightBarButtonItems = [saveButton!]
        case .add:
            self.navigationItem.leftBarButtonItems = [backButton!]
            self.navigationItem.rightBarButtonItems = [addButton!]
        }

        guard let user = viewModel?.activeUser else { return }
        content?.update(forUser: user, displayMode: displayMode!)
        
    }
    
    fileprivate func updateContentSize() {
        
        if var contentSize = self.content?.realContentSize { // calculated real content size for proper scrolling (Shared+Ext.swfit)
            contentSize.height += Layout.margin
            self.scrollView?.contentSize = contentSize;
        }
        
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
        
        let textColor = UIColor(hex: CustomColor.text)
        let value = Gender.all[row].rawValue
        return NSAttributedString(string: value, attributes: [NSForegroundColorAttributeName:textColor])
        
    }
    
}

