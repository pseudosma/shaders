uniform sampler2D colorSampler;
uniform sampler2D depth;
uniform vec2 size;
uniform float u_time;
uniform sampler2D dropsNormalSampler;
uniform sampler2D dropsNormalSampler2;
uniform sampler2D depthFirstPass;

varying vec2 uv;

void main()
{
    
    //depth outline wiggles
    float mag = texture2D(depthFirstPass,uv).r;
    
    vec2 new_uv = fract((uv - 0.5)/(vec2(1.775,1.0)*1.8) + 0.5 + vec2(0.0,u_time*0.005));
    vec3 normal = texture2D(dropsNormalSampler,vec2(new_uv.x,1.0-new_uv.y)).rgb;
    normal = normal * 2.0 - 1.0;
    vec4 dfpSampler = texture2D(depthFirstPass,fract(uv + normal.xy*0.008));
    dfpSampler.a = 1.0;
    
    vec4 depthOutline = texture2D(colorSampler,uv);
    depthOutline = vec4(depthOutline.r - mag, depthOutline.g - mag, depthOutline.b - mag,1.0);
    
    new_uv = fract((uv - 0.5)/(vec2(1.775,1.0)*1.8) + 0.5 + vec2(0.0,-u_time*0.003));
    normal = texture2D(dropsNormalSampler2,vec2(new_uv.x,1.0-new_uv.y)).rgb;
    normal = normal * 2.0 - 1.0;
    vec4 dfpSampler2 = texture2D(depthFirstPass,fract(uv + normal.xy*0.008));
    dfpSampler.a = 1.0;
    
    depthOutline -= mix(dfpSampler,dfpSampler2,0.5) * 4.0;
    
    
    // blur pass
    
    vec2 tc;
    
    float amplitude = 1.0;
    float frequency = 1.0;
    tc.x = u_time * 0.1;
    tc.y = sin(tc.x * frequency);
    float t = (texture2D(colorSampler,uv).g*323.0);
    tc.y += sin(tc.x*frequency*2.1 + t)*4.5;
    tc.y += sin(tc.x*frequency*1.72 + t*1.121)*4.0;
    tc.y += sin(tc.x*frequency*2.221 + t*0.437)*5.0;
    tc.y += sin(tc.x*frequency*3.1122+ t*4.269)*2.5;
    tc.y *= amplitude*0.9;
    
    vec2 widthStep = vec2(1.0 / size.x, 0.0);
    vec2 heightStep = vec2(0.0, (1.0 + tc.y) / size.y);
    vec2 widthHeightStep = vec2(1.0 / size.x, (1.0 + tc.y) / size.y);
    vec2 widthNegativeHeightStep = vec2(1.0 / size.x, -((1.0 + tc.y) / size.y));
    
    vec2 leftTextureCoordinate = uv.xy - widthStep;
    vec2 rightTextureCoordinate = uv.xy + widthStep;
    
    vec2 topTextureCoordinate = uv.xy - heightStep;
    vec2 topLeftTextureCoordinate = uv.xy - widthHeightStep;
    vec2 topRightTextureCoordinate = uv.xy + widthNegativeHeightStep;
    
    vec2 bottomTextureCoordinate = uv.xy + heightStep;
    vec2 bottomLeftTextureCoordinate = uv.xy - widthNegativeHeightStep;
    vec2 bottomRightTextureCoordinate = uv.xy + widthHeightStep;
    
    vec4 bottomLeftIntensity = texture2D(colorSampler, bottomLeftTextureCoordinate);
    vec4 topRightIntensity = texture2D(colorSampler, topRightTextureCoordinate);
    vec4 topLeftIntensity = texture2D(colorSampler, topLeftTextureCoordinate);
    vec4 bottomRightIntensity = texture2D(colorSampler, bottomRightTextureCoordinate);
    vec4 leftIntensity = texture2D(colorSampler, leftTextureCoordinate);
    vec4 rightIntensity = texture2D(colorSampler, rightTextureCoordinate);
    vec4 bottomIntensity = texture2D(colorSampler, bottomTextureCoordinate);
    vec4 topIntensity = texture2D(colorSampler, topTextureCoordinate);
    
    float blur = 20.0/(size.x * size.y);
    vec4 sum = vec4(0.0);
    sum += bottomLeftIntensity * 0.0162162162;
    sum += topRightIntensity * blur * 0.0540540541;
    sum += topLeftIntensity * blur * 0.1216216216;
    sum += bottomRightIntensity * blur * 0.1945945946;
    
    sum += leftIntensity * blur * 0.1945945946;
    sum += rightIntensity * blur * 0.1216216216;
    sum += bottomIntensity * blur * 0.0540540541;
    sum += topIntensity * blur * 0.0162162162;
    
    
    gl_FragColor = mix(depthOutline,mix(texture2D(colorSampler,uv),sum * 60.0,0.5),0.5);
    
}
