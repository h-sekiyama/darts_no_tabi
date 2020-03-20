import Foundation
import PromiseKit

typealias ListInteractorDependencies = (
    propertyListApi: PropertyListApiProtocol,
    mylistService: MylistServiceProtocol
)

protocol ListInteractorProtocol {
    /// 駅名一覧APIをフェッチします。
    ///
    /// - Parameters:
    ///   - page: ページ位置
    func fetchPropertyList(type: PrefectureCode,
                           page: Int) -> Promise<PropertyListResponseDto>
}

class ListInteractor {

    private let dependencies: ListInteractorDependencies
    
    init(
        dependencies: ListInteractorDependencies = (
        propertyListApi: PropertyListApi(),
        mylistService: MylistService()
        )){

        self.dependencies = dependencies
    }
}

extension ListInteractor: ListInteractorProtocol {
    
    func fetchPropertyList(type: PrefectureCode,
                           page: Int) -> Promise<PropertyListResponseDto> {
        let dto = PropertyListRequestDto(
            prefectureCode: 13,
            offset: 1,
            limit: 100)
        return dependencies.propertyListApi.get(dto)
    }
}
