uniform sampler2D colorSampler;
uniform sampler2D depth;
uniform vec2 size;
uniform float u_time;
uniform sampler2D dropsNormalSampler;
uniform sampler2D dropsNormalSampler2;
uniform sampler2D depthFirstPass;

varying vec2 uv;

/*float rand2D(in vec2 co){
    return fract(sin(dot(co.xy ,vec2(12.9898,78.233))) * 43758.5453);
}

float voronoiNoise2D(in float x, in float y, in float xrand, in float yrand)
{
    float integer_x = x - fract(x);
    float fractional_x = x - integer_x;
    
    float integer_y = y - fract(y);
    float fractional_y = y - integer_y;
    
    float val[4];
    
    val[0] = rand2D(vec2(integer_x, integer_y));
    val[1] = rand2D(vec2(integer_x+1.0, integer_y));
    val[2] = rand2D(vec2(integer_x, integer_y+1.0));
    val[3] = rand2D(vec2(integer_x+1.0, integer_y+1.0));
    
    float xshift[4];
    
    xshift[0] = xrand * (rand2D(vec2(integer_x+0.5, integer_y)) - 0.5);
    xshift[1] = xrand * (rand2D(vec2(integer_x+1.5, integer_y)) -0.5);
    xshift[2] = xrand * (rand2D(vec2(integer_x+0.5, integer_y+1.0))-0.5);
    xshift[3] = xrand * (rand2D(vec2(integer_x+1.5, integer_y+1.0))-0.5);
    
    float yshift[4];
    
    yshift[0] = yrand * (rand2D(vec2(integer_x, integer_y +0.5)) - 0.5);
    yshift[1] = yrand * (rand2D(vec2(integer_x+1.0, integer_y+0.5)) -0.5);
    yshift[2] = yrand * (rand2D(vec2(integer_x, integer_y+1.5))-0.5);
    yshift[3] = yrand * (rand2D(vec2(integer_x+1.5, integer_y+1.5))-0.5);
    
    float dist[4];
    
    dist[0] = sqrt((fractional_x + xshift[0]) * (fractional_x + xshift[0]) + (fractional_y + yshift[0]) * (fractional_y + yshift[0]));
    dist[1] = sqrt((1.0 -fractional_x + xshift[1]) * (1.0-fractional_x+xshift[1]) + (fractional_y +yshift[1]) * (fractional_y+yshift[1]));
    dist[2] = sqrt((fractional_x + xshift[2]) * (fractional_x + xshift[2]) + (1.0-fractional_y +yshift[2]) * (1.0-fractional_y + yshift[2]));
    dist[3] = sqrt((1.0-fractional_x + xshift[3]) * (1.0-fractional_x + xshift[3]) + (1.0-fractional_y +yshift[3]) * (1.0-fractional_y + yshift[3]));
    
    int i, i_min;
    float dist_min = 100.0;
    for (i=0; i<4;i++)
    {
        if (dist[i] < dist_min)
        {
            dist_min = dist[i];
            i_min = i;
        }
    }
    
    return val[i_min];
    
}*/

void main()
{
    
    //depth outline wigglesds
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
    
    //gl_FragColor = depthOutline;
    
    // blur pass
    
    /*float resolution = 1080.0;
    float radius = 17.0;
    vec2 dir = vec2(1.0,1.0);
    
    //this will be our RGBA sum
    vec4 sum = vec4(0.0);
    
    //our original texcoord for this fragment
    vec2 tc = uv;
    
    //the amount to blur, i.e. how far off center to sample from
    //1.0 -> blur by one pixel
    //2.0 -> blur by two pixels, etc.
    float blur = radius/resolution;
    
    //the direction of our blur
    //(1.0, 0.0) -> x-axis blur
    //(0.0, 1.0) -> y-axis blur
    float hstep = dir.x;
    float vstep = dir.y;
    
    //apply blurring, using a 9-tap filter with predefined gaussian weights
    
    sum += texture2D(colorSampler, vec2(tc.x - 4.0*blur*hstep, tc.y - 4.0*blur*vstep)) * 0.0162162162;
    sum += texture2D(colorSampler, vec2(tc.x - 3.0*blur*hstep, tc.y - 3.0*blur*vstep)) * 0.0540540541;
    sum += texture2D(colorSampler, vec2(tc.x - 2.0*blur*hstep, tc.y - 2.0*blur*vstep)) * 0.1216216216;
    sum += texture2D(colorSampler, vec2(tc.x - 1.0*blur*hstep, tc.y - 1.0*blur*vstep)) * 0.1945945946;
    
    sum += texture2D(colorSampler, vec2(tc.x, tc.y)) * 0.2270270270;
    
    sum += texture2D(colorSampler, vec2(tc.x + 1.0*blur*hstep, tc.y + 1.0*blur*vstep)) * 0.1945945946;
    sum += texture2D(colorSampler, vec2(tc.x + 2.0*blur*hstep, tc.y + 2.0*blur*vstep)) * 0.1216216216;
    sum += texture2D(colorSampler, vec2(tc.x + 3.0*blur*hstep, tc.y + 3.0*blur*vstep)) * 0.0540540541;
    sum += texture2D(colorSampler, vec2(tc.x + 4.0*blur*hstep, tc.y + 4.0*blur*vstep)) * 0.0162162162;
    
    //discard alpha for our simple demo, multiply by vertex color and return
    //gl_FragColor = texture2D(colorSampler,uv) * vec4(sum.rgb, 1.0);
    
    gl_FragColor = mix(depthOutline,mix(texture2D(colorSampler,uv),sum,0.5),0.5);*/
    
    //gl_FragColor = vec4(voronoiNoise2D(uv.x/0.03, uv.y/0.03, rand2D(uv), rand2D(uv)));
    
    //gl_FragColor = mix(texture2D(depth,uv),sum,0.5);

    /*vec4 blurredDepth = mix(texture2D(depth,uv),sum,0.5);
    if (any(lessThan(blurredDepth, vec4(0.8,0.8,0.8,0.8)))) {
        gl_FragColor = mix(depthOutline,mix(blurredDepth,vec4(voronoiNoise2D(uv.x/0.03, uv.y/0.03, rand2D(uv), rand2D(uv))),0.1),0.5);
    } else {
        gl_FragColor = mix(depthOutline, texture2D(colorSampler,uv), 0.5);
    }*/
    
    
    //gl_FragColor = vec4(voronoiNoise2D(uv.x/0.1, uv.y/0.03, rand2D(uv), rand2D(uv)));
    
    //vec4 outPut = mix(depthOutline,texture2D(colorSampler,uv),0.5);
    //gl_FragColor = texture2D(depth,uv);
    
    vec2 tc;
    
    float amplitude = 1.4;
    float frequency = 1.7;
    tc.x = 6.5;//u_time * 0.1;
    tc.y = sin(tc.x * frequency);
    float t = (texture2D(colorSampler,uv).g*323.0);
    tc.y += sin(tc.x*frequency*2.1 + t)*1.5;
    tc.x += sin(tc.y*frequency*6.72 + t*1.121)*3.5;
    tc.y += sin(tc.x*frequency*5.221 + t*0.437)*3.6;
    tc.x += sin(tc.y*frequency*3.1122+ t*1.269)*3.5;
    tc.y *= amplitude*1.9;
    
    vec2 widthStep = vec2(3.5 / size.x, 5.0);
    vec2 heightStep = vec2(4.0, (0.5 + tc.y) / size.y);
    vec2 widthHeightStep = vec2(0.5 / size.x, (0.5 + tc.y) / size.y);
    vec2 widthNegativeHeightStep = vec2(0.5 / size.x, -((0.5 + tc.y) / size.y));
    
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
    //gl_FragColor = mix(depthOutline,mix(mix(texture2D(colorSampler,uv),sum * 60.0,0.5),vec4(voronoiNoise2D(uv.x/0.03, uv.y/0.03, rand2D(uv), rand2D(uv))),0.1),0.5);
    
}
