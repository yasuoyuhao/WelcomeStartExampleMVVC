// Copyright SIX DAY LLC. All rights reserved.

import UIKit

protocol WelcomeViewControllerDelegate: class {
    func didPressCreateWallet(in viewController: WelcomeViewController)
    func didPressImportWallet(in viewController: WelcomeViewController)
}

class WelcomeViewController: UIViewController {

    var viewModel = WelcomeViewModel()
    weak var delegate: WelcomeViewControllerDelegate?

    lazy var collectionViewController: OnboardingCollectionViewController = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.scrollDirection = .horizontal
        let collectionViewController = OnboardingCollectionViewController(collectionViewLayout: layout)
        collectionViewController.pages = pages
        collectionViewController.pageControl = pageControl
        collectionViewController.collectionView?.isPagingEnabled = true
        collectionViewController.collectionView?.showsHorizontalScrollIndicator = false
        collectionViewController.collectionView?.backgroundColor = viewModel.backgroundColor
        return collectionViewController
    }()
    let pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        return pageControl
    }()
    let createWalletButton: UIButton = {
        let button = Button(size: .large, style: .solid)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(NSLocalizedString("welcome.createWallet.button.title", value: "這是一個歡迎的按鈕", comment: ""), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: UIFont.Weight.semibold)
        button.backgroundColor = Colors.darkBlue
        return button
    }()
    let importWalletButton: UIButton = {
        let importWalletButton = Button(size: .large, style: .border)
        importWalletButton.translatesAutoresizingMaskIntoConstraints = false
        importWalletButton.setTitle(NSLocalizedString("welcome.importWallet.button.title", value: "祝你我都能永垂不朽", comment: ""), for: .normal)
        importWalletButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: UIFont.Weight.semibold)
        importWalletButton.accessibilityIdentifier = "import-wallet"
        return importWalletButton
    }()
    let pages: [OnboardingPageViewModel] = [
        OnboardingPageViewModel(
            title: NSLocalizedString("welcome.privateAndSecure.label.title", value: "空城", comment: ""),
            subtitle: NSLocalizedString("welcome.privateAndSecure.label.description", value: "這城市那麼空，這回憶那麼兇～", comment: ""),
            image: #imageLiteral(resourceName: "IMG_0196")
        ),
        OnboardingPageViewModel(
            title: NSLocalizedString("welcome.erc20.label.title", value: "想擁有巨額的財富？", comment: ""),
            subtitle: NSLocalizedString("welcome.erc20.label.description", value: "那就捲起袖子一步一步幹吧，\n任何瞬間發財的秘訣，都是對方先發財。", comment: ""),
            image: #imageLiteral(resourceName: "IMG_0195")
        ),
        OnboardingPageViewModel(
            title: NSLocalizedString("welcome.fullyTransparent.label.title", value: "這是一張比特幣的圖", comment: ""),
            subtitle: NSLocalizedString("welcome.fullyTransparent.label.description", value: "你應該看得出來吧。", comment: ""),
            image: #imageLiteral(resourceName: "IMG_3116")
        ),
        OnboardingPageViewModel(
            title: NSLocalizedString("welcome.ultraReliable.label.title", value: "這街道車水馬龍", comment: ""),
            subtitle: NSLocalizedString("welcome.ultraReliable.label.description", value: "三寶成堆而來。", comment: ""),
            image: #imageLiteral(resourceName: "IMG_0194")
        ),
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.numberOfPages = pages.count
        view.addSubview(collectionViewController.view)

        let stackView = UIStackView(arrangedSubviews: [
            pageControl,
            createWalletButton,
            importWalletButton,
        ])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 15
        view.addSubview(stackView)

        collectionViewController.view.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            collectionViewController.view.topAnchor.constraint(equalTo: view.topAnchor),
            collectionViewController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            collectionViewController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionViewController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),

            stackView.topAnchor.constraint(equalTo: collectionViewController.view.centerYAnchor, constant: 120),
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.widthAnchor.constraint(equalToConstant: 300),

            pageControl.heightAnchor.constraint(equalToConstant: 20),
            pageControl.centerXAnchor.constraint(equalTo: stackView.centerXAnchor),

            createWalletButton.leadingAnchor.constraint(equalTo: stackView.leadingAnchor),
            createWalletButton.trailingAnchor.constraint(equalTo: stackView.trailingAnchor),

            importWalletButton.leadingAnchor.constraint(equalTo: stackView.leadingAnchor),
            importWalletButton.trailingAnchor.constraint(equalTo: stackView.trailingAnchor),
        ])

        createWalletButton.addTarget(self, action: #selector(start), for: .touchUpInside)
        importWalletButton.addTarget(self, action: #selector(importFlow), for: .touchUpInside)

        configure(viewModel: viewModel)
    }

    func configure(viewModel: WelcomeViewModel) {
        title = viewModel.title
        view.backgroundColor = viewModel.backgroundColor
        pageControl.currentPageIndicatorTintColor = viewModel.currentPageIndicatorTintColor
        pageControl.pageIndicatorTintColor = viewModel.pageIndicatorTintColor
        pageControl.numberOfPages = viewModel.numberOfPages
        pageControl.currentPage = viewModel.currentPage
    }

    @IBAction func start() {
        delegate?.didPressCreateWallet(in: self)
    }

    @IBAction func importFlow() {
        delegate?.didPressImportWallet(in: self)
    }
}
