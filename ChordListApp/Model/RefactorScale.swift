//
//  refactorScale.swift
//  ChordListApp
//
//  Created by 渡邉天彰 on 2020/07/16.
//  Copyright © 2020 takaaki watanabe. All rights reserved.
//

import Foundation

class RefactorScale{
    
    let sharpToneList:Array<String> = ["C","C#","D","D#","E","F","F#","G","G#","A","A#","B","C","C#","D","D#","E","F","F#","G","G#","A","A#","B","C","C#","D","D#","E"]
    let flatToneList:Array<String> = ["C","D♭","D","E♭","E","F","G♭","G","A♭","A","B♭","B","C","D♭","D","E♭","E","F","G♭","G","A♭","A","B♭","B","C","D♭","D","E♭","E"]

    let MAJER_SCALE:[[Bool]] = [[true,true],[false,false],[true,false],[false,false],[true,false],[true,true],[false,false],[true,true],[false,false],[true,false],[false,false],[false,true]]
    let MINER_SCALE:[[Bool]] = [[true,false],[false,false],[false,true],[true,true],[false,false],[true,false],[false,false],[true,false],[true,true],[false,false],[true,true],[false,false]]
}
