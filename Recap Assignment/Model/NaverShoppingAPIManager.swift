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
    
    
    func callRequest(text : String, start : Int, display : Int, sort : String = RequestSort.sim.caseValue, completaionHandler : @escaping (NaverShopping, Int) -> ()) {
        
        let query = text.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        let url = "https://openapi.naver.com/v1/search/shop.json?query=\(query)&display=\(display)&sort=\(sort)&start=\(start)"
        
        let header : HTTPHeaders = [
            "X-Naver-Client-Id" : API.naverClientId,
            "X-Naver-Client-Secret": API.naverClientSecret]
        
        AF.request(url, method: .get, headers: header)
            .responseDecodable(of: NaverShopping.self) { response in
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
    
}
