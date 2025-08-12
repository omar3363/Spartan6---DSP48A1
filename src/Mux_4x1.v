module Mux_4x1(In0,In1,In2,In3,Sel,Out);

input [47:0] In0,In1,In2,In3;
input [1:0] Sel;

output wire [47:0] Out;

assign Out = (Sel == 2'b00) ? In0 :
             (Sel == 2'b01) ? In1 :
             (Sel == 2'b10) ? In2 :
             (Sel == 2'b11) ? In3 :
             In0; // Default case

endmodule