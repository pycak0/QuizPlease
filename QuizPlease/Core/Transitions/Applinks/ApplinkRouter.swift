//
//  ApplinkRouter.swift
//  QuizPlease
//
//  Created by Владислав on 07.10.2022.
//  Copyright © 2022 Владислав. All rights reserved.
//

import os
import UIKit

/// Object that manages routing with Applinks
protocol ApplinkRouter {

    /// Prepare to show Applink instance
    /// - Parameter link: Applink instance
    func prepareTransition(with link: Applink)
}

/// Class that implements ApplinkRouter protocol
final class ApplinkRouterImpl: ApplinkRouter {

    // MARK: - Private Properties

    private var mainScreenLoaded = false

    private lazy var endpointsDictionary: [String: ApplinkEndpoint.Type] = {
        let endpoints = getClasses(implementing: ApplinkEndpoint.self) as? [ApplinkEndpoint.Type] ?? []
        return endpoints.reduce(into: [:]) { dict, endpointClass in
            dict[endpointClass.identifier] = endpointClass
        }
    }()

    private var pendingLink: Applink?

    // MARK: - Lifecycle

    /// Initializer
    init() {
        var token: NSObjectProtocol?
        token = NotificationCenter.default.addObserver(
            forName: .mainScreenLoaded,
            object: nil,
            queue: .main
        ) { [weak self] _ in
            guard let self = self else { return }
            self.mainScreenLoaded = true
            self.performTransition()
            NotificationCenter.default.removeObserver(token!)
        }

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(performTransition),
            name: UIApplication.didBecomeActiveNotification,
            object: nil
        )
    }

    // MARK: - ApplinkRouter

    func prepareTransition(with link: Applink) {
        os_log(.info, "Preparing for transition")
        pendingLink = link
    }

    // MARK: - Private Methods

    @objc
    private func performTransition() {
        guard mainScreenLoaded, let link = pendingLink else { return }
        defer { pendingLink = nil }
        os_log(.info, "Starting to perform the transition")

        guard let endpoint = getEndpoint(with: link.identifier) else {
            showDebugAlert(title: "Got link but didn't find any endpoint to show")
            return
        }

        let didShowSuccessfully = endpoint.show(parameters: link.parameters)

        if !didShowSuccessfully {
            showDebugAlert(title: "Target endpoint (\(endpoint)) refused to show the link")
        }
    }

    private func getEndpoint(with identifier: String) -> ApplinkEndpoint? {
        guard let endpointClass = endpointsDictionary[identifier] else {
            print("❌ Did not found any endpoint candidate. Aborting transition")
            return nil
        }
        print("👀 Found candidate for transition: '\(endpointClass.self)'. Trying to show the endpoint...")
        return endpointClass.init()
    }

    private func getClasses(implementing proto: Protocol) -> [AnyClass] {
        let expectedClassCount = objc_getClassList(nil, 0)
        let allClasses = UnsafeMutablePointer<AnyClass>.allocate(capacity: Int(expectedClassCount))
        let autoreleasingAllClasses = AutoreleasingUnsafeMutablePointer<AnyClass>(allClasses)
        let actualClassCount = objc_getClassList(autoreleasingAllClasses, expectedClassCount)

        var classes = [AnyClass]()
        for i in 0 ..< actualClassCount {
            let currentClass: AnyClass = allClasses[Int(i)]
            if class_conformsToProtocol(currentClass, proto) {
                classes.append(currentClass)
            }
        }

        allClasses.deallocate()

        return classes
    }

    private func showDebugAlert(title: String) {
        guard !Configuration.current.isProduction else { return }
        // present error alert
        guard let topVc = UIApplication.shared.getKeyWindow()?.topViewController else { return }
        let linkDescription = pendingLink.map { String(describing: $0) } ?? "null"
        let keys = endpointsDictionary.keys.map { String($0) }
        let validEndpointsIds = "Valid enpoint identifiers: \(keys)"
        topVc.showSimpleAlert(title: title, message: "Link: \(linkDescription),\n\n\(validEndpointsIds)")
    }
}
