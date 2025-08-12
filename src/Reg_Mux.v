module Reg_Mux(In,Sel,Out,Clk,Rst,Enable);

parameter WIDTH_REG_MUX_IN = 18;
parameter WIDTH_REG_MUX_OUT=18;
parameter TYPE = "SYNC";

input [WIDTH_REG_MUX_IN-1:0] In;
input Sel,Rst,Clk,Enable;

output [WIDTH_REG_MUX_OUT-1:0] Out;

reg [WIDTH_REG_MUX_IN-1:0] In_reg;
//Async or Sync Rst
generate 
    if (TYPE == "SYNC") begin
        always @(posedge Clk) begin 
            if(Rst)
                In_reg <= 0;
            else begin
                if(Enable)
                    In_reg <= In;
            end
        end
    end
    else begin
        always @(posedge Clk or posedge Rst) begin
            if(Rst)
                In_reg <= 0;
            else begin
                if(Enable)
                    In_reg <= In;
            end
        end
    end
endgenerate
    
assign Out = (Sel)? In_reg : In;

endmodule