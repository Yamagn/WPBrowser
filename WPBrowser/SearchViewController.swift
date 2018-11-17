//
//  SearchViewController.swift
//  WPBrowser
//
//  Created by ymgn on 2018/11/17.
//  Copyright © 2018 ymgn. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {
    
    // UISearchControllerを変数として保持しておく
    var searchController: UISearchController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 検索結果を表示するSearchResultViewControllerのインスタンス
        let searchResultViewController = SearchResultViewController()
        
        // UISearchControllerのインスタンス生成＆検索結果画面をSearchResultViewControllerに指定
        searchController = UISearchController(searchResultsController: searchResultViewController)
        
        // このクラスを表示の起点とする
        self.definesPresentationContext = true
        
        // ナビゲーションバーに検索窓を表示する
        self.navigationItem.searchController = searchController
        
        // ナビゲーションバーにタイトルを入れる
        self.title = "検索"
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationItem.largeTitleDisplayMode = .automatic
        
        // 検索処理をどのクラスで処理をするかを指定
        // SearchResultViewControllerを指定
        searchController.searchResultsUpdater = searchResultViewController
    }

}
