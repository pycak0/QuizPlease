//
//  DebugSettingsViewController.swift
//  QuizPlease
//
//  Created by Владислав on 21.04.2023.
//  Copyright © 2023 Владислав. All rights reserved.
//

import UIKit

@available(iOS 13, *)
final class DebugSettingsViewController: UIViewController {

    private let sections = [
        DebugSettingsSection.info([
            DebugSettingsInfoItem(title: UIApplication.shared.debugInfo)
        ]),
        DebugSettingsSection.settings([
            DebugSettingsSwitchItem(
                title: "Проверка геолокации всегда успешна",
                isEnabledProvider: AppSettings.geoChecksAlwaysSuccessful,
                onValueChange: { newValue in
                    AppSettings.geoChecksAlwaysSuccessful = newValue
                }
            ),
            DebugSettingsSwitchItem(
                title: "Новый экран GamePage включен",
                isEnabledProvider: AppSettings.isGamePageEnabled,
                onValueChange: { newValue in
                    AppSettings.isGamePageEnabled = newValue
                }
            ),
            DebugSettingsSwitchItem(
                title: "Возможность оплаты доступна только для онлайн-игр",
                isEnabledProvider: AppSettings.inAppPaymentOnlyForOnlineGamesEnabled,
                onValueChange: { newValue in
                    AppSettings.inAppPaymentOnlyForOnlineGamesEnabled = newValue
                }
            )
        ])
    ]

    // MARK: - UI Elements

    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.delegate = self
        return tableView
    }()

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        makeLayout()
        registerCells()
        view.backgroundColor = .systemBackgroundAdapted
        navigationItem.title = "\(Configuration.current.rawValue.capitalized)-Настройки"
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .done,
            target: self,
            action: #selector(donePressed)
        )
    }

    // MARK: - Private Methods

    private func makeLayout() {
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    private func registerCells() {
        tableView.register(DebugSettingsSwitchCell.self, forCellReuseIdentifier: "\(DebugSettingsSwitchCell.self)")
        tableView.register(DebugSettingsInfoCell.self, forCellReuseIdentifier: "\(DebugSettingsInfoCell.self)")
    }

    @objc
    private func donePressed() {
        dismiss(animated: true)
    }
}

// MARK: - UITableViewDataSource

@available(iOS 13, *)
extension DebugSettingsViewController: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        sections.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        sections[section].count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let section = sections[indexPath.section]
        switch section {
        case let .info(items):
            let item = items[indexPath.row]
            let cell = tableView.dequeueReusableCell(DebugSettingsInfoCell.self, for: indexPath)
            cell.configure(item: item)
            return cell

        case let .settings(settings):
            let item = settings[indexPath.row]
            let cell = tableView.dequeueReusableCell(DebugSettingsSwitchCell.self, for: indexPath)
            cell.configure(item: item)
            return cell
        }
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        sections[section].title
    }
}

@available(iOS 13, *)
extension DebugSettingsViewController: UITableViewDelegate {

    func tableView(
        _ tableView: UITableView,
        shouldShowMenuForRowAt indexPath: IndexPath
    ) -> Bool {
        if case .info = sections[indexPath.section] {
            return true
        }
        return false
    }

    func tableView(
        _ tableView: UITableView,
        canPerformAction action: Selector,
        forRowAt indexPath: IndexPath,
        withSender sender: Any?
    ) -> Bool {
        if case .info = sections[indexPath.section] {
            return action == #selector(copy(_:))
        }
        return false
    }

    func tableView(
        _ tableView: UITableView,
        performAction action: Selector,
        forRowAt indexPath: IndexPath,
        withSender sender: Any?
    ) {
        guard action == #selector(copy(_:)) else { return }
        let text = tableView.cellForRow(at: indexPath)?.textLabel?.text
        UIPasteboard.general.string = text
    }
}
