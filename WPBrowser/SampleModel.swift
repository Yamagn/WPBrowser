//
//  SampleModel.swift
//  WPBrowser
//
//  Created by ymgn on 2018/11/16.
//  Copyright © 2018 ymgn. All rights reserved.
//

import Foundation

struct SampleModel: Codable {
    var date: String = "" // 記事公開日
    var link: String = "" // 記事のURL
    
    var dateString: String {
        // DateFormatterのインスタンスを生成
        let formatter: DateFormatter = DateFormatter()
        
        // 受け取るフォーマットを設定
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        
        // 正常にDate型に変換できるか確認
        if let date = formatter.date(from: date) {
            // 表示するフォーマットを指定
            formatter.dateFormat = "yyyy/MM/dd HH:mm"
            
            // String型に変換を行い、返す
            let str = formatter.string(from: date)
            return str
        }
        // 万が一失敗した場合は、そのまま"date"を返す
        return date
    }
    
    var title: SampleTitleModel = SampleTitleModel() // 記事のタイトル
    struct SampleTitleModel: Codable {
        var rendered: String = ""
    }
}
