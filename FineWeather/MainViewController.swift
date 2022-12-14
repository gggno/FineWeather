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
    
    let locationManager = CLLocationManager()
    var lat = 0
    var lon = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .systemYellow
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        
        // 타이틀에 현재위치 출력
        guard let currentLocation = locationManager.location else {return}
        convertAddress(from: currentLocation)
        
        let xy = convertGrid(code: "toXY", v1: locationManager.location?.coordinate.latitude ?? 0.0, v2: locationManager.location?.coordinate.longitude ?? 0.0)
        lat = Int(xy["nx"] ?? 0.0)
        lon = Int(xy["ny"] ?? 0.0)
        print("convertGrid: \(convertGrid(code: "toXY", v1: locationManager.location?.coordinate.latitude ?? 0.0, v2: locationManager.location?.coordinate.longitude ?? 0.0))")
        print("int lat: \(lat), int lon: \(lon)")
        
        // MARK: - 메인화면 내비게이션 요소 설정
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
        let titleView = titleViewSetting() // 매개변수 다 제거할 예정
        
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
import CoreLocation

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
