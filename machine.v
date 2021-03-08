
module machine(
		quarter, 
		nickel,
		dime,
		soda,
		diet,
		clk,
		reset,
	 	change_count, 
		give_soda,
 		give_diet
	);

input quarter, nickel, dime, soda, diet, clk, reset;
output reg give_soda, give_diet;
output reg[2:0] change_count;
reg[3:0] current_state, next_state; 

parameter cent0  = 4'b0000, 
	  cent5  = 4'b0001, 
	  cent10 = 4'b0010, 
	  cent15 = 4'b0011, 
	  cent20 = 4'b0100, 
	  cent25 = 4'b0101, 
	  cent30 = 4'b0110,
	  cent35 = 4'b0111,
	  cent40 = 4'b1000;

always @(posedge clk or posedge reset)
    begin
        if(reset)
            current_state <= cent0;
        else
            current_state <= next_state;
    end

always @(nickel , dime , quarter)
    begin
    case(current_state)
        cent0: begin
		change_count <= 3'b000;
		give_diet <= 1'b0;
		give_soda <= 1'b0;
            if(nickel)  
                    next_state <= cent5;
            else if(dime)
                    next_state <= cent10;
            else if(quarter)
                    next_state <= cent25;
            end
        cent5: begin
            if(nickel)  
                    next_state <= cent10;
            else if(dime)
                    next_state <= cent15;
            else if(quarter)
                    next_state <= cent30;
            end
        cent10: begin
            if(nickel)  
                    next_state <= cent15;
            else if(dime)
                    next_state <= cent20;
            else if(quarter)
                    next_state <= cent35;
            end
        cent15: begin
            if(nickel)  
                    next_state <= cent20;
            else if(dime)
                    next_state <= cent25;
            else if(quarter)
                    next_state <= cent40;
            end
        cent20: begin
            if(nickel)  
                    next_state <= cent25;
            else if(dime)
                    next_state <= cent30;
            else if(quarter) begin
                    next_state <= cent0;
                    if(soda)    
                            give_soda <= 1'b1;
                    else if(diet)
                            give_diet <= 1'b1;
		end
            end
         cent25: begin
            if(nickel)  
                    next_state <= cent30;
            else if(dime)
                    next_state <= cent35;
            else if(quarter) begin
                    next_state <= cent0;
                    change_count <= 3'b001;
                    if(soda)    
                            give_soda <= 1'b1;
                    else if(diet)
                            give_diet <= 1'b1;
		end
            end
         cent30: begin
            if(nickel)
                    next_state <= cent35;
            else if(dime)
                    next_state <= cent40;
            else if(quarter) begin
                    next_state <= cent0;
                    change_count <= 3'b010;
                    if(soda)    
                            give_soda <= 1'b1;
                    else if(diet)
                            give_diet <= 1'b1;
		end
            end
         cent35: begin
            if(nickel)
                    next_state <= cent40;
            else if(dime)
                    next_state <= cent40;
            else if(quarter) begin
                    next_state <= cent0;
                    change_count <= 3'b010;
                    if(soda)
                          give_soda <= 1'b1;
                    else if(diet)
                          give_diet <= 1'b1;
		end
            end
         cent40: begin
            if(nickel) begin
                    next_state <= cent0;
                    if(soda)
                           give_soda <= 1'b1;
                    else if(diet)
                           give_diet <= 1'b1;
		end
             else if(dime) begin
                    next_state <= cent0;
                    change_count <= 3'b001;
                    if(soda)
                            give_soda <= 1'b1;
                    else if(diet)
                            give_diet <= 1'b1;
		end
             else if(quarter) begin
                    next_state <= cent0;
                    change_count <= 3'b100;
                    if(soda)
                            give_soda <= 1'b1;
                    else if(diet)
                            give_diet <= 1'b1;
		end
             end
            default: next_state <= current_state;
            endcase
	end
endmodule 
