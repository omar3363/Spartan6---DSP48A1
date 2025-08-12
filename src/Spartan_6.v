module Spartan_6(
    A,B,D,C
    ,CLK,CARRYIN
    ,OPMODE,BCIN,RSTA,RSTB,RSTM,RSTP,RSTC,RSTD,RSTCARRYIN,RSTOPMODE
    ,CEA,CEB,CEM,CEP,CEC,CED,CECARRYIN,CEOPMODE
    ,PCIN
    ,BCOUT,PCOUT,P,M,CARRYOUT,CARRYOUTF
    );
//parameters for A and B inputs that define whether the mux out is reg or not (SELECT LINE OF REG_MUX)
parameter A0REG = 0;
parameter B0REG = 0; //0 refers to no registers
parameter A1REG = 1; //1 refers to registers
parameter B1REG = 1;
//parameters for C,D,M,P,CARRYIN,CARRYOUT,OPMODE that define whether the mux out is reg or not (SELECT LINE OF REG_MUX)
parameter CREG = 1;
parameter DREG = 1;
parameter MREG = 1;
parameter PREG = 1;
parameter CARRYINREG = 1;
parameter CARRYOUTREG = 1;
parameter OPMODEREG = 1;
//CARRYINSEL either the CARRYIN input will be considered or the value of opcode[5] , Values = "CARRYIN" , "OPMODE5"
wire CARRYIN_SEL;
parameter CARRYINSEL = "OPMODE5";

assign CARRYIN_SEL = (CARRYINSEL == "OPMODE5")? 1 : 0;

//B_INPUT defines whether the input to the B port is <B input> (DIRECT) or <cascaded input BCIN> from the previous DSP48A1 (CASCADE)
wire B_SEL;
parameter B_INPUT = "DIRECT";

assign B_SEL = (B_INPUT == "DIRECT")? 1 : 0;

//RSTTYPE selects whether all resets for the DSP48A1 should have a synchronous or asynchronous reset , Values = "ASYNC" , "SYNC"
parameter RSTTYPE = "SYNC";
//inputs
input [17:0] A,B,D,BCIN;
input [7:0] OPMODE;
input [47:0] C,PCIN;

input CARRYIN,CLK;
input CEA,CEB,CEC,CECARRYIN,CED,CEM,CEOPMODE,CEP; //clk enable for the Reg_Mux for each input
input RSTA,RSTB,RSTC,RSTCARRYIN,RSTD,RSTM,RSTOPMODE,RSTP; //rst active high for the Reg_Mux for each input, Sync or Async depending on RSTTYPE
//output
output CARRYOUT,CARRYOUTF;
output [17:0] BCOUT;
output [35:0] M;
output [47:0] PCOUT,P;
//Needed Internal Signals
wire CIN,COUT,Carry_Cascade;
wire [7:0] OPMODE_Mux;
wire [17:0] D_Mux,B_Mux,B0_Mux,A0_Mux,Pre_Add_Mux_Out,B1_Mux,A1_Mux;
reg [17:0] Pre_Add;
wire [35:0] Multi_Value,M_Reg_Mux_Out;
wire [47:0] C_Mux,Concatenation,X_Out,Z_Out,Post_Add;
wire [48:0] Full_Add;
//inputs into Reg_Mux
Mux B_Input (.In0(BCIN),.In1(B),.Sel(B_SEL),.Out(B_Mux));//which will be B_port 

Reg_Mux #(.TYPE(RSTTYPE)) D_Entry (.In(D),.Sel(DREG),.Out(D_Mux),.Clk(CLK),.Rst(RSTD),.Enable(CED));//D input entry
Reg_Mux #(.TYPE(RSTTYPE)) B_Entry (.In(B_Mux),.Sel(B0REG),.Out(B0_Mux),.Clk(CLK),.Rst(RSTB),.Enable(CEB));//B input entry
Reg_Mux #(.TYPE(RSTTYPE)) A_Entry (.In(A),.Sel(A0REG),.Out(A0_Mux),.Clk(CLK),.Rst(RSTA),.Enable(CEA));//A0 input entry
Reg_Mux #(.WIDTH_REG_MUX_IN(48),.WIDTH_REG_MUX_OUT(48),.TYPE(RSTTYPE)) C_Entry (.In(C),.Sel(CREG),.Out(C_Mux),.Clk(CLK),.Rst(RSTC),.Enable(CEC));//C input entry
Reg_Mux #(.WIDTH_REG_MUX_IN(8),.WIDTH_REG_MUX_OUT(8),.TYPE(RSTTYPE)) OPMODE_Entry (.In(OPMODE),.Sel(OPMODEREG),.Out(OPMODE_Mux),.Clk(CLK),.Rst(RSTOPMODE),.Enable(CEOPMODE));
//operations till multiplication
always@(*) begin
    if(OPMODE_Mux[6])
        Pre_Add = D_Mux - B0_Mux;
    else
        Pre_Add = D_Mux + B0_Mux;
end
Mux Pre_Add_Mux (.In0(B0_Mux),.In1(Pre_Add),.Sel(OPMODE_Mux[4]),.Out(Pre_Add_Mux_Out));
//B1,A1 reg
Reg_Mux #(.TYPE(RSTTYPE)) B1_Reg_Mux (.In(Pre_Add_Mux_Out),.Sel(B1REG),.Out(B1_Mux),.Clk(CLK),.Rst(RSTB),.Enable(CEB));
Reg_Mux #(.TYPE(RSTTYPE)) A1_Reg_Mux (.In(A0_Mux),.Sel(A1REG),.Out(A1_Mux),.Clk(CLK),.Rst(RSTA),.Enable(CEA));
assign BCOUT = B1_Mux;
//Multiplication
assign Multi_Value = (B1_Mux * A1_Mux);
Reg_Mux #(.WIDTH_REG_MUX_IN(36), .WIDTH_REG_MUX_OUT(36),.TYPE(RSTTYPE)) M_Reg_Mux (.In(Multi_Value),.Sel(MREG),.Out(M_Reg_Mux_Out),.Clk(CLK),.Rst(RSTM),.Enable(CEM));
assign M = M_Reg_Mux_Out;
//X_MUX , Z_MUX
assign Concatenation = {D_Mux[11:0],A1_Mux[17:0],B1_Mux[17:0]};

Mux_4x1 X (.In0(48'b0),.In1({12'b0,M_Reg_Mux_Out}),.In2(P),.In3(Concatenation),.Sel(OPMODE_Mux[1:0]),.Out(X_Out));

Mux_4x1 Z (.In0(48'b0),.In1(PCIN),.In2(P),.In3(C_Mux),.Sel(OPMODE_Mux[3:2]),.Out(Z_Out));
//pereparing CIN for the 2nd ADD
assign Carry_Cascade = (CARRYIN_SEL)? OPMODE_Mux[5] : CARRYIN;
Reg_Mux #(.TYPE(RSTTYPE),.WIDTH_REG_MUX_IN(1),.WIDTH_REG_MUX_OUT(1)) CYI (.In(Carry_Cascade),.Sel(CARRYINREG),.Out(CIN),.Clk(CLK),.Rst(RSTCARRYIN),.Enable(CECARRYIN));
//second Add
assign Full_Add = (OPMODE_Mux[7])? ({1'b0,Z_Out}-({1'b0,X_Out}+CIN)) : ({1'b0,Z_Out}+{1'b0,X_Out}+CIN);
assign Post_Add = Full_Add [47:0];
assign COUT = Full_Add [48];

Reg_Mux #(.WIDTH_REG_MUX_IN(48),.WIDTH_REG_MUX_OUT(48),.TYPE(RSTTYPE)) P_Reg_Mux (.In(Post_Add),.Sel(PREG),.Out(P),.Clk(CLK),.Rst(RSTP),.Enable(CEP));
assign PCOUT = P;
Reg_Mux #(.TYPE(RSTTYPE),.WIDTH_REG_MUX_IN(1),.WIDTH_REG_MUX_OUT(1)) COUT_Reg_Mux (.In(COUT),.Sel(CARRYOUTREG),.Out(CARRYOUT),.Clk(CLK),.Rst(RSTCARRYIN),.Enable(CECARRYIN));
assign CARRYOUTF = CARRYOUT;

endmodule