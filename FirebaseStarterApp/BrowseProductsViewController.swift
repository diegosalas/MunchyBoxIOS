//
//  BrowseProductsViewController.swift
//  Basic Integration
//
//  Created by Jack Flintermann on 5/2/16.
//  Copyright © 2016 Stripe. All rights reserved.
//

import UIKit

struct Product {
    let emoji: String
    let image: String
    let price: Int
}

class BrowseProductsViewController: UICollectionViewController {

    let productsAndPrices = [
        Product(emoji: "N95 Mask",image: "https://firebasestorage.googleapis.com/v0/b/mbox-eff46.appspot.com/o/masks4.jpg?alt=media&token=add39e7a-7912-4aee-9a66-49b9f7d4f4fd", price: 1000),
        Product(emoji: "Sanitizer",image: "https://firebasestorage.googleapis.com/v0/b/mbox-eff46.appspot.com/o/sanitizer.png?alt=media&token=ee1ccf00-909c-4298-b68b-719ae15f0da9", price: 250),
        Product(emoji: "Mini Listerine",image: "https://firebasestorage.googleapis.com/v0/b/mbox-eff46.appspot.com/o/lister.png?alt=media&token=d6442ff6-80dc-4651-b283-fa70eac34e20", price: 650),
        Product(emoji: "Boss Coffee",image: "https://firebasestorage.googleapis.com/v0/b/mbox-eff46.appspot.com/o/BOSS.png?alt=media&token=ebd1fecc-34b3-4327-913f-f98419240f33", price: 700),
        Product(emoji: "Mini Soft Drink",image: "https://firebasestorage.googleapis.com/v0/b/mbox-eff46.appspot.com/o/redbul.png?alt=media&token=f49541c7-ff5f-4d94-bd33-e7cc1ec3cf21", price: 300),
        Product(emoji: "Tim Tam",image: "https://firebasestorage.googleapis.com/v0/b/mbox-eff46.appspot.com/o/timtam.png?alt=media&token=fee402da-1e03-447f-85a7-0fcaf930ce31", price: 300),
        Product(emoji: "Tic tac candy",image: "https://firebasestorage.googleapis.com/v0/b/mbox-eff46.appspot.com/o/tictac.png?alt=media&token=580e23e6-1c89-489b-8d65-ea7ca5d3cadf", price: 350),
        Product(emoji: "Eclipse",image: "https://firebasestorage.googleapis.com/v0/b/mbox-eff46.appspot.com/o/eclips.png?alt=media&token=53692036-bfee-42cb-ae8b-bfb04fba783d", price: 400),
        Product(emoji: "Mentos",image: "https://firebasestorage.googleapis.com/v0/b/mbox-eff46.appspot.com/o/mentos.png?alt=media&token=76197dec-7207-4f41-ac4b-50d7e4c5eb6b", price: 400),
        Product(emoji: "Skittles",image: "https://firebasestorage.googleapis.com/v0/b/mbox-eff46.appspot.com/o/skittl.png?alt=media&token=ea39319d-069a-4983-96a9-5ae32f99d391", price: 400),
        Product(emoji: "Jelly Belly",image: "https://firebasestorage.googleapis.com/v0/b/mbox-eff46.appspot.com/o/jelly.png?alt=media&token=872839d5-1b83-41dd-a6e0-f6e58a01c303", price: 400),
        Product(emoji: "Doritos",image: "https://firebasestorage.googleapis.com/v0/b/mbox-eff46.appspot.com/o/dorito.png?alt=media&token=715913aa-96ab-43a9-8053-247d4a2779ac", price: 200),
        Product(emoji: "Smiths",image: "https://firebasestorage.googleapis.com/v0/b/mbox-eff46.appspot.com/o/smith.png?alt=media&token=9417c993-40b0-4d93-b7e3-dc41700f5b14", price: 200),
        Product(emoji: "Nutella and Go",image: "https://firebasestorage.googleapis.com/v0/b/mbox-eff46.appspot.com/o/nutell.png?alt=media&token=50142249-1412-4851-b2bc-cc6df6ff82ed", price: 600),
        Product(emoji: "Freddo",image: "https://firebasestorage.googleapis.com/v0/b/mbox-eff46.appspot.com/o/freddo.png?alt=media&token=d199b4c5-e97e-47e5-b1eb-307944226e6d", price: 300),
        Product(emoji: "Maltesers",image: "https://firebasestorage.googleapis.com/v0/b/mbox-eff46.appspot.com/o/maltes.png?alt=media&token=f2b6fb5b-5775-41fc-9f2c-c6b952afa45d", price: 150),
        Product(emoji: "Kit Kat", image: "https://firebasestorage.googleapis.com/v0/b/mbox-eff46.appspot.com/o/kitkat.png?alt=media&token=c19259de-2d40-4bb5-9f4d-4094946d9df7",price: 550),
        Product(emoji: "M&M Tube",image: "https://firebasestorage.googleapis.com/v0/b/mbox-eff46.appspot.com/o/m%26m.png?alt=media&token=ffe8fceb-9bb4-4944-b082-26d72e894274", price: 500),
        Product(emoji: "Snickers Fun Size",image: "https://firebasestorage.googleapis.com/v0/b/mbox-eff46.appspot.com/o/Snicke.png?alt=media&token=83a6ff60-d334-4171-9282-37ff0c1bee10", price: 200),
        Product(emoji: "Extra",image: "https://firebasestorage.googleapis.com/v0/b/mbox-eff46.appspot.com/o/extra.png?alt=media&token=020f8d80-9ff4-432c-bccf-0bb87581e7d1", price: 500),
    ]
    
    var shoppingCart = [Product]() {
        didSet {
            let price = shoppingCart.reduce(0) { result, product in result + product.price }
            buyButton.priceLabel.text = numberFormatter.string(from: NSNumber(value: Float(price)/100))!
            let enabled = price > 0
            if enabled == buyButton.isEnabled {
                return
            }
            buyButton.isEnabled = enabled
            // Order of operations is important to avoid conflicting constraints
            (enabled ? buyButtonBottomDisabledConstraint : buyButtonBottomEnabledConstraint).isActive = false
            (enabled ? buyButtonBottomEnabledConstraint : buyButtonBottomDisabledConstraint).isActive = true
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0, options: [], animations: {
                self.view.layoutIfNeeded()
            }, completion: nil)
        }
    }
    
    var numberFormatter : NumberFormatter = {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .currency
        numberFormatter.usesGroupingSeparator = true
        return numberFormatter
    }()

    let settingsVC = SettingsViewController()
    
    lazy var buyButton: BrowseBuyButton = {
        let buyButton = BrowseBuyButton(enabled: false)
        buyButton.addTarget(self, action: #selector(didSelectBuy), for: .touchUpInside)
        return buyButton
    }()
    
    var buyButtonBottomDisabledConstraint: NSLayoutConstraint!
    var buyButtonBottomEnabledConstraint: NSLayoutConstraint!
    
    convenience init() {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12)
        self.init(collectionViewLayout: layout)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Munchy Box"
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.view.backgroundColor = .white
        collectionView?.backgroundColor = UIColor(red: 246/255, green: 249/255, blue: 252/255, alpha: 1)
        #if canImport(CryptoKit)
        if #available(iOS 13.0, *) {
            self.navigationController?.view.backgroundColor = .systemBackground
            collectionView?.backgroundColor = .systemGray6
        }
        #endif
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "Products", style: .plain, target: nil, action: nil)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Settings", style: .plain, target: self, action: #selector(showSettings))
        
        self.numberFormatter.locale = self.settingsVC.settings.currencyLocale
        
        collectionView?.register(EmojiCell.self, forCellWithReuseIdentifier: "Cell")
        collectionView?.allowsMultipleSelection = true
        
        // Buy button
        buyButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(buyButton)
        let bottomAnchor: NSLayoutYAxisAnchor
        if #available(iOS 11, *) {
            bottomAnchor = view.safeAreaLayoutGuide.bottomAnchor
        } else {
            bottomAnchor = view.bottomAnchor
        }
        buyButtonBottomEnabledConstraint = buyButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8)
        buyButtonBottomDisabledConstraint = buyButton.topAnchor.constraint(equalTo: view.bottomAnchor)
        NSLayoutConstraint.activate([
            buyButtonBottomDisabledConstraint,
            buyButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 8),
            buyButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -8),
            buyButton.heightAnchor.constraint(equalToConstant: BuyButton.defaultHeight),
        ])
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let theme = self.settingsVC.settings.theme
        self.view.backgroundColor = theme.primaryBackgroundColor
        self.navigationController?.navigationBar.barTintColor = theme.secondaryBackgroundColor
        self.navigationController?.navigationBar.tintColor = theme.accentColor
        let titleAttributes = [
            NSAttributedString.Key.foregroundColor: theme.primaryForegroundColor!,
            NSAttributedString.Key.font: theme.font!,
        ] as [NSAttributedString.Key : Any]
        let buttonAttributes = [
            NSAttributedString.Key.foregroundColor: theme.accentColor!,
            NSAttributedString.Key.font: theme.font!,
        ] as [NSAttributedString.Key : Any]
        self.navigationController?.navigationBar.titleTextAttributes = titleAttributes
        self.navigationItem.leftBarButtonItem?.setTitleTextAttributes(buttonAttributes, for: UIControl.State())
        self.navigationItem.backBarButtonItem?.setTitleTextAttributes(buttonAttributes, for: UIControl.State())
        
        self.numberFormatter.locale = self.settingsVC.settings.currencyLocale
        self.view.setNeedsLayout()
        let selectedItems = self.collectionView.indexPathsForSelectedItems ?? []
        self.collectionView.reloadData()
        for item in selectedItems {
            self.collectionView.selectItem(at: item, animated: false, scrollPosition: [])
        }
    }

    @objc func showSettings() {
        let navController = UINavigationController(rootViewController: settingsVC)
        navController.modalPresentationStyle = .fullScreen
        self.present(navController, animated: true, completion: nil)
    }
    
    @objc func didSelectBuy() {
        let checkoutViewController = CheckoutViewController(products: shoppingCart,
                                                            settings: self.settingsVC.settings)
        self.navigationController?.pushViewController(checkoutViewController, animated: true)
    }
    
    func addToCart(_ product: Product) {
        shoppingCart.append(product)
    }
    
    /// Removes at most one product from self.shoppingCart
    func removeFromCart(_ product: Product) {
        if let indexToRemove = shoppingCart.firstIndex(where: { candidate in
            product.emoji == candidate.emoji
        }) {
            shoppingCart.remove(at: indexToRemove)
        }
    }
}

extension BrowseProductsViewController: UICollectionViewDelegateFlowLayout {

    //MARK: - UICollectionViewDelegate
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.productsAndPrices.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as? EmojiCell else {
            return UICollectionViewCell()
        }
        
        let product = self.productsAndPrices[indexPath.item]
        
        cell.configure(with: product, numberFormatter: self.numberFormatter)
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let product = productsAndPrices[indexPath.item]
        addToCart(product)
    }
    
    override func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let product = productsAndPrices[indexPath.item]
        removeFromCart(product)
    }

    //MARK: - UICollectionViewDelegateFlowLayout
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = view.frame.size.width * 0.45
        return CGSize(width: width, height: 230)
    }
}
