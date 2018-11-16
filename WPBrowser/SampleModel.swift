//
//  SampleModel.swift
//  WPBrowser
//
//  Created by ymgn on 2018/11/16.
//  Copyright © 2018 ymgn. All rights reserved.
//

import Foundation

struct SampleModel: Codable {
    var link: String = "" // 記事のURL
    var date: String = "" // 記事公開日
    
    var title: SampleTitleModel = SampleTitleModel() // 記事のタイトル
    struct SampleTitleModel: Codable {
        var rendered: String = ""
    }
}
