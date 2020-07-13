//
//  TriadTableViewCell.swift
//  ChordListApp
//
//  Created by 渡邉天彰 on 2020/07/11.
//  Copyright © 2020 takaaki watanabe. All rights reserved.
//

import UIKit

class TriadTableViewCell: UITableViewCell {

    @IBOutlet weak var rootToneLabel: UILabel!
    @IBOutlet weak var triadToneLabel: UILabel!
    
    @IBOutlet weak var firstToneLabel: UILabel!
    @IBOutlet weak var thirdToneLabel: UILabel!
    @IBOutlet weak var fifthToneLabel: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func setTriadCode(triadCode:TriadCode){
        
        /*
         var rootToneNumber:Int = 0
         var thirdToneNumber:Int = 0
         var fifthToneNumber:Int = 0
         var rootNote:String = ""
         var triadCode:String = ""
         */
        
    
        
        self.rootToneLabel.text = triadCode.rootNote
        self.triadToneLabel.text = triadCode.triadCode
        self.firstToneLabel.text = String(triadCode.rootToneNumber)
        self.thirdToneLabel.text = String(triadCode.thirdToneNumber)
        self.fifthToneLabel.text = String(triadCode.fifthToneNumber)
        
    }
    
}
