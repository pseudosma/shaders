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
    vec4 m = (vec4(vec3(mag), 1.0));
    vec4 n = m;
    
    if (any(lessThan(m, vec4(0.5,0.5,0.4,0.5)))) {
       m = vec4(1,1,1,1);
    } else {
        m = -m;
    }
    
    if (any(lessThan(n, vec4(0.1,0.1,0.1,0.1)))) {
        n = vec4(1,1,1,1);
    } else {
        n = -n;
    }
    
    gl_FragColor = mix(n,texture2D(colorSampler, uv.xy), .7);
    gl_FragColor = mix(gl_FragColor,m, .3);
    if (any(lessThan(gl_FragColor, vec4(0.35,0.35,0.35,0.35)))) {
        gl_FragColor = vec4 (0,0,0,0);
    }
    //gl_FragColor = vec4(vec3(mag), 1.0);
    //gl_FragColor = texture2D(colorSampler, uv.xy);
    //gl_FragColor = n;
}
