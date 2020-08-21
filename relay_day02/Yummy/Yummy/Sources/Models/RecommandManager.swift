//
//  RecommandManager.swift
//  Yummy
//
//  Created by 김근수 on 2020/08/21.
//  Copyright © 2020 woong. All rights reserved.
//

import Foundation

class RecommendManager{
    public static let shared:RecommendManager = RecommendManager()
    public var keyWords = [String:Int]()
    private init() { }
    
    public func getRankedKeywords() -> [String]{
        let wordArray = Array(keyWords).sorted(by: {$0.value > $1.value }).map{ $0.key }
        return wordArray
    }
    
    public func updateKeyWords(_ input: [String]){
        for str in input {
            let tmp = String(str.split(separator: "/")[0]).split(separator: " ")
            processWords(String(tmp[0]))
        }
    }
    
    private func processWords(_ keyword: String){
        if let _ = keyWords[keyword]{
            keyWords[keyword]! += 1
        }else{
            keyWords[keyword] = 1
        }
    }
}
