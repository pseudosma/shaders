uniform vec3 lightPosition;
uniform vec3 objectPosition;
uniform vec3 coolColor;
uniform vec3 warmColor;
uniform vec3 objectColor;
uniform vec3 alpha_Beta_litDistance;
uniform vec4 outline_popColors_distanceOutline_extraTexture;
uniform sampler2D extraTexture;

float dotProdView = dot(normalize(_surface.view), normalize(_surface.normal));

vec3 normalVector = normalize(_surface.normal);
vec3 lightVector = normalize(lightPosition);
float diffuseLighting = dot(lightVector, normalVector);
float interpolationValue = ((1.0 + diffuseLighting)/2.0);

vec3 coolColorMod = coolColor + objectColor * alpha_Beta_litDistance.x;
vec3 warmColorMod = warmColor + objectColor * alpha_Beta_litDistance.y;
vec4 transformSurfaceNor = u_inverseViewTransform * vec4(_surface.position, 1.0);

_surface.diffuse.rgb = mix(coolColorMod, warmColorMod, interpolationValue);

if (outline_popColors_distanceOutline_extraTexture.w == 1.0) {
 vec2 tile2 = vec2(64.0, 64.0);
 vec2 phase2 = fract(transformSurfaceNor.xy * 100 / tile2);
 _surface.diffuse.rgb = mix(_surface.diffuse.rgb,vec3(texture2D(extraTexture, phase2)), 0.3);
}

