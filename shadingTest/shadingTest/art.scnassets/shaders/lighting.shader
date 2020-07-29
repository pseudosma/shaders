float dotProduct = dot(_surface.normal, _light.direction);
float dotProdView = dot(_surface.view, _surface.normal);

vec2 st = _surface.view.xy/vec2(300.0);
vec2 i = floor(st);
vec2 f = fract(st);
vec2 u = f*f*(3.0-2.0*f);
float a = fract(sin(dot(i + vec2(0.0),vec2(12.9898,78.233)))* 43758.5453123);
float b = fract(sin(dot(i + vec2(1.0,0.0),vec2(12.9898,78.233)))* 43758.5453123);
float c = fract(sin(dot(i + vec2(0.0,0.0),vec2(12.9898,78.233)))* 43758.5453123);
float d = fract(sin(dot(i + vec2(1.0),vec2(12.9898,78.233)))* 43758.5453123);
float noise = mix(a, b, u.x) + (c - a)* u.y * (1.0 - u.x) + (d - b) * u.x * u.y;



float num1 = cos(1.0 * _surface.diffuseTexcoord.y) * 0.2;
float num2 = (sin(1.0 * _surface.diffuseTexcoord.y) / 2.0) + (sin(1.0 * _surface.diffuseTexcoord.y) / 4.0);
float num3 = (cos(1.0 * _surface.diffuseTexcoord.y)) + (cos(1.0 * _surface.diffuseTexcoord.y) / 2.0);
float num4 = (sin(1.0 * _surface.diffuseTexcoord.y)) + (sin(1.0 * _surface.diffuseTexcoord.y) / 2.0) + (sin(1.0 * _surface.diffuseTexcoord.y) / 3.0);

//float num5 = ((tan(1.0 * _surface.view.x)) + (tan(1.0 * _surface.view.x) / 2.0) + (tan(1.0 * _surface.view.x) / 3.0));


/*if (dotProduct > 0.0) {
    _lightingContribution.diffuse += (dotProduct * _light.intensity.rgb);
    _lightingContribution.diffuse = floor(_lightingContribution.diffuse * 5.0) / 4.0;
}*/

/*if (dotProduct < 1.0 && dotProduct >= 0.7) {
    _lightingContribution.diffuse = vec3(0.9, 0.9, 0.9);
} else if (dotProduct < 0.7 && dotProduct >= (0.6)) {
    _lightingContribution.diffuse = vec3(0.7, 0.7, 0.7);
}else if (dotProduct < 0.6 && dotProduct >= (0.3 + random)) {
    _lightingContribution.diffuse = vec3(0.5, 0.5, 0.5);
}else if (dotProduct < 0.3 && dotProduct >= 0.2) {
    _lightingContribution.diffuse = vec3(0.3, 0.3, 0.3);
}else if (dotProduct < 0.2 && dotProduct >= 0.0) {
    _lightingContribution.diffuse = vec3(0.1, 0.1, 0.1);
}*/

/*vec2 st = _surface.view.xy/vec2(300.0);
vec2 i = floor(st);
vec2 f = fract(st);
vec2 u = f*f*(3.0-2.0*f);
vec2 x1 = vec2( dot(i + vec2(0.0,0.0),vec2(127.1,311.7)), dot(st,vec2(269.5,183.3)) );
vec2 y1 = -1.0 + 2.0*fract(sin(vec2( dot(x1,vec2(127.1,311.7)), dot(st,vec2(269.5,183.3)) ))*43758.5453123);
vec2 x2 = vec2( dot(i + vec2(1.0,0.0),vec2(127.1,311.7)), dot(st,vec2(269.5,183.3)) );
vec2 y2 = -1.0 + 2.0*fract(sin(vec2( dot(x2,vec2(127.1,311.7)), dot(st,vec2(269.5,183.3)) ))*43758.5453123);
vec2 x3 = vec2( dot(i + vec2(0.0,1.0),vec2(127.1,311.7)), dot(st,vec2(269.5,183.3)) );
vec2 y3 = -1.0 + 2.0*fract(sin(vec2( dot(x3,vec2(127.1,311.7)), dot(st,vec2(269.5,183.3)) ))*43758.5453123);
vec2 x4 = vec2( dot(i + vec2(1.0,1.0),vec2(127.1,311.7)), dot(st,vec2(269.5,183.3)) );
vec2 y4 = -1.0 + 2.0*fract(sin(vec2( dot(x4,vec2(127.1,311.7)), dot(st,vec2(269.5,183.3)) ))*43758.5453123);

float noise = mix( mix( dot( y1, f - vec2(0.0,0.0) ), dot( y2, f - vec2(1.0,0.0) ), u.x), mix( dot( y3, f - vec2(0.0,1.0) ), dot( y4, f - vec2(1.0,1.0) ), u.x), u.y);

vec3 color = vec3(1.0) * smoothstep(.18,.2,noise); // Big black drops
color += smoothstep(.15,.2,noise); // Black splatter
color -= smoothstep(.35,.4,noise); // Holes on splatter*/
    


const vec3 additive = vec3(0.2,0.2,0.2);
_lightingContribution.diffuse = vec3(0.1, 0.1, 0.1);

if (dotProduct > 0.2 - num1 * 0.2) {
    _lightingContribution.diffuse += additive;
}
if (dotProduct > 0.3 - num2) {
    _lightingContribution.diffuse += additive;
}
if (dotProduct > 0.6 - num3) {
    _lightingContribution.diffuse += additive;
}
if (dotProduct > 0.7 - num4 * 0.5) {
    _lightingContribution.diffuse += additive;
}

if (dotProdView <= 0.2) {
 _lightingContribution.diffuse += (dotProdView * _light.intensity.rgb);
}