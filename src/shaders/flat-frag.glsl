#version 300 es
precision highp float;

uniform vec3 u_Eye, u_Ref, u_Up;
uniform vec2 u_Dimensions;
uniform float u_Time;
uniform sampler2D u_NoiseTex1, u_NoiseTex2, u_FlameTex;

in vec2 fs_Pos;
out vec4 out_Col;

void main() {
  vec2 uv = 0.5 * (fs_Pos.xy + vec2(1.0));
  uv.x *= u_Dimensions.x / u_Dimensions.y;
  uv.x -= 0.25 * u_Dimensions.x / u_Dimensions.y;
  uv.y *= 0.5;


  float xOffset = 2.0 * texture(u_NoiseTex1, uv - vec2(0.0, u_Time * 0.01)).r - 1.0;
  float yOffset = 2.0 * texture(u_NoiseTex2, uv - vec2(0.0, u_Time * 0.005)).r - 1.0;

  vec4 flameSource = texture(u_FlameTex, uv + 0.5 * vec2(xOffset, yOffset));

  vec2 finalUV = uv + vec2(xOffset, yOffset) * flameSource.a * mix(0.15, 1.0, uv.y);
  vec4 resampledTexture = texture(u_FlameTex, finalUV);
  vec3 coreColor = vec3(150.0, 255.0, 247.0) / 255.0 * mix(0.0, 1.0, resampledTexture.g);
  vec3 outerColor = vec3(0.0, 255.0, 210.0) / 255.0 * mix(0.0, 1.0, resampledTexture.r);
  vec3 noColor = vec3(0.0, 0.0, 50.0) / 255.0 * mix(0.0, 1.0, resampledTexture.b);

  out_Col = vec4(coreColor + outerColor + noColor, 1.0);
  out_Col.rgb = mix(out_Col.rgb, noColor, step(uv.x, 0.1));
  out_Col.rgb = mix(out_Col.rgb, noColor, step(0.9, uv.x));
  // out_Col.rgb *= out_Col.a;
  // out_Col.a = 1.0;

  // out_Col = vec4(finalUV, 0.0, 1.0);
  // out_Col = vec4(xOffset, yOffset, 0.0, 1.0);
  // out_Col.a = 1.0;
  // out_Col.rg = uv;
  // out_Col.b = 0.0;
}
