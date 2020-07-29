uniform sampler2D brushStrokes;
uniform sampler2D paperTexture1;
uniform sampler2D paperTexture2;
uniform sampler2D paperTexture3;
uniform sampler2D paperTexture4;
uniform sampler2D paperTexture5;

vec2 tile = vec2(512.0, 512.0);

vec2 xy = gl_FragCoord.xy;
vec2 phase = fract(xy / tile);
float dotProd = dot(_surface.view, _surface.normal);

if (outline_popColors_distanceOutline_extraTexture.x == 1.0) {
if ( 0.18 >= dotProd && dotProd > 0.08 ) {
    _output.color.rgb = mix(vec3(0.8,0.8,0.8),vec3(texture2D(brushStrokes, phase)), interpolationValue);
    //discard;
    }
}

vec3 mixed1 = mix(_surface.diffuse.rgb,vec3(texture2D(paperTexture1, phase)), 0.1);
vec3 mixed2 = mix(_surface.diffuse.rgb,vec3(texture2D(paperTexture2, phase)), 0.1);
vec3 mixed3 = mix(_surface.diffuse.rgb,vec3(texture2D(paperTexture3, phase)), 0.1);
vec3 mixed4 = mix(_surface.diffuse.rgb,vec3(texture2D(paperTexture4, phase)), 0.1);
vec3 mixed5 = mix(_surface.diffuse.rgb,vec3(texture2D(paperTexture5, phase)), 0.1);


if (distance(transformSurfaceNor, vec4(lightPosition,1.0)) > alpha_Beta_litDistance.z) {
    _lightingContribution.diffuse = vec3(1.0,1.0,1.0);
}

if (all(lessThan(_lightingContribution.diffuse,vec3(0.3,0.3,0.3)))) {
    _output.color.rgb = mix(_lightingContribution.diffuse, mixed2, 0.5);
}
if (all(equal(_lightingContribution.diffuse,vec3(0.4,0.4,0.4)))) {
    _output.color.rgb = mix(_lightingContribution.diffuse, mixed2, 0.5);
}
if (all(equal(_lightingContribution.diffuse,vec3(0.6,0.6,0.6)))) {
    _output.color.rgb = mix(_lightingContribution.diffuse, mixed3, 0.5);
}
if (all(equal(_lightingContribution.diffuse,vec3(0.8,0.8,0.8)))) {
    _output.color.rgb = mix(_lightingContribution.diffuse, mixed1, 0.5);
}
if (any(greaterThan(_lightingContribution.diffuse,vec3(0.8,0.8,0.8)))) {
    _output.color.rgb = mix(_lightingContribution.diffuse, mixed5, 0.5);
}

float viewToNormalDistance = distance(_surface.view,_surface.position);
_output.color.rgb = mix(_output.color.rgb, vec3(texture2D(paperTexture5, phase)), viewToNormalDistance / 1000);

if (any(greaterThan(_lightingContribution.diffuse,vec3(0.99,0.99,0.99)))) {
    _output.color = texture2D(paperTexture5, phase);
}
