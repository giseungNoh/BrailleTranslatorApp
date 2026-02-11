//
//  CirriculumViewModel.swift
//  BrailleTranslatorApp
//
//  Created by AI on 2/10/26.
//

import SwiftUI
import Combine

/// 커리큘럼 화면에서 사용하는 데이터/로직을 담당하는 뷰모델
final class CirriculumViewModel: ObservableObject {
    // ObservableObject 요구 충족용 퍼블리셔
    let objectWillChange = ObservableObjectPublisher()
    struct CurriculumDay: Identifiable {
        enum Status {
            case completed
            case inProgress
            case notStarted

            var label: String {
                switch self {
                case .completed: return "완료"
                case .inProgress: return "진행중"
                case .notStarted: return "시작"
                }
            }
        }

        let id: Int
        let day: Int
        let title: String
        let status: Status
    }

    struct CurriculumSection: Identifiable {
        let id: Int
        let title: String
        let days: [CurriculumDay]
    }

    /// 섹션별 커리큘럼 데이터
    let sections: [CurriculumSection]

    init() {
        // 개별 일차 정보 정의
        let allDays: [CurriculumDay] = [
            .init(id: 1, day: 1, title: "점자의 첫걸음,(구조 익히기)", status: .completed),
            .init(id: 2, day: 2, title: "손끝 길 트기, 가로 선 따라가기", status: .completed),
            .init(id: 3, day: 3, title: "서로 다른 점 찾기 (점형 구별)", status: .inProgress),
            .init(id: 4, day: 4, title: "온점과 빈칸 느끼기", status: .notStarted),
            .init(id: 5, day: 5, title: "자음 1 'ㄱ~ㄹ'", status: .notStarted),
            .init(id: 6, day: 6, title: "자음 2 'ㅁ~ㅇ'", status: .notStarted),
            .init(id: 7, day: 7, title: "[1주차 복습] 점자 보물찾기 퀴즈", status: .notStarted),

            .init(id: 8, day: 8, title: "자음 3 'ㅈ~ㅎ'", status: .notStarted),
            .init(id: 9, day: 9, title: "된소리 표기법", status: .notStarted),
            .init(id: 10, day: 10, title: "모음 1 'ㅏ~ㅕ'", status: .notStarted),
            .init(id: 11, day: 11, title: "모음 2 'ㅗ~ㅣ'", status: .notStarted),
            .init(id: 12, day: 12, title: "내려앉은 소리, 받침 자음의 원리", status: .notStarted),
            .init(id: 13, day: 13, title: "두 칸의 어울림, 복모음 익히기", status: .notStarted),
            .init(id: 14, day: 14, title: "[2주차 복습] 글자 완성하기 퍼즐", status: .notStarted),

            .init(id: 15, day: 15, title: "수표와 숫자 123", status: .notStarted),
            .init(id: 16, day: 16, title: "마침표와 물음표", status: .notStarted),
            .init(id: 17, day: 17, title: "약자 1 '가~하'", status: .notStarted),
            .init(id: 18, day: 18, title: "약자 2 '것, 억, 언...'", status: .notStarted),
            .init(id: 19, day: 19, title: "문장을 이어주는 말, 접속사 약어", status: .notStarted),
            .init(id: 20, day: 20, title: "[수료] 띄어쓰기와 문장 완성하기", status: .notStarted)
        ]

        func days(in range: ClosedRange<Int>) -> [CurriculumDay] {
            allDays.filter { range.contains($0.day) }
        }

        sections = [
            .init(
                id: 1,
                title: "Section 1: 감각 깨우기 (1주차)",
                days: days(in: 1...7)
            ),
            .init(
                id: 2,
                title: "Section 2: 한글 점자의 기초 (2주차)",
                days: days(in: 8...14)
            ),
            .init(
                id: 3,
                title: "Section 3: 실전 규칙과 약자 (3주차)",
                days: days(in: 15...20)
            )
        ]
    }
}

extension CirriculumViewModel {
    var allDays: [CurriculumDay] {
        sections.flatMap { $0.days }
    }

    var totalCount: Int {
        allDays.count
    }

    var completedCount: Int {
        allDays.filter { $0.status == .completed }.count
    }

    var progress: Double {
        guard totalCount > 0 else { return 0 }
        return Double(completedCount) / Double(totalCount)
    }
}

