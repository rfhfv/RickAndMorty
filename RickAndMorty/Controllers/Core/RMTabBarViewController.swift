import UIKit

final class RMTabBarViewController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setUpTabs()
    }
    
    private func setUpTabs() {
        let characterVC = RMCharacterViewController()
        let locationVC = RMLocationViewController()
        let episodeVC = RMEpisodeViewController()
        let settingVC = RMSettingsViewController()
        
        characterVC.navigationItem.largeTitleDisplayMode = .automatic
        locationVC.navigationItem.largeTitleDisplayMode = .automatic
        episodeVC.navigationItem.largeTitleDisplayMode = .automatic
        settingVC.navigationItem.largeTitleDisplayMode = .automatic
        
        let nav1 = UINavigationController(rootViewController: characterVC)
        let nav2 = UINavigationController(rootViewController: locationVC)
        let nav3 = UINavigationController(rootViewController: episodeVC)
        let nav4 = UINavigationController(rootViewController: settingVC)
        
        nav1.tabBarItem = UITabBarItem(
            title: "Characters",
            image: UIImage(systemName: "person.fill"),
            tag: 1)
        nav2.tabBarItem = UITabBarItem(
            title: "Locations",
            image: UIImage(systemName: "globe.europe.africa.fill"),
            tag: 2)
        nav3.tabBarItem = UITabBarItem(
            title: "Episodes",
            image: UIImage(systemName: "tv.fill"),
            tag: 3)
        nav4.tabBarItem = UITabBarItem(
            title: "Settings",
            image:  UIImage(systemName: "gearshape.fill"),
            tag: 4)
        
        for nav in [nav1, nav2, nav3, nav4] {
            nav.navigationBar.prefersLargeTitles = true
        }
        
        setViewControllers(
            [nav1, nav2, nav3, nav4],
            animated: true)
    }
}
