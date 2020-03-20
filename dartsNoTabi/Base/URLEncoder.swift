public class URLEncoder {
    /// URLにエンコード
    ///
    /// - Parameter parameters: keyとvalueのタプル
    /// - Returns: エンコード文字列 (key1=value1&key2=value2)のような形式
    public class func encode(_ parameters: [(key: String, value: String)]) -> String {
        let encodedString: String = parameters.compactMap {
            guard let value = $0.value.addingPercentEncoding(withAllowedCharacters: .alphanumerics) else {
                return nil
            }
            return "\($0.key)=\(value)"
            }.joined(separator: "&")
        return encodedString
    }
}
