/*float V = _surface.diffuseTexcoord.y;

float dp       = length(vec2(_surface.diffuseTexcoord.x, _surface.diffuseTexcoord.y));
float logdp     = -log2(dp);
float ilogdp    = floor(logdp);
float frequency = exp2(ilogdp);
float sawtooth  = fract(V * 16.0 * frequency);
float triangle = abs(2.0 * sawtooth - 1.0);

const float edgew = 0.5;            // width of smooth step

float transition = logdp - ilogdp;
triangle = abs((1.0 + transition) * triangle - transition);


float edge0  = clamp(1.0 - edgew, 0.0, 1.0);
float edge1  = clamp(1.0, 0.0, 1.0);
float square = 1.0 - smoothstep(edge0, edge1, triangle);

_output.color.rgba = vec4(vec3(square), 1.0);*/



float WrapFactor = 0.5;

float dotProduct = (WrapFactor + max(0.0, dot(_surface.normal,_light.direction))) / (1.0 + WrapFactor);
_lightingContribution.diffuse += (dotProduct * _light.intensity.rgb);
vec3 halfVector = normalize(_light.direction + _surface.view);
dotProduct = max(0.0, pow(max(0.0, dot(_surface.normal, halfVector)), _surface.shininess));
_lightingContribution.specular += (dotProduct * _light.intensity.rgb);