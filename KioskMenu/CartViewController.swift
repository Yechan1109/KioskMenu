//import UIKit
//
//class CartViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
//    
//    private var cartItems: [MenuItem] = []
//    
//    private let tableView: UITableView = {
//        let tableView = UITableView()
//        tableView.register(CartTableViewCell.self, forCellReuseIdentifier: "CartCell")
//        tableView.translatesAutoresizingMaskIntoConstraints = false
//        return tableView
//    }()
//    
//    private let totalPriceLabel: UILabel = {
//        let label = UILabel()
//        label.font = UIFont.boldSystemFont(ofSize: 18)
//        label.textAlignment = .right
//        label.translatesAutoresizingMaskIntoConstraints = false
//        return label
//    }()
//    
//    private let checkoutButton: UIButton = {
//        let button = UIButton(type: .system)
//        button.setTitle("주문하기", for: .normal)
//        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
//        button.translatesAutoresizingMaskIntoConstraints = false
//        return button
//    }()
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        title = "장바구니"
//        view.backgroundColor = .white
//        
//        tableView.delegate = self
//        tableView.dataSource = self
//        
//        view.addSubview(tableView)
//        view.addSubview(totalPriceLabel)
//        view.addSubview(checkoutButton)
//        
//        setupConstraints()
//        updateTotalPrice()
//    }
//    
//    private func setupConstraints() {
//        NSLayoutConstraint.activate([
//            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
//            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
//            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
//            tableView.bottomAnchor.constraint(equalTo: totalPriceLabel.topAnchor, constant: -10),
//            
//            totalPriceLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
//            totalPriceLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
//            totalPriceLabel.bottomAnchor.constraint(equalTo: checkoutButton.topAnchor, constant: -10),
//            
//            checkoutButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
//            checkoutButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
//            checkoutButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
//            checkoutButton.heightAnchor.constraint(equalToConstant: 50)
//        ])
//    }
//    
//    func addToCart(item: MenuItem) {
//        cartItems.append(item)
//        tableView.reloadData()
//        updateTotalPrice()
//    }
//    
//    private func updateTotalPrice() {
//        let totalPrice = cartItems.reduce(0) { $0 + $1.price }
//        totalPriceLabel.text = "총 \(cartItems.count)개 결제: \(totalPrice)원"
//    }
//    
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return cartItems.count
//    }
//    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "CartCell", for: indexPath) as! CartTableViewCell
//        cell.configure(with: cartItems[indexPath.row])
//        return cell
//    }
//    
//    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
//        if editingStyle == .delete {
//            cartItems.remove(at: indexPath.row)
//            tableView.deleteRows(at: [indexPath], with: .automatic)
//            updateTotalPrice()
//        }
//    }
//}
