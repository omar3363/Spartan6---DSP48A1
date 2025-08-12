module Mux(In0,In1,Sel,Out);

parameter WIDTH_MUX_IN0 = 18;
parameter WIDTH_MUX_IN1 = 18;
parameter WIDTH_MUX_OUT = 18;

input [WIDTH_MUX_IN0-1:0] In0;
input [WIDTH_MUX_IN1-1:0] In1;
input Sel;

output [WIDTH_MUX_OUT-1:0] Out;

assign Out = (Sel)? In1 : In0;

endmodule