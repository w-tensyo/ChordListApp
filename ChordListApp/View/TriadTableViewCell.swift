//
//  TriadTableViewCell.swift
//  ChordListApp
//
//  Created by 渡邉天彰 on 2020/07/11.
//  Copyright © 2020 takaaki watanabe. All rights reserved.
//

import UIKit

class TriadTableViewCell: UITableViewCell {
    

    @IBOutlet weak var numberLabel: UILabel!
    
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
        
    
        var toneSign:String = ""
        switch triadCode.toneNumber {
        case 0:
            toneSign = "Ⅰ"
            break
        case 2:
            toneSign = "Ⅱ"
            break
        case 3:
            toneSign = "Ⅲ"
            break
        case 4:
            toneSign = "Ⅲ"
            break
        case 5:
            toneSign = "Ⅳ"
            break
        case 7:
            toneSign = "Ⅴ"
            break
        case 8:
            toneSign = "Ⅵ"
            break
        case 9:
            toneSign = "Ⅵ"
            break
        case 10:
            toneSign = "Ⅶ"
            break
        case 11:
            toneSign = "Ⅶ"
            break
        default:
            toneSign = "-"
        }
        
        self.numberLabel.text = toneSign
        
    }
    
    //各コードのMajer Minerを判定するためのメソッド
    func judgeCode(firstElement:Bool,secondElement:Bool) ->String{
        
        var majarOrMiner:String = ""
        
        if firstElement == true && secondElement == true{
            majarOrMiner = " maj  "
        }else if firstElement == true && secondElement == false{
            majarOrMiner = "  m   "
        }else if firstElement == false && secondElement == true{
            majarOrMiner = " m(♭5)"
        }else{
            majarOrMiner = "  --  "
        }
        return majarOrMiner
        
    }
    
    //    CustomCellの高さを定義するためのメソッド
    func judgeCellheight(firstElement:Bool,secondElement:Bool)-> CGFloat{
        if firstElement == false && secondElement == false{
            return 0
        }else{ //false,false以外は全てリストとして表示をしたいので、これで分岐。
            return 70
        }
    }
    
}
