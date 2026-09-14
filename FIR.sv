

module FIR #(parameter int N = 16;) (
logic signed [N-1:0] inp_sig, //16 bits (Q8.8)


logic signed [(2*N)+4:0]  out_sig, //36 bits +sign bit

logic CLK, n_RST

);




logic signed [N-1:0] D_wire [N-2:0]; //16bits
logic signed out_sig_reg;

//
//to be edited as input////
//

// Q1.15 coefficients: the integer values sum to 32768 (unity DC gain).

parameter signed Coeff0 = 16'sh0180;
parameter signed Coeff1 = 16'sh0200;
parameter signed Coeff2 = 16'sh0380;
parameter signed Coeff3 = 16'sh0600;
parameter signed Coeff4 = 16'sh0900;
parameter signed Coeff5 = 16'sh0C00;
parameter signed Coeff6 = 16'sh0E80;
parameter signed Coeff7 = 16'sh0F80;
parameter signed Coeff8 = 16'sh0F80;
parameter signed Coeff9 = 16'sh0E80;
parameter signed Coeff10 = 16'sh0C00;
parameter signed Coeff11 = 16'sh0900;
parameter signed Coeff12 = 16'sh0600;
parameter signed Coeff13 = 16'sh0380;
parameter signed Coeff14 = 16'sh0200;
parameter signed Coeff15 = 16'sh0180;

always @(posedge CLK or negedge n_RST) begin

    D_wire[0] = inp_sig;
    for (i=1; i<= N-2; i++) begin
        D_wire[i] = D_wire[i-1];
    end

    out_sig_reg = inp_sig * Coeff0 +
                  D_wire[0] * Coeff1 +
                  D_wire[1] * Coeff2 +
                  D_wire[2] * Coeff3 +
                  D_wire[3] * Coeff4 +
                  D_wire[4] * Coeff5 +
                  D_wire[5] * Coeff6 +
                  D_wire[6] * Coeff7 +
                  D_wire[7] * Coeff8 +
                  D_wire[8] * Coeff9 +
                  D_wire[9] * Coeff10 +
                  D_wire[10] * Coeff11 +
                  D_wire[11] * Coeff12 +
                  D_wire[12] * Coeff13 +
                  D_wire[13] * Coeff14 +
                  D_wire[14] * Coeff15;

    
end



endmodule