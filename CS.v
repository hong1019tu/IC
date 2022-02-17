//`timescale 1ns/10ps
/*
 * IC Contest Computational System (CS)
*/
module CS(Y, X, reset, clk);

input clk, reset; 
input [7:0] X;
output reg [9:0] Y;
reg first;
reg [7:0]data[8:0];
reg [5:0]i;
reg [10:0]avg,appr,little,sum,ans;
always @(posedge clk or posedge reset) begin
    if(reset)begin
        first <= 1'd0;
        i <= 6'd0;
    end
    else begin
        if(first == 0)begin
            data[i] <= X;
            i <= i + 6'd1;
            if (i == 6'd8) begin
                first <= 1'd1;
            end
    end
    else begin
        //Y <= ans;
        data[0] <= data[1];
        data[1] <= data[2];
        data[2] <= data[3];
        data[3] <= data[4];
        data[4] <= data[5];
        data[5] <= data[6];
        data[6] <= data[7];
        data[7] <= data[8];
        data[8] <= X;
    end
end
end

always@(*)begin
    if(reset)begin
        little = 11'd2047;
    end
    else if(first == 1)begin
        sum = data[0] + data[1] + data[2] + data[3] + data[4] + data[5] + data[6] + data[7] + data[8];
        avg = sum/9;
        if (avg == data[0] || avg == data[1] || avg == data[2] || avg == data[3] || avg == data[4] || avg == data[5] || avg == data[6] || avg == data[7] || avg == data[8]) begin
            appr = avg;
        end
        else begin
            for (i = 0;i < 9 ;i = i + 1 ) begin
                if(avg - data[i] < little)begin
                    little = avg - data[i];
                    appr = data[i];
                end
            end   
        end
        ans = (sum + appr * 9)/8;
        little = 11'd2047;
    end
end

always@(negedge clk)begin
    Y <= ans;
end

endmodule