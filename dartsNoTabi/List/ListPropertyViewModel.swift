/// リストViewModel
struct ListPropertyViewModel {

    /// ピクト
    enum Pict {
        /// 新着
        case new
        /// 価格更新
        case update
        /// 表示なし
        case none
    }

    /// ## 駅名
    let name: String

    /// ## 駅コード
    let imageUrl: String?

    /// モデル生成
    ///
    /// - Parameters:
    ///   - item: 駅名Dto
    ///   - isMyList: マイリスト登録済ならtrue
    ///   - isChecked: まとめて資料請求チェックされてるならtrue
    /// - Returns: ViewModel
    static func from(item: PropertyListResponseDto.Station) -> ListPropertyViewModel {
        return ListPropertyViewModel(
            name: item.name!,
            imageUrl: item.code)
    }
}
