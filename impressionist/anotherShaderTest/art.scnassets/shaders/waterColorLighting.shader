float dotProduct = dot((_surface.normal), (_light.direction));
float dotProdView = dot(normalize(_surface.view), normalize(_surface.normal));

float num1 = cos(2.17 * _surface.diffuseTexcoord.y) * 0.273;
float num2 = (sin(7.33 * _surface.diffuseTexcoord.y) / 2.0) * 0.7 + (sin(8.013 * _surface.diffuseTexcoord.y) / 3.0);
float num3 = (cos(2.07 * _surface.diffuseTexcoord.y)) + (cos(1.1198 * _surface.diffuseTexcoord.y) / 26.01);
float num4 = (sin(3.059 * _surface.diffuseTexcoord.y)) + (sin(1.178 * _surface.diffuseTexcoord.y) / 33.12) + (sin(178.12 * _surface.diffuseTexcoord.y) / 3.445);

const vec3 additive = vec3(0.2,0.2,0.2);

if (outline_popColors_distanceOutline_extraTexture.y == 1.0) {
    
    _lightingContribution.diffuse = vec3(0.3, 0.3, 0.3);
    
    if (dotProduct < 0.5 + sin(num4)) {
        _lightingContribution.diffuse = vec3(0.0, 0.0, 0.0);
    }
    
}else{
    _lightingContribution.diffuse = vec3(1.0, 1.0, 1.0);
    
    if (dotProduct > 0.2 + num1) {
        _lightingContribution.diffuse -= additive;
    }
    if (dotProduct > 0.3 + num2) {
        _lightingContribution.diffuse -= additive;
    }
    if (dotProduct > 0.6 + num3) {
        _lightingContribution.diffuse -= additive;
    }
    if (dotProduct > 0.7 + num4) {
        _lightingContribution.diffuse -= additive;
    }
}

if (outline_popColors_distanceOutline_extraTexture.x == 1.0) {
    if (dotProdView <= 0.2) {
        _lightingContribution.diffuse += (dotProdView * _light.intensity.rgb);
    }
}
