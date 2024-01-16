module milf_Destructor(iClock,iDraw,oPlot,oX,oY,oColour,select);
  input iClock,iDraw;
  input [2:0] select;
  output oPlot;
  output reg [8:0] oX;
  output reg [7:0] oY;
  output reg [2:0] oColour;
  wire [2:0] colour;
  
  reg [16:0] memory_address;
  
  always@(*)memory_address=320*oY+oX;
  
  controller PP(iClock, colour, select, memory_address);
  
  always@(posedge iClock)begin
		if(iDraw)begin
			if(oX=='d319 && oY == 'd239)begin
				oX<='d0;
				oY<='d0;
			end else if (oX=='d319)begin
				oY<=oY+'d1;
				oX<='d0;
			end else oX<=oX+'d1;
		end
		oColour <=colour;
	end

	assign oPlot = iDraw;
  
endmodule

module controller (
	input clock,
	output reg [2:0] oColour,
	input [2:0] select, 
	input [16:0] memory_address
);

	wire [2:0] oColourB, oColourR, oColourP, oRP1, oRP2;

	blue blue_instance(.address(memory_address), .clock(clock), .q(oColourB));
	red red_instance(.address(memory_address), .clock(clock), .q(oColourR));
	pong pong_instance(.address(memory_address), .clock(clock), .q(oColourP));
	p1 p1_instance(.address(memory_address), .clock(clock), .q(oRP1));
	p2 p2_instance(.address(memory_address), .clock(clock), .q(oRP2));

	always @(*) begin
		case(select)
			'd0: oColour = oColourP;
			'd1: oColour = oColourR;
			'd2: oColour = oColourB;
			'd3: oColour = oRP1;
			'd4: oColour = oRP2;
			default oColour = 'b000;
		endcase
	end

endmodule
				
	
	