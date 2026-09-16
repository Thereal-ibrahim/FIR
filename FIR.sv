

module FIR #(parameter int Width = 16, parameter int Taps = 31 ) // 
 (
input logic signed [Width-1:0] inp_sig, //16 bits (Q8.8)

output logic signed [(2*Width)+ $clog2(Taps)+1:0]  out_sig, // 37 bits +sign bit

input logic CLK, n_RST

);




logic signed [Width-1:0] D_wire [Taps-2:0]; //16bits each, 30 elements (Taps-1), 
logic signed [(2*Width)+$clog2(Taps)+1:0] out_sig_reg;


// Q1.15 coefficients supplied for the 31-tap filter.
parameter logic signed [Width-1:0] Coeff [0:Taps-1] = '{ //[0:Taps-1] to start with the first element of the array at index 0
    16'sd41,    -16'sd23,   -16'sd11,    16'sd81,
   -16'sd192,   16'sd323,  -16'sd416,   16'sd389,
   -16'sd155,  -16'sd345,  16'sd1117, -16'sd2091,
   16'sd3132, -16'sd4063,  16'sd4709, 16'sd27780,
   16'sd4709, -16'sd4063,  16'sd3132, -16'sd2091,
   16'sd1117,  -16'sd345,  -16'sd155,   16'sd389,
   -16'sd416,   16'sd323,  -16'sd192,    16'sd81,
   -16'sd11,    -16'sd23,    16'sd41
};

always @(posedge CLK or negedge n_RST) begin
    if (!n_RST) begin
        for (int i=0; i<= Taps-2; i++) begin
            D_wire[i] <= 0;
        end
        out_sig_reg <= 0;
    end
    else begin
    D_wire[0] <= inp_sig;
    for (int i=1; i<= Taps-2; i++) begin
        D_wire[i] <= D_wire[i-1];
    end

    out_sig_reg <= inp_sig * Coeff[0];
    for (int i = 1; i < Taps; i++) begin
        out_sig_reg <= out_sig_reg + D_wire[i-1] * Coeff[i];
    end




    
end


assign out_sig = out_sig_reg;


endmodule