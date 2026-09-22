library verilog;
use verilog.vl_types.all;
entity FIR is
    generic(
        Width           : integer := 16;
        Taps            : integer := 31;
        out_Width       : vl_logic_vector(31 downto 0)
    );
    port(
        inp_sig         : in     vl_logic_vector;
        out_sig         : out    vl_logic_vector;
        CLK             : in     vl_logic;
        n_RST           : in     vl_logic
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of Width : constant is 2;
    attribute mti_svvh_generic_type of Taps : constant is 2;
    attribute mti_svvh_generic_type of out_Width : constant is 4;
end FIR;
