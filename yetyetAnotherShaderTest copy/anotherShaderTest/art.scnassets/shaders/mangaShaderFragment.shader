if (shadingScheme == 1) {
    float frequency = 30;
    vec2 st2 = mat2(0.707, -0.707, 0.707, 0.707) * gl_FragCoord.xy;
    vec2 nearest = 2.0*fract(frequency * st2) - 1.0;
    float dist = length(nearest / 1.5);
    float radius = 0.5;
    vec3 white = vec3(1.0, 1.0, 1.0);
    vec3 black = vec3(0.0, 0.0, 0.0);
    vec3 fragcolor = mix(black, white, step(radius, dist));
    if (all(lessThan(_lightingContribution.diffuse, vec3(0.1,0.1,0.1)))) {
        _output.color = vec4(fragcolor, 1.0);
    }
} else if (shadingScheme == 2) {
    _output.color = vec4(1,1,1,1);
    if (any(lessThan(_lightingContribution.diffuse, vec3(0.1,0.1,0.1)))) {
        float r = floor((sin(1.0 * gl_FragCoord.y)) + (sin(1.0 * gl_FragCoord.y) / 2.0) + (sin(1.0 * gl_FragCoord.y) / 3.0));

        if (mod((gl_FragCoord.x ) + gl_FragCoord.y, 7.0) == 0.0)
        {
            _output.color = vec4(0.0, 0.0, 0.0, 1.0);
        }
        
        if (mod(gl_FragCoord.x + gl_FragCoord.y - 3, 11.0) == 0.0)
        {
            _output.color = vec4(0.0, 0.0, 0.0, 1.0);
        }
    }
} else if(shadingScheme == 3) {
    _output.color = vec4(1,1,1,1);
    float frequency = 30;
    vec2 st2 = mat2(0.707, -0.707, 0.707, 0.707) * gl_FragCoord.xy;
    vec2 nearest = 2.0*fract(frequency * st2) - 1.0;
    float dist = length(nearest / 1.5);
    float radius = 0.5;
    vec3 white = vec3(0.5, 0.5, 0.5);
    vec3 black = vec3(0.0, 0.0, 0.0);
    vec3 fragcolor = mix(black, white, step(radius, dist));
    if (mod(gl_FragCoord.x + gl_FragCoord.y - 5.0, 10.0) == 0.0)
    {
        _output.color = vec4(0.0, 0.0, 0.0, 1.0);
    }
    if (mod(gl_FragCoord.x + gl_FragCoord.y, 10.0) == 0.0)
    {
        _output.color = vec4(0.0, 0.0, 0.0, 1.0);
    }
    if (mod(gl_FragCoord.x - gl_FragCoord.y, 10.0) == 0.0)
    {
        _output.color = vec4(0.0, 0.0, 0.0, 1.0);
    }
    if (mod(gl_FragCoord.x - gl_FragCoord.y - 5.0, 10.0) == 0.0)
    {
        _output.color = vec4(0.0, 0.0, 0.0, 1.0);
    }
    if (all(lessThan(_lightingContribution.diffuse, vec3(0.1,0.1,0.1)))) {
        _output.color = vec4(fragcolor, 1.0);
    }
} else if (shadingScheme == 5) {
    _output.color = vec4(1,1,1,1);
    if (all(lessThan(_lightingContribution.diffuse, vec3(0.7,0.7,0.7)))) {
        if (mod(gl_FragCoord.x + gl_FragCoord.y - 5.0, 10.0) == 0.0)
        {
            _output.color = vec4(0.0, 0.0, 0.0, 1.0);
        }
        if (mod(gl_FragCoord.x + gl_FragCoord.y, 10.0) == 0.0)
        {
            _output.color = vec4(0.0, 0.0, 0.0, 1.0);
        }
    }
    if (all(lessThan(_lightingContribution.diffuse, vec3(0.1,0.1,0.1)))) {
        if (mod(gl_FragCoord.x - gl_FragCoord.y, 10.0) == 0.0)
        {
            _output.color = vec4(0.0, 0.0, 0.0, 1.0);
        }
        if (mod(gl_FragCoord.x - gl_FragCoord.y - 5.0, 10.0) == 0.0)
        {
            _output.color = vec4(0.0, 0.0, 0.0, 1.0);
        }
    }
} else if (shadingScheme == 6) {
    if (all(lessThan(_lightingContribution.diffuse, vec3(0.7,0.7,0.7)))) {
        _output.color = vec4(1,1,1,1);
        if (mod(gl_FragCoord.x + gl_FragCoord.y - 5.0, 10.0) == 0.0)
        {
            _output.color = vec4(0.0, 0.0, 0.0, 1.0);
        }
        if (mod(gl_FragCoord.x + gl_FragCoord.y, 10.0) == 0.0)
        {
            _output.color = vec4(0.0, 0.0, 0.0, 1.0);
        }
    }
    if (all(lessThan(_lightingContribution.diffuse, vec3(0.1,0.1,0.1)))) {
        float frequency = 30;
        vec2 st2 = mat2(0.707, -0.707, 0.707, 0.707) * gl_FragCoord.xy;
        vec2 nearest = 2.0*fract(frequency * st2) - 1.0;
        float dist = length(nearest / 1.5);
        float radius = 0.5;
        vec3 white = vec3(1.0, 1.0, 1.0);
        vec3 black = vec3(0.0, 0.0, 0.0);
        vec3 fragcolor = mix(black, white, step(radius, dist));
        _output.color = vec4(fragcolor, 1.0);
        
    }

}
