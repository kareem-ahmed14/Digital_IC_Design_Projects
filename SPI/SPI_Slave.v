module SPI_Slave(clk,rst_n,MOSI,MISO,SS_n,rx_data,rx_valid,tx_data,tx_valid);
   // Parameters 
   parameter IDLE = 3'b000;
   parameter CHK_CMD = 3'b001;
   parameter WRITE = 3'b010;
   parameter READ_ADD = 3'b011;
   parameter READ_DATA = 3'b100;
   // Ports Declaration
   input clk,rst_n,MOSI,SS_n,tx_valid;
   input [7:0] tx_data;
   output reg MISO;
   output reg [9:0] rx_data;
   output rx_valid;
   // Internal Signals
   (* fsm_encoding = "gray" *)
   reg [2:0] cs,ns;
   reg [3:0] count_add, count_data;
   reg C_READ;
   // State Memory
   always@(posedge clk,negedge rst_n)begin
      if(~rst_n)
        cs <= IDLE;
      else 
        cs <= ns;  
   end 
   // Next State Logic 
   always @(*)begin
      case(cs)
        IDLE : begin
            if(~SS_n)
              ns = CHK_CMD;
            else
              ns = IDLE;   
        end

        CHK_CMD : begin
            if(SS_n == 0 && MOSI == 0)
              ns = WRITE;
            else if(SS_n == 0 && MOSI == 1 && C_READ == 0)  
              ns = READ_ADD;
            else if(SS_n == 0 && MOSI == 1 && C_READ == 1)  
              ns = READ_DATA;
            else
              ns = IDLE;  
        end

        WRITE : begin
            if(SS_n)
              ns = IDLE;
            else
              ns = WRITE;  
        end

        READ_ADD : begin
            if(SS_n)
              ns = IDLE;
            else 
              ns = READ_ADD;  
        end

        READ_DATA : begin
            if(SS_n)
              ns = IDLE;
            else
              ns = READ_DATA;  
        end

        default : ns = IDLE;
      endcase 
   end
   // Output Logic
   always@(posedge clk,negedge rst_n)begin
      if(~rst_n)begin
        MISO <= 0;
        rx_data <= 0;
        C_READ <= 0;
        count_add <= 0;
        count_data <= 0;
      end
      else begin
        case(cs)
          IDLE : begin
            MISO <= 0;
            rx_data <= 0;
            count_add <= 0;
            count_data <= 0;
          end

        WRITE : begin
            if(count_add < 10)begin
                rx_data[9-count_add] <= MOSI;
                count_add <= count_add + 1;
            end
        end

        READ_ADD : begin
            if(count_add < 10)begin
                rx_data[9-count_add] <= MOSI;
                count_add <= count_add + 1;
            end
            if(count_add == 10)
                C_READ <= 1;
        end

        READ_DATA : begin
           if(count_add < 10)begin
                rx_data[9-count_add] <= MOSI;
                count_add <= count_add + 1;
           end
           if(tx_valid && count_add == 10)begin
              if(count_data < 8)begin
                MISO <= tx_data[7-count_data];
                count_data <= count_data + 1;
                C_READ <= 0;
              end
              else begin
                MISO <= 0;
              end
           end
        end  

        default : begin
        MISO <= 0;
        count_add <= 0;
        count_data <= 0;
        rx_data <= 0;
        C_READ <= 0;            
        end        
        endcase
      end
   end 

   assign rx_valid = ((cs == WRITE || cs == READ_ADD) && count_add == 10)?1:0;
endmodule