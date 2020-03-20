import Foundation

/// 依存性
typealias ListRouterTransitionDependencies = (
    detailRouter: ListRouterEntry,
    inquiryRouter: Any?  // サンプル用ダミー
)

protocol ListRouterTransitionProtocol {
    
}

class ListRouterTransition: ListRouterTransitionProtocol {
    /// 依存性
    private let dependencies: ListRouterTransitionDependencies
    
    /// イニシャライザ
    ///
    /// - Parameter dependencies: 依存性
    init(dependencies: ListRouterTransitionDependencies = (
        detailRouter: ListRouter(),
        inquiryRouter: nil)) {

        self.dependencies = dependencies
    }
}

