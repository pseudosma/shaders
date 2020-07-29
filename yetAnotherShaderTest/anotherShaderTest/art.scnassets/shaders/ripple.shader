float Amplitude = 0.1;

_geometry.position.xyz += _geometry.normal * (Amplitude*_geometry.position.y*_geometry.position.x) * sin(1.0 * u_time);
