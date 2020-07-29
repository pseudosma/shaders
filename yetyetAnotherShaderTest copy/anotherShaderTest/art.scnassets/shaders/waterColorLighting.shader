float dotProduct = dot((_surface.normal), (_light.direction));
float dotProdView = dot(normalize(_surface.view), normalize(_surface.normal));

float num1 = cos(1.0 * _surface.diffuseTexcoord.y) * 0.2;
float num2 = (sin(1.0 * _surface.diffuseTexcoord.y) / 2.0) * 0.7 + (sin(1.0 * _surface.diffuseTexcoord.y) / 3.0);
float num3 = (cos(1.0 * _surface.diffuseTexcoord.y)) + (cos(1.0 * _surface.diffuseTexcoord.y) / 2.0);
float num4 = (sin(1.0 * _surface.diffuseTexcoord.y)) + (sin(1.0 * _surface.diffuseTexcoord.y) / 2.0) + (sin(1.0 * _surface.diffuseTexcoord.y) / 3.0);

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
