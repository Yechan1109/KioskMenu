import UIKit

class MenuViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, CartTableViewCellDelegate {
    
// UICollectionViewDataSource 프로토콜을 통해 컬렉션 뷰에 표시할 데이터를 제공.
// UICollectionViewDelegate 프로토콜을 통해 사용자 인터랙션 처리.
    
    private let categories = ["베스트", "탕", "사이드", "소주/맥주", "음료"]
    private var selectedCategory: String = "베스트" // 초기 위치 설정값 지정
    private var cartItems: [MenuItem] = []  // 장바구니 담기
    private var menuItems: [MenuItem] = [
        MenuItem(imageName: "amuk", title: "오뎅탕", subtitle: "9000원", category: "탕", price: 9000, quantity: 1),
        MenuItem(imageName: "image2", title: "새우탕", subtitle: "8000원", category: "탕", price: 8000, quantity: 1),
        MenuItem(imageName: "image3", title: "진로", subtitle: "4000원", category: "소주/맥주", price: 4000, quantity: 1),
        MenuItem(imageName: "image3", title: "테라", subtitle: "4000원", category: "소주/맥주", price: 4000, quantity: 1),
        MenuItem(imageName: "image3", title: "카스", subtitle: "4000원", category: "소주/맥주", price: 4000, quantity: 1),
        MenuItem(imageName: "image3", title: "진로", subtitle: "4000원", category: "소주/맥주", price: 4000, quantity: 1),
        MenuItem(imageName: "image3", title: "참이슬", subtitle: "4000원", category: "소주/맥주", price: 4000, quantity: 1),
        MenuItem(imageName: "image3", title: "테라", subtitle: "4000원", category: "소주/맥주", price: 4000, quantity: 1),
        MenuItem(imageName: "image3", title: "카스", subtitle: "4000원", category: "소주/맥주", price: 4000, quantity: 1),
        MenuItem(imageName: "image3", title: "참이슬", subtitle: "4000원", category: "소주/맥주", price: 4000, quantity: 1),
        MenuItem(imageName: "image3", title: "진로", subtitle: "4000원", category: "소주/맥주", price: 4000, quantity: 1),
        MenuItem(imageName: "image3", title: "테라", subtitle: "4000원", category: "소주/맥주", price: 4000, quantity: 1),
        MenuItem(imageName: "image3", title: "카스", subtitle: "4000원", category: "소주/맥주", price: 4000, quantity: 1),
        MenuItem(imageName: "image3", title: "참이슬", subtitle: "4000원", category: "소주/맥주", price: 4000, quantity: 1),
        // 여기에 다른 MenuItem 추가
    ]
    
    private let segmentedControl: UISegmentedControl = {
        let segControl = UISegmentedControl(items: ["베스트", "탕", "사이드", "소주/맥주", "음료"])
        segControl.selectedSegmentIndex = 0 // 현재 선택된 인덱스
        segControl.translatesAutoresizingMaskIntoConstraints = false
        return segControl
    }()
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout() // UICollectionViewFlowLayout 아이템들 수직 또는 수평 스크롤 방향 설정
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: 100, height: 120) // 각 아이템 사이즈 설정
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.showsVerticalScrollIndicator = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(MenuCollectionViewCell.self, forCellWithReuseIdentifier: "MenuCell") // 셀 위치에 들어갈 커스텀 MenuCollectionViewCell 등록
        return collectionView
    }()
    
    private let cartView: UIView = {
        let view = UIView()
//        view.backgroundColor = .systemGray6 // layout 확인차
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.lightGray.cgColor
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let cartTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(CartTableViewCell.self, forCellReuseIdentifier: "CartCell") // 셀 위치에 들어갈 커스텀 CartTableViewCell 등록
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
    
    private let clearAllButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("전체 삭제", for: .normal)
        button.layer.cornerRadius = 10
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor.systemBlue.cgColor
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "스파르탕"
        view.backgroundColor = .white
        
        segmentedControl.addTarget(self, action: #selector(categoryChanged), for: .valueChanged)
        
        collectionView.delegate = self // collectionView.delegate를 MenuViewController로 설정
        collectionView.dataSource = self
        
        cartTableView.delegate = self
        cartTableView.dataSource = self
        
        view.addSubview(segmentedControl)
        view.addSubview(collectionView)
        view.addSubview(cartView)
        
        cartView.addSubview(cartTableView)
        cartView.addSubview(totalPriceLabel)
        cartView.addSubview(checkoutButton)
        
        setupConstraints()
        
        // 전체 삭제용
        view.addSubview(clearAllButton)
        setupClearAllButtonConstraints()
        clearAllButton.addTarget(self, action: #selector(clearAllButtonTapped), for: .touchUpInside)
        

        
        
    }
// MARK: - 제약 세팅
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            segmentedControl.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            segmentedControl.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            segmentedControl.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            
            collectionView.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor, constant: 10),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            collectionView.bottomAnchor.constraint(equalTo: cartView.topAnchor, constant: -40),
            
            cartView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            cartView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            cartView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            cartView.heightAnchor.constraint(equalToConstant: 300),
            
            cartTableView.topAnchor.constraint(equalTo: cartView.topAnchor),
            cartTableView.leadingAnchor.constraint(equalTo: cartView.leadingAnchor),
            cartTableView.trailingAnchor.constraint(equalTo: cartView.trailingAnchor),
            cartTableView.bottomAnchor.constraint(equalTo: totalPriceLabel.topAnchor, constant: -10),
            
            totalPriceLabel.trailingAnchor.constraint(equalTo: cartView.trailingAnchor, constant: -20),
            totalPriceLabel.bottomAnchor.constraint(equalTo: checkoutButton.topAnchor, constant: -10),
            
            checkoutButton.leadingAnchor.constraint(equalTo: cartView.leadingAnchor, constant: 20),
            checkoutButton.trailingAnchor.constraint(equalTo: cartView.trailingAnchor, constant: -20),
            checkoutButton.bottomAnchor.constraint(equalTo: cartView.bottomAnchor, constant: -10),
            checkoutButton.heightAnchor.constraint(equalToConstant: 50),
        ])
    }
// MARK: - 기능관련 Area
    
    // 메뉴 카테고리 이동 애니메이션(segmentControl)
    @objc private func categoryChanged() {
        selectedCategory = categories[segmentedControl.selectedSegmentIndex]
        collectionView.reloadData()
    }

    // numberOfItemsInSection : 특정 세션에 표시한 아이템 갯수 반환 
    // 고차함수(filter)를 통해 선택된 카테고리 아이템 갯수 반환
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return menuItems.filter { $0.category == selectedCategory }.count
    }
    
    // cellForItemAt : 각 인덱스에 해당하는 셀 반환
    // dequeseReusableCell : 재사용 가능한 셀을 가져오고, 해당 셀을 MenuCollectionViewCell 타입으로 캐스팅
    // 간략히 설명하면 메모리 절약을 위해 스크롤 등으로 화면이 옮겨질때, 이전에 사용되었던 셀이 재사용하는 것
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // 'MenuCell'은 상단 collectionView에서 지정함
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MenuCell", for: indexPath) as! MenuCollectionViewCell
        let filteredItems = menuItems.filter { $0.category == selectedCategory } // 현재 선택된 카테고리 영역에 해당하는 아이템값 filteredItems에 저장
        cell.configure(with: filteredItems[indexPath.item]) // filteredItems에 들어온 아이템들의 configure함수값 데이터 사용
        return cell
    }
    
    // 최종적으로 특정 카테고리 선택시 해당 아이템 호출하는 함수임.
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let filteredItems = menuItems.filter { $0.category == selectedCategory }
        let selectedItem = filteredItems[indexPath.item]
        cartItems.append(selectedItem) // 선택된 아이템을 cartItem에 담고
        cartTableView.reloadData() // cartTableView에 실시간 리로드
        updateTotalPrice()         // 총 금액 업데이트
    }
    
    // 전체 총 주문 가격 계싼
    private func updateTotalPrice() {
        let totalPrice = cartItems.reduce(0) { $0 + $1.price * $1.quantity }
        totalPriceLabel.text = "총 메뉴 \(cartItems.count)개 결제: \(totalPrice)원"
    }
    
    // 전체 삭제 버튼 제약 및 동작 세팅 -> 왜 setupConstraints로 합치면 충돌이나지? ㅇㄴ결국 따로 뺴서 작업함..
    private func setupClearAllButtonConstraints() {
        NSLayoutConstraint.activate([
            clearAllButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -2),
            clearAllButton.bottomAnchor.constraint(equalTo: cartView.topAnchor, constant: -2),
            clearAllButton.widthAnchor.constraint(equalToConstant: 80),
            clearAllButton.heightAnchor.constraint(equalToConstant: 30)
        ])
    }
    
    @objc private func clearAllButtonTapped() {
        cartItems.removeAll()
        updateTotalPrice()
        cartTableView.reloadData()
    }
    
    
    
    
}

// MARK: - 재사용성을 위한 모듈화와 가독성을 위해 분리하여 코드 작성함
extension MenuViewController: UITableViewDelegate, UITableViewDataSource {
    
    // tableview 필요한 row 갯수 반환
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cartItems.count
    }
    // dequeueReusableCell 재사용 가능한 셀 생성
    // configure(with:) cartItems 배열의 해당 항목으로 셀을 구성
    // cell.delegate = self를 통해 셀의 델리게이트를 현재 뷰 컨트롤러로 설정 -> 버튼 클릭 등의 이벤트 처리 가능
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CartCell", for: indexPath) as! CartTableViewCell
        cell.configure(with: cartItems[indexPath.row])
        cell.delegate = self // removebutton을 위한 델리게이터 설정
        return cell
    }
    
    // tableview엣허 행 삭제 동작 기능
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            cartItems.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic) // 테이블 뷰에서 해당 행을 애니메이션과 함께 삭제
            updateTotalPrice()
        }
    }
    
    // 메뉴 수량 변경
    func didUpdateQuantity(on cell: CartTableViewCell, quantity: Int) {
        guard let indexPath = cartTableView.indexPath(for: cell) else { return }
        cartItems[indexPath.row].quantity = quantity
        cartTableView.reloadRows(at: [indexPath], with: .none) // 테이블 뷰의 해당 행을 다시 로드
        updateTotalPrice()
    }
    
    
    // 메뉴 삭제
    func didTapRemoveButton(on cell: CartTableViewCell) {
        guard let indexPath = cartTableView.indexPath(for: cell) else { return }
        cartItems.remove(at: indexPath.row)
        cartTableView.deleteRows(at: [indexPath], with: .automatic) // 테이블 뷰에서 해당 행을 애니메이션과 함께 삭제
        updateTotalPrice()
    }
    
    
    
}

#Preview {
    MenuViewController()
}
