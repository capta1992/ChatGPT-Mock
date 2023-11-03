//
//  ChatMessageCell.swift
//  ChatGPT
//
//  Created by Lawson Falomo on 11/1/23.
//

import UIKit

class ChatMessageCell: UITableViewCell {
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureUI() {
        backgroundColor = .blue
    }
    
    private func configureNavController() {
        print("Do Something I want git hub GUI to react")
    }
}
