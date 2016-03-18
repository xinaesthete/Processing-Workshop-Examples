#ifdef GL_ES
precision mediump float;
precision mediump int;
#endif

#define PROCESSING_TEXTURE_SHADER

uniform sampler2D texture;
uniform sampler2D textureB;

varying vec4 vertColor;
varying vec4 vertTexCoord;

void main() {
  vec4 colA = texture2D(texture, vertTexCoord.xy);
  vec4 colB = texture2D(textureB, vertTexCoord.xy);
  gl_FragColor = mix(colA, colB, 0.5);
}
