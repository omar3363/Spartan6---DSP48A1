module Spartan_6_tb();

//stimuls and response 
reg [17:0] A_tb,B_tb,D_tb,BCIN_tb;
reg [7:0] OPMODE_tb;
reg [47:0] C_tb,PCIN_tb;

reg CARRYIN_tb,CLK_tb;
reg CEA_tb,CEB_tb,CEC_tb,CECARRYIN_tb,CED_tb,CEM_tb,CEOPMODE_tb,CEP_tb;
reg RSTA_tb,RSTB_tb,RSTC_tb,RSTCARRYIN_tb,RSTD_tb,RSTM_tb,RSTOPMODE_tb,RSTP_tb;

wire CARRYOUT_DUT,CARRYOUTF_DUT;
wire [17:0] BCOUT_DUT;
wire [35:0] M_DUT;
wire [47:0] PCOUT_DUT,P_DUT;

reg CARRYOUT_Expected;
reg [17:0] BCOUT_Expected;
reg [35:0] M_Expected;
reg [47:0] P_Expected;

//DUT
Spartan_6 DUT (
    // -- Inputs --
    .A(A_tb),
    .B(B_tb),
    .D(D_tb),
    .C(C_tb),
    .CLK(CLK_tb),
    .CARRYIN(CARRYIN_tb),
    .OPMODE(OPMODE_tb),
    .BCIN(BCIN_tb),
    .PCIN(PCIN_tb),

    // -- Reset Inputs --
    .RSTA(RSTA_tb),
    .RSTB(RSTB_tb),
    .RSTC(RSTC_tb),
    .RSTD(RSTD_tb),
    .RSTM(RSTM_tb),
    .RSTP(RSTP_tb),
    .RSTCARRYIN(RSTCARRYIN_tb),
    .RSTOPMODE(RSTOPMODE_tb),

    // -- Clock Enable Inputs --
    .CEA(CEA_tb),
    .CEB(CEB_tb),
    .CEC(CEC_tb),
    .CED(CED_tb),
    .CEM(CEM_tb),
    .CEP(CEP_tb),
    .CEOPMODE(CEOPMODE_tb),
    .CECARRYIN(CECARRYIN_tb),

    // -- Outputs --
    .BCOUT(BCOUT_DUT),
    .PCOUT(PCOUT_DUT),
    .P(P_DUT),
    .M(M_DUT),
    .CARRYOUT(CARRYOUT_DUT),
    .CARRYOUTF(CARRYOUTF_DUT)
);
//clk generation
initial begin
    CLK_tb = 0;
    forever
        #1 CLK_tb = ~CLK_tb;
end
//start from known states <wait> >> (Randomize - wait - check)for loop
initial begin
//rst check
RSTA_tb = 1;
RSTB_tb = 1;
RSTC_tb = 1;
RSTCARRYIN_tb = 1;
RSTD_tb = 1;
RSTM_tb = 1;
RSTOPMODE_tb = 1;
RSTP_tb = 1;

A_tb = $random;
B_tb = $random;
D_tb = $random;
BCIN_tb = $random;
OPMODE_tb = $random;
C_tb = $random;
PCIN_tb = $random;
CARRYIN_tb = $random;

CEA_tb = $random;
CEB_tb = $random;
CEC_tb = $random;
CECARRYIN_tb = $random;
CED_tb = $random;
CEM_tb = $random;
CEOPMODE_tb = $random;
CEP_tb = $random;

@(negedge CLK_tb);
if(CARRYOUT_DUT != 0 || CARRYOUTF_DUT != 0 || BCOUT_DUT != 0 || M_DUT != 0 || PCOUT_DUT != 0 || P_DUT != 0) begin
    $display ("ERROR In Reset");
    $stop;
end
//Path 1 check
RSTA_tb = 0;
RSTB_tb = 0;
RSTC_tb = 0;
RSTCARRYIN_tb = 0;
RSTD_tb = 0;
RSTM_tb = 0;
RSTOPMODE_tb = 0;
RSTP_tb = 0;

CEA_tb = 1;
CEB_tb = 1;
CEC_tb = 1;
CECARRYIN_tb = 1;
CED_tb = 1;
CEM_tb = 1;
CEOPMODE_tb = 1;
CEP_tb = 1;

OPMODE_tb = 8'b11011101;
A_tb = 20;
B_tb = 10;
C_tb = 350;
D_tb = 25;

BCOUT_Expected = 'hf;
M_Expected = 'h12c;
P_Expected = 'h32;
CARRYOUT_Expected = 0;

repeat(4) @(negedge CLK_tb);
if(BCOUT_DUT != BCOUT_Expected || M_DUT != M_Expected || P_DUT != P_Expected || PCOUT_DUT != P_Expected || CARRYOUT_DUT != CARRYOUT_Expected || CARRYOUTF_DUT != CARRYOUT_Expected) begin
    $display("ERROR In Path 1");
    $stop;
end
//path 2 check
OPMODE_tb = 8'b00010000;
A_tb = 20;
B_tb = 10;
C_tb = 350;
D_tb = 25;

BCOUT_Expected = 'h23;
M_Expected = 'h2bc;
P_Expected = 'h0;
CARRYOUT_Expected = 0;

repeat(3) @(negedge CLK_tb);
if(BCOUT_DUT != BCOUT_Expected || M_DUT != M_Expected || P_DUT != P_Expected || PCOUT_DUT != P_Expected || CARRYOUT_DUT != CARRYOUT_Expected || CARRYOUTF_DUT != CARRYOUT_Expected) begin
    $display("ERROR In Path 2");
    $stop;
end
//path 3 check
OPMODE_tb = 8'b00001010;
A_tb = 20;
B_tb = 10;
C_tb = 350;
D_tb = 25;

BCOUT_Expected = 'ha;
M_Expected = 'hc8;
P_Expected = 'h0;
CARRYOUT_Expected = 0;

repeat(3) @(negedge CLK_tb);
if(BCOUT_DUT != BCOUT_Expected || M_DUT != M_Expected || P_DUT != P_Expected || PCOUT_DUT != P_Expected || CARRYOUT_DUT != CARRYOUT_Expected || CARRYOUTF_DUT != CARRYOUT_Expected) begin
    $display("ERROR In Path 3");
    $stop;
end
//path 4 check
OPMODE_tb = 8'b10100111;
A_tb = 5;
B_tb = 6;
C_tb = 350;
D_tb = 25;
PCIN_tb = 3000;

BCOUT_Expected = 'h6;
M_Expected = 'h1e;
P_Expected = 'hfe6fffec0bb1;
CARRYOUT_Expected = 1;

repeat(3) @(negedge CLK_tb);
if(BCOUT_DUT != BCOUT_Expected || M_DUT != M_Expected || P_DUT != P_Expected || PCOUT_DUT != P_Expected || CARRYOUT_DUT != CARRYOUT_Expected || CARRYOUTF_DUT != CARRYOUT_Expected) begin
    $display("ERROR In Path 4");
    $stop;
end
else 
    $display("DSP Is Working");


$stop;
end

endmodule