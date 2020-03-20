import Foundation

public class ApiTaskURLCreator {

    // MARK: - PublicFunc
    /// RequestDtoからURL, HTTPMethod, Header, Bodyを設定済みのNSURLRequestを作成します。
    /// - returns: 設定済みのNSURLRequest
    static func createRequest(apiMethod: ApiMethod,
                              url: String,
                              dto: RequestDto,
                              header: [String: String]?,
                              timeoutInterval: TimeInterval,
                              cachePolicy: URLRequest.CachePolicy) -> URLRequest {

        let urlRequest = NSMutableURLRequest()
        urlRequest.httpMethod = apiMethod.rawValue
        urlRequest.timeoutInterval = timeoutInterval
        urlRequest.cachePolicy = cachePolicy
        if let httpHeader = header {
            httpHeader.forEach {
                urlRequest.setValue($0.1, forHTTPHeaderField: $0.0)
            }
        }
        if apiMethod == .get {
            urlRequest.url = URL(string: appendUrlGetParameter(url: url, parameter: URLEncoder.encode(dto.params())))
        } else {
            urlRequest.url = URL(string: url)
            urlRequest.httpBody = URLEncoder.encode(dto.params()).data(using: String.Encoding.utf8, allowLossyConversion: false)
        }
        #if DEBUG
            debugUrlRequest(with: urlRequest as URLRequest)
        #endif
        return urlRequest as URLRequest
    }

    /// dtoとbaseURLからURL生成
    ///
    /// - Parameters:
    ///   - url: ベースURL
    ///   - dto: リクエストDto
    /// - Returns: URL
    public static func getURL(url: String,
                       dto: RequestDto) -> String {
        return appendUrlGetParameter(url: url, parameter: URLEncoder.encode(dto.params()))
    }
    /// Urlにパラメータを追加する
    /// urlに?がある場合は&をデリミタにする
    /// 　urlのサフィックスが?か&の場合はデリミタをつけない
    /// urlに?がない場合はデリミタを?にする
    ///
    /// - Parameters:
    ///   - url: url
    ///   - parameter: 追加するパラメータ
    /// - Returns: パラメータ合成されたUrl
    static func appendUrlGetParameter(url: String, parameter: String) -> String {
        let separator: String
        if url.contains("?") {
            if ["?", "&"].contains(url.suffix(1)) {
                separator = ""
            } else {
                separator = "&"
            }
        } else {
            separator = "?"
        }
        return [url, parameter].joined(separator: separator)
    }

    // MARK: - ログ

    /// URLRequestのログ出力
    /// - parameter urlRequest: 出力するURLRequest
    static private func debugUrlRequest(with urlRequest: URLRequest) {
        let details: [String] = [
            "timeoutInterval: \(urlRequest.timeoutInterval)",
            "method: \(urlRequest.httpMethod ?? "")",
            "cachePolicy: \(urlRequest.cachePolicy)",
            "allHTTPHeaderFields: \(urlRequest.allHTTPHeaderFields ?? [:])",
            "body: \(String(data: urlRequest.httpBody ?? Data(), encoding: .utf8) ?? "")"
        ]
        let detail: String = details.joined(separator: ", ")
        print(#file, #function)
        print("リクエスト: {url: \(urlRequest.url?.absoluteString ?? "")}")
        print("リクエスト詳細: {\(detail)}")
    }
}
