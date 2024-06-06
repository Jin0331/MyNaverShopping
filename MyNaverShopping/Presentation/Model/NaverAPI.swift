//
//  NaverShoppingAPI.swift
//  SeSAC Shopping
//
//  Created by JinwooLee on 2/6/24.
//

import UIKit
import Alamofire

enum NaverAPI {
    
    static let baseURL = "https://openapi.naver.com/v1/search/"
    static let header : HTTPHeaders = ["X-Naver-Client-Id" : API.naverClientId,    
                                       "X-Naver-Client-Secret": API.naverClientSecret]
    static var method : HTTPMethod = .get
    
    //MARK: - Error 관련 Enum
    enum APIError : Error {
        case failedRequeset
        case noData
        case invalidResponse
        case invalidData
        case invalidDecodable
    }
    
    //MARK: - API request sort 관련
    enum RequestSort : String, CaseIterable {
        case sim
        case date
        case dsc
        case asc
        
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
        
        var textValue : String {
            switch self {
            case .sim:
                return "정확도"
            case .date:
                return "날짜순"
            case .dsc:
                return "가격높은순"
            case .asc:
                return "가격낮은순"
            }
        }
        
        var caseValue : String {
            switch self {
            default:
                return String(describing: self)
            }
        }
    }
    
    enum Shop : CaseIterable {
        static var allCases: [NaverAPI.Shop] {
            return [.shop(query: "", display: "", sort:"", start: "")]
        }

        case shop(query:String, display:String, sort:String, start:String)
        
        var endPoint : URL {
            get {
                switch self {
                default :
                    return URL(string: NaverAPI.baseURL + "shop.json")!
                }
            }
        }
        
        var start : String {
            switch self {
            case .shop(let query, let display, let sort, let start):
                return start
            }
        }
        
        var parameter : Parameters {
            switch self {
            case .shop(let query, let display, let sort, let start):
                return ["language":"ko-KR",
                        "query":query,
                        "display":display,
                        "sort":sort,
                        "start":start]
            }
        }
    }
    
    
}
