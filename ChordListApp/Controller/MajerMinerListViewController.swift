//
//  MajerMinerListViewController.swift
//  ChordListApp
//
//  Created by 渡邉天彰 on 2020/07/16.
//  Copyright © 2020 takaaki watanabe. All rights reserved.
//

import UIKit

class MajerMinerListViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
    
    //前画面から取得する値
    var pickUpKey:Int?
    var pickUpScale:Int?
    var pickUpSignature:Int?
    
    /*# ♭それぞれのトーンを配列で用意
     このいずれかを、useScaleArrayへ格納する*/
    let sharpToneList:Array<String> = ["C","C#","D","D#","E","F","F#","G","G#","A","A#","B","C","C#","D","D#","E","F","F#","G","G#","A","A#","B","C","C#","D","D#","E"]
    let flatToneList:Array<String> = ["C","D♭","D","E♭","E","F","G♭","G","A♭","A","B♭","B","C","D♭","D","E♭","E","F","G♭","G","A♭","A","B♭","B","C","D♭","D","E♭","E"]
    
    /*メジャースケール、マイナースケールそれぞれのルート、3rd、5thを二次元配列で格納
    このいずれかを、displayScareArrayへ格納する*/
    let MAJERSCALE_CONSITUTION_ARRAY: [[Int]] = [[0,4,7],[1,5,8],[2,5,9],[3,6,10],[4,7,11],[5,9,12],[6,10,13],[7,11,14],[8,12,15],[9,12,16],[10,13,17],[11,14,17]]
    let MINERSCALE_CONSITUTION_ARRAY: [[Int]] = [[0,3,7],[1,4,8],[2,5,8],[3,7,10],[4,8,11],[5,8,12],[6,9,13],[7,10,14],[8,12,15],[9,14,16],[10,14,17],[11,15,18]]
    
    /*Viewへ表示するための判定をする配列
     このいずれかを、displayScareArrayへ格納する*/
    let MAJER_SCALE:[[Bool]] = [[true,true],[false,false],[true,false],[false,false],[true,false],[true,true],[false,false],[true,true],[false,false],[true,false],[false,false],[false,true]]
    let MINER_SCALE:[[Bool]] = [[true,false],[false,false],[false,true],[true,true],[false,false],[true,false],[false,false],[true,false],[true,true],[false,false],[true,true],[false,false]]
    //↑のいずれかをこれに格納する
    var judgeDisplayScareArray:[[Bool]] = []
    
    //#か♭か使う配列を格納するための配列
    var useScaleArray:Array<String> = []
    
    //userScaleArrayに入れた配列をルート音以降だけに抽出した配列を格納するための配列
    var adjustToneArray:Array<String> = []
    
    //MAJERSCALE_CONSITUTION_ARRAYかMINERSCALE_CONSITUTION_ARRAYを格納するための配列
    var useConsituTionArray:[[Int]] = []
    
    //TriadTableViewCell.swiftに値を渡すため、Model内に用意したTriadCode.swiftを用意する
    var triadCodeArray:Array<TriadCode> = []
    
    //非表示にしたいcellの高さを0で返したいので、変数を用意
    var cellHeight:CGFloat = 0
    
    //Storyboard上に設置したUIを定義
    @IBOutlet weak var scaleListLabel: UILabel!
    @IBOutlet weak var diatonicTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        diatonicTableView.dataSource = self
        diatonicTableView.delegate = self
        
        
        //前画面から拾ってきたpickUpSignatureを使って#の配列を使うか♭の配列を使うかswitch文で選定
        switch pickUpSignature {
        case 1: //#だった場合
            useScaleArray = sharpToneList
            break
        case 2: //♭だった場合
            useScaleArray = flatToneList
            break
        default:
            print("pickUpSignature（調号の判定）のSwitch文がなにやらうまくいっていないらしい")
            break
        }
        
        //スケールのルート音以降の全ての配列をadjustToneListArrayに格納する
        adjustDisplayTone(tone: pickUpKey!)
        
        /*MajerスケールかMinerスケールかをここで判断。
        対象の配列をdisplayScaleArrayに格納する*/
        switch pickUpScale {
        case 0:
            judgeDisplayScareArray = MAJER_SCALE
            useConsituTionArray = MAJERSCALE_CONSITUTION_ARRAY
            scaleListLabel.text = "\(adjustToneArray[0])メジャースケール"
            break
        case 1:
            judgeDisplayScareArray = MINER_SCALE
            useConsituTionArray = MINERSCALE_CONSITUTION_ARRAY
            scaleListLabel.text = "\(adjustToneArray[0])マイナースケール"
            break
        default:
            print("pickUpScale（メジャーかマイナーかどっちのスケールか）のSwitch文がなにやらうまくいっていないらしい")
            break
        }
        

        diatonicTableView.register(UINib(nibName: "TriadTableViewCell", bundle: nil), forCellReuseIdentifier:  "TriadCell")
    }
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 12
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let indexPathNumber = Int(indexPath.row)
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TriadCell",for: indexPath) as! TriadTableViewCell
        
        // TriadTableViewCell.swift　に渡すように各配列を定数へ格納
        let firstElement = judgeDisplayScareArray[indexPath.row][0]
        let secondElement = judgeDisplayScareArray[indexPath.row][1]
        
        //各配列がMajerコードか、Minerコードかをここで判定して、judgeCodeに格納している
        let judgeCode = cell.judgeCode(firstElement: firstElement, secondElement: secondElement)
        
        //CustomCellの高さを判定するメソッド
        cellHeight = cell.judgeCellheight(firstElement: firstElement, secondElement: secondElement)
        print("cellHeight:\(cellHeight)")
        //triadCodeArrayを配列で宣言していたので、その末尾にTriadCode型の配列を追加
          triadCodeArray.append(TriadCode())
          
          //TriadTableViewCellで実装しているsetTriadCodeに以下のパラメータを入れていく
          
          triadCodeArray[indexPathNumber].rootNote = self.adjustToneArray[useConsituTionArray[indexPath.row][0]]
          triadCodeArray[indexPathNumber].triadCode = judgeCode
          triadCodeArray[indexPathNumber].rootToneNumber = self.adjustToneArray[useConsituTionArray[indexPath.row][0]]
          triadCodeArray[indexPathNumber].thirdToneNumber = self.adjustToneArray[useConsituTionArray[indexPath.row][1]]
          triadCodeArray[indexPathNumber].fifthToneNumber = self.adjustToneArray[useConsituTionArray[indexPath.row][2]]

          triadCodeArray[indexPathNumber].toneNumber = indexPathNumber
          
          cell.setTriadCode(triadCode: triadCodeArray[indexPathNumber])

          return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeight
    }

    
    //スケールのルート音以降の全ての配列をadjustToneListArrayに格納する
    //tone = pickUpKey
    func adjustDisplayTone(tone:Int){
            
        //dropFirst()メソッドを使うと、arraySlice型で出力されるため、それをさらにArray型にキャストする必要がある
        let arraySlice = useScaleArray.dropFirst(tone)
        adjustToneArray = Array(arraySlice)
        
    }

}
