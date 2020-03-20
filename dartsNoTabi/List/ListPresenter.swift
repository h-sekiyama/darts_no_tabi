//
//  DetailPresenter.swift
//  dartsNoTabi
//
//  Created by 関山　秀光 on 2020/02/28.
//  Copyright © 2020 関山　秀光. All rights reserved.
//

import Foundation

typealias ListPresenterDependencies = (
    router: ListRouterTransitionProtocol,
    interactor: ListInteractorProtocol
)

class ListPresenter {
    
    private weak var view: ListViewController?
    /// 遷移時のパラメータ
    private let entry: ListEntryEntity
    
    /// 遷移元（VC）
    private weak var transition: ViewControllerTransition?
    
    private let dependencies: ListPresenterDependencies
    
    /// リスト状態
    private var listState: ListState?

    /// 駅名一覧のリスト状態
    private class ListState {
        /// 一覧Dto
        var items: [PropertyListResponseDto.Station]
        /// チェック状態
        var checkIndices: [Int]
        /// ページ数
        var page: Int
        /// 更読みエラー
        var isLoadMoreError: Bool
        /// フェッチ状態
        var isFetching: Bool

        init(items: [PropertyListResponseDto.Station]) {
            self.items = items
            checkIndices = []
            page = 1
            isLoadMoreError = false
            isFetching = false
        }
    }
    
    /// イニシャライザ
    init(
        entry: ListEntryEntity,
        view: ListViewController,
        transition: ViewControllerTransition,
        dependencies: ListPresenterDependencies? = nil) {
            // entry.propertyTypeをanalyticsに設定したいため、初期値をinit内で生成しています。
            self.dependencies = dependencies ?? ListPresenterDependencies(
                router: ListRouterTransition(),
                interactor: ListInteractor())
            self.entry = entry
            self.view = view
            self.transition = transition
        }
    
    // 1件目からの駅名一覧を取得します
    private func fetchFirstPage() {
        // リスト状態の初期化
        listState = nil
        view?.reload()
        
        dependencies.interactor.fetchPropertyList(type: entry.propertyType,
                                                  page: 1)
            .done { [weak self] listDto in
                self?.handleFirstPageFetchSuccess(listDto: listDto.point)
            }
            .catch { [weak self] error in
                self?.handleFirstPageFetchError(error: error)
        }
    }

    /// 初回fetch成功時の処理
    ///
    /// - Parameters:
    ///   - listDto: API結果(一覧)
    private func handleFirstPageFetchSuccess(listDto: PropertyListResponseDto.Point) {
        let listState = ListState(items: listDto.station)
        self.listState = listState

        view?.reload()

    }
        
    /// 初回fetch失敗時の処理
    ///
    /// - Parameters:
    ///   - error: エラー。
    private func handleFirstPageFetchError(error: Error) {
//        view?.configureLoading(false)
//        view?.configureRetry(true)
    }
}

extension ListPresenter: ListDelegate {

    func didLoad() {
        fetchFirstPage()
    }

    func willAppear() {

    }
}

extension ListPresenter: ListItemDataSource {
    
    var numberOfItems: Int {
        return listState?.items.count ?? 0
    }
    
    func item(at: Int) -> ListPropertyViewModel? {
        guard let listState = listState,
            at < listState.items.count else {
                return nil
        }
        let item = listState.items[at]
        return .from(item: item)
    }
    

}
