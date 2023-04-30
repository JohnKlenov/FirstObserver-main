//
//  GroupCell.swift
//  FirstObserver
//
//  Created by Evgenyi on 30.08.22.
//

import UIKit

class GroupCell: UICollectionViewCell {
    
    
    @IBOutlet weak var groupNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = .clear
        contentView.backgroundColor = R.Colors.secondarySystemBackground
        contentView.layer.cornerRadius = 10
        // Initialization code
    }
    
    func setupCell(groupName:String, isSelected: Bool) {
        groupNameLabel.text = groupName
        
        if isSelected {
            groupNameLabel.textColor = R.Colors.systemPurple
        } else {
            groupNameLabel.textColor = R.Colors.label
        }
    }

}
