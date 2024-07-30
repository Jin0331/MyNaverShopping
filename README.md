# 🔎 **My Naver Shopping - 네이버 쇼핑 검색**

![merge](https://github.com/Jin0331/MyNaverShopping/assets/42958809/4339dc66-1b1f-492d-b8be-4f20f151ed30)

> 출시 기간 : 2024.01.17 - 01.22 (약 2주)
>
> 개발 1인
>
> 프로젝트 환경 - iPhone 전용(iOS 15.0+), 라이트 모드 고정

---

## 🔎 **한줄소개**

***가볍고, 빠른 나만의 상품 검색***

<br>

## 🔎 **핵심 기능**

* **네이버 오픈 API를 활용한 상품 검색 기능**

* **검색된 상품의 정확도, 최신순, 최저가/최고가 정렬 기능**

* **프로필 설정 및 상품 좋아요 기능**

* ****

<br>


## 🔎 **적용 기술**

* ***프레임워크***

  ​	UIKit

* ***아키텍쳐***

  ​	MVVM

* ***오픈 소스***(Cocoapods)

  ​	RxSwift / Alamofire / Kingfisher / SnapKit / UserDefault

* ***버전 관리***

  ​	Git / Github

<br>

## 🔎 **적용 기술 소개**

***MVVM***

* View 및 Business 로직을 분리하기 위한 `MVVM` 아키텍처를 도입

* `Input-Output 패턴`의 Protocol을 채택함으로써 User Interaction과 View Data 핸들링

    ```swift
    protocol ViewModelType {
        var disposeBag : DisposeBag { get }
        associatedtype Input
        associatedtype Output
        func transform(input : Input) -> Output
    }
    ```

***Reactive Programming***

* 비동기 Event의 관리를 위한 `RxSwift`와 `Combine`를 이용한 Reactive Programming 구현

***Alamofire***

* `URLRequestConvertible`을 활용한 `Router 패턴` 기반의 네트워크 통신 추상화

***UserDefault***

* 사용자의 로그인, 검색, 프로필 기록 저장을 위한 `User Default` 사용

* `propertyWrapper`와 `Generic`의 사용으로 반복되는 코드 사용의 최소화

  ```swift
  @propertyWrapper
  struct UserDefault<T> {
      let key: String
      let defaultValue: T
      
      var wrappedValue: T {
          get {
              UserDefaults.standard.object(forKey: key) as? T ?? defaultValue
          }
          set {
              UserDefaults.standard.set(newValue, forKey: key)
          }
      }
  }
  
  '''
  @UserDefault(key: UDKey.profileImage.rawValue, defaultValue: "")
  var profileImage: String

  ```
