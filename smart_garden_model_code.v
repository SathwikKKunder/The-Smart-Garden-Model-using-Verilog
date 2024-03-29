// Vismay Smart Garden

module Vismay(clk,reset,motor,r1,r2,r3,r4,display,display1,sec1,sec2,min1,min2,hr1,hr2,control,controlh,seq,seqc,stepout,pwm,seqf);

input clk,reset,motor;
input r1,r2,r3,r4;                                             // resets used in digital clock
integer t,temp2,t3,t4,t5,count,stepcount2,stepcount1,countf;

output [3:0]sec1,sec2,min1,min2,hr1,hr2,pwm;
output [3:0]control,controlh,stepout;
output [2:0]seqf;

reg [3:0]control,flag,controlh,stepout,stepout1,stepout2;
reg Gate;
reg flag1;
reg flagf;
reg en1,en2;

output [7:0] display,display1;
reg [7:0] display,display1;                               // used in displaying part of the code

output [7:0]seq,seqc;
reg [2:0]seqf;
reg [7:0]seq,seqc;
reg [3:0]sec1,sec2,min1,min2,hr1,hr2,pwm;
reg clkdiv,clkms,clkgo,clklo,clkfo; 
reg [15:0]lo,go,fo;


initial
 begin
  t=0;
  temp2=0;
  t3=1'b0;
  t4=1'b0;
  sec1=4'b0;
  sec2=4'b0101;
  min1=4'b1001;
  min2=4'b0010;
  hr1=4'b0001;
  hr2=4'b0010;
  clkdiv=1'b0;
  clkms=1'b0;
  flag=4'b0000;
  count=5'b00000;
  seq=8'b00000000;
  seqc=8'b00000000;
  clkgo=1'b0;
  clklo=1'b0;
  clkfo=1'b0;
  stepout=4'b1000;
  stepout1=4'b1000;
  stepcount1=4'b0000;
  stepout2=4'b1000;
  stepcount2=4'b0000;
  Gate=1'b0;
  flagf=1'b0;
  countf=3'b000;
 end
 

// ****************************************************clock division******************************************************************* 
 always@(posedge clk)
  begin
   t=t+1;
	temp2=temp2+1;
	t3=t3+1;
	t4=t4+1;
	t5=t5+1;
	
   if(t==2000000)   // divided clock with frequrncy 1Hz for digital clock
	 begin
	 clkdiv=~clkdiv;
	 t=0;
	 end
	 
   if(temp2==2000) //divided clock with frequrncy 1kHz to display the clock on 7 segement
	begin
	  clkms=~clkms;
	  temp2=0;
	end

  if(t4==2000000)   // divided clock with frequrncy 1Hz for ligth sequence
	 begin
	   clklo=~clklo;
	   t4=0;
	 end
		
  if(t3==20000)  // divided clock with frequrncy 100Hz for stepper motor(gate control)
	  begin
	    clkgo=~clkgo;
	    t3=0;
          end
		
   if(t5==4000000) // divided clock with frequrncy 0.5Hz for fountain
	  begin
	    clkfo=~clkfo;
	    t5=0;
	  end	
	
end


/////////////////////////////////////////////////////////////Clock Counter////////////////////////////////////////////
always@(posedge clkdiv)
 begin
     if(reset==1'b1)
      begin
	 sec1=4'b0;
         sec2=4'b0;
         min1=4'b0;
         min2=4'b0;
         hr1=4'b0;
         hr2=4'b0;
      end
	
    else if(r1)
     begin
       sec1=4'b0000; 
       sec2=4'b0101;   // 50 seconds 
	 
       min1=4'b1001;
       min2=4'b0010;  //  29 minutes 
	 
       hr1=4'b0001;
       hr2=4'b0010;   // 21 hours 
     end

   else if(r2)
     begin
      sec1=4'b0000;
      sec2=4'b0101;  // 50 seconds 
	 
      min1=4'b1001;
      min2=4'b0101;  // 59 seconds 
	 
      hr1=4'b0100;
      hr2=4'b0010;   // 23 hours ???
     end

   else	
     begin

     sec1=sec1+1;
     if(sec1==4'b1010)   //sec1=10  //unit's place
       begin
	sec1=0;
	sec2=sec2+1;
		         
        if(sec2==4'b0110)   //sec=6    //ten's place
         begin
					  
	  sec2=0;
	  min1=min1+1;
						  
          if(min1==4'b1010)  //min=10   //unit's place
           begin
							 
	    min1=0;
	    min2=min2+1;
					  		
            if(min2==4'b0110) //min=6     //ten's place
             begin
									 
	      min2=0;
	      hr1=hr1+1;
										
              if(hr1>=4'b0100) //hr1=4
               begin
                 if(hr2==4'b0010) //hr2=2
	           begin
	            sec1=4'b0;																      
                    sec2=4'b0;																	   
                    min1=4'b0;
                    min2=4'b0;
	            hr1=4'b0;
	            hr2=4'b0;	
	         end
	
              else if(hr1==4'b1010) //?????							
                  begin
                   hr2=hr2+1;
	
	           sec1=4'b0;
	           sec2=4'b0;
	           min1=4'b0;
	           min2=4'b0;
	           hr1=4'b0;															
																	
	         end
            end
        end
     end 
  end
 end
 end
 
end


************************************************** Display part of the code for sec1,sec2,min1,min2,hr1,hr2 on 7 segments*******************************************************************

always@(posedge clkms)
begin
 if (flag==4'b0000)
  begin
   control=4'b0111;
   case (sec1)
     4'd0:display=8'b11111100;
     4'd1:display=8'b01100000;
     4'd2:display=8'b11011010;
     4'd3:display=8'b11110010;
     4'd4:display=8'b01100110;
     4'd5:display=8'b10110110;
     4'd6:display=8'b10111110;
     4'd7:display=8'b11100000;
     4'd8:display=8'b11111110;
     4'd9:display=8'b11110110;
    endcase
   flag=4'b0001;
  end


 else if(flag==4'b0001)
  begin
   control=4'b1011;
   case (sec2)
     4'd0:display=8'b11111100;
     4'd1:display=8'b01100000;
     4'd2:display=8'b11011010;
     4'd3:display=8'b11110010;
     4'd4:display=8'b01100110;
     4'd5:display=8'b10110110;
     4'd6:display=8'b10111110;
     4'd7:display=8'b11100000;
     4'd8:display=8'b11111110;
     4'd9:display=8'b11110110;
   endcase
   flag=4'b0010;
  end



 else if(flag==4'b0010)
  begin
  control=4'b1101;
  case (min1)
   4'd0:display=8'b11111101;
   4'd1:display=8'b01100001;
   4'd2:display=8'b11011011;
   4'd3:display=8'b11110011;
   4'd4:display=8'b01100111;
   4'd5:display=8'b10110111;
   4'd6:display=8'b10111111;
   4'd7:display=8'b11100001;
   4'd8:display=8'b11111111;
   4'd9:display=8'b11110111;
  endcase
  flag=4'b0011;
 end


else if(flag==4'b0011)
 begin
   control=4'b1110;
   case (min2)
     4'd0:display=8'b11111100;
     4'd1:display=8'b01100000;
     4'd2:display=8'b11011010;
     4'd3:display=8'b11110010;
     4'd4:display=8'b01100110;
     4'd5:display=8'b10110110;
     4'd6:display=8'b10111110;
     4'd7:display=8'b11100000;
     4'd8:display=8'b11111110;
     4'd9:display=8'b11110110;
   endcase
  flag=4'b0100;
 end



 else if(flag==4'b0100)
  begin
   controlh=4'b0111;
   case (hr1)
    4'd0:display1=8'b11111101;
    4'd1:display1=8'b01100001;
    4'd2:display1=8'b11011011;
    4'd3:display1=8'b11110011;
    4'd4:display1=8'b01100111;
    4'd5:display1=8'b10110111;
    4'd6:display1=8'b10111111;
    4'd7:display1=8'b11100001;
    4'd8:display1=8'b11111111;
    4'd9:display1=8'b11110111;
   endcase
   flag=4'b0101;
  end


 else if(flag==4'b0101)
  begin
   controlh=4'b1011;
   case (hr2)
     4'd0:display1=8'b11111100;
     4'd1:display1=8'b01100000;
     4'd2:display1=8'b11011010;
     4'd3:display1=8'b11110010;
     4'd4:display1=8'b01100110;
   endcase
   flag=4'b0000;
  end

end

//*****************************************************ligth sequence part*************************************************************************************

always@(posedge clklo)
begin

 if(reset==1)
  begin
  count=4'b0000;
  seq=8'b0;
  seqc=8'b0;
  lo=16'b0;
  end

 else if(r1)
   begin
   seq=8'b0;
   seqc=8'b0;
   count=0;
  end
 
else if(r2)
 begin
 seq=8'b0;
 seqc=8'b0;
 count=0;
 end
  
else 
 begin
  lo={hr2,hr1,min2,min1};

   if(lo>=16'b0010000100110000) 
    begin
     if(lo<=16'b0010000100110000)   // start and close time set for ligth seq. ie. 21:30:00-21:31:00
       begin
        count=count+1;

        if(count==20)
          begin
           count=0;
          end
 
        case(count)
          4'd1:seq=8'b10000000;
          4'd2:seq=8'b01000000;
          4'd3:seq=8'b00100000;
          4'd4:seq=8'b00010000;
          4'd5:seq=8'b00001000;
          4'd6:seq=8'b00000100;
          4'd7:seq=8'b00000010;
          4'd8:seq=8'b00000001;
          4'd9:seq=8'b10000001;
          4'd10:seq=8'b11000011;
          4'd11:seq=8'b11100111;
          4'd12:seq=8'b11111111;
          4'd13:seq=8'b11100111;
          4'd14:seq=8'b11000011;
          4'd15:seq=8'b10000001;
          4'd16:seq=8'b00000000;
          4'd17:seq=8'b1000001;
          4'd18:seq=8'b11000011;
          4'd19:seq=8'b11100111;
          4'd20:seq=8'b11111111;
        endcase

        seqc=seq;

       end

     end //***
  end

end

//*****************************************************Gate control part *************************************************************************************
always@(posedge clkgo)
begin

 if(reset==1'b1)
  begin
   stepout=4'b1000;
   stepout1=4'b1000;
   stepcount1=4'b0000;
   stepout2=4'b1000;
   stepcount2=4'b0000;
   Gate=1'b0;
 end

 else if(r3)             // for manual control (to open the gates)
  begin
   stepcount1=stepcount1+1;
    
   if(stepcount1<=100)
	stepout1={stepout1[0],stepout1[3:1]};
	
    stepout=stepout1;
    end

 else if(r4)             // for manual control (to close the gates)
  begin
   stepcount2=stepcount2+1;	
   
   if(stepcount2<=100)
    stepout2={stepout2[2:0],stepout2[3]};
	
   stepout=stepout2;
  end
 
 else
  begin
   go={hr2,hr1,min2,min1};

   if(go>=16'b0010000100110000)
    begin
     if(go<=16'b0010000100110000)      // opening and closing time set for gaeden ie. 21:30:00-21:31:00
      begin
       Gate=1'b1;
      end	
  
     else
      begin
       Gate=1'b0;
      end

   case(Gate)
     1'b0:begin                    // for stepper motor to rotate in clockwise direction (for closing of the gates)
	stepcount1=stepcount1+1;
	  
          if(stepcount1<=100)
		 stepout1={stepout1[0],stepout1[3:1]};
		 stepout=stepout1;
	  end 
			 
    1'b1:begin                   // for stepper motor to rotate in anticlockwise direction (for opening of the gates)
       stepcount2=stepcount2+1;	
       
          if(stepcount2<=100)
		 stepout2={stepout2[2:0],stepout2[3]};
		 stepout=stepout2;
	  end 				
  endcase

 end 
end
	  
end	  

//*****************************************************Smart irrigation part*************************************************************************************

always@(posedge clkdiv)
begin
  if(reset==1)
   begin
    pwm=4'b0;
   end

  else 
   if(motor) // input from the soil moisture sensor
   pwm=4'b0111; // for controllind dc motor

   else
   pwm=4'b0;

end


//*****************************************************// Fountain control part*************************************************************************************

always@(posedge clkdiv)
begin

  if(reset==1)
   begin
    countf=0;
    seqf=3'b0;
    fo=16'b0;

   end

  else if(r1)
   seqf=3'b0;
 
  else if(r2)
   seqf=3'b0;
  
  else 
   begin
    fo={hr2,hr1,min2,min1};

    if(fo>=16'b0010000100110000)
     begin
      if(fo<=16'b0010000100110000) // start and close time set for fountain  ie. 21:30:00-21:31:00            
       begin
        countf=countf+1'b1;

         if(countf==8)
          begin
           countf=0;
          end
 
       case(countf)            // seqeunce of operation for the motors
        3'd0:seqf=3'b000;
        3'd1:seqf=3'b001;
        3'd2:seqf=3'b010;
        3'd3:seqf=3'b100;
        3'd4:seqf=3'b010;
        3'd5:seqf=3'b001;
        3'd6:seqf=3'b011;
        3'd7:seqf=3'b111;
       endcase
      end

    else 
     seqf=3'b0;

   end
  
  end
	  
end

endmodule

//*****************************************************---UFC----*************************************************************************************


net "clk" loc = "p55";

//FRC2
net "reset" loc = "p93";
net "r1" loc = "p94";
net "r2" loc = "p95";
net "motor" loc = "p97";
net "r3" loc = "p98";
net "r4" loc = "p99";

//FRC10
net "display[7]" loc = "p7";
net "display[6]" loc = "p8";
net "display[5]" loc = "p9";
net "display[4]" loc = "p11";
net "display[3]" loc = "p10";
net "display[2]" loc = "p35";
net "display[1]" loc = "p41";
net "display[0]" loc = "p43"; 
net "control[0]" loc = "p44";
net "control[1]" loc = "p45";
net "control[2]" loc = "p58";
net "control[3]" loc = "p61";

//FRC5
net "display1[7]" loc = "p1";
net "display1[6]" loc = "p12";
net "display1[5]" loc = "p14";
net "display1[4]" loc = "p15";
net "display1[3]" loc = "p17";
net "display1[2]" loc = "p21";
net "display1[1]" loc = "p22";
net "display1[0]" loc = "p24"; 
net "controlh[0]" loc = "p26";
net "controlh[1]" loc = "p27";
net "controlh[2]" loc = "p29";
net "controlh[3]" loc = "p30";

//FRC1
net "seq[0]" loc = "p80";
net "seq[1]" loc = "p81";
net "seq[2]" loc = "p82";
net "seq[3]" loc = "p84";
net "seq[7]" loc = "p92";
net "seq[6]" loc = "p85";
net "seq[5]" loc = "p88";
net "seq[4]" loc = "p83";

//FRC4
net "seqc[0]" loc = "p121";
net "seqc[1]" loc = "p124";
net "seqc[2]" loc = "p127";
net "seqc[3]" loc = "p126";
net "seqc[4]" loc = "p132";
net "seqc[5]" loc = "p140";
net "seqc[6]" loc = "p139";
net "seqc[7]" loc = "p143";

//FRC9 
net "stepout[0]" loc = "p6";
net "stepout[1]" loc = "p5";
net "stepout[2]" loc = "p2";
net "stepout[3]" loc = "p38";



net "pwm[0]" loc = "p32";
net "pwm[1]" loc = "p34";
net "pwm[2]" loc = "p40";
net "pwm[3]" loc = "p46";

//FRC7
net "seqf[0]" loc = "p57";
net "seqf[1]" loc = "p59";
net "seqf[2]" loc = "p62";




