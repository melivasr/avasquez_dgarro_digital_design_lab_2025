 module decoder(input logic [1:0] Op,
	input logic [5:0] Funct,
	input logic [3:0] Rd,
	output logic [1:0] FlagW,
	output logic PCS,RegW,MemW,
	output logic MemtoReg,ALUSrc,
	output logic [1:0] ImmSrc,RegSrc,ALUControl,
	output logic Link);
	
 logic [9:0] controls_raw;
 logic Branch,ALUOp;
 logic RegW_int;
 
 logic is_cmp;
 assign is_cmp = (Op == 2'b00) && (Funct[4:1] == 4'b1010);
 assign Link = (Op == 2'b10) && Funct[5];
 
 //MainDecoder
 always_comb
	 casex(Op)
		//Data-processing immediate
		 2'b00:if(Funct[5]) controls_raw = 10'b0000101001;
		 //Data-processing register
			else controls_raw=10'b0000001001;
		 //LDR
		 2'b01:if(Funct[0]) controls_raw=10'b0001111000;
		 //STR
			else controls_raw=10'b1001110100;
		 //B
		 2'b10: controls_raw=10'b0110100010;
		 //Unimplemented
		 default: controls_raw=10'b0000000000;
  endcase

	 
  assign {RegSrc, ImmSrc, ALUSrc, MemtoReg,
          RegW_int, MemW, Branch, ALUOp} = controls_raw;

  assign RegW = is_cmp ? 1'b0 : RegW_int;
	 
 //ALUDecoder
 always_comb
	 if(ALUOp)begin 
	 case(Funct[4:1])
		 4'b0100: ALUControl=2'b00; //ADD
		 4'b0010: ALUControl=2'b01; //SUB
		 4'b0011: ALUControl = 2'b01; // RSB
		 4'b0000: ALUControl=2'b10; //AND
		 4'b1100: ALUControl=2'b11; //ORR
		 4'b1101: ALUControl = 2'b11; // MOV
		 4'b1010: ALUControl = 2'b01; // CMP
       default: ALUControl = 2'b00; // por defecto ADD
	 endcase
	 //update flags if S bit is set (C & V only for arith)
	 FlagW[1] =Funct[0]; 
	 FlagW[0] =Funct[0]&
	 (ALUControl==2'b00|ALUControl==2'b01);
	 end else begin
	 ALUControl=2'b00; 
	 FlagW =2'b00; //don't update Flags
	end
	
 //PCLogic
 assign PCS =((Rd==4'b1111)&RegW)|Branch;
 endmodule