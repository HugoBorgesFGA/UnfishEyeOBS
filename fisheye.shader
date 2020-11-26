uniform int center_x_percent = 50;
uniform int center_y_percent = 50;
uniform float power = 1.75;

/*
   Adapted from: https://github.com/exeldro/obs-lua/fisheye.shader
   
   Slightly changed the code to run with "OBS ShaderFilter Plus" plugin.
   OBS ShaderFilter Plus supports both: Windows and Linux.
*/

float4 render(float2 uv) {
    float2 center_pos = float2(center_x_percent * .01, center_y_percent * .01);
    float b = 0.0;
    if (power > 0.0){
        b = sqrt(dot(center_pos, center_pos));
    }else {
        if (uv.x < uv.y){
            b = center_pos.x;
        }else{
            b = center_pos.y;
        }
    }
    float2 uvFinal;
    if (power > 0.0)
        uvFinal = center_pos  + normalize(uv - center_pos) * tan(distance(center_pos, uv) * power) * b / tan( b * power);
    else if (power < 0.0)
        uvFinal = center_pos  + normalize(uv - center_pos) * atan(distance(center_pos, uv) * -power * 10.0) * b / atan(-power * b * 10.0);
    else 
        uvFinal = uv;
    return image.Sample(builtin_texture_sampler, uvFinal);
}
