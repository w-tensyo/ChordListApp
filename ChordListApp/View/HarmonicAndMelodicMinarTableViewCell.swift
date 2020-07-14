//
//  HarmonicMinerTableViewCell.swift
//  ChordListApp
//
//  Created by 渡邉天彰 on 2020/07/14.
//  Copyright © 2020 takaaki watanabe. All rights reserved.
//

import UIKit

class HarmonicAndMelodicMinarTableViewCell: UITableViewCell {

    @IBOutlet weak var noteImageVIew: UIImageView!
    @IBOutlet weak var codeNotoLabel: UILabel!
    @IBOutlet weak var codeLabel: UILabel!
    @IBOutlet weak var rootNoteLabel: UILabel!
    @IBOutlet weak var thirdNoteLabel: UILabel!
    @IBOutlet weak var fifthNoteLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setHarmonicMinerLabel(triadCode:TriadCode){
        self.codeNotoLabel.text = triadCode.rootNote
        self.codeLabel.text = triadCode.triadCode
        self.rootNoteLabel.text = String(triadCode.rootToneNumber)
        self.thirdNoteLabel.text = String(triadCode.thirdToneNumber)
        self.fifthNoteLabel.text = String(triadCode.fifthToneNumber)
            
        
        var toneImage:UIImage = UIImage(named: "")!
        switch  triadCode.toneNumber{
            case 0:
                toneImage = UIImage(named: "first")!
                break
            case 2:
                toneImage = UIImage(named: "second")!
                break
            case 3:
                toneImage = UIImage(named: "third")!
                break
            case 5:
                toneImage = UIImage(named: "fourth")!
                break
            case 7:
                toneImage = UIImage(named: "fifth")!
                break
            case 8:
                toneImage = UIImage(named: "sixth")!
                break
            case 9:
                toneImage = UIImage(named: "sixth")!
                break
            case 11:
                toneImage = UIImage(named: "seventh")!
                break
            default:
                break
        }
        noteImageVIew.image = toneImage
    }

    //ハーモニックマイナースケール、メロディックマイナースケール aug,miner,majer,m-5
    /*-> true,true,true   :majer
         true,true,false  :aug
         true,false,true  :miner
         true,false,false :m♭5
         false,true,true、false,true,false、false,false,true、false,false,false:スケール外（リストに表示しない */
    //各コードのMajer Minerを判定するためのメソッド
    func judgeCode(firstElement:Bool,secondElement:Bool,thirdElement:Bool) ->String{
        
        var judgementCode:String = ""
        
        //firstElementがfalseのものは全てリストに表示しないため、条件分岐を利用して篩に掛ける
        if firstElement == true{
            if secondElement == true && thirdElement == true{
                judgementCode = "maj"
            }else if secondElement == true && thirdElement == false{
                judgementCode = "aug"
            }else if firstElement == false && secondElement == true{
                judgementCode = "minar"
            }else{
                judgementCode = "m♭5"
            }
        }else{
            judgementCode = "--"
        }
        return judgementCode
    }
    
    //    CustomCellの高さを定義するためのメソッド
    func judgeCellheight(firstElement:Bool)-> CGFloat{
        if firstElement == true{
            return 80
        }else{ //ダイアトニックスケール外の場合
            return 0
        }
    }
    
}

