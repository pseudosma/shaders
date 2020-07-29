uniform sampler2D colorSampler;
uniform sampler2D depth;
uniform float u_time;
uniform vec2 size;

varying vec2 uv;
vec2 u_resolution = vec2(500.0,400.0);

float random (in vec2 _st) {
    return fract(sin(dot(_st.xy,
                         vec2(12.9898,78.233)))*
                 43758.5453123);
}

vec4 softBlur(in sampler2D t,in vec2 tOffset, in vec2 coord, in vec4 vertColor) {
    vec2 tc0 = coord + vec2(-tOffset.x, -tOffset.y);
    vec2 tc1 = coord + vec2(0.0, -tOffset.y);
    vec2 tc2 = coord + vec2(+tOffset.x, -tOffset.y);
    vec2 tc3 = coord + vec2(-tOffset.x,0.0);
    vec2 tc4 = coord + vec2(0.0,0.0);
    vec2 tc5 = coord + vec2(+tOffset.x,0.0);
    vec2 tc6 = coord + vec2(-tOffset.x, +tOffset.y);
    vec2 tc7 = coord + vec2(0.0, +tOffset.y);
    vec2 tc8 = coord + vec2(+tOffset.x, +tOffset.y);
    
    vec4 col0 = texture2D(t, tc0);
    vec4 col1 = texture2D(t, tc1);
    vec4 col2 = texture2D(t, tc2);
    vec4 col3 = texture2D(t, tc3);
    vec4 col4 = texture2D(t, tc4);
    vec4 col5 = texture2D(t, tc5);
    vec4 col6 = texture2D(t, tc6);
    vec4 col7 = texture2D(t, tc7);
    vec4 col8 = texture2D(t, tc8);
    
    vec4 sum = (1.0 * col0 + 2.0 * col1 + 1.0 * col2 + 2.0 * col3 + 4.0 * col4 + 2.0 * col5 + 1.0 * col6 + 2.0 * col7 + 1.0 * col8) / 16.0;
    return vec4(sum.rgb, 1.0) * vertColor;
}

float voronoiNoise2D(in float x, in float y, in float xrand, in float yrand)
{
    float integer_x = x - fract(x);
    float fractional_x = x - integer_x;
    
    float integer_y = y - fract(y);
    float fractional_y = y - integer_y;
    
    float val[4];
    
    val[0] = random(vec2(integer_x, integer_y));
    val[1] = random(vec2(integer_x+1.0, integer_y));
    val[2] = random(vec2(integer_x, integer_y+1.0));
    val[3] = random(vec2(integer_x+1.0, integer_y+1.0));
    
    float xshift[4];
    
    xshift[0] = xrand * (random(vec2(integer_x+0.5, integer_y)) - 0.5);
    xshift[1] = xrand * (random(vec2(integer_x+1.5, integer_y)) -0.5);
    xshift[2] = xrand * (random(vec2(integer_x+0.5, integer_y+1.0))-0.5);
    xshift[3] = xrand * (random(vec2(integer_x+1.5, integer_y+1.0))-0.5);
    
    float yshift[4];
    
    yshift[0] = yrand * (random(vec2(integer_x, integer_y +0.5)) - 0.5);
    yshift[1] = yrand * (random(vec2(integer_x+1.0, integer_y+0.5)) -0.5);
    yshift[2] = yrand * (random(vec2(integer_x, integer_y+1.5))-0.5);
    yshift[3] = yrand * (random(vec2(integer_x+1.5, integer_y+1.5))-0.5);
    
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
    
}

vec4 bleed() {
    vec2 tc;
    
    float amplitude = 1.4;
    float frequency = 1.7;
    tc.x = 60.5;//sin(u_time/9173.59) * 0.1;
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
    
    return sum;
}

float noise (in vec2 _st) {
    vec2 i = floor(_st);
    vec2 f = fract(_st);
    
    // Four corners in 2D of a tile
    float a = random(i);
    float b = random(i + vec2(1.0, 0.0));
    float c = random(i + vec2(0.0, 1.0));
    float d = random(i + vec2(1.0, 1.0));
    
    vec2 u = f * f * (3.0 - 2.0 * f);
    
    return mix(a, b, u.x) +
    (c - a)* u.y * (1.0 - u.x) +
    (d - b) * u.x * u.y;
}

float fbm ( in vec2 _st) {
    float v = 0.0;
    float a = 0.5;
    vec2 shift = vec2(100.0);
    for (int i = 0; i < 5; ++i) {
        v += a * noise(_st);
        _st = _st * 2.0 + shift;
        a *= 0.5;
    }
    return v;
}

mat2 rotate2d(float angle){
    return mat2(cos(angle),-sin(angle),
                sin(angle),cos(angle));
}

float lines(in vec2 pos, float b){
    float scale = 10.0;
    pos *= scale;
    return smoothstep(0.0,
                      .5+b*.5,
                      abs((sin(pos.x*3.1415)+b*2.0))*.5);
}

vec4 colorRound(in vec4 c){
    //float r = random(uv);
    
    if (all(lessThanEqual(c.rgb,vec3(0.1)))) {
        return vec4(0.0);
    }
    if ((all(greaterThan(c.rgb,vec3(0.1)))) && (all(lessThanEqual(c.rgb,vec3(0.2))))) {
        return vec4(0.1) ;
    }
    if ((all(greaterThan(c.rgb,vec3(0.2)))) && (all(lessThanEqual(c.rgb,vec3(0.3))))) {
        return vec4(0.2);
    }
    if ((all(greaterThan(c.rgb,vec3(0.3)))) && (all(lessThanEqual(c.rgb,vec3(0.4))))) {
        return vec4(0.4);
    }
    if ((all(greaterThan(c.rgb,vec3(0.4)))) && (all(lessThanEqual(c.rgb,vec3(0.5))))) {
        return vec4(0.5);
    }
    if ((all(greaterThan(c.rgb,vec3(0.5)))) && (all(lessThanEqual(c.rgb,vec3(0.6))))) {
        return vec4(0.6);
    }
    if ((all(greaterThan(c.rgb,vec3(0.6)))) && (all(lessThanEqual(c.rgb,vec3(0.7))))) {
        return vec4(0.7);
    }
    if ((all(greaterThan(c.rgb,vec3(0.8)))) && (all(lessThanEqual(c.rgb,vec3(0.9))))) {
        return vec4(0.8);
    }
    if (any(greaterThan(c.rgb,vec3(0.9)))) {
        return vec4(0.9);
    }
}



void main() {
    vec4 c = texture2D(colorSampler,uv);
    vec2 st = gl_FragCoord.xy/u_resolution.xy*3.;
    vec3 color = vec3(0.1);
    
    vec2 q = vec2(0.);
    q.x = fbm( st + 0.00*u_time);
    q.y = fbm( st + vec2(1.0));
    
    vec2 r = vec2(0.);
    r.x = fbm( st + 1.0*q + vec2(1.7,9.2)+ 0.15 * c.r/ 0.1);
    r.y = fbm( st + 1.0*q + vec2(8.3,2.8)+ 0.126 * c.r/ 0.2);
    
    float f = fbm(st+r);
    //lines
    vec2 pos = st.yx*vec2(10.,3.);
    float pattern = pos.x;
    pos = rotate2d( noise(pos)) * pos * 0.05 * (1.0/c.r) * (1.1 + sin(u_time/13.17) * 0.1);
    pattern = lines(pos,.5);
    //------------------
    color = mix(color,
                vec3(c.rgb),
                clamp(length(r.x),0.0,1.0));
    
    vec4 retVal = vec4(0.5);

    //gl_FragColor = colorRound(vec4((f*f*f+.6*f*f+.5*f)*color,1.));
    //gl_FragColor = vec4((f*f*f+.6*f*f+.5*f)*color,1.);
    if ((all(lessThan(vec3(pattern),vec3(0.1)))) && (all(greaterThan(c.rgb,vec3(0.0))))) {
        retVal = vec4((f*f*f+.6*f*f+.5*f)*color,1.);

    } else {
        retVal = colorRound(vec4((f*f*f+.6*f*f+.5*f)*color,1.));
    }
    pos = rotate2d( noise(pos)) * pos * 0.5 * (c.r) * (1.1 + sin(u_time/83.17) * 0.1);
    pattern = lines(pos,.5);
    //gl_FragColor = mix(retVal,bleed() * 60.0,0.5);
    //gl_FragColor = vec4(noise(uv * 173.176 * random(uv)));
    //gl_FragColor = vec4(0.0);
    //gl_FragColor = vec4(voronoiNoise2D(uv.x/0.05, uv.y/0.01, noise(uv / c.r * 1.3 + sin(floor(u_time/3.51))), 1.1 + cos(u_time/27.73)));
    /*if ((all(greaterThan(c,vec4(0.1))))) {
        gl_FragColor = vec4(voronoiNoise2D(uv.x*(0.1 + sin(floor(u_time/1.51))), uv.y/0.01, noise(uv / c.r * 7.3 + sin(floor(u_time/3.51))), 5.1 + cos(floor(u_time/7.73))));

        if (mod(floor(u_time),3.0) == 0.0) {
            gl_FragColor = vec4(voronoiNoise2D(uv.x/0.2, uv.y/0.1, noise(uv / c.r * 1.3 + sin(u_time/17.51)), 1.1 + cos(u_time/27.73)));
        } else {
            gl_FragColor = vec4(voronoiNoise2D(uv.x/0.05, uv.y/0.01, noise(uv / c.r * 1.3 + sin(u_time/17.51)), 1.1 + cos(u_time/27.73)));
        }
    }*/
    //gl_FragColor = vec4(voronoiNoise2D(uv.x/0.05, uv.y/0.1, noise(uv / c.r * 1.3 + sin(u_time/17.51)), 1.1 + cos(u_time/27.73)));
    gl_FragColor = softBlur(colorSampler, vec2(.005,.005),uv,mix(retVal,bleed() * 60.0,0.5));
    //gl_FragColor = softBlur(colorSampler, vec2(.005,.005),uv,mix(vec4((f*f*f+.6*f*f+.5*f)*color,1.),bleed() * 60.0,0.5));
    //gl_FragColor = vec4(vec3(pattern),1.0);

}
