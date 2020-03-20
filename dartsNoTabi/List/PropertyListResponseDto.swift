import Foundation
/// 駅名一覧APIレスポンスDTO(駅名一覧用)
struct PropertyListResponseDto {
    let point: Point

    struct Point: Codable {
        let station: [Station]
    }
    
    struct Station: Codable {
        ///駅名
        let name: String?
        ///駅コード
        let code: String?
        ///駅名よみがな
        let yomi: String?
      
        private enum CodingKeys: String, CodingKey {
            case name = "name"
            case code = "code"
            case yomi = "yomi"
           
        }
    }
}
