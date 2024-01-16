module DrawRec(iClock,iDraw,iX,iY,iColour,iXs,iYs,oDone,oPlot,oX,oY,oColour);
  input iClock,iDraw;
  input [8:0] iX,iXs;
  input [7:0] iY,iYs;
  input [2:0] iColour;
  output reg oDone;
  output oPlot;
  output reg [8:0] oX;
  output reg [7:0] oY;
  output reg [2:0] oColour;

  reg [8:0] XsC;
  reg [7:0] YsC;
  reg [2:0] CS,NS;

  always@(posedge iClock)begin
    case(CS)
    'b0:begin
      if(!YsC & !XsC & iDraw)oDone<='b1;
      else if(iDraw)begin
          if(!XsC)begin
            YsC<=YsC-'b1;
            oY<=oY+'b1;
            XsC<=iXs-'b1;
            oX<=iX;
          end else begin
            oX<=oX+'b1;
            XsC<=XsC-'b1;
          end
      end else begin
        oDone='b0;
        NS='b1;
      end
    end
    'b1:begin
      if(iDraw)begin
        oDone<='b0;
        oX<=iX;
        oY<=iY;
        XsC<=iXs-'b1;
        YsC<=iYs-'b1;
        oColour<=iColour;
        NS<='b0;
      end
    end
    default: begin
      NS='b1;
      oDone='b0;
    end
    endcase
  end

  always@(*)CS=NS;

  assign oPlot = iDraw;
endmodule

module oVGA(iClock, iYp1, iYp2, iXb, iYb, oX, oY, oColour, oPlot, oDone, iStart);
	input iClock, iStart;
	input [7:0] iYp1, iYp2, iYb;
	input [8:0] iXb;
	
	output  [8:0] oX;
	output  [7:0] oY;
	output [2:0] oColour;
	output reg  oDone;
	output oPlot;
	
	reg [5:0] CS,NS;
	reg Draw,start_F;
	reg [2:0]  Colour;
	wire Done;
	reg [8:0] X,Xs;
	reg [7:0] Y,Ys;
	
	DrawRec D1(iClock,Draw,X,Y,Colour,Xs,Ys,Done,oPlot,oX,oY,oColour);
	
	localparam 
		IDLE = 6'd0,
		CLEAR_P1 = 6'd1,
		WAIT_CP1 = 6'd2,
		DRAW_P1 = 6'd7,
		WAIT_DP1 = 6'd8,
		DRAW_P2 = 6'd9,
		WAIT_DP2 = 6'd10,
		DRAW_BT = 6'd11,
		WAIT_BT = 6'd12,
		DRAW_BM = 6'd13,
		WAIT_BM = 6'd14,
		DRAW_BB = 6'd15,
		DONE =6'd16;
		
		always@(*)begin
			case(CS)
			IDLE: if(iStart) NS = CLEAR_P1; else NS = IDLE;
			CLEAR_P1: if (Done) NS = WAIT_CP1; else NS = CLEAR_P1;
			WAIT_CP1: NS=DRAW_P1;
			DRAW_P1: if(Done) NS=WAIT_DP1; else NS=DRAW_P1;
			WAIT_DP1: NS=DRAW_P2;
			DRAW_P2: if(Done) NS=WAIT_DP2; else NS=DRAW_P2;
			WAIT_DP2: NS=DRAW_BT;
			DRAW_BT:if(Done) NS = WAIT_BT; else NS =DRAW_BT;
			WAIT_BT: NS=DRAW_BM;
			DRAW_BM:if(Done) NS=WAIT_BM; else NS=DRAW_BM;
			WAIT_BM:NS=DRAW_BB;
			DRAW_BB:if(Done)NS=DONE; else NS = DRAW_BB;
			DONE: NS= IDLE;
			default NS = IDLE;
			endcase
		end
		
		always@(*)begin
			Draw='b0;
			Colour='b000;
			X='b0;
			Y='b0;
			Xs='b0;
			Ys='b0;
			oDone='b0;
			
			case(CS)
				CLEAR_P1: begin
					Draw='b1;
					X='d0;
					Xs='d329;
					Ys='d240;
				end
				DRAW_P1:begin
					Draw='b1;
					X='d1;
					Y=iYp1;
					Xs='d5;
					Ys='d60;
					Colour='b100;
				end
				DRAW_P2: begin
					Draw='b1;
					X='d314;
					Xs='d5;
					Y=iYp2;
					Ys='d60;
					Colour='b001;
				end
				DRAW_BT:begin
					Draw='b1;
					X=iXb+'d1;
					Xs='d4;
					Y=iYb;
					Ys='d1;
					Colour='b111;
				end
				DRAW_BM:begin
					Draw='b1;
					X=iXb;
					Y=iYb+'d1;
					Xs='d6;
					Ys='d4;
					Colour='b111;
				end
				DRAW_BB:begin
					Draw='b1;
					X=iXb+'d1;
					Y=iYb+'d5;
					Xs='d4;
					Ys='d1;
					Colour='b111;
				end
				DONE: begin oDone='b1; start_F='b0; end
			endcase
		end
		
		always@(posedge iClock) CS<=NS;
		
	endmodule