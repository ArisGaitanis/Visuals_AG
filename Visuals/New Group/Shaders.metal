//
//  Shaders.metal
//  Visuals
//
//  Created by Aristeidis Gaitanis on 7/10/26.
//


#include <metal_stdlib>
#include <SwiftUI/SwiftUI.h>
using namespace metal;

// Ripple Distortion Shader
[[ stitchable ]] float2 rippleDistortion(
    float2 position,
    float2 touchPosition,
    float time,
    float speed,
    float frequency,
    float amplitude,
    float decay
) {
    // Calculate distance from current pixel position to touch origin
    float distance = length(position - touchPosition);
    
    // Calculate decaying sine wave based on distance and elapsed time
    float wave = sin((distance * frequency) - (time * speed));
    
    // Exponential attenuation so the ripple dies out further away
    float attenuation = exp(-distance * decay);
    
    // Offset vector pointing away from touch origin
    float2 direction = normalize(position - touchPosition);
    
    // Return distorted coordinate pass
    return position + direction * wave * amplitude * attenuation;
}
// MARK: - Glass Water Caustics Shader
[[ stitchable ]] half4 waterCaustics(
    float2 position,
    half4 color,
    float time,
    float speed
) {
    // Scale coordinate space for noise frequency
    float2 uv = position * 0.012;
    float t = time * speed;
    
    // Layer 1: Diagonal moving sine wave vectors
    float wave1 = sin(uv.x * 3.0 + t) + cos(uv.y * 3.0 + t);
    
    // Layer 2: Offset intersecting wave vectors
    float wave2 = sin(uv.x * 5.0 - t * 1.2) + cos(uv.y * 4.0 + t * 0.8);
    
    // Combine layers to create sharp liquid light focal points
    float caustic = pow(sin(wave1 + wave2), 2.0);
    
    // Caustic color tint (cyan-blue glow)
    half3 causticColor = half3(0.2, 0.8, 1.0) * half(caustic * 0.6);
    
    // Add light caustics directly onto base pixel color
    return half4(color.rgb + causticColor, color.a);
}
// MARK: - Pixel Noise & Holographic Glitch Shader
[[ stitchable ]] half4 holographicGlitch(
    float2 position,
    SwiftUI::Layer layer,
    float time,
    float glitchIntensity
) {
    if (glitchIntensity <= 0.0) {
        return layer.sample(position);
    }
    
    // Block grid quantization
    float blockSize = 16.0;
    float2 blockPos = floor(position / blockSize) * blockSize;
    
    // Pseudo-random noise seed per block
    float blockNoise = fract(sin(dot(blockPos, float2(12.9898, 78.233)) + floor(time * 15.0)) * 43758.5453);
    
    // Trigger shift on random blocks
    float2 samplePos = position;
    if (blockNoise < glitchIntensity * 0.4) {
        float shiftX = (blockNoise - 0.5) * 40.0 * glitchIntensity;
        samplePos.x += shiftX;
    }
    
    // Sample base layer at shifted position
    half4 originalColor = layer.sample(samplePos);
    
    // Separate RGB channels for chromatic aberration on glitched pixels
    if (blockNoise < glitchIntensity * 0.3) {
        half4 redChannel = layer.sample(samplePos + float2(6.0 * glitchIntensity, 0.0));
        half4 blueChannel = layer.sample(samplePos - float2(6.0 * glitchIntensity, 0.0));
        return half4(redChannel.r, originalColor.g, blueChannel.b, originalColor.a);
    }
    
    return originalColor;
}
