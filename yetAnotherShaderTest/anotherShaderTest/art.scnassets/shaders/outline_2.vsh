attribute vec4 a_position;
uniform vec2 size;

varying vec2 uv;

varying vec2 leftTextureCoordinate;
varying vec2 rightTextureCoordinate;

varying vec2 topTextureCoordinate;
varying vec2 topLeftTextureCoordinate;
varying vec2 topRightTextureCoordinate;

varying vec2 bottomTextureCoordinate;
varying vec2 bottomLeftTextureCoordinate;
varying vec2 bottomRightTextureCoordinate;

void main() {
    gl_Position = a_position;
    uv = (a_position.xy + 1.0) * 0.5;
    
    
    vec2 widthStep = vec2(2.0 / size.x, 0.0);
    vec2 heightStep = vec2(0.0, 2.0 / size.y);
    vec2 widthHeightStep = vec2(2.0 / size.x, 2.0 / size.y);
    vec2 widthNegativeHeightStep = vec2(2.0 / size.x, -(2.0 / size.y));
    
    
    leftTextureCoordinate = uv.xy - widthStep;
    rightTextureCoordinate = uv.xy + widthStep;
    
    topTextureCoordinate = uv.xy - heightStep;
    topLeftTextureCoordinate = uv.xy - widthHeightStep;
    topRightTextureCoordinate = uv.xy + widthNegativeHeightStep;
    
    bottomTextureCoordinate = uv.xy + heightStep;
    bottomLeftTextureCoordinate = uv.xy - widthNegativeHeightStep;
    bottomRightTextureCoordinate = uv.xy + widthHeightStep;
}
