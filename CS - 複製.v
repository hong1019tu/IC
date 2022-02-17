//`timescale 1ns/10ps
/*
 * IC Contest Computational System (CS)
*/
module CS(Y, X, reset, clk);

input clk, reset; 
input [7:0] X;
output reg [9:0] Y;
reg process;
reg [7:0]data[8:0];
reg [5:0]i;
reg [10:0]sum1,sum2,avg,little,appr,load,count;
always @(posedge clk or posedge reset) begin
    if(reset)begin
        process <= 1'd0;
        i <= 6'd0;
        sum1 <= 11'd0;
        sum2 <= 11'd0;
        avg <= 11'd0;
        little <= 11'd2048;
    end
    else begin
        if (process == 1'd0) begin
            data[i] <= X;
            i <= i + 6'd1;
            sum1 <= sum1 + X;
            sum2 <= sum2 + X;
            if (i == 6'd8) begin
                process <= 1'd1;
            end
        end
        else begin
            if (sum1 > 0) begin
                sum1 <= sum1 - 11'd9;
                avg <= avg + 11'd1;
            end
            else if (avg == data[0] || avg == data[1] || avg == data[2] || avg == data[3] || avg == data[4] || avg == data[5] || avg == data[6] || avg == data[7] || avg == data[8]) begin
                appr <= avg;
            end
            else begin
                if (i != 6'd0) begin
                    i <= i - 6'd1;
                    if (data[i] < avg) begin
                       appr <= (little < (avg - data[i]))?appr:data[i]; 
                    end
                    else begin
                        
                    end
                end
            end
            if (i == -6'd1) begin
                load <= load + 11'd1;
                if(load == 11'd0)begin
                    sum2 <= sum2 + appr*9;
                end
                else begin
                    if (sum2 > 0) begin
                        sum2 <= sum2 - 8;
                        count <= count + 1;
                    end
                    else begin
                        Y <= count;
                    end
                end
            end
        end
    end
end
 
endmodule
