uniform sampler2D diffuseTexture;
uniform sampler2D reflectiveTexture;
uniform vec2 textureDimensions;


_surface.diffuse = vec4(1, 1, 1, 1);
vec4 transformSurfaceNor = u_inverseViewTransform * vec4(_surface.position, 1.0);

if (any(greaterThan(textureDimensions, vec2(0, 0)))) {
    //dimensions were specified so we should query the textures
    vec2 phase = fract(transformSurfaceNor.xy * 100 / textureDimensions);
    _surface.diffuse = texture2D(diffuseTexture, phase);
    //always assume there's a reflectiveTexture too
    _surface.reflective = texture2D(reflectiveTexture, phase);
}

