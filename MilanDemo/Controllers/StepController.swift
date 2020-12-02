//
//  StepController.swift
//  MilanDemo
//
//  This project was originally created by Guilherme Rambo on 07/11/18.
//  I just made edits to something already built, so all credit lies with him
//  Copyright © 2018 Guilherme Rambo. All rights reserved.

import UIKit
import os.log

final class StepController: UIViewController {

    private let log = OSLog(subsystem: "daniel.MilanDemo", category: "StepController")

    var buttonTitle: String? {
        get {
            return actionButton.title(for: .normal)
        }
        set {
            actionButton.setTitle(newValue, for: .normal)
        }
    }

    var buttonAction: (() -> Void)?

    private lazy var actionButton: UIButton = {
        let b = UIButton(type: .system)

        b.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        b.translatesAutoresizingMaskIntoConstraints = false

        return b
    }()

    @objc private func buttonTapped() {
        buttonAction?()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .black

        installButton()
    }

    private func installButton() {
        view.addSubview(actionButton)

        NSLayoutConstraint.activate([
            actionButton.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
            actionButton.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor)
        ])
    }

    // MARK: - Success animation

    private lazy var feedbackGenerator = UINotificationFeedbackGenerator()

    func performSuccessAnimation() {
        feedbackGenerator.notificationOccurred(.success)
        actionButton.removeFromSuperview()

        loadAndShowMilanAnimation()
    }

    private var MilanView: AnimationView?

    private func loadAndShowMilanAnimation() {
        do {
            let archive = try AnimationArchive(assetNamed: "Milan")

            MilanView = AnimationView(archive: archive)
            MilanView?.translatesAutoresizingMaskIntoConstraints = false

            showMilanAnimation()
        } catch {
            os_log("Failed to load success animation: %{public}@", log: self.log, type: .error, String(describing: error))
        }
    }

    private func showMilanAnimation() {
        guard let MilanView = MilanView else { return }

        view.addSubview(MilanView)

        NSLayoutConstraint.activate([
            MilanView.widthAnchor.constraint(equalToConstant: 414),
            MilanView.heightAnchor.constraint(equalToConstant: 896),
            MilanView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            MilanView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])

        MilanView.play()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Hide the Navigation Bar
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
}

