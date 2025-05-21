//
//  RouterManager.swift
//  BlindIDCase
//
//  Created by Oguz Yildirim on 21.05.2025.
//

import SwiftUI

protocol RouterProtocol: ObservableObject {
    
    var navigationController: BlindIDCaseNavigationController { get }
    
    func start()
    func show(_ route: Route, animated: Bool)
    func showPopup(_ route: Route, transition: UIModalTransitionStyle, animated: Bool)
    func pop(animated: Bool)
    func popToRoot(animated: Bool)
    func popToFirstViewAfterRoot(animated: Bool)
    func dismiss(animated: Bool, completion: (() -> Void)?)
    func switchTab(index: Int)
    func removeInitialLoginView()
}

final class RouterManager: RouterProtocol {
    
    static let shared: any RouterProtocol = RouterManager()
    
    let navigationController: BlindIDCaseNavigationController = .init(nibName: nil, bundle: nil)
    
    private init() {}
    
    func start() {
        show(.splash, animated: true)
    }
    
    func show(_ route: Route, animated: Bool) {
        
        DispatchQueue.main.async {
            
            let routeView = route.view()
            let view = routeView.environmentObject(self)
            let viewController = UIHostingController(rootView: view)
            
            viewController.navigationItem.hidesBackButton = true

            switch route.rotingType {
                
            case .push:
                LogHelper.log("Pushed: \(route)")
                self.navigationController.pushViewController(viewController, animated: animated)
                
            case .presentModally:
                LogHelper.log("Presented Modally: \(route)")
                viewController.modalPresentationStyle = .formSheet
                self.navigationController.present(viewController, animated: animated)
                
            case .presentFullScreen:
                LogHelper.log("Presented Full Screen: \(route)")
                viewController.modalPresentationStyle = .fullScreen
                self.navigationController.present(viewController, animated: animated)
            }
        }
    }
    
    func showPopup(_ route: Route, transition: UIModalTransitionStyle = .coverVertical, animated: Bool) {
        
        DispatchQueue.main.async {
            
            let routeView = route.view()
            let view = routeView.environmentObject(self)
            let viewController = UIHostingController(rootView: view)
            
            viewController.navigationItem.hidesBackButton = true
            
            switch route.rotingType {
                
            case .push, .presentModally:
                LogHelper.log("Presented Modally: \(route)")
                viewController.modalPresentationStyle = .formSheet
                viewController.modalTransitionStyle = transition
                self.navigationController.present(viewController, animated: animated)
                
            case .presentFullScreen:
                LogHelper.log("Presented Full Screen: \(route)")
                viewController.modalPresentationStyle = .overFullScreen
                viewController.modalTransitionStyle = transition
                self.navigationController.present(viewController, animated: animated)
            }
        }
    }
    
    func pop(animated: Bool) {
        
        DispatchQueue.main.async {
            self.navigationController.popViewController(animated: animated)
        }
    }
    
    func popToRoot(animated: Bool) {
        DispatchQueue.main.async {
            self.navigationController.popToRootViewController(animated: animated)
        }
    }
    
    func popToFirstViewAfterRoot(animated: Bool) {
        DispatchQueue.main.async {
            if self.navigationController.viewControllers.count > 1 {
                self.navigationController.popToViewController(self.navigationController.viewControllers[1], animated: animated)
            }
        }
    }
    
    func dismiss(animated: Bool, completion: (() -> Void)? = nil) {
        
        DispatchQueue.main.async {
            self.navigationController.presentedViewController?.dismiss(animated: animated, completion: completion)
        }
    }
    
    func switchTab(index: Int) {
        
        // Change tabbar selected index
    }
    
    func removeInitialLoginView() {
        DispatchQueue.main.async {
            if self.navigationController.viewControllers.count > 2 {
                self.navigationController.viewControllers.remove(at: 1)
            }
        }
    }
}
