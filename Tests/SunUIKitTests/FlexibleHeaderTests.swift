// Tests/SunUIKitTests/FlexibleHeaderTests.swift

import Testing
@testable import SunUIKit

@Suite("FlexibleHeaderConfiguration")
struct FlexibleHeaderConfigurationTests {

    // MARK: - BaseHeight

    @Test("halfContainer 返回容器高度的一半")
    func halfContainerHeight() {
        let config = FlexibleHeaderConfiguration()
        #expect(config.baseHeight.resolve(containerHeight: 800) == 400)
    }

    @Test("fixed 返回固定高度")
    func fixedHeight() {
        let config = FlexibleHeaderConfiguration(baseHeight: .fixed(260))
        #expect(config.baseHeight.resolve(containerHeight: 800) == 260)
    }

    // MARK: - Default 预设

    @Test("default 预设无任何限制和回调")
    func defaultHasNoLimits() {
        let config = FlexibleHeaderConfiguration.default
        #expect(config.maximumHeight == nil)
        #expect(config.minimumHeight == nil)
        #expect(config.onStretchProgress == nil)
    }

    // MARK: - Clamped 预设

    @Test("clamped 预设正确设置最大高度")
    func clampedMaxHeight() {
        let config = FlexibleHeaderConfiguration.clamped(
            baseHeight: .fixed(240),
            max: 480
        )
        #expect(config.maximumHeight == 480)
        #expect(config.minimumHeight == nil)
    }

    @Test("clamped 预设回调正常触发")
    func clampedCallback() {
        var received: CGFloat = -1
        let config = FlexibleHeaderConfiguration.clamped(
            baseHeight: .fixed(240),
            max: 480
        ) { received = $0 }

        config.onStretchProgress?(0.5)
        #expect(received == 0.5)
    }
}