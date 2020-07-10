//
//  ViewController.swift
//  ChordListApp
//
//  Created by 渡邉天彰 on 2020/07/08.
//  Copyright © 2020 takaaki watanabe. All rights reserved.
//

import UIKit

class TopViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {

    //♭か#かを判定
    //0 = ♭、1 = #
    var signatureState: Int = 1
    


    @IBOutlet weak var signatureSwitchView: UISwitch!
    @IBOutlet weak var scaleTextField: UITextField!
    @IBOutlet weak var keyTextField: UITextField!
    //ドラムロールの
    @IBOutlet weak var choiceScalePicker: UIPickerView!
    @IBOutlet weak var choiceKeyPicker: UIPickerView!
    //選択したコードを表示するためのダイアログを定義
    var comfilmSelectChord: UIAlertController!
    
    let pickerView = UIPickerView()
    // ドラムロールボタンの選択肢を配列にして格納
    let keyDataSourceSharp =  ["C","C#","D","D#","E","F","F#","G","G#","A","A#","B"]
    let keyDataSourceflat =  ["C","D♭","D","E♭","E","F","G♭","G","A♭","A","B♭","B"]
    let scaleDataSource = ["メジャースケール","マイナースケール","ハーモニックマイナースケール","メロディックマイナースケール"]
    
    override func viewDidLoad() {
        super.viewDidLoad()



        // pickerViewの配置するx,yと幅と高さを設定.
        choiceKeyPicker.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: choiceKeyPicker.bounds.size.height)
        choiceScalePicker.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: choiceScalePicker.bounds.size.height)
        
        // Delegateを自身に設定する
        choiceKeyPicker.delegate = self
        choiceScalePicker.delegate = self

        
        // 選択肢を自身に設定する
        choiceKeyPicker.dataSource = self
        choiceScalePicker.dataSource = self
        // pickerViewをViewに追加する
        let keyPickerView = UIView(frame: choiceKeyPicker.bounds)
        keyPickerView.backgroundColor = UIColor.white
        keyPickerView.addSubview(choiceKeyPicker)
        
        let scalePickerView = UIView(frame: choiceScalePicker.bounds)
        scalePickerView.backgroundColor = UIColor.white
        scalePickerView.addSubview(choiceScalePicker)

        scaleTextField.text = ""
        keyTextField.text = ""
        
        scaleTextField.inputView = scalePickerView
        keyTextField.inputView = keyPickerView

    }


    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView.tag == 1{
            if signatureState == 1{
                return keyDataSourceSharp[row]
            }else{
                return keyDataSourceflat[row]
            }
        }else{
            return scaleDataSource[row]
        }
    }

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView.tag == 1{
            if signatureState == 1{
                return keyDataSourceSharp.count
            }else{
                return keyDataSourceflat.count
            }
        }else{
            return scaleDataSource.count
        }
    }

    // 各選択肢が選ばれた時の操作
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView.tag == 1{
            if signatureState == 1{
                keyTextField.text = keyDataSourceSharp[row]
            }else{
                keyTextField.text = keyDataSourceflat[row]
            }
        }else if pickerView.tag == 2{
            scaleTextField.text = scaleDataSource[row]
        }
        scaleTextField.endEditing(true)
        keyTextField.endEditing(true)
    }
    
    func datasourceSelecter(){
        
    }
    
    
    func comfilmSelectChordAlert(Selectkey: Int){
        if pickerView.tag == 1{
            comfilmSelectChord = UIAlertController(title:"キーは\(keyDataSourceSharp[Selectkey])", message: "キーはこれでいいですか？", preferredStyle: .alert)
            let cancell:UIAlertAction = UIAlertAction(title: "OK", style: .cancel, handler:{
                (action: UIAlertAction!) in
                print("タップされたよ")
                
            })
            comfilmSelectChord.addAction(cancell)
            present(comfilmSelectChord, animated: true, completion: nil)
        }else{
            
        }
    }
    @IBAction func signatureSwitch(_ sender: UISwitch) {
        if sender.isOn {
            //onの時の処理
            signatureState = 1
        }else{
            signatureState = 0
        }
    }
}
