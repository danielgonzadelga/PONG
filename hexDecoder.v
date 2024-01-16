module hex_decoder(c,display);

  input [3:0]c;
  output reg [6:0]display;


  always @(*)
  begin
    if(c == 4'b0000)
    begin
      display = 7'b1000000;
    end

    else if(c == 4'b0001)
    begin
      display = 7'b1111001;
    end

    else if(c == 4'b0010)
    begin
      display = 7'b0100100;
    end

    else if(c == 4'b0011)
    begin
      display = 7'b0110000;
    end

    else if(c == 4'b0100)
    begin
      display = 7'b0011001;
    end
    else if(c == 4'b0101)
    begin
      display = 7'b0010010;
    end

    else if(c == 4'b0110)
    begin
      display = 7'b0000010;
    end

    else if(c == 4'b0111)
    begin
      display = 7'b1111000;
    end

    else if(c == 4'b1000)
    begin
      display = 7'b0000000;
    end

    else if(c == 4'b1001)
    begin
      display = 7'b0011000;
    end

    else if(c == 4'b1010)
    begin
      display = 7'b0001000;
    end

    else if(c == 4'b1011)
    begin
      display = 7'b0000011;
    end

    else if(c == 4'b1100)
    begin
      display = 7'b1000110;
    end

    else if(c == 4'b1101)
    begin
      display = 7'b0100001;
    end

    else if(c == 4'b1110)
    begin
      display = 7'b0000110;
    end

    else if(c == 4'b1111)
    begin
      display = 7'b0001110;
    end
  end
endmodule