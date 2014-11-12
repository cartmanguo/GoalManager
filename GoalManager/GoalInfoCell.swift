//
//  GoalInfoCell.swift
//  GoalManager
//
//  Created by Line_Hu on 14-10-27.
//  Copyright (c) 2014年 Alpha. All rights reserved.
//

import UIKit
protocol StatusButtonPressedDelegate
{
    func buttonPressed(sender:UIButton)
}
class GoalInfoCell: UITableViewCell
{
    var delegate:StatusButtonPressedDelegate?
    @IBOutlet weak var goalNameLabel: UILabel!
    @IBOutlet weak var statusButton: GBFlatButton!
    @IBOutlet weak var goalDesLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        statusButton.addTarget(self, action: "statusButtonPressed", forControlEvents: UIControlEvents.TouchUpInside)
        // Initialization code
    }
    
    func statusButtonPressed()
    {
        delegate?.buttonPressed(statusButton)
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
