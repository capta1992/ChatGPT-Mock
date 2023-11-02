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
        // Adding main UI components to the view
        view.addSubview(leftNavbutton)
        view.addSubview(rightNavButton)
      //  view.addSubview(segmentedControl) // Comment out this line to not display the segmented control
        view.addSubview(suggestionsCollectionView)
        view.addSubview(chatTableView)
        view.addSubview(chatContainerView)
        
        // Setting up the bottomStackView with its subviews
        chatContainerView.addSubview(bottomStackView)
        bottomStackView.addArrangedSubview(cameraButton)
        bottomStackView.addArrangedSubview(messageInputField)
        bottomStackView.addArrangedSubview(folderButton)
        
        setupLayoutConstraints()
    }
    private func setupLayoutConstraints() {
        chatContainerView.translatesAutoresizingMaskIntoConstraints = false
        stackView.translatesAutoresizingMaskIntoConstraints = false
        cameraButton.translatesAutoresizingMaskIntoConstraints = false
        folderButton.translatesAutoresizingMaskIntoConstraints = false
        leftNavbutton.translatesAutoresizingMaskIntoConstraints = false
        bottomStackView.translatesAutoresizingMaskIntoConstraints = false
        rightNavButton.translatesAutoresizingMaskIntoConstraints = false
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        chatTableView.translatesAutoresizingMaskIntoConstraints = false
        messageInputField.translatesAutoresizingMaskIntoConstraints = false
        suggestionsCollectionView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            // Left Navigation Button
            leftNavbutton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            leftNavbutton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            
            // Right Navigation Button
            rightNavButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            rightNavButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            
            // Segmented Control (GPT-3.5 and GPT-4)
            segmentedControl.topAnchor.constraint(equalTo: leftNavbutton.bottomAnchor, constant: 20),
            segmentedControl.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            segmentedControl.widthAnchor.constraint(equalToConstant: 200),
            
            // Suggestions Collection View
            suggestionsCollectionView.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor, constant: 10),
            suggestionsCollectionView.leftAnchor.constraint(equalTo: view.leftAnchor),
            suggestionsCollectionView.rightAnchor.constraint(equalTo: view.rightAnchor),
            suggestionsCollectionView.bottomAnchor.constraint(equalTo: chatContainerView.topAnchor, constant: -10), // Adjusted this to be 10pts above chatContainerView
            suggestionsCollectionView.heightAnchor.constraint(equalToConstant: 50),
            
            // Chat Container View
            chatContainerView.leftAnchor.constraint(equalTo: view.leftAnchor),
            chatContainerView.rightAnchor.constraint(equalTo: view.rightAnchor),
            chatContainerView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            chatContainerView.heightAnchor.constraint(equalToConstant: 60), // Adjust based on your requirements
            
            // Chat TableView
            chatTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            chatTableView.leftAnchor.constraint(equalTo: view.leftAnchor),
            chatTableView.rightAnchor.constraint(equalTo: view.rightAnchor),
            chatTableView.bottomAnchor.constraint(equalTo: chatContainerView.topAnchor), // Fix here
            
            // Bottom Stack View (contains Message Input and other buttons)
            bottomStackView.bottomAnchor.constraint(equalTo: chatContainerView.bottomAnchor),
            bottomStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            bottomStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            bottomStackView.heightAnchor.constraint(equalTo: chatContainerView.heightAnchor),

            // Message Input Field
            messageInputField.leadingAnchor.constraint(equalTo: cameraButton.trailingAnchor, constant: 10),
            messageInputField.trailingAnchor.constraint(equalTo: folderButton.leadingAnchor, constant: -10),
            messageInputField.centerYAnchor.constraint(equalTo: bottomStackView.centerYAnchor),
            messageInputField.heightAnchor.constraint(equalToConstant: 40),
            
            // Camera and Folder Buttons
            cameraButton.leadingAnchor.constraint(equalTo: bottomStackView.leadingAnchor, constant: 10),
            cameraButton.centerYAnchor.constraint(equalTo: bottomStackView.centerYAnchor),
            cameraButton.widthAnchor.constraint(equalToConstant: 40), // Assuming a square button
            cameraButton.heightAnchor.constraint(equalToConstant: 40),
            
            folderButton.trailingAnchor.constraint(equalTo: bottomStackView.trailingAnchor, constant: -10),
            folderButton.centerYAnchor.constraint(equalTo: bottomStackView.centerYAnchor),
            folderButton.widthAnchor.constraint(equalToConstant: 40), // Assuming a square button
            folderButton.heightAnchor.constraint(equalToConstant: 40),
        ])
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
