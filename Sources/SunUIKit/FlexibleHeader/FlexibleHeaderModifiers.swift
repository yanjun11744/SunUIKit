// FlexibleHeader/FlexibleHeaderModifiers.swift

import SwiftUI

// MARK: - ScrollView 修饰器

/// 挂在 ScrollView 上，监听滚动几何变化并写入环境。
struct FlexibleHeaderScrollViewModifier: ViewModifier {
    let configuration: FlexibleHeaderConfiguration
    @State private var geometry = FlexibleHeaderGeometry()

    func body(content: Content) -> some View {
        content
            .onScrollGeometryChange(for: CGFloat.self) { scrollGeo in
                // 超出顶部时为负值，正常滚动时钳制为 0
                min(scrollGeo.contentOffset.y + scrollGeo.contentInsets.top, 0)
            } action: { _, newOffset in
                geometry.offset = newOffset
                fireProgressCallbackIfNeeded(offset: newOffset)
            }
            .environment(geometry)
    }

    private func fireProgressCallbackIfNeeded(offset: CGFloat) {
        guard
            let callback = configuration.onStretchProgress,
            let maxH = configuration.maximumHeight
        else { return }

        // offset 为负，stretch 为正
        let stretch = -offset
        // 用固定基准高度计算，halfContainer 时以 300 兜底（回调场景建议用 fixed）
        let base: CGFloat
        if case .fixed(let h) = configuration.baseHeight {
            base = h
        } else {
            base = 300
        }
        let range = maxH - base
        guard range > 0 else { return }
        callback(min(stretch / range, 1.0))
    }
}

// MARK: - 头部内容修饰器

/// 挂在头部视图上，根据滚动偏移动态调整高度和位置。
struct FlexibleHeaderContentModifier: ViewModifier {
    let configuration: FlexibleHeaderConfiguration
    @Environment(FlexibleHeaderGeometry.self) private var geometry

    func body(content: Content) -> some View {
        GeometryReader { proxy in
            let containerHeight = proxy.size.height > 0
                ? proxy.size.height
                : UIScreen.main.bounds.height

            let height = resolvedHeight(containerHeight: containerHeight)

            content
                .frame(width: proxy.size.width, height: height, alignment: .center)
                .padding(.bottom, geometry.offset)
                .offset(y: geometry.offset)
        }
    }

    private func resolvedHeight(containerHeight: CGFloat) -> CGFloat {
        let base = configuration.baseHeight.resolve(containerHeight: containerHeight)
        // offset ≤ 0，减去它等于加上拉伸量
        var height = base - geometry.offset

        if let minH = configuration.minimumHeight {
            height = max(height, minH)
        }
        if let maxH = configuration.maximumHeight {
            height = min(height, maxH)
        }
        return height
    }
}