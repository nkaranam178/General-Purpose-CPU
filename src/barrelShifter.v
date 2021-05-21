/* 
    CS/ECE 552 Spring '19
    Homework #4, Problem 1
    
    A barrel shifter module.  It is designed to shift a number via rotate
    left, shift left, shift right arithmetic, or shift right logical based
    on the Op() value that is passed in (2 bit number).  It uses these
    shifts to shift the value any number of bits between 0 and 15 bits.
 */
module barrelShifter (In, Cnt, Op, Out);

   // declare constant for size of inputs, outputs (N) and # bits to shift (C)
   parameter   N = 16;
   parameter   C = 4;
   parameter   O = 2;

   input [N-1:0]   In;
   input [C-1:0]   Cnt;
   input [O-1:0]   Op;
   output [N-1:0]  Out;

   /* YOUR CODE HERE */
//Right shift
wire [15:0] shift1,shift2,shift3,res;
assign shift1 = Cnt[0] ? {{~Op[0]&In[15]},In[15:1]} : In[15:0];  	       //Shift by 1 bit
assign shift2 = Cnt[1] ? {{2{~Op[0]&In[15]}},shift1[15:2]} : shift1;           //Shift by 2 bits
assign shift3 = Cnt[2] ? {{4{~Op[0]&In[15]}},shift2[15:4]} : shift2;           //Shift by 4 bits
assign res = Cnt[3] ? {{8{~Op[0]&In[15]}},shift3[15:8]} : shift3;              //Shift by 8 bits
   

//Rotate or shift left
wire [15:0] lshift1,lshift2,lshift3,res2;
assign lshift1 = Cnt[0] ? {{In[14:0]}, Op[0]? 1'b0:In[15]} : In[15:0];                           //Shift by 1 bit 
assign lshift2 = Cnt[1] ? {{lshift1[13:0]}, Op[0]? 2'b0:lshift1[15:14]} : lshift1;            //Shift by 2 bits
assign lshift3 = Cnt[2] ? {{lshift2[11:0]}, Op[0]? 4'b0:lshift2[15:12]} : lshift2;            //Shift by 4 bits
assign res2 = Cnt[3] ? {{lshift3[7:0]}, Op[0]? 8'b0:lshift3[15:8]} : lshift3;                    //Shift by 8 bits


assign Out = Op[1] ? res : res2; //Choose between left and right shift

endmodule
