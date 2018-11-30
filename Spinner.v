/*
TASK Spinner

A ideia dessa task é fazer o display girar durante um segundo,
utilizando uma máquina de estados em que cada estado é um segmento aceso.

Como são 6 displays que devem ficar acesos, cada um ficará por 0.16666 segundos.

Para a task funcionar, o arquivo deve ser declarado como SystemVerilog no Quartus II:

Files > Properties > HDL Version > SystemVerilog_2005
*/

task Spinner();

	input CLOCK_50, in;
	output reg[6:0] HEX0;
	integer i = 0;
	reg[3:0] estado;
	reg in;
	
	//estados A-F são os displays em volta
	//estado G é o display do meio
	parameter A = 3'b 000, B = 3'b 001, C = 3'b 010, D = 3'b 011, E = 3'b 100, F = 3'b 101, G = 3'b 110;

	//estado inicial é o display do meio
	estado = G;

	//se receber o parametro 1 na variável in
	//inicia a máquina no estado A
	if(in == 1) begin
		estado = A;
	end

	case(estado)

		A : begin

		//liga o primeiro segmento do display
		HEX0 = 7'b 01111111;

		//verifica cada ciclo do clock
		if(CLOCK_50 == 1'b 1) begin

			//incrementa o contador i
			i = i + 1;

			//quando i atinge 1/6 segundo (8.3mi),
			//muda de estado para o próximo segmento
			if(i == 8333333)
				estado = B;

			i = 0;
		end
	end

	B : begin

		HEX0 = 7'b 1011111; //segundo segmento

		if(CLOCK_50 == 1'b 1) begin

			i = i + 1;

			if(i == 8333333)
				estado = C;

			i = 0;
		end
	end

	C : begin

		HEX0 = 7'b 1101111;

		if(CLOCK_50 == 1'b 1) begin

			i = i + 1;

			if(i == 8333333)
				estado = D;

			i = 0;
		end
	end

	D : begin

		HEX0 = 7'b 1110111;

		if(CLOCK_50 == 1'b 1) begin

			i = i + 1;

			if(i == 8333333)
				estado = F;

			i = 0;
		end
	end

	E : begin

		HEX0 = 7'b 1111011;

		if(CLOCK_50 == 1'b 1) begin

			i = i + 1;

			if(i == 8333333)
				estado = A;

			i = 0;
		end
	end

	F : begin

		HEX0 = 7'b 1111101;

		/*
		analisar se a task se encerra aqui
		ou deve continuar retornando ao estado A
		(compilar código na placa)
		
		
		if(CLOCK_50 == 1'b 1) begin
		
			i = i + 1;
		
			if(i == 8333333)
				estado = A;
		
			i = 0;
		end
		*/
	end

	//estado G não leva em outro estado
	G : begin
		HEX0 = 7'b 1111110;
	end

	endcase

endtask
