// FlexibleHeader/FlexibleHeaderModifiers.swift

import SwiftUI

// MARK: - ScrollView 修饰器

/// 挂在 ScrollView 上，监听滚动几何变化并写入环境。
struct FlexibleHeaderScrollViewModifier: ViewModifier {
    let configuration: FlexibleHeaderConfiguration
    @State private var geometry = FlexibleHeaderGeometry()

    func body(content: Content) -> some View {
        content
            // 用 background GeometryReader 读取容器高度，不影响布局
            .background {
                GeometryReader { proxy in
                    Color.clear
                        .onAppear {
                            geometry.containerHeight = proxy.size.height
                        }
                        .onChange(of: proxy.size.height) { _, newHeight in
                            geometry.containerHeight = newHeight
                        }
                }
            }
            .onScrollGeometryChange(for: CGFloat.self) { scrollGeo in
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

        let stretch = -offset
        let base: CGFloat
        if case .fixed(let h) = configuration.baseHeight {
            base = h
        } else {
            base = geometry.containerHeight / 2
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
        let height = resolvedHeight()

        content
            .frame(height: height)
            .padding(.bottom, geometry.offset)
            .offset(y: geometry.offset)
    }

    private func resolvedHeight() -> CGFloat {
        let base = configuration.baseHeight.resolve(containerHeight: geometry.containerHeight)
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