import UIKit

extension UITabBarController {
    func configureItemDesing(tabBar : UITabBar) {
        
        tabBar.tintColor = ImageStyle.pointColor
        tabBar.barTintColor = ImageStyle.backgroundColor
        
        // item 디자인
        if let item = tabBar.items {
            
            item[0].title = "검색"
            item[0].setTitleTextAttributes([.font: ImageStyle.normalFontSize], for: .normal)
            item[0].image = UIImage(systemName: "magnifyingglass")
            
            item[1].title = "설정"
            item[1].setTitleTextAttributes([.font: ImageStyle.normalFontSize], for: .normal)
            item[1].image = UIImage(systemName: "person")
            
        }
    }
}
