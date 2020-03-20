//
//  MainPresenter.swift
//  dartsNoTabi
//
//  Created by 関山　秀光 on 2020/02/27.
//  Copyright © 2020 関山　秀光. All rights reserved.
//

import Foundation

typealias MainPresenterDependencies = (
    router: MainRouterTransitionProtocol,
    interactor: MainInteractorProtocol
)

class MainPresenter {
    private var text: String = "sekky"
    private var view: MainView?
    private var delegate: MainDelegate?
    
    init(
        view: MainView
    ) {
        self.view = view
    }
    
}

extension MainPresenter: MainDelegate {
    func didLoad() {
        print("didLoad")
        view?.setText("didLoad")
    }
    
    func willAppear() {
        print("willAppear")
    }
    
    func onTapButton() {
        print("onTapButton")
    }
}


