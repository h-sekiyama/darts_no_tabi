import Foundation

/// baseURL作成クラス
public struct ApiBaseURLCreator {
    /// urlとパラメータを結合する。
    /// - parameter url     : ベースとなるURL
    /// - parameter uid     : UIDパラメータ
    /// - parameter key     : KEYパラメータ
    /// - returns           : 結合された文字列
    public static func baseUrl(url: String) -> String {
        return url
    }

    /// urlとパラメータを結合する。
    /// - parameter url     : ベースとなるURL
    /// - parameter aid     : AIDパラメータ
    /// - parameter apw     : APWパラメータ
    /// - parameter key     : KEYパラメータ
    /// - returns           : 結合された文字列
//    static func baseUrl(url: String, aid: String, apw: String, key: String, date: Date = Date()) -> String {
//        let stmp = DateFormatter.japaneseFormatter(withDateFormat: "yyMMdd").string(from: date)
//        let params = ["AID=\(aid)", "APW=\(apw)", "KEY=\(key.sha1())\(stmp.sha1())"]
//        return params.reduce(into: url, joinURL)
//    }

    /// 文字列に"?"が含まれていれば"&","?"が含まれていなければ"?"をつけてパラメータを結合する
    /// - parameter url     : ベースとなるURL(ここにパラメータが足されて行く）
    /// - parameter param   : パラメータ
    public static func joinURL(url:inout String, param: String) {
        let delim = url.contains("?") ? "&" : "?" ///初めから"?"が付いていた場合"?&"となりますが許容としています。
        url += delim + param
    }
}
