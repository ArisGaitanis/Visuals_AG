# Visuals_AG
A repository for demonstration of some visual effects
# Visuals 🎨✨

A curated collection of high-performance, pure SwiftUI visual effects, custom graphics shaders, and interactive UI components for iOS. Built using modern SwiftUI techniques, `Canvas` API, trigonometry, layer blend modes, and clean architecture principles.

![iOS 17.0+](https://img.shields.io/badge/iOS-17.0%2B-blue?logo=apple)
![Swift 5.9](https://img.shields.io/badge/Swift-5.9-orange?logo=swift)
![License MIT](https://img.shields.io/badge/License-MIT-green)

---

## 🌟 Visual Showcase

| Effect | Description | Key Technologies |
| :--- | :--- | :--- |
| **3D Glassmorphic Card** | Interactive card component with dynamic 3D pitch/roll tilt and live specular light sheen following touch drag vectors. | `.ultraThinMaterial`, `rotation3DEffect`, Dynamic `UnitPoint` |
| **Siri Perimeter Glow** | Rotating multi-color ambient border flowing along rounded card perimeters, replicating Apple Intelligence aesthetics. | `AngularGradient`, `TimelineView`, Dual-pass Bloom Blur |
| **Liquid Metaballs** | Fluid, merging liquid droplets that stretch and fuse organically when moving close to each other. | SwiftUI `Canvas`, `.blur`, `.alphaThreshold` |
| **Siri Audio Waveform** | Multi-layered, glowing sine wave visualizer curves with smooth endpoint anchoring and interference patterns. | Custom `Shape` Paths, Trigonometric Sine Envelopes, `.plusLighter` |
| **RGB Chromatic Aberration** | Analog lens split effect separating UI content into distinct Red, Green, and Blue channels during gesture distortion. | Channel Splitting, `.colorMultiply`, `.plusLighter` Blend |
| **Particle Constellation** | Interactive node network connecting nearby floating particles with proximity-faded vector lines and touch attraction. | SwiftUI `Canvas`, Euclidean Distance Physics, `hypot()` |
| **Particle Sphere** | Interactive 3D particle point cloud rotating and responding to user gestures. | `TimelineView`, 3D Projection, `Canvas` |
| **Bouncing Dots** | Smooth, rhythmic loading indicator animation with staggered spring physics. | SwiftUI Transitions, Spring Animations |

---

## 🛠 Features

* **Zero External Dependencies**: 100% native Swift & SwiftUI codebase.
* **120 FPS Rendering**: Driven by optimized `TimelineView` and `Canvas` context passes.
* **Interactive Previews**: Every component contains self-contained `#Preview` blocks for instant iteration in Xcode.
* **Dual Showcase Architecture**: Includes both a tabbed horizontal selector dashboard and an iOS-native `NavigationStack` list menu.

---

## 🚀 Getting Started

### Requirements
* Xcode 15.0 or later
* iOS 17.0+ SDK
* Swift 5.9+

### Installation

1. Clone the repository:
   ```bash
   git clone [https://github.com/YOUR_GITHUB_USERNAME/Visuals.git](https://github.com/YOUR_GITHUB_USERNAME/Visuals.git)
