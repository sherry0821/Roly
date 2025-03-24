//// OnboardingSheetView.swift
//// Roly
//// Created by 劉采璇 on 3/12/25
//
//import SwiftUI
//
//struct OnboardingSheetView: View {
//    @Binding var onboardingSheetIsPresented: Bool
//    
//    var body: some View {
//        VStack {
//            ScrollView(.horizontal) {
//                HStack {
//                    ForEach(pages) { page in
//                        PageView(page: page)
//                    }
//                }
//            }
//            .scrollIndicators(.hidden)
//            .containerRelativeFrame(.vertical) { value, _ in
//                value * 0.45
//            }
//        }
//        .safeAreaPadding(15)
//    }
//    
//    private func dismissSheet() {
//        onboardingSheetIsPresented = false
//    }
//}
//
//// MARK: - Page View
//struct PageView: View {
//    let page: PageInfo
//    
//    var body: some View {
//        ZStack {
//            VStack(spacing: 50) {
//                Image(systemName: page.image)
//                    .font(.system(size: 72))
//                Text(page.label)
//                    .font(.largeTitle)
//                    .multilineTextAlignment(.center)
//                    .padding(.horizontal, 20)
//            }
//            .frame(width: 300, height: 300)
////            .background(RoundedRectangle(cornerRadius: 34).foregroundStyle(.gray))
//            .ignoresSafeArea()
//        }
//    }
//}
//
//// MARK: - Page Model
//struct PageInfo: Identifiable {
//    let id = UUID()
//    let image: String
//    let label: String
//}
//
//private let pages = [
//    PageInfo(image: "star", label: "2 Tasks a Day Endless Possibilities"),
//    PageInfo(image: "dollarsign", label: "Quantify Goals find balance"),
//    PageInfo(image: "chart.line.uptrend.xyaxis", label: "Track often, Integrate Effectively"),
//    PageInfo(image: "lessthanorequalto.circle.fill", label: "Simplify Life, Amplify Success"),
//    PageInfo(image: "time", label: "Feel Time. Achieve Naturally")
//]
//
//// MARK: - Preview
//#Preview {
//    OnboardingSheetView(onboardingSheetIsPresented: .constant(true))
////    PageView(page: pages[0])
//}
