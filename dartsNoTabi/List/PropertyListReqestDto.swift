/// 駅名一覧用APIリクエストDTO
struct PropertyListRequestDto: RequestDto {
    /// 県名
    let prefectureCode: Int
    /// ページ番号
    let offset: Int
    // 表示数
    let limit: Int

    /// パラメータを返却します
    /// - returns : パラメータのタプル
    // swiftlint:disable cyclomatic_complexity
    func params() -> [(key: String, value: String)] {
        var params: [(key: String, value: String)] = []
        
        /* 可変パラメータ */

        // ページ番号
        params.append(("offset", String(offset)))
        // 県名
        params.append(("prefectureCode", String(prefectureCode)))
        // 表示数
        params.append(("limit", String(limit)))

        return params
    }
    // swiftlint:enable cyclomatic_complexity
}

private extension Bool {
    func toParam() -> String {
        return self == true ? "1" : "0"
    }
}
