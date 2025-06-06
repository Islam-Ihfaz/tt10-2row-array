/*
 * Copyright (c) 2024 Your Name
 * SPDX-License-Identifier: Apache-2.0
 */

`default_nettype none

module tt_um_islam_ihfaz_2row_array (
    input  wire [7:0] ui_in,    // Dedicated inputs
    output wire [7:0] uo_out,   // Dedicated outputs
    input  wire [7:0] uio_in,   // IOs: Input path
    output wire [7:0] uio_out,  // IOs: Output path
    output wire [7:0] uio_oe,   // IOs: Enable path (active high: 0=input, 1=output)
    input  wire       ena,      // always 1 when the design is powered, so you can ignore it
    input  wire       clk,      // clock
    input  wire       rst_n     // reset_n - low to reset
);

    wire X = ui_in[0];
    wire A = ui_in[4:1];
    wire B = ui_in[7:5], uio_in[0];
    wire C = uio_in[4:1];
    wire P = uio_in[6:5];

    // Assign outputs
    assign uo_out[0] = F;
    assign uo_out[1] = F;
    assign uo_out[2] = S;
    assign uo_out[3] = S;
    assign uo_out[4] = S;
    assign uo_out[5] = S;
    assign uo_out[6] = S;
    assign uo_out[7] = 1'b0;

  // All output pins must be assigned. If not used, assign to 0.
  // assign uo_out  = ui_in + uio_in;  // Example: ou_out is the sum of ui_in and uio_in
  assign uio_out = 0;
  assign uio_oe  = 0;

  // List all unused inputs to prevent warnings
    wire _unused = &{ena, clk, rst_n, uio_in[7]};

// Arithmetic Cell
module ac
(
input wire A, B, C, X, F, C1,
output wire S, D, E, C0
);
assign S = ((A ^ (B ^ X) ^ C1) & F) | (A & ~F);
assign C0 = ((B ^ X) & (A | C1)) | (A & C1);
assign D = C & (B | F);
assign E = B | (C & F);
endmodule

// Control Cell
module cc
(
input wire X, P, C0,
output wire F
);
assign F = (C0 & X) | (P & ~X);
endmodule

module gpca
(
input wire X,
input wire [1:5] P,
input wire [1:7] B, C,
input wire [1:10] A,
output wire [1:5] F,
output wire [1:11] S
);
wire [1:7] FI;
wire [1:3] C1;
wire [1:5] C2;
wire [1:7] C3;
wire [1:9] C4;

wire [1:11] C5;
wire [1:3] S1;
wire [1:5] S2;
wire [1:7] S3;
wire [1:9] S4;
wire [1:11] S5;
wire [1:3] D1;
wire [1:5] D2;
wire [1:7] D3;
wire [1:9] D4;
wire [1:11] D5;
wire [1:3] E1;
wire [1:5] E2;
wire [1:7] E3;
wire [1:9] E4;
wire [1:11] E5;

assign F[1] = C1[1];
assign F[2] = C2[1];
assign F[3] = C3[1];
assign F[4] = C4[1];
assign F[5] = C5[1];
//
assign S = S5;

//control cells (X,P,C0 / F)
cc cc1(X, P[1], C1[1], FI[1]);
cc cc2(X, P[2], C2[1], FI[2]);
cc cc3(X, P[3], C3[1], FI[3]);
cc cc4(X, P[4], C4[1], FI[4]);
cc cc5(X, P[5], C5[1], FI[5]);
cc cc6(X, P[6], C6[1], FI[6]);
cc cc7(X, P[7], C7[1], FI[7]);

// arithmetic cells of row 1(A,B,C,X,F,C1/S,D,E,C0)
ac ac11(.A(1'b0), .B(B[1]),.C(C[1]),.X(X),.F(FI[1]),.C1(C1[2]),
.S(S1[1]), .D(D1[1]), .E(E1[1]),.C0(C1[1]));
ac ac12(.A(A[1]), .B(B[2]),.C(C[2]),.X(X),.F(FI[1]),.C1(C1[3]),
.S(S1[2]), .D(D1[2]), .E(E1[2]),.C0(C1[2]));
ac ac13(.A(A[2]),
.B(B[3]),.C(C[3]),.X(X),.F(FI[1]),.C1(X),.S(S1[3]), .D(D1[3]),
.E(E1[3]),.C0(C1[3]));

// arithmetic cells of row 2(A,B,C,X,F,C1/S,D,E,C0)
ac ac21(.A(S1[1]), .B(1'b0),.C(1'b0),.X(X),.F(FI[2]), .C1(C2[2]),
.S(S2[1]), .D(D2[1]), .E(E2[1]),.C0(C2[1]));
ac ac22(.A(S1[2]), .B(D1[1]), .C(E1[1]), .X(X),.F(FI[2]),
.C1(C2[3]), .S(S2[2]), .D(D2[2]), .E(E2[2]),.C0(C2[2]));
ac ac23(.A(S1[3]), .B(D1[2]), .C(E1[2]), .X(X),.F(FI[2]),
.C1(C2[4]), .S(S2[3]), .D(D2[3]), .E(E2[3]),.C0(C2[3]));
ac ac24(.A(A[3]), .B(D1[3]), .C(E1[3]),
.X(X),.F(FI[2]),.C1(C2[5]), .S(S2[4]), .D(D2[4]),
.E(E2[4]),.C0(C2[4]));
ac ac25(.A(A[4]),
.B(B[4]),.C(C[4]),.X(X),.F(FI[2]),.C1(X),.S(S2[5]), .D(D2[5]),
.E(E2[5]),.C0(C2[5]));
    
endmodule
