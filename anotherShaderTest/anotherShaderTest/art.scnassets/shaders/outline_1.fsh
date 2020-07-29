uniform sampler2D depth;
uniform sampler2D colorSampler;

varying vec2 uv;
uniform vec2 size;

varying vec2 leftTextureCoordinate;
varying vec2 rightTextureCoordinate;

varying vec2 topTextureCoordinate;
varying vec2 topLeftTextureCoordinate;
varying vec2 topRightTextureCoordinate;

varying vec2 bottomTextureCoordinate;
varying vec2 bottomLeftTextureCoordinate;
varying vec2 bottomRightTextureCoordinate;


void main() {
    vec4 bottomLeftIntensity = texture2D(depth, bottomLeftTextureCoordinate);
    vec4 topRightIntensity = texture2D(depth, topRightTextureCoordinate);
    vec4 topLeftIntensity = texture2D(depth, topLeftTextureCoordinate);
    vec4 bottomRightIntensity = texture2D(depth, bottomRightTextureCoordinate);
    vec4 leftIntensity = texture2D(depth, leftTextureCoordinate);
    vec4 rightIntensity = texture2D(depth, rightTextureCoordinate);
    vec4 bottomIntensity = texture2D(depth, bottomTextureCoordinate);
    vec4 topIntensity = texture2D(depth, topTextureCoordinate);
    float h = -topLeftIntensity.b - 2.0 * topIntensity.b - topRightIntensity.b + bottomLeftIntensity.b + 2.0 * bottomIntensity.b + bottomRightIntensity.b;
    float v = -bottomLeftIntensity.b - 2.0 * leftIntensity.b - topLeftIntensity.b + bottomRightIntensity.b + 2.0 * rightIntensity.b + topRightIntensity.b;
    
    float mag = (length(vec2(h, v)));
    
    
    bottomLeftIntensity = texture2D(colorSampler, bottomLeftTextureCoordinate);
    topRightIntensity = texture2D(colorSampler, topRightTextureCoordinate);
    topLeftIntensity = texture2D(colorSampler, topLeftTextureCoordinate);
    bottomRightIntensity = texture2D(colorSampler, bottomRightTextureCoordinate);
    leftIntensity = texture2D(colorSampler, leftTextureCoordinate);
    rightIntensity = texture2D(colorSampler, rightTextureCoordinate);
    bottomIntensity = texture2D(colorSampler, bottomTextureCoordinate);
    topIntensity = texture2D(colorSampler, topTextureCoordinate);
    h = -topLeftIntensity.g - 1.0 * topIntensity.g - topRightIntensity.g + bottomLeftIntensity.g + 1.0 * bottomIntensity.g + bottomRightIntensity.g;
    v = -bottomLeftIntensity.g - 1.0 * leftIntensity.g - topLeftIntensity.g + bottomRightIntensity.g + 1.0 * rightIntensity.g + topRightIntensity.g;
    
    float mag2 = (length(vec2(h, v)));
    
    
    gl_FragColor = mix(vec4(vec3(mag), 1.0),vec4(vec3(mag2), 1.0),0.1);
    //gl_FragColor = vec4(vec3(mag), 1.0);
}
