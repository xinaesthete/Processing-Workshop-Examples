#ifdef GL_ES
precision mediump float;
precision mediump int;
#endif

#define PROCESSING_TEXTURE_SHADER

uniform sampler2D texture;
uniform vec2 UVLimit = vec2(1., 1.);
uniform float segAng = 3.14/3.;
uniform float Zoom = 1.;
uniform float Angle = 1.;
uniform vec2 Centre = vec2(0.5, 0.5);
uniform vec2 ImageCentre = vec2(0.5, 0.5);

varying vec4 vertColor;
varying vec4 vertTexCoord;

const float pi = 3.14152;

//2d cartesian to polar coordinates
vec2 car2pol(vec2 IN) {
  return vec2(length(IN), atan(IN.y,IN.x));
}
//2d polar to cartesian coordinates
vec2 pol2car(vec2 IN) {
  return vec2(IN.x * cos(IN.y), IN.x * sin(IN.y));
}
//function to cause numbers outside the range 0-1 to be 'reflected'
//into that range (ie pretty much mirrorRepeat)
vec2 UV_Rectify(vec2 uv) {
  //uv = abs(uv % 2);
  uv = abs(mod(uv, vec2(2.,2.)));
  //return uv > 1. ? 1.-uv : uv;
  uv.x = uv.x > 1. ? 1.-uv.x : uv.x;
  uv.y = uv.y > 1. ? 1.-uv.y : uv.y;
  return uv;
}
//rectify within a range, eg for reflecting texture coordinates in a portion of a pow2.
vec2 UV_Rectify(vec2 uv, vec2 limit) {
	uv = abs(mod(uv, vec2(2.) * limit));
	uv.x = uv.x > limit.x ? limit.x-uv.x : uv.x;
	uv.y = uv.y > limit.y ? limit.y-uv.y : uv.y;
	return uv;
}
//rectify within a range specified in the UVLimit uniform
vec2 UV_Rectify_Uniform(vec2 uv) {
	//hopefully the compiler is not stupid and will simplify this case if appropriate
	return (UV_Rectify(uv, UVLimit.xy));
}

vec2 mirrorRepeat(vec2 uv) {
	return abs(mod((vec2(-1.)-uv),vec2(2.))+vec2(1.));
}
//works for -ve uv.
//see Morgan's unpopular answer
//http://stackoverflow.com/questions/1073606/is-there-a-one-line-function-that-generates-a-triangle-wave
//although in the end that was out of phase etc. Tweaked equation until it looked right in
//graphical calculator...
vec2 triangleWave(vec2 uv, vec2 limit) {
  return ((limit/pi)*acos(cos(2.*pi/2.*limit*uv)));
}


void main() {
  vec2 uv = vertTexCoord.xy;
  vec2 polar = car2pol(uv - Centre); //XXX might want an /UVLimit in there
  float fr = fract(polar.y / segAng);
  polar.y = Angle + (fr > 0.5 ? 1.-fr : fr) * segAng;
  polar.x *= Zoom;

  //vec2 uv2 = abs(sin((UVLimit*pol2car(polar))+ImageCentre));
  vec2 uv2 = triangleWave(pol2car(polar)+ImageCentre, vec2(1));
  
  vec4 col = texture2D(texture, uv2);
  //col.rgb = vec3(1.) - col.rgb; //TODO: just increment, decide how to present dynamically...
  
  
  //col.rgb += vec3(10./255.);
  gl_FragColor = col;// * vertColor;
}

void xmain(void) {
  vec2 uv = vertTexCoord.xy / UVLimit;
  vec2 polar = car2pol(uv - Centre/UVLimit);
  float fr = fract(polar.y / segAng);
  polar.y = Angle + (fr > 0.5 ? 1.-fr : fr) * segAng;
  polar.x *= Zoom;

  //vec2 uv2 = UV_Rectify((UVLimit*pol2car(polar))+ImageCentre);
  vec2 uv2 = pol2car(polar)+ImageCentre;
  
  vec4 col = texture2D(texture, uv);
  col += vec4(0.1, 0.15, 0.17, 0);
  //col.x += vertTexCoord.x < UVLimit.x ? 1 : 0;
  //col.y += vertTexCoord.y < UVLimit.y ? 1 : 0;
  //col.xy = UVLimit;
  //col.x = 1.;
  //col.rg = mirrorRepeat(vertTexCoord.xy);
  //col.a = 1;
  gl_FragColor = col;// * vertColor;
}
