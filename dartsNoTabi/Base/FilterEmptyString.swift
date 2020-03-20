import Foundation
/// JSON内の空文字を削除
///
/// - Parameters:
///   - json: JSONのData
///   - prettyPrint: 返却値をprettyPrintするならtrue(デフォルトfalse)
/// - Returns: 空文字が削除されたJSON
/// - Throws: JSONSerializationで例外が発生した時
/// - Note: トップレベルがオブジェクト、オブジェクトの配列のみ対応。文字列配列など、それ以外の値がトップレベルは非対応（まま返却される）
public func filterEmptyString(in json: Data, prettyPrint: Bool = false) throws -> Data {
    let obj = try JSONSerialization.jsonObject(with: json, options: [])
    let resultObj: Any
    switch obj {
    case let dict as  [String: Any]:
        resultObj = filterEmptyString(in: dict)
    case let arr as  [[String: Any]]:
        resultObj = arr.map(filterEmptyString)
    default:
        resultObj = obj
    }
    let opt: JSONSerialization.WritingOptions = prettyPrint ? .prettyPrinted : []
    return try JSONSerialization.data(withJSONObject: resultObj, options: opt)
}

/// Dictionary内の空文字を削除
///
/// - Parameter dictionary: Dictionary
/// - Returns: 空文字を削除したDictionary
/// - Note:
///   - 空文字はキーごと削除される
///   - 文字列配列も空文字要素を除去する
///   - nilは削除しない（文字列配列も同様）
///   - ネストしたDictionary、Dictionaryの配列も再帰的に処理
public func filterEmptyString(in dictionary: [String: Any]) -> [String: Any] {
    var result: [String: Any] = [:]
    dictionary.forEach { key, value in
        switch value {
        case let str as String where str.isEmpty:
            return
        case let dict as [String: Any]:
            result[key] = filterEmptyString(in: dict)
        case let arr as [String?]:
            result[key] = arr.filter { str in str.map { !$0.isEmpty } ?? true } //nilは除去しません
        case let arrDict as [[String: Any]]:
            result[key] = arrDict.map { filterEmptyString(in: $0) }
        default:
            result[key] = value
        }
    }
    return result
}
