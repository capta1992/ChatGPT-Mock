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
    static let chatGPTLabelText: String = "ChatGPT"
}

class ChatViewController: UIViewController {
    
    // MARK: - Properties
    
    private var chatContainerBottomConstraint: NSLayoutConstraint!
    private var orangeCircleCenterYConstraint: NSLayoutConstraint!
    
    private let leftNavbutton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "square.and.arrow.up"), for: .normal)
        button.tintColor = .white
        return button
    }()
    
    private let rightNavButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "text.alignleft"), for: .normal)
        button.tintColor = .white
        return button
    }()

    
    private let chatGPTLabel: UILabel = {
        let label = UILabel()
        label.text = Constants.chatGPTLabelText
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 24)
        label.textAlignment = .center
        label.alpha = 0
        return label
    }()
    
    private let orangeCircle: UIView = {
        let view = UIView()
        view.backgroundColor = .orange
        view.layer.cornerRadius = 20 // This will give you a circle of diameter 40
        view.alpha = 0
        return view
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
        textField.placeholder = " Message"
        textField.layer.cornerRadius = 10
        textField.clipsToBounds = true
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
        
        // Call the animation after a delay to ensure view layouit is complete
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.animateChatGPTLabel()
        }
    }
    
    // MARK: - Helpers
    private func configureUI() {
        view.backgroundColor = .black
        setupNavigationBar()
        setupUIComponents()
        configureKeyboardNotification()
        
        messageInputField.delegate = self
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
        
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
        let navigationStack = UIStackView(arrangedSubviews: [leftNavbutton, segmentedControl, rightNavButton])
        navigationStack.axis = .horizontal
        navigationStack.distribution = .fillProportionally
        navigationStack.spacing = 8
        
        navigationStack.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(navigationStack)
        
        // Left Nav Button
        navigationStack.anchor(
            top: view.safeAreaLayoutGuide.topAnchor,
            left: view.leftAnchor,
            right: view.rightAnchor,
            paddingTop: 16,
            paddingLeft: 16,
            paddingRight: 16
        )
        
        // Chat TableView
        chatTableView.anchor(
            top: navigationStack.bottomAnchor,
            left: view.leftAnchor,
            bottom: chatContainerView.topAnchor,
            right: view.rightAnchor
        )
        
        // ChatContainerView
        chatContainerView.anchor(
            left: view.leftAnchor,
            bottom: view.safeAreaLayoutGuide.bottomAnchor,
            right: view.rightAnchor,
            height: 150 // Adjust height based on your needs
        )
        
        chatContainerBottomConstraint = chatContainerView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        chatContainerBottomConstraint.isActive = true

        // Suggestions CollectionView
        suggestionsCollectionView.anchor(
            top: chatContainerView.topAnchor,
            left: chatContainerView.leftAnchor,
            right: chatContainerView.rightAnchor,
            height: 100 // Adjust based on your needs
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
        
        chatGPTLabel.numberOfLines = 0
        chatGPTLabel.adjustsFontSizeToFitWidth = true
        
        // Create a horizontal stack view
        let horizontalStackView = UIStackView(arrangedSubviews: [chatGPTLabel, orangeCircle])
        horizontalStackView.axis = .horizontal
        horizontalStackView.spacing = 2
        horizontalStackView.distribution = .fill
        view.addSubview(horizontalStackView)
        
        horizontalStackView.translatesAutoresizingMaskIntoConstraints = false
        chatGPTLabel.translatesAutoresizingMaskIntoConstraints = false
        orangeCircle.translatesAutoresizingMaskIntoConstraints = false
        
        horizontalStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        orangeCircleCenterYConstraint = horizontalStackView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        orangeCircleCenterYConstraint.isActive = true

        // 2. Separation between suggestionsCollectionView and the Bottom Stack
        stackView.spacing = 8
        
        chatContainerView.backgroundColor = .clear
        
        // Set constraints for the orangeCircle (only if you want to adjust its size)
        NSLayoutConstraint.activate([
            orangeCircle.widthAnchor.constraint(equalToConstant: 40),
            orangeCircle.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    private func configureKeyboardNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardNotification), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardNotification), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    private func animateChatGPTLabel() {
        // Initial state
        chatGPTLabel.alpha = 0
        orangeCircle.alpha = 0
        orangeCircle.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        
        // Step 1: Show the orange circle with scaling animation
        UIView.animate(withDuration: 0.5, animations: {
            self.orangeCircle.alpha = 1
            self.orangeCircle.transform = CGAffineTransform(scaleX: 1, y: 1)
        }) { _ in
            // Step 2: Reveal the ChatGPT label from right to left using a mask
            let maskLayer = CALayer()
            maskLayer.backgroundColor = UIColor.black.cgColor
            maskLayer.frame = CGRect(x: 0, y: 0, width: 0, height: self.chatGPTLabel.frame.height) // Start with 0 width
            self.chatGPTLabel.layer.mask = maskLayer
            
            let animation = CABasicAnimation(keyPath: "bounds.size.width")
            animation.fromValue = 0
            animation.toValue = self.chatGPTLabel.frame.width
            animation.duration = 0.5
            animation.delegate = self
            maskLayer.add(animation, forKey: "slide")
            
            // Update the final state
            self.chatGPTLabel.alpha = 1
            maskLayer.bounds.size.width = self.chatGPTLabel.frame.width
        }
    }
    
    // MARK: - Actions
    
    @objc private func handleKeyboardNotification(notification: NSNotification) {
        if let userInfo = notification.userInfo {
            let keyboardFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
            let isKeyboardShowing = notification.name == UIResponder.keyboardWillShowNotification
            
            let adjustmentHeight = isKeyboardShowing ? -keyboardFrame.height : 0
            chatContainerBottomConstraint.constant = adjustmentHeight
            
            // Hide or show the chatGPTLabel based on keyboard state
            chatGPTLabel.alpha = isKeyboardShowing ? 0 : 1
            
            // Adjust the orangeCircle's centerY position
            orangeCircleCenterYConstraint.constant = adjustmentHeight / 2
            
            // Ensure the layout changes animate smoothly with the keyboard appearance
            UIView.animate(withDuration: 0.5, animations: {
                self.view.layoutIfNeeded()
            })
        }
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
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

// MARK: - CAAnimationDelegate

extension ChatViewController: CAAnimationDelegate { }

extension ChatViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
