//
//  MainViewController.swift
//  FineWeather
//
//  Created by 정근호 on 2022/12/15.
//

import UIKit
import SnapKit
import Alamofire

class MainViewController: UIViewController {
    
    var date: String = {
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYYMMdd"
        
        return formatter.string(from: date)
    }()  
    
    var time: BaseTime = .fourteen
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .systemYellow
        
        // MARK: - 메인화면 내비게이션 요소 설정
        self.title = "경기도 부천시"
        
        self.navigationItem.leftBarButtonItem = {
            let button = UIBarButtonItem(image: UIImage(systemName: "line.3.horizontal"), style: .plain, target: self, action: #selector(sideMenuBtnClicked(_:)))
            button.tintColor = .white
            
            return button
        }()
        
        self.navigationItem.rightBarButtonItem = {
            let button = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .plain, target: self, action: #selector(plusBtnClicked(_:)))
            button.tintColor = .white
            
            return button
        }()
        
        // MARK: - 메인 스크롤뷰에 넣을 요소 설정
        let weatherAPI = WeatherAPI()
        
        // MARK: - titleView 요소 설정
        
        let titleView = titleViewSetting(presentImage: "sun.max.fill", presentText: "맑음", presentTmp: self.tmp, maxTmp: "-7", minTmp: "-13", fellTmp: "-20") // 이곳에서의 tmp = -5
        
        // MARK: - dayWeatherView 요소 설정
        let dayInstackView1 = CustomDayStackView().dayStackViewSetting(time: "오후 9시", image: "cloud.heavyrain.fill", tmp: "-11")
        let dayInstackView2 = CustomDayStackView().dayStackViewSetting(time: "오후 10시", image: "sun.max.fill", tmp: "-12")
        let dayInstackView3 = CustomDayStackView().dayStackViewSetting(time: "오후 11시", image: "sun.max.fill", tmp: "-13")
        let dayInstackView4 = CustomDayStackView().dayStackViewSetting(time: "오전 01시", image: "sun.max.fill", tmp: "-14")
        let dayInstackView5 = CustomDayStackView().dayStackViewSetting(time: "오전 02시", image: "sun.max.fill", tmp: "-14")
        let dayInstackView6 = CustomDayStackView().dayStackViewSetting(time: "오전 03시", image: "sun.max.fill", tmp: "-15")
        let dayInstackView7 = CustomDayStackView().dayStackViewSetting(time: "오전 04시", image: "sun.max.fill", tmp: "-15")
        
        let hstackView: UIStackView = {
            let stackView = UIStackView(arrangedSubviews: [dayInstackView1, dayInstackView2, dayInstackView3, dayInstackView4, dayInstackView5, dayInstackView6, dayInstackView7])
            
            stackView.axis = .horizontal
            stackView.spacing = 10
            stackView.alignment = .fill
            stackView.distribution = .fillEqually
            
            return stackView
        }()
        
        let dayInScrollView: UIScrollView = {
            let scrollView = UIScrollView()
            
            scrollView.alwaysBounceHorizontal = true
            scrollView.isUserInteractionEnabled = true
            
            scrollView.addSubview(hstackView)
            
            return scrollView
        }()
        
        let dayWeatherView: UIView = {
            let view = UIView()
            
            view.backgroundColor = .systemGreen
            
            view.addSubview(dayInScrollView)
            
            return view
        }()
        
        let emptyView3: UIView = {
            let view = UIView()
            
            view.backgroundColor = .gray
            
            return view
        }()
        
        let emptyView4: UIView = {
            let view = UIView()
            
            view.backgroundColor = .gray
            
            return view
        }()
        
        let containerView: UIView = {
            let view = UIView()
            
            view.backgroundColor = .clear
            view.addSubview(titleView)
            view.addSubview(dayWeatherView)
            view.addSubview(emptyView3)
            view.addSubview(emptyView4)
            
            return view
        }()
        
        // MARK: - 메인 스크롤뷰에 넣을 요소 레이아웃
        
        // MARK: - titleView 요소 레이아웃
        titleView.snp.makeConstraints { make in
            make.height.equalTo(170)
            make.top.equalToSuperview()
            make.centerX.equalToSuperview()
            make.leading.equalTo(containerView.snp.leading).offset(30)
        }
        
        // MARK: - dayWeatherView 요소 레이아웃
        dayInstackView1.snp.makeConstraints { make in
            make.width.equalTo(70)
        }
        
        hstackView.snp.makeConstraints { make in
            make.height.equalTo(dayInScrollView.frameLayoutGuide.snp.height)
            make.edges.equalTo(dayInScrollView.contentLayoutGuide.snp.edges)
        }
        
        dayWeatherView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(titleView.snp.bottom).offset(40)
            make.leading.equalToSuperview().offset(20)
        }
        
        dayInScrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        emptyView3.snp.makeConstraints { make in
            make.height.equalTo(340)
            make.top.equalTo(dayWeatherView.snp.bottom).offset(40)
            make.centerX.equalToSuperview()
            make.leading.equalTo(containerView.snp.leading).offset(20)
        }
        
        emptyView4.snp.makeConstraints { make in
            make.height.equalTo(440)
            make.top.equalTo(emptyView3.snp.bottom).offset(40)
            make.centerX.equalToSuperview()
            make.leading.equalTo(containerView.snp.leading).offset(20)
            make.bottom.equalTo(containerView.snp.bottom).offset(-30)
        }
        
        let scrollView: UIScrollView = {
            let scroll = UIScrollView()
            scroll.alwaysBounceVertical = true // 항상 세로
            scroll.isUserInteractionEnabled = true // 사용자의 상호작용
            
            scroll.addSubview(containerView)
            
            return scroll
        }()
        
        self.view.addSubview(scrollView)
        
        containerView.snp.makeConstraints { make in
            make.edges.equalTo(scrollView.contentLayoutGuide.snp.edges)
            make.width.equalTo(scrollView.frameLayoutGuide.snp.width)
        }
        
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        
        
    }
    
    enum BaseTime: String {
        case two = "0200"
        case five = "0500"
        case eight = "0800"
        case eleven = "1100"
        case fourteen = "1400"
        case seventeen = "1700"
        case twenty = "2000"
        case twentyThree = "2300"
    }
    
    // 버튼 클릭 메서드
    @objc func sideMenuBtnClicked(_ sender: UIButton) {
        print("MainVC - sideMenuBtnClicked() called")
        let sideMenu = SideMenuNavigation(rootViewController: SideMenuViewController())
        
        present(sideMenu, animated: true)
    }
    
    @objc func plusBtnClicked(_ sender: UIButton) {
        print("MainVC - plusBtnClicked() called")
        
        self.navigationController?.pushViewController(PlusViewController(), animated: true)
    }
    
}

#if DEBUG
import SwiftUI

struct MainViewControllerPresentable: UIViewControllerRepresentable {
    func  updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        
    }
    
    func makeUIViewController(context: Context) -> some UIViewController {
        MainViewController()
    }
}

struct MainViewControllerPresentable_PreviewProvider: PreviewProvider {
    static var previews: some View {
        MainViewControllerPresentable()
            .previewDevice("iphone 12 mini")
            .previewDisplayName("iphone 12 mini")
            .ignoresSafeArea()
    }
}
#endif
