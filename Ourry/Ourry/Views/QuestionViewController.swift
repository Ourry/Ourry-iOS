//
//  QuestionViewController.swift
//  Ourry
//
//  Created by SeongHoon Jang on 2/29/24.
//

import UIKit

class QuestionViewController: UIViewController {
    
    var questionId: Int?
    private let mainViewModel = MainViewModel()
    private var questionDeatail = QuestionDetail(
        title: "",
        content: "",
        category: "",
        nickname: "",
        pollCnt: 0,
        responseCnt: 0,
        createdAt: nil,
        choices: [],
        solutions: [],
        replies: []
    )
    
    private let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.color = .gray
        indicator.hidesWhenStopped = true
        return indicator
    }()
    
    private var categoryLabel: UILabel = {
        let label = UILabel()
        label.text = "Category"
        label.font = .systemFont(ofSize: 11, weight: .light)
        label.textColor = .gray
        label.numberOfLines = 0
        
        return label
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "오늘 저녁 메뉴를 추천해주세요.오늘 저녁 메뉴를 추천해주세요.오늘 저녁 메뉴를 추천해주세요."
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        label.textColor = .black
        label.numberOfLines = 3
        label.lineBreakMode = .byWordWrapping
        
        return label
    }()
    
    private let profileImageView: UIView = {
        let containerView = UIView()
        containerView.backgroundColor = .white
        containerView.layer.cornerRadius = 5
        
        
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "person.fill")
        imageView.tintColor = .black
        
        containerView.addSubview(imageView)
        imageView.snp.makeConstraints {
            $0.height.equalTo(24)
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview()
        }
        
        return containerView
    }()
    
    private let nicknameLabel: UILabel = {
        let label = UILabel()
        label.text = "홍길동"
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        label.textColor = .black
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        
        return label
    }()
    
    private let creationDateLabel: UILabel = {
        let label = UILabel()
        label.text = "2022-03-21"
        label.font = .systemFont(ofSize: 12, weight: .light)
        label.textColor = .black
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        
        return label
    }()
    
    private let commentDivider = CommentDivider()
    
    private let descriptionUILabel: UILabel = {
        let label = UILabel()
        label.text = "저녁 메뉴를 뭐먹을지모르겠어 뭐먹을지모르겠어 뭐먹을지모르겠어 뭐먹을지모르겠어 뭐먹을지모르겠어 뭐먹을지모르겠어 뭐먹을지모르겠어 뭐먹을지모르겠어 뭐먹을지모르겠어 뭐먹을지모르겠어 뭐먹을지모르겠어 뭐먹을지모르겠어 뭐먹을지모르겠어 뭐먹을지모르겠어 뭐먹을지모르겠어 뭐먹을지 모르겠어 뭐먹을지모르겠어 뭐먹을지 모르겠어 뭐먹을지 모르겠어 뭐먹을지모르겠어 뭐먹을지모르겠어 뭐먹을지모르겠어 뭐먹을지 모르겠어 뭐먹을지모르겠어 뭐먹을지모르겠어 뭐먹을지모르겠어 뭐먹을지모르겠어 뭐먹을지 모르겠어 뭐먹을지모르겠어 뭐먹을지모르겠어 뭐먹을지모르겠어 뭐먹을지모르겠어 "
        label.font = .systemFont(ofSize: 16, weight: .regular)
        label.textColor = .black
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        
        return label
    }()
    
    
    private let chartTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "응답 결과 확인"
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        label.textColor = .black
        label.numberOfLines = 0
        
        return label
    }()
    
    
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .backgroundColor
        
        setNavigationBar()
        setQuestionInfoUI()
        setChartUI()
        
        loadQuestion(questionId: questionId)
    }
    
    //MARK: - UI
    // 네비게이션 바
    func setNavigationBar() {
        let settingButton = UIBarButtonItem(image: UIImage(systemName: "gearshape"), primaryAction: UIAction{ _ in
            // setting action
        })
        
        let alertButton = UIBarButtonItem(image: UIImage(systemName: "bell"), primaryAction: UIAction{ _ in
            // alert on/off action
        })
        
        self.navigationItem.rightBarButtonItems = [settingButton, alertButton]
        self.navigationController?.navigationBar.tintColor = .black
    }
    
    // 질문 정보
    func setQuestionInfoUI() {
        // 카테고리
        view.addSubview(categoryLabel)
        categoryLabel.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.topMargin).offset(32)
            make.leading.equalTo(self.view.safeAreaLayoutGuide.snp.leading).offset(16)
        }
        
        // 제목
        view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(categoryLabel.snp.bottom).offset(8)
            $0.leading.equalTo(self.view.safeAreaLayoutGuide.snp.leading).offset(16)
            $0.trailing.equalTo(self.view.safeAreaLayoutGuide.snp.trailing).offset(-16)
        }
        
        // 프로필 이미지
        view.addSubview(profileImageView)
        profileImageView.snp.makeConstraints {
            $0.width.height.equalTo(30)
            $0.top.equalTo(titleLabel.snp.bottom).offset(8)
            $0.leading.equalTo(self.view.safeAreaLayoutGuide.snp.leading).offset(16)
        }
        
        view.addSubview(nicknameLabel)
        nicknameLabel.snp.makeConstraints {
            $0.top.equalTo(profileImageView.snp.top)
            $0.leading.equalTo(profileImageView.snp.trailing).offset(8)
        }
        
        view.addSubview(creationDateLabel)
        creationDateLabel.snp.makeConstraints {
            $0.bottom.equalTo(profileImageView.snp.bottom)
            $0.leading.equalTo(profileImageView.snp.trailing).offset(8)
        }
        
        view.addSubview(commentDivider)
        commentDivider.snp.makeConstraints {
            $0.top.equalTo(profileImageView.snp.bottom).offset(16)
            $0.leading.equalTo(view).offset(16)
            $0.trailing.equalTo(view).offset(-16)
        }
        
        view.addSubview(descriptionUILabel)
        descriptionUILabel.snp.makeConstraints {
            $0.top.equalTo(commentDivider.snp.bottom).offset(16)
            $0.leading.equalTo(self.view.safeAreaLayoutGuide.snp.leading).offset(16)
            $0.trailing.equalTo(self.view.safeAreaLayoutGuide.snp.trailing).offset(-16)
        }
        //        descriptionUILabel.text = "\(view.frame.width)"
    }
    
    // 차트
    func setChartUI() {
        view.addSubview(chartTitleLabel)
        chartTitleLabel.snp.makeConstraints {
            $0.top.equalTo(descriptionUILabel.snp.bottom).offset(32)
            $0.leading.equalTo(self.view.safeAreaLayoutGuide.snp.leading).offset(16)
        }
        
        let foodData: [(String, Double)] = [("햄버거", 0.3), ("피자", 0.0), ("볶음밥", 0.21), ("국수", 0.12), ("치킨", 0.37)]
        let chartView = BarChartView()
        view.addSubview(chartView)
        chartView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(chartTitleLabel.snp.bottom).offset(8)
        }
        
        chartView.setup(with: foodData)
    }
    
    // answer
    func loadQuestion(questionId: Int?) {
        guard let id = questionId, id > 0 else {
            print(questionId)
            self.navigationController?.popViewController(animated: true)
            return
        }
        activityIndicator.startAnimating()
        
        mainViewModel.requestQuestionDetail(questionId: id) { result in
            switch result {
            case .success(let responseData):
                DispatchQueue.main.async {
//                    self.questionDeatail = responseData
                    self.categoryLabel.text = responseData.category
                    self.titleLabel.text = responseData.title
                    self.nicknameLabel.text = responseData.nickname
                    self.creationDateLabel.text = "2022-03-21"
                    self.descriptionUILabel.text = responseData.content
//                    self.
                    
                    
                    self.activityIndicator.stopAnimating()
                }
                
            case .failure(let error):
                let errorMessage: String
                switch error {
                case .apiError(code: let code, message: let message):
                    errorMessage = "에러코드 \(code): \(message)"
                case .networkError(let networkError):
                    errorMessage = networkError.localizedDescription
                default:
                    errorMessage = "알 수 없는 에러가 발생했습니다."
                }
                
                let alert = UIAlertController(title: "인증 오류", message: errorMessage, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "확인", style: .default, handler: nil))
                
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
}

#if canImport(SwiftUI) && DEBUG
import SwiftUI
struct QuestionViewControllerPreviews: PreviewProvider {
    static var previews: some View {
        QuestionViewController().toPreview()
    }
}
#endif
