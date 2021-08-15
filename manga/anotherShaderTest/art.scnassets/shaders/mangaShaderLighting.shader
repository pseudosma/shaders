uniform int shadingScheme;

vec3 lDir = normalize(vec3(0.1,1.0,1.0));
float dotProduct = dot(_surface.normal, _light.direction);

_lightingContribution.diffuse += (dotProduct * dotProduct * _light.intensity.rgb);

if (shadingScheme < 3) {
    _lightingContribution.diffuse = floor(_lightingContribution.diffuse * 2) /1;
}

if (shadingScheme == 3) {
    _lightingContribution.diffuse = floor(_lightingContribution.diffuse * 2) /3;
}

if (shadingScheme > 3) {
    _lightingContribution.diffuse = floor(_lightingContribution.diffuse * 3) /2;
}
