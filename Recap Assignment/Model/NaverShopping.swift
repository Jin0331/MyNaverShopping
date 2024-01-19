
//MARK: - Naver Shopping API 호출 결과
/*
 {
     "lastBuildDate": "Fri, 19 Jan 2024 15:05:47 +0900",
     "total": 2455286,
     "start": 1,
     "display": 30,
     "items": [
         {
             "title": "주차천막 스노우 로드 클리어 테라스 캐노피 지붕 알루미늄 구조 캔틸레버 파티오 천막 <b>자동차<\/b> 주차",
             "link": "https:\/\/search.shopping.naver.com\/gate.nhn?id=86596450833",
             "image": "https:\/\/shopping-phinf.pstatic.net\/main_8659645\/86596450833.jpg",
             "lprice": "918748900",
             "hprice": "",
             "mallName": "마리종합몰",
             "productId": "86596450833",
             "productType": "2",
             "brand": "",
             "maker": "",
             "category1": "스포츠\/레저",
             "category2": "캠핑",
             "category3": "천막",
             "category4": ""
         }
    ]
 }
 */

//MARK: - Json to struct Using QuickType
// MARK: - Welcome
struct NaverShopping : Codable {
    let lastBuildDate: String
    let total, start, display: Int
    let items: [NaverShoppingItem]
}

// MARK: - Item
struct NaverShoppingItem: Codable {
    let title: String
    let link: String
    let image: String
    let lprice, hprice, mallName, productID: String
    let productType, brand, maker, category1: String
    let category2, category3, category4: String
}
