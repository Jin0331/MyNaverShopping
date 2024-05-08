//
//  APIManager.swift
//  Recap Assignment
//
//  Created by JinwooLee on 1/23/24.
//

import Foundation
import Alamofire

class NaverShoppingAPIManager {
    
    static let shared = NaverShoppingAPIManager()
    
    private init() { }
    
 
    //MARK: - API request sort 관련
    enum RequestSort : String, CaseIterable {
        case sim = "정확도"
        case date = "날짜순"
        case dsc = "가격높은순"
        case asc = "가격낮은순"
        
        var index : Int {
            switch self {
            case .sim :
                return 0
            case .date :
                return 1
            case .asc :
                return 2
            case .dsc :
                return 3
            }
        }
        
        var caseValue : String {
            switch self {
            default:
                return String(describing: self)
            }
        }
    }
    
    // 🔥Alamofire🔥
    func callRequestAF(text : String, start : Int, display : Int, sort : String = RequestSort.sim.caseValue, completaionHandler : @escaping (NaverShoppingModel, Int) -> ()) {
        
        let query = text.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
let url = "https://openapi.naver.com/v1/search/shop.json?query=\(query)&display=\(display)&sort=\(sort)&start=\(start)"
        
        let header : HTTPHeaders = [
            "X-Naver-Client-Id" : API.naverClientId,
            "X-Naver-Client-Secret": API.naverClientSecret]
        
        AF.request(url, method: .get, headers: header)
            .responseDecodable(of: NaverShoppingModel.self) { response in
                switch response.result {
                case .success(let success) :
                    print("조회 성공")
                    
                    completaionHandler(success, start)
                    
                case .failure(let failure) :
                    print(#function)
                    dump(failure)
                }
            }
    }
    
    
    func callRequestURLSession<T: Decodable>(api : NaverAPI.Shop, completionHandler : @escaping (T?, Int?, NaverAPI.APIError?) -> Void) {
        
        // URL Request 부분
        // ✅ query 추가 !!! 이모지!?
        var urlComponents = URLComponents(string: api.endPoint.absoluteString)
        let queryItems = api.parameter.map { (key: String, value: Any) in
            
            if let value = value as? String {
                return URLQueryItem(name: key, value: value)
            } else {
                return URLQueryItem(name: key, value: "")
            }
        }
        urlComponents?.queryItems = queryItems
        
        var url = URLRequest(url: (urlComponents?.url)!)
        url.httpMethod = "GET"
        url.addValue(API.naverClientId, forHTTPHeaderField: "X-Naver-Client-Id")
        url.addValue(API.naverClientSecret, forHTTPHeaderField: "X-Naver-Client-Secret")
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            DispatchQueue.main.async {
                
                guard error == nil else {
                    completionHandler(nil, nil, .failedRequeset)
                    return
                }
                
                guard let data = data else {
                    completionHandler(nil, nil,.noData)
                    return
                }
                
                guard let response = response as? HTTPURLResponse else {
                    completionHandler(nil, nil, .invalidResponse)
                    return
                }
                
                guard response.statusCode == 200 else {
                    completionHandler(nil, nil, .invalidData)
                    return
                }
                
                do {
                    let result = try JSONDecoder().decode(T.self, from: data)
                    completionHandler(result, Int(api.start), nil)
                } catch {
                    completionHandler(nil, nil, .invalidDecodable)
                }
            }
        }.resume()
    }
    
    // Swift Concurrency
    func callRequestURLSessionConcurrency<T: Decodable>(api : NaverAPI.Shop) async throws -> (T?, Int?) {
        var urlComponents = URLComponents(string: api.endPoint.absoluteString)
        let queryItems = api.parameter.map { (key: String, value: Any) in
            
            if let value = value as? String {
                return URLQueryItem(name: key, value: value)
            } else {
                return URLQueryItem(name: key, value: "")
            }
        }
        urlComponents?.queryItems = queryItems
        
        var request = URLRequest(url: (urlComponents?.url)!)
        request.httpMethod = "GET"
        request.addValue(API.naverClientId, forHTTPHeaderField: "X-Naver-Client-Id")
        request.addValue(API.naverClientSecret, forHTTPHeaderField: "X-Naver-Client-Secret")
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            throw NaverAPI.APIError.invalidResponse
        }
        
        do {
            let result = try JSONDecoder().decode(T.self, from: data)
            return (result, Int(api.start))
        } catch {
            throw NaverAPI.APIError.invalidDecodable
        }
    }
}
