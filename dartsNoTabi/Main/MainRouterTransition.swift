//
//  Main.swift
//  dartsNoTabi
//
//  Created by 関山　秀光 on 2020/02/28.
//  Copyright © 2020 関山　秀光. All rights reserved.
//

import Foundation

///// 依存性
typealias MainRouterTransitionDependencies = (
    listRouter: ListRouterEntry,
    inquiryRouter: Any?  // サンプル用ダミー
)

protocol MainRouterTransitionProtocol {
    
}

class MainRouterTransition: MainRouterTransitionProtocol {
    /// 依存性
    private let dependencies: MainRouterTransitionDependencies
    
    init(dependencies: MainRouterTransitionDependencies = (
        listRouter: ListRouter(),
        nil)) {

        self.dependencies = dependencies
    }
}
