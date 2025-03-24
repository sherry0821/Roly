//
//  IntroView.swift
//  Roly
//
//  Created by 劉采璇 on 3/12/25.
//

import SwiftUI

struct IntroView: View {
    @State private var activeCard: Card? = cards.first
    @State private var scrollPosition: ScrollPosition = .init()
    @State private var currentScrollOffset: CGFloat = 0
    @State private var timer = Timer.publish(every: 0.01, on: .current, in: .default).autoconnect()
    @State private var initialAnimation: Bool = false
    @State private var titleProgress: CGFloat = 0
    @State private var scrollPhase: ScrollPhase = .idle
    
    let onComplete: () -> Void // Callback to signal completion
    
    var body: some View {
        ZStack {
            ambientBackground()
                .animation(.easeInOut(duration: 1), value: activeCard)
            
            VStack(spacing: 40) {
                VStack(spacing: 15) {
                    /*
                     Text("Manage with your responsibilities")
                     .fontWeight(.semibold)
                     .foregroundStyle(.white.secondary)
                     .blurOpacityEffect(initialAnimation)
                     */
                    Text ("Roly")
                        .font(.largeTitle.bold())
                        .foregroundStyle(.white)
                        .textRenderer(TitleTextRenderer(progress: titleProgress))
                    
                    Text("Manage with your responsibilities!"
                         /*"Create beautiful invitations for all your events. \nAnyone can receive invitations. Sending included\n with iCloud+."*/)
                    //                        .font (.callout)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)
                    .foregroundStyle(.white.secondary)
                    .blurOpacityEffect(initialAnimation)
                }
                .padding(.bottom, 15)
                
                InfiniteScrollView {
                    ForEach(cards) { card in
                        CarouselCardView(card)
                    }
                }
                .scrollIndicators(.hidden)
                .scrollPosition($scrollPosition)
                .scrollClipDisabled()
                .containerRelativeFrame(.vertical) { value, _ in
                    value * 0.45
                }
                .onScrollPhaseChange({ oldPhase, newPhase in
                    scrollPhase = newPhase
                })
                .onScrollGeometryChange(for: CGFloat.self) {
                    $0.contentOffset.x + $0.contentInsets.leading
                } action: { oldValue, newValue in
                    currentScrollOffset = newValue
                    
                    if scrollPhase != .decelerating || scrollPhase != .animating {
                        let activeIndex = Int((currentScrollOffset / 220).rounded()) % cards.count
                        activeCard = cards[activeIndex]
                    }
                }
                .visualEffect{ [initialAnimation] content, proxy in
                    content
                        .offset(y: !initialAnimation ? (proxy.size.height + 300) : 0)
                }
                
                Button {
                    timer.upstream.connect().cancel()
                    print("DEBUG: Start button tapped, calling onComplete")
                    onComplete() // Trigger callback to move to next screen
                } label: {
                    Text("Start")
                        .font(.headline)
                        .fontWeight(.semibold)
                        .foregroundStyle(.white)
                        .frame(width: 100, height: 100)
                        .background(
                            RoundedRectangle(cornerRadius: 34)
                                .fill(Color.rolyMainPink.opacity(0.3))
                        )
                }
                .blurOpacityEffect(initialAnimation)
            }
            .safeAreaPadding(15)
        }
        .onReceive(timer) { _ in
            currentScrollOffset += 0.35
            scrollPosition.scrollTo(x: currentScrollOffset)
        }
        .task {
            try? await Task.sleep(for: .seconds(0.5))
            
            withAnimation(.smooth(duration: 0.75, extraBounce: 0)) {
                initialAnimation = true
            }
            withAnimation(.smooth(duration: 2.5, extraBounce: 0).delay(0.3)) {
                titleProgress = 1
            }
        }
        .preferredColorScheme(.dark) // Moved from IntroView
    }
    
    // MARK: AMBIENT BACKGROUND
    @ViewBuilder
    private func ambientBackground() -> some View {
        GeometryReader {
            let size = $0.size
            
            ZStack {
                ForEach(cards) { card in
                    Image(card.image)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .ignoresSafeArea()
                        .frame(width: size.width, height: size.height)
                        .opacity(activeCard == card ? 1 : 0)
                }
                
                Rectangle()
                    .fill(.black.opacity(0.45))
                    .ignoresSafeArea()
            }
            .compositingGroup()
            .blur(radius: 20, opaque: true)
            .ignoresSafeArea()
        }
    }
    
    // MARK: CAROUSEL | Card View
    @ViewBuilder
    private func CarouselCardView(_ card: Card) -> some View {
        GeometryReader {
            let size = $0.size
            
            ZStack {
                Image(card.image)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: size.width, height: size.height)
                    .clipShape(.rect(cornerRadius: 34))
                    .shadow(color: .black.opacity(0.4), radius: 10, x: 1, y: 0)
                if let note = card.note {
                    Text(note)
                        .font(.callout)
                        .foregroundColor(.black)
                        .multilineTextAlignment(.center)
//                        .background(Color.black.opacity(0.4))
//                        .cornerRadius(8)
                        .padding(.leading, 150)
                        .padding(.top, 250)
                }
            }
        }
        .frame(width: 350, height: 350)
        .scrollTransition(.interactive.threshold(.centered), axis: .horizontal) {content, phase in
            content
                .offset(y: phase == .identity ? -10 : 0)
                .scaleEffect(phase.isIdentity ? 1 : 0.75)
                .rotationEffect(.degrees(phase.value * 5), anchor: .bottom)
                .opacity(phase.isIdentity ? 1 : 0.75)
        }
    }
}

#Preview {
    IntroView(onComplete: {})
}

extension View {
    func blurOpacityEffect(_ show: Bool) -> some View {
        self
            .blur(radius: show ? 0 : 2)
            .opacity(show ? 1 : 0)
            .scaleEffect(show ? 1 : 0.9)
    }
}
