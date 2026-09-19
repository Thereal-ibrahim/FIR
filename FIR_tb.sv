timescale 1ns/1ps


module FIR_tb;

//input logic signed [Width-1:0] inp_sig, //16 bits (Q1.15)
//output logic signed [out_Width-1:0]  out_sig, // 38 bits +sign bit  
//input logic CLK, n_RST

 logic signed [15:0] inp_sig; //16 bits (Q1.15)
 logic signed [37:0] out_sig; //38 bits (Q1.37)
 logic CLK, n_RST;

FIR dut (
    .inp_sig(inp_sig),
    .out_sig(out_sig),
    .CLK(CLK),
    .n_RST(n_RST)
)



// Clock generation
//10ns (100MHz) clock period, 50% duty cycle

initial begin
    CLK = 0;
    #5; 
    forever #5 CLK = ~CLK;
  end



//rst task
task rst();
begin
    n_RST = 0;
    #30;
    n_RST = 1;
end
endtask



integer fd, status;

initial begin 
    inp_sig = 0;
    rst();

    fd = $fopen("input.txt", "r"); // Open the input file for reading ("r")
    if (fd == 0) begin
        $display("Error: Can't find file");
        $finish;
    end // if file cannot be opened, display an error message and terminate the simulation


    #100;

    for (int i = 0; i<1000; i++) begin
        status = $fscanf(fd, "%d\n", inp_sig); // Read a signed decimal number from the file and store it in inp_sig
        if (status == 1) begin
            inp_sig = sample[15:0]; 
        end 
        else begin
            $display("Error: Failed to read input from file at sample %0d", i);
            break;
        end
    end

    $fclose(fd); // Close the input file
    $stop; // Stop the simulation after reading all samples
end


    


endmodule