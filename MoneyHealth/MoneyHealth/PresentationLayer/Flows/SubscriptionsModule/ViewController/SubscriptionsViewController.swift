//
//  SubscriptionsViewController.swift
//  MoneyHealth
//
//  Created by Alexander on 11/7/20.
//

import UIKit
import RxSwift
import RxCocoa
import FittedSheets

final class SubscriptionsViewController: CollectionViewController<SubscriptionsView>, ControllerProtocol {
    typealias ViewModelType = SubscriptionsViewModel

    let viewModel: ViewModelType

    init(viewModel: ViewModelType) {
        self.viewModel = viewModel

        super.init(container: viewModel.collectionViewContainer)

        self.title = "Subscriptions"
        self.tabBarItem = .init(title: "Subscriptions", image: UIImage(named: "tab_bar_subscriptions"), selectedImage: nil)

        NotificationCenter.default.addObserver(self, selector: #selector(self.pushAllSubscriptions), name: .init(rawValue: "pushAllSubscriptions"), object: nil)
    }

    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        self.view = SubscriptionsView()
    }

    func bindOutput() {
    }

    func bindInput() {
    }

    @objc func pushAllSubscriptions() {
        let viewController = SubscriptionsListViewController(viewModel: .init())
        self.navigationController?.pushViewController(viewController, animated: true)
    }
}

extension UIWindow {
    func topViewController() -> UIViewController? {
        var top = self.rootViewController
        while true {
            if let presented = top?.presentedViewController {
                top = presented
            } else if let nav = top as? UINavigationController {
                top = nav.visibleViewController
            } else if let tab = top as? UITabBarController {
                top = tab.selectedViewController
            } else {
                break
            }
        }
        return top
    }
}
