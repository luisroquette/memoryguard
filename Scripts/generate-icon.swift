import AppKit
import Foundation

let projectURL = URL(fileURLWithPath: FileManager.default.currentDirectoryPath)
let resourcesURL = projectURL.appendingPathComponent("Resources", isDirectory: true)
let iconsetURL = resourcesURL.appendingPathComponent("MemoryGuard.iconset", isDirectory: true)
try FileManager.default.createDirectory(at: iconsetURL, withIntermediateDirectories: true)

func makeBaseIcon() -> NSImage {
    let size = NSSize(width: 1024, height: 1024)
    let image = NSImage(size: size)
    image.lockFocus()

    let canvas = NSRect(origin: .zero, size: size)
    let background = NSBezierPath(roundedRect: canvas.insetBy(dx: 46, dy: 46), xRadius: 220, yRadius: 220)
    NSGradient(colors: [
        NSColor(calibratedRed: 0.035, green: 0.075, blue: 0.13, alpha: 1),
        NSColor(calibratedRed: 0.045, green: 0.30, blue: 0.22, alpha: 1),
    ])?.draw(in: background, angle: -52)

    let glow = NSBezierPath(ovalIn: NSRect(x: 172, y: 332, width: 680, height: 680))
    NSGraphicsContext.saveGraphicsState()
    background.addClip()
    NSGradient(colorsAndLocations:
        (NSColor(calibratedRed: 0.18, green: 0.95, blue: 0.56, alpha: 0.24), 0),
        (NSColor.clear, 1)
    )?.draw(in: glow, relativeCenterPosition: .zero)
    NSGraphicsContext.restoreGraphicsState()

    let shield = NSBezierPath()
    shield.move(to: NSPoint(x: 512, y: 826))
    shield.curve(to: NSPoint(x: 744, y: 742), controlPoint1: NSPoint(x: 610, y: 810), controlPoint2: NSPoint(x: 687, y: 780))
    shield.line(to: NSPoint(x: 727, y: 475))
    shield.curve(to: NSPoint(x: 512, y: 204), controlPoint1: NSPoint(x: 716, y: 348), controlPoint2: NSPoint(x: 625, y: 248))
    shield.curve(to: NSPoint(x: 297, y: 475), controlPoint1: NSPoint(x: 399, y: 248), controlPoint2: NSPoint(x: 308, y: 348))
    shield.line(to: NSPoint(x: 280, y: 742))
    shield.curve(to: NSPoint(x: 512, y: 826), controlPoint1: NSPoint(x: 337, y: 780), controlPoint2: NSPoint(x: 414, y: 810))
    shield.close()
    NSColor(calibratedWhite: 0.98, alpha: 0.96).setFill()
    shield.fill()

    let chipRect = NSRect(x: 378, y: 438, width: 268, height: 218)
    let chip = NSBezierPath(roundedRect: chipRect, xRadius: 42, yRadius: 42)
    NSColor(calibratedRed: 0.035, green: 0.19, blue: 0.145, alpha: 1).setFill()
    chip.fill()

    NSColor(calibratedRed: 0.20, green: 0.91, blue: 0.53, alpha: 1).setFill()
    let cellSize = NSSize(width: 42, height: 42)
    for row in 0..<2 {
        for column in 0..<3 {
            let rect = NSRect(
                x: 414 + CGFloat(column) * 62,
                y: 478 + CGFloat(row) * 66,
                width: cellSize.width,
                height: cellSize.height
            )
            NSBezierPath(roundedRect: rect, xRadius: 9, yRadius: 9).fill()
        }
    }

    NSColor(calibratedWhite: 0.98, alpha: 0.94).setStroke()
    for offset in stride(from: CGFloat(0), through: 144, by: 48) {
        let leftPin = NSBezierPath()
        leftPin.lineWidth = 17
        leftPin.lineCapStyle = .round
        leftPin.move(to: NSPoint(x: 350, y: 474 + offset))
        leftPin.line(to: NSPoint(x: 378, y: 474 + offset))
        leftPin.stroke()

        let rightPin = NSBezierPath()
        rightPin.lineWidth = 17
        rightPin.lineCapStyle = .round
        rightPin.move(to: NSPoint(x: 646, y: 474 + offset))
        rightPin.line(to: NSPoint(x: 674, y: 474 + offset))
        rightPin.stroke()
    }

    image.unlockFocus()
    return image
}

func writePNG(_ image: NSImage, pixels: Int, to url: URL) throws {
    guard let bitmap = NSBitmapImageRep(
        bitmapDataPlanes: nil,
        pixelsWide: pixels,
        pixelsHigh: pixels,
        bitsPerSample: 8,
        samplesPerPixel: 4,
        hasAlpha: true,
        isPlanar: false,
        colorSpaceName: .deviceRGB,
        bytesPerRow: 0,
        bitsPerPixel: 0
    ) else {
        throw CocoaError(.fileWriteUnknown)
    }
    bitmap.size = NSSize(width: pixels, height: pixels)

    NSGraphicsContext.saveGraphicsState()
    NSGraphicsContext.current = NSGraphicsContext(bitmapImageRep: bitmap)
    NSGraphicsContext.current?.imageInterpolation = .high
    image.draw(in: NSRect(x: 0, y: 0, width: pixels, height: pixels))
    NSGraphicsContext.restoreGraphicsState()

    guard let data = bitmap.representation(using: .png, properties: [:]) else {
        throw CocoaError(.fileWriteUnknown)
    }
    try data.write(to: url, options: .atomic)
}

let base = makeBaseIcon()
try writePNG(base, pixels: 1024, to: resourcesURL.appendingPathComponent("AppIcon.png"))

let variants: [(String, Int)] = [
    ("icon_16x16.png", 16),
    ("icon_16x16@2x.png", 32),
    ("icon_32x32.png", 32),
    ("icon_32x32@2x.png", 64),
    ("icon_128x128.png", 128),
    ("icon_128x128@2x.png", 256),
    ("icon_256x256.png", 256),
    ("icon_256x256@2x.png", 512),
    ("icon_512x512.png", 512),
    ("icon_512x512@2x.png", 1024),
]
for (name, pixels) in variants {
    try writePNG(base, pixels: pixels, to: iconsetURL.appendingPathComponent(name))
}
