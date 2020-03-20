import Foundation
import CryptoSwift
import PromiseKit

/// Api通信エラーコード
@objc
public enum ApiError: Int, Error {
    case recieveNilResponse = 0,    // レスポンスエラー
    recieveErrorHttpStatus,         // HTTPステータス
    recieveNilBody,                 // nilデータ
    failedParse,                    // パースエラー
    convertTags                     // タグコンバートエラー
}

/// HttpMethodの列挙型。必要に応じて追加してください。
public enum ApiMethod: String {
    case get = "GET"
    case post = "POST"
}

/// リクエスト情報プロトコル
public protocol RequestDto {
    /// パラメータ配列取得
    /// - Returns: パラメータ配列 同じkey名で複数つける場合がある為、辞書型ではなく独自型配列としています
    func params() -> [(key: String, value: String)]
}

//APIリクエストプロトコル
protocol ApiProtocol {
    /// リクエストします
    /// キャンセルする必要がないと判断した為、現時点ではキャンセルは実装していません。必要になった時に別メソッドを作成してください。
    /// - Parameters:
    ///   - apiMethod: GET or POST
    ///   - url: ベースURL
    ///   - dto: リクエストDto
    ///   - convertTags: trueの場合はタグ変換を行います。
    ///   - parser: パーサー
    /// - Returns: Promise
    func request(apiMethod: ApiMethod, url: String, dto: RequestDto, convertTags: Bool) -> Promise<Data>
}

/// NSURLSessionTaskを作ってHTTP通信を行うクラスです。
/// RequestDtoでパラメータを指定し、受信後に指定parserでパースしてentityを返却します。
/// GETの場合はパラメータを指定URLに追加、POSTの場合はDataに変換しbodyに設定します。
/// POSTの場合にGET情報も付与したい場合は、URLにあらかじめ付与しておいて下さい。
open class ApiTask: ApiProtocol {

    // MARK: - PubricParams
    /// HTTPHeader[ヘッダフィールド名: 対応する値]を記述する。
    /// よく使う値をdefaultとしている為、不要な場合はnilで上書きして下さい。
    public var httpHeader: [String: String]? = ["content-type": "application/x-www-form-urlencoded"]
    /// timeoutの時間
    /// default: 60
    public var timeoutInterval: TimeInterval = 60
    /// キャッシュ設定
    /// default: reloadIgnoringLocalCacheData(使用しない)
    public var cachePolicy: URLRequest.CachePolicy = .reloadIgnoringLocalCacheData
    /// 通信中のセッション
    static let apiTaskSession: URLSession = URLSession(configuration: URLSessionConfiguration.ephemeral)

    public init() {}

    public func request(apiMethod: ApiMethod, url: String, dto: RequestDto, convertTags isConvert: Bool = true) -> Promise<Data> {
        return Promise<Data> { seal in
            let urlRequest = ApiTaskURLCreator.createRequest(apiMethod: apiMethod,
                                                             url: url,
                                                             dto: dto,
                                                             header: httpHeader,
                                                             timeoutInterval: timeoutInterval,
                                                             cachePolicy: cachePolicy)
            let task = ApiTask.apiTaskSession.dataTask(with: urlRequest, completionHandler: {(data, response, error) in
                #if DEBUG
                    //self.debugUrlResponse(with: urlRequest, data: data, response: response)
                #endif

                if let error = error {
                    seal.reject(error)
                    return
                }
                if let responseError = ApiTask.check(response: response) {
                    seal.reject(responseError)
                    return
                }

                guard let data = data else {
                    seal.reject(ApiError.recieveNilBody)
                    return
                }

                if isConvert {
                    guard let data = self.convertTags(data) else {
                        let error = ApiError.convertTags
                        self.sendError(error as NSError)
                        seal.reject(error)
                        return
                    }
                    seal.fulfill(data)
                } else {
                    seal.fulfill(data)
                }
            })
            task.resume()
        }
    }

    // MARK: - エラーチェック

    /// エラー生成します
    ///
    /// - Parameters:
    ///   - code: ApiError
    ///   - info: 追加情報
    /// - Returns: NSError
    static func createError(_ code: ApiError, _ info: [String: Any]?) -> NSError {
        return NSError(domain: "ApiError", code: code.rawValue, userInfo: info)
    }

    /// レスポンスデータチェックをします
    ///
    /// - Parameter response: レスポンスデータ
    /// - Returns: エラーの場合はNSError 正常系はnil
    static internal func check(response: URLResponse?) -> NSError? {
        guard let notNilResponse = response else {
            return createError(.recieveNilResponse, nil)
        }

        let httpResponse = notNilResponse as! HTTPURLResponse
        guard (200..<300) ~= httpResponse.statusCode else {
            return createError(.recieveErrorHttpStatus, ["statusCode": httpResponse.statusCode])
        }
        return nil
    }

    // MARK: - タグ変換

    /// HTMLタグを変換します。
    /// データを文字列に変換し以下の置換後再度データに変換し返却します
    /// m<sup>2</sup> → ㎡
    /// <br> → \n
    /// <small>2</small> → 2
    /// - Parameter data: 変換前データ
    /// - Returns: 変換後データ
    internal func convertTags(_ data: Data) -> Data? {
        guard var str = String(data: data, encoding: .utf8) else {
            return nil
        }
        str = replaceSup2(str)
        str = replaceBr(str)
        str = replaceSmall(str)
        return str.data(using: .utf8)
    }

    /// 平米タグを正規表現置き換えします
    /// "m<sup\\s*>2</sup\\s*>" にmatchする文字列を大文字小文字区別なしで"㎡"に置換します
    /// m<sup>2</sup> → ㎡
    /// - Parameter str: 変換前文字列
    /// - Returns: 変換後文字列
    internal func replaceSup2(_ str: String) -> String {
        let pattern = "(?i)m<sup\\s*>2</sup\\s*>"
        let replace = "㎡"
        return  str.replacingOccurrences(of: pattern, with: replace, options: .regularExpression, range: nil)
    }

    /// BRタグを正規表現置き換えします(json用）
    /// "<br( )*(\\/|/)?>" にmatchする文字列を大文字小文字区別なしで"\\n"に置換する。Json用の為"\n"ではなく"\\n"としています。
    /// <br> → \\n
    /// - Parameter str: 変換前文字列
    /// - Returns: 変換後文字列
    internal func replaceBr(_ str: String) -> String {
        let pattern = "(?i)<br( )*(\\/|/)?>"
        let replace = "\\\\n"
        return  str.replacingOccurrences(of: pattern, with: replace, options: .regularExpression, range: nil)
    }

    /// smallタグを正規表現置き換えします
    /// "(?i)<(\\\\)?/?small( )*(\\\\/|/)?>" にmatchする文字列を大文字小文字区別なしで""に置換する
    /// <small>2</small> → 2
    /// - Parameter str: 変換前文字列
    /// - Returns: 変換後文字列
    internal func replaceSmall(_ str: String) -> String {
        let pattern = "(?i)<(\\\\)?/?small( )*(\\\\/|/)?>"
        let replace = ""
        return  str.replacingOccurrences(of: pattern, with: replace, options: .regularExpression, range: nil)
    }

    // MARK: - エラー送信

    /// ログ出力とCrashlyticsへのエラー送信
    /// - Parameter error: エラー
    private func sendError(_ error: NSError) {
        #if DEBUG
            print("**** タグ変換エラー ****:  \(error)")
        #endif
    }

    // MARK: - ログ

    /// URLResponseのログ出力
    /// - parameter urlRequest  : 出力するURLResponse
    /// - parameter data        : 出力するdata
    /// - parameter response    : 出力するURLResponse
    private func debugUrlResponse(with urlRequest: URLRequest, data: Data?, response: URLResponse?) {
        print(#file, #function)
        let res: [String] = [
            "url: \(urlRequest.url?.absoluteString ?? "")",
            "status: \((response as? HTTPURLResponse)?.statusCode ?? 0)"
        ]
        let detail: [String] = [
            "response: \(response ?? URLResponse())",
            "data: \(String(describing: String(data: data ?? Data(), encoding: .utf8)))"
        ]
        print("レスポンス: {\(res.joined(separator: ", "))}")
        print("レスポンス詳細: {\(detail.joined(separator: ", "))}")
    }
}
