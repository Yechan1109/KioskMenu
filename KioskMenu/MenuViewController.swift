import UIKit

class MenuViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    private let categories = ["베스트", "탕", "사이드", "소주/맥주", "음료"]
    private var selectedCategory: String = "베스트"
    private var cartItems: [MenuItem] = []  // 장바구니 담기
    
    private var menuItems: [MenuItem] = [
        MenuItem(imageName: "amuk", title: "오뎅탕", subtitle: "9000원", category: "탕", price: 9000, quantity: 1),
        MenuItem(imageName: "image2", title: "새우탕", subtitle: "8000원", category: "탕", price: 8000, quantity: 1),
        MenuItem(imageName: "image3", title: "진로", subtitle: "4000원", category: "소주/맥주", price: 4000, quantity: 1),
        MenuItem(imageName: "image3", title: "테라", subtitle: "4000원", category: "소주/맥주", price: 4000, quantity: 1),
        MenuItem(imageName: "image3", title: "카스", subtitle: "4000원", category: "소주/맥주", price: 4000, quantity: 1),
        MenuItem(imageName: "image3", title: "참이슬", subtitle: "4000원", category: "소주/맥주", price: 4000, quantity: 1),
        // 여기에 다른 MenuItem 추가
    ]
    
    private let segmentedControl: UISegmentedControl = {
        let segControl = UISegmentedControl(items: ["베스트", "탕", "사이드", "소주/맥주", "음료"])
        segControl.selectedSegmentIndex = 0
        segControl.translatesAutoresizingMaskIntoConstraints = false
        return segControl
    }()
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: 100, height: 120)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(MenuCollectionViewCell.self, forCellWithReuseIdentifier: "MenuCell")
        return collectionView
    }()
    
    private let cartView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray6 // layout 확인차
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.lightGray.cgColor
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let cartTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(CartTableViewCell.self, forCellReuseIdentifier: "CartCell")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.isScrollEnabled = true
        return tableView
    }()
    
    private let totalPriceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.textAlignment = .right
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let checkoutButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("주문하기", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "스파르탕"
        view.backgroundColor = .white
        
        segmentedControl.addTarget(self, action: #selector(categoryChanged), for: .valueChanged)
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        cartTableView.delegate = self
        cartTableView.dataSource = self
        
        view.addSubview(segmentedControl)
        view.addSubview(collectionView)
        view.addSubview(cartView)
//        view.addSubview(totalPriceLabel)
        
        cartView.addSubview(cartTableView)
        cartView.addSubview(totalPriceLabel)
        cartView.addSubview(checkoutButton)
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            segmentedControl.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            segmentedControl.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            segmentedControl.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            
            collectionView.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor, constant: 10),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            collectionView.bottomAnchor.constraint(equalTo: cartView.topAnchor, constant: -10),
            
            cartView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            cartView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            cartView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            cartView.heightAnchor.constraint(equalToConstant: 300),
            
            cartTableView.topAnchor.constraint(equalTo: cartView.topAnchor),
            cartTableView.leadingAnchor.constraint(equalTo: cartView.leadingAnchor),
            cartTableView.trailingAnchor.constraint(equalTo: cartView.trailingAnchor),
            cartTableView.bottomAnchor.constraint(equalTo: totalPriceLabel.topAnchor, constant: -10),
            
//            totalPriceLabel.leadingAnchor.constraint(equalTo: cartView.leadingAnchor, constant: 120),
            totalPriceLabel.trailingAnchor.constraint(equalTo: cartView.trailingAnchor, constant: -20),
            totalPriceLabel.bottomAnchor.constraint(equalTo: checkoutButton.topAnchor, constant: -10),
//            totalPriceLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
//            totalPriceLabel.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -300),
            
            
            checkoutButton.leadingAnchor.constraint(equalTo: cartView.leadingAnchor, constant: 20),
            checkoutButton.trailingAnchor.constraint(equalTo: cartView.trailingAnchor, constant: -20),
            checkoutButton.bottomAnchor.constraint(equalTo: cartView.bottomAnchor, constant: -10),
            checkoutButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    @objc private func categoryChanged() {
        selectedCategory = categories[segmentedControl.selectedSegmentIndex]
        collectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return menuItems.filter { $0.category == selectedCategory }.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MenuCell", for: indexPath) as! MenuCollectionViewCell
        let filteredItems = menuItems.filter { $0.category == selectedCategory }
        cell.configure(with: filteredItems[indexPath.item])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let filteredItems = menuItems.filter { $0.category == selectedCategory }
        let selectedItem = filteredItems[indexPath.item]
        cartItems.append(selectedItem)
        
        cartTableView.reloadData()
        updateTotalPrice()
    }
    
    private func updateTotalPrice() {
        let totalPrice = cartItems.reduce(0) { $0 + $1.price }
        totalPriceLabel.text = "총 \(cartItems.count)개 결제: \(totalPrice)원"
    }
    
    
        
    
    
    
}

extension MenuViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cartItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CartCell", for: indexPath) as! CartTableViewCell
        cell.configure(with: cartItems[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            cartItems.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            updateTotalPrice()
        }
    }
    
    
    
    
    
    
}

#Preview {
    MenuViewController()
}
