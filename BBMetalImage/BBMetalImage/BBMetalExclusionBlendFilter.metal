//
//  BBMetalExclusionBlendFilter.metal
//  BBMetalImage
//
//  Created by Kaibo Lu on 4/5/19.
//  Copyright © 2019 Kaibo Lu. All rights reserved.
//

#include <metal_stdlib>
using namespace metal;

kernel void exclusionBlendKernel(texture2d<half, access::write> outputTexture [[texture(0)]],
                                 texture2d<half, access::read> inputTexture [[texture(1)]],
                                 texture2d<half, access::sample> inputTexture2 [[texture(2)]],
                                 uint2 gid [[thread_position_in_grid]]) {
    
    const half4 base = inputTexture.read(gid);
    constexpr sampler quadSampler;
    const half4 overlay = inputTexture2.sample(quadSampler, float2(float(gid.x) / inputTexture.get_width(), float(gid.y) / inputTexture.get_height()));
    
    const half4 outColor((overlay.rgb * base.a + base.rgb * overlay.a - 2.0h * overlay.rgb * base.rgb) + overlay.rgb * (1.0h - base.a) + base.rgb * (1.0h - overlay.a), base.a);
    outputTexture.write(outColor, gid);
}
