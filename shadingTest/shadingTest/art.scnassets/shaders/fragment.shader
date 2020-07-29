/*const float frequency = 1.0;
uniform vec3 ObjPos;

float dp = length(vec2(dFdx(1.0), dFdy(1.0)));
float logdp = -log2(dp * 8.0);
float ilogdp = floor(logdp);
float stripes = exp2(ilogdp);

float noise = texture3D(3, ObjPos).x;

float sawtooth = fract((1 + noise * 0.1) * frequency * stripes);
float triangle = abs(2.0 * sawtooth - 1.0);

float transition = logdp - ilogdp;

const float edgew = 0.3;

float edge0 = clamp(1.0 - edgew, 0.0, 1.0);
float edge1 = clamp(1.0, 0.0, 1.0);
float square = 1.0 - smoothstep(edge0, edge1, triangle);*/




/*float dotProduct = dot(_surface.view, _surface.normal);
float edge1 = clamp(1.0, 0.0, 1.0);

float sawtooth = fract(dotProduct * 2.0);
float triangle = abs(2.0 * sawtooth - 1.0);
float square = step(0.5, triangle);
_output.color.rgba = vec4(vec3(square), 1.0);*/





//hatch shading
//uniform vec3 LightingPosition;


vec3 ObjPos          = (_surface.position + vec3(0.0, 0.0, u_time)) * 0.2;
vec3 pos        = vec3(vec3(u_modelViewTransform) * _surface.position);
vec3 tnorm      = normalize(vec3(u_normalTransform) * _surface.normal);
vec3 lightVec   = normalize(LightingPosition - pos);

float LightIntensity  = max(dot(lightVec, tnorm), 0.0);

//float V = gl_MultiTexCoord0.t;  // try .s for vertical stripes
//float V = _surface.diffuseTexcoord.y;
float V = ObjPos.y;



const float frequency = 300.0;


//uniform sampler2D texture1;            // value of Noise = 3;


float dp       = length(vec2(ObjPos.x, ObjPos.y));
float logdp    = -log2(dp * 8.0);
float ilogdp   = floor(logdp);
float stripes  = exp2(ilogdp);
    
//float noise    = texture2D(texture1, ObjPos.xy).x;
    
float sawtooth = fract((V + 1.0 * 0.1) * frequency * stripes);
float triangle = abs(2.0 * sawtooth - 1.0);
    
// adjust line width
float transition = logdp - ilogdp;
    
// taper ends
triangle = abs((1.0 + transition) * triangle - transition);
    
const float edgew = 0.3;            // width of smooth step
    
float edge0  = clamp(LightIntensity - edgew, 0.0, 1.0);
float edge1  = clamp(LightIntensity, 0.0, 1.0);
float square = 1.0 - smoothstep(edge0, edge1, triangle);
    
//gl_FragColor = vec4(vec3(square), 1.0);

_output.color.rgba = vec4(vec3(square), 1.0);
//_output.color.bg = mix(_output.color.bg, (1.0 - dot(_surface.view, _surface.normal)) * _output.color.bg, 1.0);




//texture hatching
/*uniform vec3 LightingPosition;
uniform sampler2D texture1;
uniform sampler2D texture2;
uniform sampler2D texture3;
uniform sampler2D texture4;

vec3 pos        = vec3(vec3(u_modelViewTransform) * _surface.position);
vec3 tnorm      = normalize(vec3(u_normalTransform) * _surface.normal);
vec3 lightVec   = normalize(LightingPosition - pos);

float LightIntensity  = max(dot(lightVec, tnorm), 0.0);

vec3 ObjPos          = (_surface.position + vec3(0.0, 0.0, u_time)) * 0.2;

//vec2 texCoord = vec2(tnorm.x, tnorm.y);
//vec2 texCoordMax = vec2(86.0, 86.0);
float texCoordX = clamp(ObjPos.x, 0.0, 86.0);
float texCoordY = clamp(ObjPos.y, 0.0, 86.0);;

_output.color.rgba = vec4(1.0, 1.0, 1.0, 1.0);

if (ObjPos.x > 86.0)
{
    texCoordX = (fract(ObjPos.x / 86.0) * 86.0);
}

if (ObjPos.y > 86.0)
{
    texCoordY = (fract(ObjPos.y / 86.0) * 86.0);
}


if (LightIntensity < 0.85)
{
    _output.color.rgba = texture2D(texture1, vec2(texCoordX, texCoordY));
}

if (LightIntensity < 0.75)
{
    _output.color.rgba = texture2D(texture2, vec2(texCoordX, texCoordY));
}

if (LightIntensity < 0.5)
{
    _output.color.rgba = texture2D(texture3, vec2(texCoordX, texCoordY));
}

if (LightIntensity < 0.25)
{
    _output.color.rgba = texture2D(texture4, vec2(texCoordX, texCoordY));
}*/






//cross-lines shader
/*uniform vec3 LightingPosition;


vec3 pos        = vec3(vec3(u_modelViewTransform) * _surface.position);
vec3 tnorm      = normalize(vec3(u_normalTransform) * _surface.normal);
vec3 lightVec   = normalize(LightingPosition - pos);

float LightIntensity  = max(dot(lightVec, tnorm), 0.0);


_output.color.rgba = vec4(1.0, 1.0, 1.0, 1.0);


if (LightIntensity < 0.85)
{
    // hatch from left top corner to right bottom
    if (mod(gl_FragCoord.x + gl_FragCoord.y, 10.0) == 0.0)
    {
        _output.color.rgba = vec4(0.0, 0.0, 0.0, 1.0);
    }
}

if (LightIntensity < 0.75)
{
    // hatch from right top corner to left boottom
    if (mod(gl_FragCoord.x - gl_FragCoord.y, 10.0) == 0.0)
    {
        _output.color.rgba = vec4(0.0, 0.0, 0.0, 1.0);
    }
}

if (LightIntensity < 0.5)
{
    // hatch from left top to right bottom
    if (mod(gl_FragCoord.x + gl_FragCoord.y - 5.0, 10.0) == 0.0)
    {
        _output.color.rgba = vec4(0.0, 0.0, 0.0, 1.0);
    }
}

if (LightIntensity < 0.25)
{
    // hatch from right top corner to left bottom
    if (mod(gl_FragCoord.x - gl_FragCoord.y - 5.0, 10.0) == 0.0)
    {
        _output.color.rgba = vec4(0.0, 0.0, 0.0, 1.0);
    }
}*/


//gooch + texture

//
/*uniform sampler2D brushStrokes;
uniform sampler2D paperTexture1;
uniform sampler2D paperTexture2;
uniform sampler2D paperTexture3;
uniform sampler2D paperTexture4;
uniform sampler2D paperTexture5;


vec2 tile = vec2(512.0, 512.0);

vec2 xy = gl_FragCoord.xy;
// Tile coords
vec2 phase = fract(xy / tile);



/*vec3 objectColor = vec3(1.0, 1.0, 1.0);
vec3 coolColor = vec3(159.0/255.0, 148.0/255.0, 255.0/255.0);
vec3 warmColor = vec3(255.0/255.0, 75.0/255.0, 75.0/255.0);
float alpha = 0.25;
float beta = 0.5;*/

//dot product = 1 is parallel,dot product = 0 is perpindicular normal (edge).


/*vec3 normalVector1 = normalize(_surface.normal);
vec3 lightVector1 = normalize(LightingPosition);
float diffuseLighting1 = dot(lightVector1, normalVector1);
float interpolationValue1 = ((1.0 + diffuseLighting1)/2.0);*/


/*vec3 coolColorMod = coolColor + objectColor * alpha;
vec3 warmColorMod = warmColor + objectColor * beta;
vec3 mixedColors = mix(coolColorMod, warmColorMod, interpolationValue);
//_output.color.rgb = mix(mixedColors, vec3(texture2D(paintSplotch, vec2(texCoordX, texCoordY))), interpolationValue);

//dot product = 1 is parallel, dot product = 0 is perpindicular (edge).

float dotProd = dot(_surface.view, _surface.normal);
// fraction here dictates line thickness.
if ( 0.18 >= dotProd && dotProd > 0.08 ) {
    //_output.color.rgb = mix(vec3(0.8,0.8,0.8),vec3(texture2D(brushStrokes, phase)), interpolationValue);
    //discard;
}*/


/*uniform sampler2D screenTexture;

mat3 sx = mat3(
               1.0, 2.0, 1.0,
               0.0, 0.0, 0.0,
               -1.0, -2.0, -1.0
               );
mat3 sy = mat3(
               1.0, 0.0, -1.0,
               2.0, 0.0, -2.0,
               1.0, 0.0, -1.0
               );


    vec3 diffuse = texture2D(screenTexture, gl_FragCoord.st).rgb;
    mat3 I;
    for (int i=0; i<3; i++) {
        for (int j=0; j<3; j++) {
            vec3 _sample  = texelFetch(screenTexture, ivec2(gl_FragCoord) + ivec2(i-1,j-1), 0 ).rgb;
            I[i][j] = length(_sample);
        }
    }
    
    float gx = dot(sx[0], I[0]) + dot(sx[1], I[1]) + dot(sx[2], I[2]);
    float gy = dot(sy[0], I[0]) + dot(sy[1], I[1]) + dot(sy[2], I[2]);
    
    float g = sqrt(pow(gx, 2.0)+pow(gy, 2.0));
    _output.color = vec4(diffuse - vec3(g), 1.0);*/


//vec3 mixed1 = mix(_surface.diffuse.rgb,vec3(texture2D(paperTexture1, phase)), 0.5);
//vec3 mixed2 = mix(_surface.diffuse.rgb,vec3(texture2D(paperTexture2, phase)), 0.5);
//vec3 mixed3 = mix(_surface.diffuse.rgb,vec3(texture2D(paperTexture3, phase)), 0.5);
//vec3 mixed4 = mix(_surface.diffuse.rgb,vec3(texture2D(paperTexture4, phase)), 0.5);
//vec3 mixed5 = mix(_surface.diffuse.rgb,vec3(texture2D(paperTexture5, phase)), 0.5);



//_output.color.rgb = mix(_surface.diffuse.rgb,vec3(texture2D(paintSplotch, phase)), _lightingContribution.diffuse);
/*if (all(equal(_lightingContribution.diffuse,vec3(0.1,0.1,0.1)))) {
    _output.color.rgb = mix(_lightingContribution.diffuse, mixed4, 0.5);
}
if (all(equal(_lightingContribution.diffuse,vec3(0.3,0.3,0.3)))) {
    _output.color.rgb = mix(_lightingContribution.diffuse, mixed2, 0.5);
}
if (all(equal(_lightingContribution.diffuse,vec3(0.5,0.5,0.5)))) {
    _output.color.rgb = mix(_lightingContribution.diffuse, mixed3, 0.5);
}
if (all(equal(_lightingContribution.diffuse,vec3(0.7,0.7,0.7)))) {
    _output.color.rgb = mix(_lightingContribution.diffuse, mixed2, 0.5);
}
if (all(equal(_lightingContribution.diffuse,vec3(0.9,0.9,0.9)))) {
    //_output.color.rgb = vec3(texture2D(paperTexture5, phase));
}*/

