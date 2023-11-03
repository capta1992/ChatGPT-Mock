//
//  ChatViewController.swift
//  ChatGPT
//
//  Created by Lawson Falomo on 10/30/23.
//

import UIKit

private enum Constants {
    static let navigationTitle: String = "Chat-GPT"
    static let reuseIdentifier: String = "SuggestionsPromptCell"
    static let tableReuseIdentifier: String = "MessageCell"
}

class ChatViewController: UIViewController {
    
    // MARK: - Properties
    
    private let leftNavbutton: UIButton = {
        let button = UIButton()
        button.setTitle("<", for: .normal)
        button.tintColor = .white
        return button
    }()
    
    private let rightNavButton: UIButton = {
        let button = UIButton()
        button.setTitle(">", for: .normal)
        button.tintColor = .white
        return button
    }()
    
    private let chatGPTLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    private let segmentedControl: UISegmentedControl = {
        let items = ["GPT-3.5", "GPT-4"]
        let segmentedControl = UISegmentedControl(items: items)
        segmentedControl.selectedSegmentIndex = 1
        return segmentedControl
    }()
    
    private let chatTableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .black
        return tableView
    }()
    
    private lazy var suggestionsCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.register(SuggestionsPromptCell.self, forCellWithReuseIdentifier: Constants.reuseIdentifier)
        cv.delegate = self
        cv.dataSource = self
        cv.backgroundColor = .clear
        return cv
    }()
    
    private let messageInputField: UITextField = {
        let textField = UITextField()
        textField.backgroundColor = .gray
        textField.placeholder = "Message"
        return textField
    }()
    
    private let chatContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .darkGray
        view.layer.cornerRadius = 15
        return view
    }()
    
    private let stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 5
        return stack
    }()
    
    
    private let cameraButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "camera"), for: .normal)
        return button
    }()
    
    private let photoBadgeButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "photo.badge.plus"), for: .normal)
        return button
    }()
    
    private let folderButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "folder"), for: .normal)
        return button
    }()
    
    private let bottomStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 10
        stack.contentMode = .scaleAspectFit
        stack.clipsToBounds = true
        stack.distribution = .fillProportionally
        return stack
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    // MARK: - Helpers
    private func configureUI() {
        view.backgroundColor = .black
        setupNavigationBar()
        setupUIComponents()
    }
    
    private func setupNavigationBar() {
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationController?.navigationBar.barTintColor = .black
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        
        navigationItem.title = Constants.navigationTitle
    }
    
    private func setupUIComponents() {
        view.addSubview(chatTableView)
        view.addSubview(chatContainerView)
        
        chatContainerView.addSubview(bottomStackView)
        chatContainerView.addSubview(suggestionsCollectionView)
        
        bottomStackView.addArrangedSubview(cameraButton)
        bottomStackView.addArrangedSubview(messageInputField)
        bottomStackView.addArrangedSubview(photoBadgeButton)
        bottomStackView.addArrangedSubview(folderButton)
        
        // Custom Navigation Bar Components
        view.addSubview(leftNavbutton)
        view.addSubview(rightNavButton)
        view.addSubview(segmentedControl)
        
        setupLayoutConstraints()
    }
    
    private func setupLayoutConstraints() {
        // Left Nav Button
        leftNavbutton.anchor(
            top: view.safeAreaLayoutGuide.topAnchor,
            left: view.leftAnchor,
            paddingTop: 16,
            paddingLeft: 16
        )
        
        // Right Nav Button
        rightNavButton.anchor(
            top: view.safeAreaLayoutGuide.topAnchor,
            right: view.rightAnchor,
            paddingTop: 16,
            paddingRight: 16
        )
        
        // Segmented Control
        segmentedControl.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        segmentedControl.anchor(
            top: leftNavbutton.bottomAnchor,
            paddingTop: 8
        )
        
        // Chat TableView
        chatTableView.anchor(
            top: segmentedControl.bottomAnchor,
            left: view.leftAnchor,
            bottom: chatContainerView.topAnchor,
            right: view.rightAnchor
        )
        
        // ChatContainerView
        chatContainerView.anchor(
            left: view.leftAnchor,
            bottom: view.safeAreaLayoutGuide.bottomAnchor,
            right: view.rightAnchor,
            height: 200 // Adjust height based on your needs
        )
        
        // Suggestions CollectionView
        suggestionsCollectionView.anchor(
            top: chatContainerView.topAnchor,
            left: chatContainerView.leftAnchor,
            right: chatContainerView.rightAnchor,
            height: 150 // Adjust based on your needs
        )
        
        // Bottom Stack View
        bottomStackView.anchor(
            top: suggestionsCollectionView.bottomAnchor,
            left: chatContainerView.leftAnchor,
            bottom: chatContainerView.bottomAnchor,
            right: chatContainerView.rightAnchor,
            paddingLeft: 10,
            paddingBottom: 10,
            paddingRight: 10
        )
    }
}

// MARK: - UICollectionViewDataSource, UICollectionViewDelegateFlowLayout

extension ChatViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.reuseIdentifier, for: indexPath) as? SuggestionsPromptCell else {
            return UICollectionViewCell()
        }
        cell.titleLabel.text = "Suggest fun activities"
        cell.subtitleLabel.text = "to do indoors with my high-enrgy dog"
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: view.frame.width * 0.8, height: 70)
    }
}

extension ChatViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.tableReuseIdentifier, for: indexPath) as? MessageCell else {
            return UITableViewCell()
        }
        return cell
    }
}
