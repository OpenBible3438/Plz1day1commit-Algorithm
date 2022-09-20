//
//  ViewController.swift
//  CalendarMemo
//
//  Created by 편성경 on 2022/08/08.
//

import UIKit
import FSCalendar
import FirebaseFirestore

class ViewController: UIViewController, FSCalendarDelegate, FSCalendarDataSource, FSCalendarDelegateAppearance {

    @IBOutlet weak var calendarView: FSCalendar!
    @IBOutlet weak var contentsText: UITextView!
    
    // Text 이벤트
    @IBAction func tapTextView(_ sender: Any) {
        // 메모 작성 or 편집 화면 이동
        let writeMemoVC = UIStoryboard(name: "CreateMemoViewController", bundle: nil).instantiateViewController(identifier: "CreateMemoViewController") as! CreateMemoViewController
        writeMemoVC.modalTransitionStyle = .coverVertical
        writeMemoVC.modalPresentationStyle = .fullScreen
        self.present(writeMemoVC, animated: true, completion: nil)
    }
    
    // Firebase
    let db = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        contentsText.text = ""
        
        setCalendarUI()
        
        // 오늘 날짜 String
        let nowDate = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyyMMdd" // Firestore 문서ID
        let todayString = dateFormatter.string(from: nowDate)
        
        // 오늘 날짜에 해당하는 문서 찾기
        let docRef = db.collection("MEMO").document(todayString)
        docRef.getDocument() { (document, error) in
            if let document = document, document.exists {
                // 해달 날짜의 doc 존재
                let todayContents = document.data()!["contents"] as! String
                print(todayContents)
                self.contentsText.text = todayContents
            } else {
                print("document does not exist")
                self.contentsText.text = "작성된 글이 없습니다"
            }
        }
        
    }
    
    // 날짜 선택 이벤트
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyyMMdd"
        //print(dateFormatter.string(from: date) + " 선택")
        
        let selDate = dateFormatter.string(from: date)
        
        // 선택된 날짜 DB 조회
        let docRef = db.collection("MEMO").document(selDate)
        docRef.getDocument() { (document, error) in
            if let document = document, document.exists {
                // 해달 날짜의 doc 존재
                let todayContents = document.data()!["contents"] as! String
                print(todayContents)
                self.contentsText.text = todayContents
            } else {
                print("document does not exist")
                self.contentsText.text = "작성된 글이 없습니다"
            }
        }
    }
    
    
    /* FSCalendar UI 설정 */
    func setCalendarUI() {
        self.calendarView.delegate = self
        self.calendarView.dataSource = self
        
        // 월간
        self.calendarView.scope = .month
        
        // 요일 언어
        self.calendarView.locale = Locale(identifier: "ko_KR")
        
        // 요일 글자 색
        self.calendarView.appearance.weekdayTextColor = UIColor.gray
        
        // 오늘의 날짜 색
        self.calendarView.appearance.todayColor = UIColor.blue
        
        // 선택된 날짜 색
        self.calendarView.appearance.selectionColor = UIColor.gray
        
        
        // 헤더
        // 헤더 날짜 포맷
        // 처음 실행될 때는 오늘 날짜
        /*
        let nowDate = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy.MM.dd"
        let dateString = dateFormatter.string(from: nowDate)
        */
        //calendarView.appearance.headerDateFormat = dateString
        
        // 다른 날짜를 클릭하면 헤더의 날짜 변경
        // 로직 추가 !
        
        // 헤더 양 옆의 글씨 투명도 (안 보이게)
        self.calendarView.appearance.headerMinimumDissolvedAlpha = 0.0
        
        // 헤더 폰트 색상
        self.calendarView.appearance.headerTitleColor = UIColor.gray
    }

}
