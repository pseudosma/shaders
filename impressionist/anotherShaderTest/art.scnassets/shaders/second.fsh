uniform sampler2D depth;
uniform sampler2D colorSampler;
uniform float u_time;

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

float random (in vec2 _st) {
    return fract(sin(dot(_st.xy,
                         vec2(12.9898,78.233)))*
                 43758.5453123);
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

vec3 monetBlur(in sampler2D t1, in vec4 c, in vec2 v) {
    vec3 W = vec3(0.2125, 0.7154, 0.0721);
    float dx = 1./720.;
    float dy = 1./720.;
    
    float tempLumi;
    float minLumi = -1.0;
    float Quantize = 10.;
    vec3 color;
    
    //Go through all the the random selected pixels in a 5x5 patch to find the hightest
    
    vec3 sample0 = texture2D(t1, vec2(v.x - dx, v.y + dy)).rgb;
    tempLumi = dot(sample0, W);
    if(tempLumi > minLumi){
        minLumi = tempLumi;
        color = sample0;
    }
    
    vec3 sample1 = c.rgb;
    tempLumi = dot(sample1, W);
    if(tempLumi > minLumi){
        minLumi = tempLumi;
        color = sample1;
    }
    
    vec3 sample2 = texture2D(t1, vec2(v.x - dx, v.y - dy)).rgb;
    tempLumi = dot(sample2, W);
    if(tempLumi > minLumi){
        minLumi = tempLumi;
        color = sample2;
    }
    
    vec3 sample4 = texture2D(t1, vec2(v.x, v.y)).rgb;
    tempLumi = dot(sample4, W);
    if(tempLumi > minLumi){
        minLumi = tempLumi;
        color = sample4;
    }
    
    vec3 sample6 = c.rgb;
    tempLumi = dot(sample6, W);
    if(tempLumi > minLumi){
        minLumi = tempLumi;
        color = sample6;
    }
    
    vec3 sample7 = c.rgb;
    tempLumi = dot(sample7, W);
    if(tempLumi > minLumi){
        minLumi = tempLumi;
        color = sample7;
    }
    
    vec3 sample9 = texture2D(t1, vec2(v.x + 2.*dx, v.y)).rgb;
    tempLumi = dot(sample9, W);
    if(tempLumi > minLumi){
        minLumi = tempLumi;
        color = sample9;
    }
    
    vec3 sample10 = texture2D(t1, vec2(v.x - 2.* dx, v.y)).rgb;
    tempLumi = dot(sample10, W);
    if(tempLumi > minLumi){
        minLumi = tempLumi;
        color = sample10;
    }
    
    vec3 sample11 = c.rgb;
    tempLumi = dot(sample11, W);
    if(tempLumi > minLumi){
        minLumi = tempLumi;
        color = sample11;
    }
    
    vec3 sample12 = texture2D(t1, vec2(v.x, v.y + 2.* dy)).rgb;
    tempLumi = dot(sample12, W);
    if(tempLumi > minLumi){
        minLumi = tempLumi;
        color = sample12;
    }
    
    vec3 sample13 = texture2D(t1, vec2(v.x + 2.*dx, v.y + 2.* dy)).rgb;
    tempLumi = dot(sample13, W);
    if(tempLumi > minLumi){
        minLumi = tempLumi;
        color = sample13;
    }
    
    vec3 sample14 = c.rgb;
    tempLumi = dot(sample14, W);
    if(tempLumi > minLumi){
        minLumi = tempLumi;
        color = sample14;
    }
    
    vec3 sample15 = c.rgb;
    tempLumi = dot(sample15, W);
    if(tempLumi > minLumi){
        minLumi = tempLumi;
        color = sample15;
    }
    
    vec3 sample16 = texture2D(t1, vec2(v.x- 2.*dx, v.y + dy)).rgb;
    tempLumi = dot(sample16, W);
    if(tempLumi > minLumi){
        minLumi = tempLumi;
        color = sample16;
    }
    
    color = floor(color * 10.0) * 0.1;
    return color;
}

void main() {
    vec4 bottomLeftIntensity = texture2D(colorSampler, bottomLeftTextureCoordinate);
    vec4 topRightIntensity = texture2D(colorSampler, topRightTextureCoordinate);
    vec4 topLeftIntensity = texture2D(colorSampler, topLeftTextureCoordinate);
    vec4 bottomRightIntensity = texture2D(colorSampler, bottomRightTextureCoordinate);
    vec4 leftIntensity = texture2D(colorSampler, leftTextureCoordinate);
    vec4 rightIntensity = texture2D(colorSampler, rightTextureCoordinate);
    vec4 bottomIntensity = texture2D(colorSampler, bottomTextureCoordinate);
    vec4 topIntensity = texture2D(colorSampler, topTextureCoordinate);
    float h = -topLeftIntensity.b - 7.0 * topIntensity.b - topRightIntensity.b + bottomLeftIntensity.b + 7.0 * bottomIntensity.b + bottomRightIntensity.b;
    float v = -bottomLeftIntensity.b - 7.0 * leftIntensity.b - topLeftIntensity.b + bottomRightIntensity.b + 7.0 * rightIntensity.b + topRightIntensity.b;
    
    float mag = (length(vec2(h, v)));
    vec4 c = vec4(texture2D(colorSampler, uv));
    vec4 t = vec4(0.0);
    //gl_FragColor = c;
    //gl_FragColor = mix(vec4(vec3(mag), 1.0),vec4(vec3(mag2), 1.0),0.1);
    gl_FragColor = vec4(clamp(vec3(mag), vec3(0.0), vec3(0.5)), 1.0);
    
    if ((all(lessThanEqual(vec3(mag),vec3(0.1))))) {
        gl_FragColor = texture2D(colorSampler, uv);
    } else if ((all(greaterThan(vec3(mag),vec3(0.1)))) &&  (all(lessThan(vec3(mag),vec3(0.3))))){
        gl_FragColor = mix(vec4(monetBlur(colorSampler, -(vec4(vec3(mag / noise(uv)), 1.0)), uv), 1.0), texture2D(colorSampler,uv),0.1);
    } else {
        gl_FragColor = mix(vec4(monetBlur(colorSampler, -(vec4(vec3(mag), 1.0)), uv), 1.0), texture2D(colorSampler,uv),0.1);
    }
    
    
    //gl_FragColor = mix(c, vec4(noise(uv / 0.1 / c.r)), 0.5);
    //gl_FragColor = mix((vec4(vec3(mag), 1.0)), texture2D(colorSampler, uv), 0.5);

    //gl_FragColor = mix(vec4(monetBlur(colorSampler, -(vec4(vec3(mag), 1.0)), uv), 1.0), c, 0.5);
    
    
    //gl_FragColor = mix(mix(vec4(monetBlur(colorSampler, -(vec4(vec3(mag), 1.0)), uv), 1.0), c,0.5), mix(c, -vec4(noise(uv / c.r)), 0.5),0.5);
    /*if ((all(greaterThan(c,vec4(0.3))))) {
        t = vec4(voronoiNoise2D(uv.x/ 0.03, uv.y/0.02, noise(uv / c.r * 7.3 + sin(floor(u_time/0.2))), random(uv * 5.1 + cos(floor(u_time/0.3)))));
    }
    if ((all(greaterThan(t,vec4(0.9))))) {
        gl_FragColor += vec4(clamp(vec3(mag), vec3(0.0), vec3(0.1)), 1.0);
    }*/
}
