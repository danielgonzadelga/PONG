module boinkNoise
	(
		CLOCK_50,						//	On Board 50 MHz
		KEY,
		enable,
		AUD_ADCDAT,

		// Bidirectionals
		AUD_BCLK,
		AUD_ADCLRCK,
		AUD_DACLRCK,

		FPGA_I2C_SDAT,

		// Outputs
		AUD_XCK,
		AUD_DACDAT,

		FPGA_I2C_SCLK,

	);

	input			CLOCK_50;			//	50 MHz
	input			AUD_ADCDAT;
	input 			KEY;
	input 			enable;

	inout				AUD_BCLK;
	inout				AUD_ADCLRCK;
	inout				AUD_DACLRCK;

	inout				FPGA_I2C_SDAT;

	output				AUD_XCK;
	output				AUD_DACDAT;
	output				FPGA_I2C_SCLK;
	
	wire							audio_in_available;
	wire		[31:0]	left_channel_audio_in;
	wire		[31:0]	right_channel_audio_in;
	wire				read_audio_in;

	wire				audio_out_allowed;
	wire		[31:0]	left_channel_audio_out;
	wire		[31:0]	right_channel_audio_out;
	wire				write_audio_out;
	wire     [7:0] data_received;

	
	wire [15:0] soundOut;

	reg [22:0] a;
	reg [22:0] address; 

	boink r2(.address(address), .clock(CLOCK_50), .q(soundOut));

	always @(posedge CLOCK_50) begin
			if (enable == 1'b0) begin
				address <= 0;
			end
			if (enable == 1'b1) begin
				if(a == 23'd0)begin
						a <= 23'b0;
						if(address < 23'd15435) address <= address + 1;
				end
				else  a <= a + 1;
			end
	end


	assign read_audio_in			= audio_in_available & audio_out_allowed;
	assign left_channel_audio_out	= soundOut << 14;
	assign right_channel_audio_out	= soundOut << 14;
	assign write_audio_out			= audio_in_available & audio_out_allowed;

	Audio_Controller Audio_Controller (
		// Inputs
		.CLOCK_50						(CLOCK_50),
		.reset									(KEY),

		.clear_audio_in_memory		(),
		.read_audio_in				(read_audio_in),
		
		.clear_audio_out_memory		(),
		.left_channel_audio_out		(left_channel_audio_out),
		.right_channel_audio_out	(right_channel_audio_out),
		.write_audio_out			(write_audio_out),

		.AUD_ADCDAT					(AUD_ADCDAT),

		// Bidirectionals
		.AUD_BCLK					(AUD_BCLK),
		.AUD_ADCLRCK				(AUD_ADCLRCK),
		.AUD_DACLRCK				(AUD_DACLRCK),


		// Outputs
		.audio_in_available			(audio_in_available),
		.left_channel_audio_in		(left_channel_audio_in),
		.right_channel_audio_in		(right_channel_audio_in),

		.audio_out_allowed			(audio_out_allowed),

		.AUD_XCK					(AUD_XCK),
		.AUD_DACDAT					(AUD_DACDAT)

	);

	avconf #(.USE_MIC_INPUT(1)) avc (
		.FPGA_I2C_SCLK					(FPGA_I2C_SCLK),
		.FPGA_I2C_SDAT					(FPGA_I2C_SDAT),
		.CLOCK_50					(CLOCK_50),
		.reset						(~KEY)
	);
		
endmodule


