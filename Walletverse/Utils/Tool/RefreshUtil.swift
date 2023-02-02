//
//  RefreshUtil.swift
//  Walletverse
//
//  Created by Ky on 2022/9/29.
//  Copyright © 2022 Walletverse. All rights reserved.
//

import UIKit
import MJRefresh

extension UIScrollView {
    var uHead: MJRefreshHeader {
        get { return mj_header }
        set { mj_header = newValue }
    }
    var uFoot: MJRefreshFooter {
        get { return mj_footer }
        set { mj_footer = newValue }
    }
}

class URefreshHeader: MJRefreshNormalHeader {
    override func prepare() {
        super.prepare()
        
        setTitle("Pull down to refresh", for: .idle)
        setTitle("Release to refresh", for: .pulling)
        setTitle("Loading ...", for: .refreshing)
        
        stateLabel.font = FontSystem(size: 15)
        lastUpdatedTimeLabel.font = FontSystem(size: 14)
    }
}

class URefreshAutoHeader: MJRefreshHeader {}

class URefreshFooter: MJRefreshBackNormalFooter {}

class URefreshAutoFooter: MJRefreshAutoFooter {}

class URefreshDiscoverFooter: MJRefreshAutoNormalFooter {
    override func prepare() {
        super.prepare()
        
        setTitle("Click or drag up to refresh", for: .idle)
        setTitle("Loading more ...", for: .refreshing)
        setTitle("No more data", for: .noMoreData)
        
        stateLabel.font = FontSystem(size: 15)
        stateLabel.font = FontSystem(size: 15)
        
        refreshingBlock = { self.endRefreshing() }
    }
}

class URefreshTipKissFooter: MJRefreshBackFooter {
    
    lazy var tipLabel: UILabel = {
        let tl = UILabel()
        tl.textAlignment = .center
        tl.textColor = UIColor.lightGray
        tl.font = UIFont.systemFont(ofSize: 14)
        tl.numberOfLines = 0
        return tl
    }()
    
    lazy var imageView: UIImageView = {
        let iw = UIImageView()
        return iw
    }()
    
    override func prepare() {
        super.prepare()
        backgroundColor = UIColor.random
        mj_h = 240
        addSubview(tipLabel)
        addSubview(imageView)
    }
    
    override func placeSubviews() {
        tipLabel.frame = CGRect(x: 0, y: 40, width: bounds.width, height: 60)
        imageView.frame = CGRect(x: (bounds.width - 80 ) / 2, y: 110, width: 80, height: 80)
    }
    
    convenience init(with tip: String) {
        self.init()
        refreshingBlock = { self.endRefreshing() }
        tipLabel.text = tip
    }
}
