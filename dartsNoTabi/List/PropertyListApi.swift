import Foundation
import PromiseKit
/// ベースURL取得
/// - Returns: URL
private func baseURL() -> String {
    return "https://api.apigw.smt.docomo.ne.jp/ekispertCorp/v1/station?APIKEY=3536347a307777544266735a4b33304e4a633854617a78713653704a62332e497538532e526b3451562e2e&type=train"
}

/// 駅名一覧APIレスポンス全体（パースする為の最上位構造）
private struct PropertyListResponseDtos<T: Codable>: Codable {
    let resultset: Resultset?
    struct Resultset: Codable {
        let point: Piont?

        struct Piont: Codable {
            let station: [T]?
            let totalhits: Int?
        }
    }
}

/// PropertyListDetailParse独自エラー
///
/// - notFound: smatch.resultset.itemが空の場合
enum PropertyListDetailParseError: Error {
    case notFound
}
/// PropertyListParse独自エラー
///
/// - parseError: smatch.resultset.item,totalhitsがnilの場合
enum PropertyListParseError: Error {
    case parseError
}

protocol PropertyListApiProtocol {
    func get(_ dto: PropertyListRequestDto) -> Promise<PropertyListResponseDto>
}

/// 駅名一覧用
private func parse(_ data: Data) throws -> PropertyListResponseDto {
    let replacedData = try filterEmptyString(in: data)
    let response: PropertyListResponseDtos<PropertyListResponseDto.Point> =
        try JSONDecoder().decode(PropertyListResponseDtos<PropertyListResponseDto.Point>.self,
                                 from: replacedData)
    guard let rset = response.resultset?.point, let item = rset.station, let _ = rset.totalhits else {
        throw PropertyListParseError.parseError
    }
    return PropertyListResponseDto(point: item)
}

/// 駅名一覧API
struct PropertyListApi: PropertyListApiProtocol {
    private let api: ApiProtocol
    init(apiTask: ApiProtocol = ApiTask()) {
        api = apiTask
    }

//    func getDetail(_ dto: PropertyListDetailRequestDto) -> Promise<PropertyListDetailResponseDto> {
//        return api.request(apiMethod: .get, url: baseURL(), dto: dto, convertTags: true).compactMap { try parse($0) }
//    }

    func get(_ dto: PropertyListRequestDto) -> Promise<PropertyListResponseDto> {
        return api.request(apiMethod: .get, url: baseURL(), dto: dto, convertTags: true).compactMap { try parse($0) }
    }
}

