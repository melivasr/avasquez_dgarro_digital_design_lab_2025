function automatic [3:0] sat_inc_0to8(input [3:0] v);
    if (v < 4'd8) sat_inc_0to8 = v + 4'd1;
    else          sat_inc_0to8 = 4'd8;
endfunction
