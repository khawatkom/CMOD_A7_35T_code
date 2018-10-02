library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_arith.all;
use ieee.std_logic_signed.all;

entity dynamic_choose is
	   port(
			  clk : in std_logic;
			  rst: in std_logic;
		     ctl: in std_logic;
		     freq_1: in std_logic;
		     freq_2: in std_logic;
			  freq_3: in std_logic;
			  freq_4: in std_logic;
		     freq_5: in std_logic;
		     freq_6: in std_logic;
			  freq_7: in std_logic;
			  freq_8: in std_logic;
			  freq_9: in std_logic;
		     freq_10: in std_logic;
			  freq_11: in std_logic;
			  freq_12: in std_logic;
		     freq_13: in std_logic;
		     freq_14: in std_logic;
			  freq_15: in std_logic;
			  freq_16: in std_logic;
			  countnumber: in integer range 0 to 511;
			  choose_result: out integer range 0 to 16
			  );
end dynamic_choose;

 architecture Behavioral of dynamic_choose is
   --signal choose: integer range 0 to 7;
	signal up1,   up2,   up3,   up4,   up5,   up6,   up7,   up8,up9,   up10,   up11,   up12,   up13,   up14,   up15,   up16:   integer range 0 to 63;
	signal down1, down2, down3, down4, down5, down6, down7, down8,down9, down10, down11, down12, down13, down14, down15, down16: integer range 0 to 63;
	--signal pre1,  pre2,  pre3,  pre4:  std_logic := '0';
   signal distance1, distance2, distance3, distance4, distance5, distance6, distance7, distance8,distance9, distance10, distance11, distance12, distance13, distance14, distance15, distance16: integer range -50 to 127;
begin
   process(freq_1, freq_2,  freq_3,  freq_4,  freq_5,  freq_6,  freq_7,  freq_8, 
	        freq_9, freq_10, freq_11, freq_12, freq_13, freq_14, freq_15, freq_16,
	        up1, up2,  up3,  up4,  up5,  up6,  up7,  up8,
           up9, up10, up11, up12, up13, up14, up15, up16,	
           down1, down2,  down3,  down4,  down5,  down6,  down7,  down8,
           down9, down10, down11, down12, down13, down14, down15, down16,
           distance1, distance2,  distance3,  distance4,  distance5,  distance6,  distance7,   distance8,
           distance9, distance10, distance11, distance12, distance13, distance14, distance15,  distance16,
			  clk,rst, ctl, countnumber)
		variable pre1, pre2, pre3, pre4, pre5, pre6, pre7, pre8,pre9, pre10, pre11, pre12, pre13, pre14, pre15, pre16: std_logic := '0';
		variable choose: integer range 0 to 16;
	begin	
	      if(rst = '1' or ctl = '1') then
			   choose := 0;
				pre1 := '0';
				pre2 := '0';
				pre3 := '0';
				pre4 := '0';
				pre5 := '0';
				pre6 := '0';
				pre7 := '0';
				pre8 := '0';	
				pre9 := '0';
				pre10 := '0';
				pre11 := '0';
				pre12 := '0';
				pre13 := '0';
				pre14 := '0';
				pre15 := '0';
				pre16 := '0';				
				up1  <= 0;  down1 <= 0;
				up2  <= 0;  down2 <= 0;
				up3  <= 0;  down3 <= 0;
				up4  <= 0;  down4 <= 0;
				up5  <= 0;  down5 <= 0;
				up6  <= 0;  down6 <= 0;
				up7  <= 0;  down7 <= 0;
				up8  <= 0;  down8 <= 0;
				up9  <= 0;  down9 <= 0;
				up10  <= 0;  down10 <= 0;
				up11  <= 0;  down11 <= 0;
				up12  <= 0;  down12 <= 0;
				up13  <= 0;  down13 <= 0;
				up14  <= 0;  down14 <= 0;
				up15  <= 0;  down15 <= 0;
				up16  <= 0;  down16 <= 0;
				distance1 <= 0;
				distance2 <= 0;
				distance3 <= 0;
				distance4 <= 0;
				distance5 <= 0;
				distance6 <= 0;
				distance7 <= 0;
				distance8 <= 0;
				distance9 <= 0;
				distance10 <= 0;
				distance11<= 0;
				distance12 <= 0;
				distance13 <= 0;
				distance14 <= 0;
				distance15 <= 0;
				distance16 <= 0;
				choose_result <= 16;
			else
				if(countnumber = 100) then	
				   pre1 := freq_1; 
					pre2 := freq_2;
					pre3 := freq_3;
					pre4 := freq_4;
				   pre5 := freq_5; 
					pre6 := freq_6;
					pre7 := freq_7;
					pre8 := freq_8;
					pre9  := freq_9; 
					pre10 := freq_10;
					pre11 := freq_11;
					pre12 := freq_12;
				   pre13 := freq_13; 
					pre14 := freq_14;
					pre15 := freq_15;
					pre16 := freq_16;
					up1  <= 0;  down1 <= 0;
					up2  <= 0;  down2 <= 0;
					up3  <= 0;  down3 <= 0;
					up4  <= 0;  down4 <= 0;
					up5  <= 0;  down5 <= 0;
					up6  <= 0;  down6 <= 0;
					up7  <= 0;  down7 <= 0;
					up8  <= 0;  down8 <= 0;
					up9  <= 0;
					up10 <= 0;
					up11 <= 0;
					up12 <= 0;
					up13 <= 0;
					up14 <= 0;
					up15 <= 0;
					up16 <= 0;
					down9  <= 0;
					down10 <= 0;
					down11 <= 0;
					down12 <= 0;
					down13 <= 0;
					down14 <= 0;
					down15 <= 0;
					down16 <= 0;
					distance1 <= 0;
					distance2 <= 0;
					distance3 <= 0;
					distance4 <= 0;
					distance5 <= 0;
					distance6 <= 0;
					distance7 <= 0;
					distance8 <= 0;
					distance9  <= 0;
					distance10 <= 0;
					distance11 <= 0;
					distance12 <= 0;
					distance13 <= 0;
					distance14 <= 0;
					distance15 <= 0;
					distance16 <= 0;
		   elsif(countnumber >= 101 and countnumber <= 196) then
		      if(freq_1 /= pre1) then
					pre1 := freq_1;
				   if(freq_1 = '1') then
		            up1 <= countnumber;
					else
					   down1 <= countnumber;
				   end if;
				else
				   pre1 := pre1;
				end if;
		      if(freq_2 /= pre2) then
					pre2 := freq_2;
				   if(freq_2 = '1') then
		            up2 <= countnumber;
					else
					   down2 <= countnumber;
				   end if;
				else
				   pre2 := pre2;
				end if;
		      if(freq_3 /= pre3) then
					pre3 := freq_3;
				   if(freq_3 = '1') then
		            up3 <= countnumber;
					else
					   down3 <= countnumber;
				   end if;
				else
				   pre3 := pre3;
				end if;
		      if(freq_4 /= pre4) then
					pre4 := freq_4;
				   if(freq_4 = '1') then
		            up4 <= countnumber;
					else
					   down4 <= countnumber;
				   end if;
				else
				   pre4 := pre4;
				end if;	
		      if(freq_5 /= pre5) then
					pre5 := freq_5;
				   if(freq_5 = '1') then
		            up5 <= countnumber;
					else
					   down5 <= countnumber;
				   end if;
				else
				   pre5 := pre5;
				end if;
		      if(freq_6 /= pre6) then
					pre6 := freq_6;
				   if(freq_6 = '1') then
		            up6 <= countnumber;
					else
					   down6 <= countnumber;
				   end if;
				else
				   pre6 := pre6;
				end if;
		      if(freq_7 /= pre7) then
					pre7 := freq_7;
				   if(freq_7 = '1') then
		            up7 <= countnumber;
					else
					   down7 <= countnumber;
				   end if;
				else
				   pre7 := pre7;
				end if;
		      if(freq_8 /= pre8) then
					pre8 := freq_8;
				   if(freq_8 = '1') then
		            up8 <= countnumber;
					else
					   down8 <= countnumber;
				   end if;
				else
				   pre8 := pre8;
				end if;
				if(freq_9 /= pre9) then
					pre9 := freq_9;
				   if(freq_9 = '1') then
		            up9 <= countnumber;
					else
					   down9 <= countnumber;
				   end if;
				end if;
		      if(freq_10 /= pre10) then
					pre10 := freq_10;
				   if(freq_10 = '1') then
		            up10 <= countnumber;
					else
					   down10 <= countnumber;
				   end if;
				end if;
		      if(freq_11 /= pre11) then
					pre11 := freq_11;
				   if(freq_11 = '1') then
		            up11 <= countnumber;
					else
					   down11 <= countnumber;
				   end if;
				end if;
		      if(freq_12 /= pre12) then
					pre12 := freq_12;
				   if(freq_12 = '1') then
		            up12 <= countnumber;
					else
					   down12 <= countnumber;
				   end if;
				end if;
		      if(freq_13 /= pre13) then
					pre13 := freq_13;
				   if(freq_13 = '1') then
		            up13 <= countnumber;
					else
					   down13 <= countnumber;
				   end if;
				end if;	
		      if(freq_14 /= pre14) then
					pre14 := freq_14;
				   if(freq_14 = '1') then
		            up14 <= countnumber;
					else
					   down14 <= countnumber;
				   end if;
				end if;
		      if(freq_15 /= pre15) then
					pre15 := freq_15;
				   if(freq_15 = '1') then
		            up15 <= countnumber;
					else
					   down15 <= countnumber;
				   end if;
				end if;
		      if(freq_16 /= pre16) then
					pre16 := freq_16;
				   if(freq_16 = '1') then
		            up16 <= countnumber;
					else
					   down16 <= countnumber;
				   end if;
				end if;	
		   elsif(countnumber = 197) then
		      if(up1 > down1) then 
			      distance1 <= 200 - up1;
		      else 
			      distance1 <= 200 - (down1 + down1 - up1);
		      end if;
			   if(up2 > down2) then 
			      distance2 <= 200 - up2;
		      else 
			      distance2 <= 200 - (down2 + down2 - up2);
		      end if;
			   if(up3 > down3) then 
			      distance3 <= 200 - up3;
		      else 
			      distance3 <= 200 - (down3 + down3 - up3);
		      end if;
			   if(up4 > down4) then 
			      distance4 <= 200 - up4;
		      else 
			      distance4 <= 200 - (down4 + down4 - up4);
		      end if;
		      if(up5 > down5) then 
			      distance5 <= 200 - up5;
		      else 
			      distance5 <= 200 - (down5 + down5 - up5);
		      end if;
			   if(up6 > down6) then 
			      distance6 <= 200 - up6;
		      else 
			      distance6 <= 200 - (down6 + down6 - up6);
		      end if;
			   if(up7 > down7) then 
			      distance7 <= 200 - up7;
		      else 
			      distance7 <= 200 - (down7 + down7 - up7);
		      end if;
			   if(up8 > down8) then 
			      distance8 <= 200 - up8;
		      else 
			      distance8 <= 200 - (down8 + down8 - up8);
		      end if;
				if(up9 > down9) then 
			      distance9 <= 200 - up9;
		      else 
			      distance9 <= 200 - (down9 + down9 - up9);
		      end if;
			   if(up10 > down10) then 
			      distance10 <= 200 - up10;
		      else 
			      distance10 <= 200 - (down10 + down10 - up10);
		      end if;
			   if(up11 > down11) then 
			      distance11 <= 200 - up11;
		      else 
			      distance11 <= 200 - (down11 + down11 - up11);
		      end if;
			   if(up12 > down12) then 
			      distance12 <= 200 - up12;
		      else 
			      distance12 <= 200 - (down12 + down12 - up12);
		      end if;
			   if(up13 > down13) then 
			      distance13 <= 200 - up13;
		      else 
			      distance13 <= 200 - (down13 + down13 - up13);
		      end if;
			   if(up14 > down14) then 
			      distance14 <= 200 - up14;
		      else 
			      distance14 <= 200 - (down14 + down14 - up14);
		      end if;	
			   if(up15 > down15) then 
			      distance15 <= 200 - up15;
		      else 
			      distance15 <= 200 - (down15 + down15 - up15);
		      end if;			
			   if(up16 > down16) then 
			      distance16 <= 200 - up16;
		      else 
			      distance16 <= 200 - (down16 + down16 - up16);
		      end if;	
		  elsif(countnumber = 198) then
			   if(    abs(distance1) <= abs(distance2)  and abs(distance1) <= abs(distance3)  and abs(distance1) <= abs(distance4)  and abs(distance1) <= abs(distance5) 
				   and abs(distance1) <= abs(distance6)  and abs(distance1) <= abs(distance7)  and abs(distance1) <= abs(distance8)  and abs(distance1) <= abs(distance9)
               and abs(distance1) <= abs(distance10) and abs(distance1) <= abs(distance11) and abs(distance1) <= abs(distance12) and abs(distance1) <= abs(distance13)
               and abs(distance1) <= abs(distance14) and abs(distance1) <= abs(distance15) and abs(distance1) <= abs(distance16))then --and abs(distance1) <= abs(distance17)
--					and abs(distance1) <= abs(distance18) and abs(distance1) <= abs(distance19) and abs(distance1) <= abs(distance20) and abs(distance1) <= abs(distance21)
--					and abs(distance1) <= abs(distance22) and abs(distance1) <= abs(distance23) and abs(distance1) <= abs(distance24) and abs(distance1) <= abs(distance25)
--					and abs(distance1) <= abs(distance26) and abs(distance1) <= abs(distance27) and abs(distance1) <= abs(distance28) and abs(distance1) <= abs(distance29)
--					and abs(distance1) <= abs(distance30) and abs(distance1) <= abs(distance31) and abs(distance1) <= abs(distance32)) then
					if (distance1 >= 0) then
					   choose := 0;
					else
					   choose := 15;
					end if;
			   elsif( abs(distance2) <= abs(distance1)  and abs(distance2) <= abs(distance3)  and abs(distance2) <= abs(distance4)  and abs(distance2) <= abs(distance5) 
				   and abs(distance2) <= abs(distance6)  and abs(distance2) <= abs(distance7)  and abs(distance2) <= abs(distance8)  and abs(distance2) <= abs(distance9)
               and abs(distance2) <= abs(distance10) and abs(distance2) <= abs(distance11) and abs(distance2) <= abs(distance12) and abs(distance2) <= abs(distance13)
               and abs(distance2) <= abs(distance14) and abs(distance2) <= abs(distance15) and abs(distance2) <= abs(distance16))then--and abs(distance2) <= abs(distance17)
--					and abs(distance2) <= abs(distance18) and abs(distance2) <= abs(distance19) and abs(distance2) <= abs(distance20) and abs(distance2) <= abs(distance21)
--					and abs(distance2) <= abs(distance22) and abs(distance2) <= abs(distance23) and abs(distance2) <= abs(distance24) and abs(distance2) <= abs(distance25)
--					and abs(distance2) <= abs(distance26) and abs(distance2) <= abs(distance27) and abs(distance2) <= abs(distance28) and abs(distance2) <= abs(distance29)
--					and abs(distance2) <= abs(distance30) and abs(distance2) <= abs(distance31) and abs(distance2) <= abs(distance32)) then					
					if (distance2 >= 0) then
					   choose := 1;
					else
					   choose := 0;
					end if;
			   elsif( abs(distance3) <= abs(distance1)  and abs(distance3) <= abs(distance2)  and abs(distance3) <= abs(distance4)  and abs(distance3) <= abs(distance5) 
				   and abs(distance3) <= abs(distance6)  and abs(distance3) <= abs(distance7)  and abs(distance3) <= abs(distance8)  and abs(distance3) <= abs(distance9)
               and abs(distance3) <= abs(distance10) and abs(distance3) <= abs(distance11) and abs(distance3) <= abs(distance12) and abs(distance3) <= abs(distance13)
               and abs(distance3) <= abs(distance14) and abs(distance3) <= abs(distance15) and abs(distance3) <= abs(distance16)) then
--					and abs(distance3) <= abs(distance17)
--					and abs(distance3) <= abs(distance18) and abs(distance3) <= abs(distance19) and abs(distance3) <= abs(distance20) and abs(distance3) <= abs(distance21)
--					and abs(distance3) <= abs(distance22) and abs(distance3) <= abs(distance23) and abs(distance3) <= abs(distance24) and abs(distance3) <= abs(distance25)
--					and abs(distance3) <= abs(distance26) and abs(distance3) <= abs(distance27) and abs(distance3) <= abs(distance28) and abs(distance3) <= abs(distance29)
--					and abs(distance3) <= abs(distance30) and abs(distance3) <= abs(distance31) and abs(distance3) <= abs(distance32)) then						
					if (distance3 >= 0) then
					   choose := 2;
					else
					   choose := 1;
					end if;
			   elsif( abs(distance4) <= abs(distance1)  and abs(distance4) <= abs(distance2)  and abs(distance4) <= abs(distance3)  and abs(distance4) <= abs(distance5) 
				   and abs(distance4) <= abs(distance6)  and abs(distance4) <= abs(distance7)  and abs(distance4) <= abs(distance8)  and abs(distance4) <= abs(distance9)
               and abs(distance4) <= abs(distance10) and abs(distance4) <= abs(distance11) and abs(distance4) <= abs(distance12) and abs(distance4) <= abs(distance13)
               and abs(distance4) <= abs(distance14) and abs(distance4) <= abs(distance15) and abs(distance4) <= abs(distance16)) then
--					and abs(distance4) <= abs(distance17)
--					and abs(distance4) <= abs(distance18) and abs(distance4) <= abs(distance19) and abs(distance4) <= abs(distance20) and abs(distance4) <= abs(distance21)
--					and abs(distance4) <= abs(distance22) and abs(distance4) <= abs(distance23) and abs(distance4) <= abs(distance24) and abs(distance4) <= abs(distance25)
--					and abs(distance4) <= abs(distance26) and abs(distance4) <= abs(distance27) and abs(distance4) <= abs(distance28) and abs(distance4) <= abs(distance29)
--					and abs(distance4) <= abs(distance30) and abs(distance4) <= abs(distance31) and abs(distance4) <= abs(distance32)) then
					if (distance4 >= 0) then
					   choose := 3;
					else
					   choose := 2;
					end if;
			   elsif( abs(distance5) <= abs(distance1)  and abs(distance5) <= abs(distance2)  and abs(distance5) <= abs(distance3)  and abs(distance5) <= abs(distance4) 
				   and abs(distance5) <= abs(distance6)  and abs(distance5) <= abs(distance7)  and abs(distance5) <= abs(distance8)  and abs(distance5) <= abs(distance9)
               and abs(distance5) <= abs(distance10) and abs(distance5) <= abs(distance11) and abs(distance5) <= abs(distance12) and abs(distance5) <= abs(distance13)
               and abs(distance5) <= abs(distance14) and abs(distance5) <= abs(distance15) and abs(distance5) <= abs(distance16)) then
--					and abs(distance5) <= abs(distance17)
--					and abs(distance5) <= abs(distance18) and abs(distance5) <= abs(distance19) and abs(distance5) <= abs(distance20) and abs(distance5) <= abs(distance21)
--					and abs(distance5) <= abs(distance22) and abs(distance5) <= abs(distance23) and abs(distance5) <= abs(distance24) and abs(distance5) <= abs(distance25)
--					and abs(distance5) <= abs(distance26) and abs(distance5) <= abs(distance27) and abs(distance5) <= abs(distance28) and abs(distance5) <= abs(distance29)
--					and abs(distance5) <= abs(distance30) and abs(distance5) <= abs(distance31) and abs(distance5) <= abs(distance32)) then
					if (distance5 >= 0) then
					   choose := 4;
					else
					   choose := 3;
					end if;
			   elsif( abs(distance6) <= abs(distance1)  and abs(distance6) <= abs(distance2)  and abs(distance6) <= abs(distance3)  and abs(distance6) <= abs(distance4) 
				   and abs(distance6) <= abs(distance5)  and abs(distance6) <= abs(distance7)  and abs(distance6) <= abs(distance8)  and abs(distance6) <= abs(distance9)
               and abs(distance6) <= abs(distance10) and abs(distance6) <= abs(distance11) and abs(distance6) <= abs(distance12) and abs(distance6) <= abs(distance13)
               and abs(distance6) <= abs(distance14) and abs(distance6) <= abs(distance15) and abs(distance6) <= abs(distance16)) then
--					and abs(distance6) <= abs(distance17)
--					and abs(distance6) <= abs(distance18) and abs(distance6) <= abs(distance19) and abs(distance6) <= abs(distance20) and abs(distance6) <= abs(distance21)
--					and abs(distance6) <= abs(distance22) and abs(distance6) <= abs(distance23) and abs(distance6) <= abs(distance24) and abs(distance6) <= abs(distance25)
--					and abs(distance6) <= abs(distance26) and abs(distance6) <= abs(distance27) and abs(distance6) <= abs(distance28) and abs(distance6) <= abs(distance29)
--					and abs(distance6) <= abs(distance30) and abs(distance6) <= abs(distance31) and abs(distance6) <= abs(distance32)) then				
					if (distance6 >= 0) then
					   choose := 5;
					else
					   choose := 4;
					end if;
			   elsif( abs(distance7) <= abs(distance1)  and abs(distance7) <= abs(distance2)  and abs(distance7) <= abs(distance3)  and abs(distance7) <= abs(distance4) 
				   and abs(distance7) <= abs(distance5)  and abs(distance7) <= abs(distance6)  and abs(distance7) <= abs(distance8)  and abs(distance7) <= abs(distance9)
               and abs(distance7) <= abs(distance10) and abs(distance7) <= abs(distance11) and abs(distance7) <= abs(distance12) and abs(distance7) <= abs(distance13)
               and abs(distance7) <= abs(distance14) and abs(distance7) <= abs(distance15) and abs(distance7) <= abs(distance16)) then
--					and abs(distance7) <= abs(distance17)
--					and abs(distance7) <= abs(distance18) and abs(distance7) <= abs(distance19) and abs(distance7) <= abs(distance20) and abs(distance7) <= abs(distance21)
--					and abs(distance7) <= abs(distance22) and abs(distance7) <= abs(distance23) and abs(distance7) <= abs(distance24) and abs(distance7) <= abs(distance25)
--					and abs(distance7) <= abs(distance26) and abs(distance7) <= abs(distance27) and abs(distance7) <= abs(distance28) and abs(distance7) <= abs(distance29)
--					and abs(distance7) <= abs(distance30) and abs(distance7) <= abs(distance31) and abs(distance7) <= abs(distance32)) then
					if (distance7 >= 0) then
					   choose := 6;
					else
					   choose := 5;
					end if;
			   elsif( abs(distance8) <= abs(distance1)  and abs(distance8) <= abs(distance2)  and abs(distance8) <= abs(distance3)  and abs(distance8) <= abs(distance4) 
				   and abs(distance8) <= abs(distance5)  and abs(distance8) <= abs(distance6)  and abs(distance8) <= abs(distance7)  and abs(distance8) <= abs(distance9)
               and abs(distance8) <= abs(distance10) and abs(distance8) <= abs(distance11) and abs(distance8) <= abs(distance12) and abs(distance8) <= abs(distance13)
               and abs(distance8) <= abs(distance14) and abs(distance8) <= abs(distance15) and abs(distance8) <= abs(distance16)) then
--					and abs(distance8) <= abs(distance17)
--					and abs(distance8) <= abs(distance18) and abs(distance8) <= abs(distance19) and abs(distance8) <= abs(distance20) and abs(distance8) <= abs(distance21)
--					and abs(distance8) <= abs(distance22) and abs(distance8) <= abs(distance23) and abs(distance8) <= abs(distance24) and abs(distance8) <= abs(distance25)
--					and abs(distance8) <= abs(distance26) and abs(distance8) <= abs(distance27) and abs(distance8) <= abs(distance28) and abs(distance8) <= abs(distance29)
--					and abs(distance8) <= abs(distance30) and abs(distance8) <= abs(distance31) and abs(distance8) <= abs(distance32)) then	
					if (distance8 >= 0) then
					   choose := 7;
					else
					   choose := 6;
					end if;
			   elsif( abs(distance9) <= abs(distance1)  and abs(distance9) <= abs(distance2)  and abs(distance9) <= abs(distance3)  and abs(distance9) <= abs(distance4) 
				   and abs(distance9) <= abs(distance5)  and abs(distance9) <= abs(distance6)  and abs(distance9) <= abs(distance7)  and abs(distance9) <= abs(distance8)
               and abs(distance9) <= abs(distance10) and abs(distance9) <= abs(distance11) and abs(distance9) <= abs(distance12) and abs(distance9) <= abs(distance13)
               and abs(distance9) <= abs(distance14) and abs(distance9) <= abs(distance15) and abs(distance9) <= abs(distance16)) then
--					and abs(distance9) <= abs(distance17)
--					and abs(distance9) <= abs(distance18) and abs(distance9) <= abs(distance19) and abs(distance9) <= abs(distance20) and abs(distance9) <= abs(distance21)
--					and abs(distance9) <= abs(distance22) and abs(distance9) <= abs(distance23) and abs(distance9) <= abs(distance24) and abs(distance9) <= abs(distance25)
--					and abs(distance9) <= abs(distance26) and abs(distance9) <= abs(distance27) and abs(distance9) <= abs(distance28) and abs(distance9) <= abs(distance29)
--					and abs(distance9) <= abs(distance30) and abs(distance9) <= abs(distance31) and abs(distance9) <= abs(distance32)) then	
					if (distance9 >= 0) then
					   choose := 8;
					else
					   choose := 7;
					end if;	
			   elsif( abs(distance10) <= abs(distance1)  and abs(distance10) <= abs(distance2)  and abs(distance10) <= abs(distance3)  and abs(distance10) <= abs(distance4) 
				   and abs(distance10) <= abs(distance5)  and abs(distance10) <= abs(distance6)  and abs(distance10) <= abs(distance7)  and abs(distance10) <= abs(distance8)
               and abs(distance10) <= abs(distance9)  and abs(distance10) <= abs(distance11) and abs(distance10) <= abs(distance12) and abs(distance10) <= abs(distance13)
               and abs(distance10) <= abs(distance14) and abs(distance10) <= abs(distance15) and abs(distance10) <= abs(distance16)) then
--					and abs(distance10) <= abs(distance17)
--					and abs(distance10) <= abs(distance18) and abs(distance10) <= abs(distance19) and abs(distance10) <= abs(distance20) and abs(distance10) <= abs(distance21)
--					and abs(distance10) <= abs(distance22) and abs(distance10) <= abs(distance23) and abs(distance10) <= abs(distance24) and abs(distance10) <= abs(distance25)
--					and abs(distance10) <= abs(distance26) and abs(distance10) <= abs(distance27) and abs(distance10) <= abs(distance28) and abs(distance10) <= abs(distance29)
--					and abs(distance10) <= abs(distance30) and abs(distance10) <= abs(distance31) and abs(distance10) <= abs(distance32)) then		
					if (distance10 >= 0) then
					   choose := 9;
					else
					   choose := 8;
					end if;
			   elsif( abs(distance11) <= abs(distance1)  and abs(distance11) <= abs(distance2)  and abs(distance11) <= abs(distance3)  and abs(distance11) <= abs(distance4) 
				   and abs(distance11) <= abs(distance5)  and abs(distance11) <= abs(distance6)  and abs(distance11) <= abs(distance7)  and abs(distance11) <= abs(distance8)
               and abs(distance11) <= abs(distance9)  and abs(distance11) <= abs(distance10) and abs(distance11) <= abs(distance12) and abs(distance11) <= abs(distance13)
               and abs(distance11) <= abs(distance14) and abs(distance11) <= abs(distance15) and abs(distance11) <= abs(distance16)) then
--					and abs(distance11) <= abs(distance17)
--					and abs(distance11) <= abs(distance18) and abs(distance11) <= abs(distance19) and abs(distance11) <= abs(distance20) and abs(distance11) <= abs(distance21)
--					and abs(distance11) <= abs(distance22) and abs(distance11) <= abs(distance23) and abs(distance11) <= abs(distance24) and abs(distance11) <= abs(distance25)
--					and abs(distance11) <= abs(distance26) and abs(distance11) <= abs(distance27) and abs(distance11) <= abs(distance28) and abs(distance11) <= abs(distance29)
--					and abs(distance11) <= abs(distance30) and abs(distance11) <= abs(distance31) and abs(distance11) <= abs(distance32)) then		
					if (distance11 >= 0) then
					   choose := 10;
					else
					   choose := 9;
					end if;
			   elsif( abs(distance12) <= abs(distance1)  and abs(distance12) <= abs(distance2)  and abs(distance12) <= abs(distance3)  and abs(distance12) <= abs(distance4) 
				   and abs(distance12) <= abs(distance5)  and abs(distance12) <= abs(distance6)  and abs(distance12) <= abs(distance7)  and abs(distance12) <= abs(distance8)
               and abs(distance12) <= abs(distance9)  and abs(distance12) <= abs(distance10) and abs(distance12) <= abs(distance11) and abs(distance12) <= abs(distance13)
               and abs(distance12) <= abs(distance14) and abs(distance12) <= abs(distance15) and abs(distance12) <= abs(distance16)) then
--					and abs(distance12) <= abs(distance17)
--					and abs(distance12) <= abs(distance18) and abs(distance12) <= abs(distance19) and abs(distance12) <= abs(distance20) and abs(distance12) <= abs(distance21)
--					and abs(distance12) <= abs(distance22) and abs(distance12) <= abs(distance23) and abs(distance12) <= abs(distance24) and abs(distance12) <= abs(distance25)
--					and abs(distance12) <= abs(distance26) and abs(distance12) <= abs(distance27) and abs(distance12) <= abs(distance28) and abs(distance12) <= abs(distance29)
--					and abs(distance12) <= abs(distance30) and abs(distance12) <= abs(distance31) and abs(distance12) <= abs(distance32)) then		
					if (distance12 >= 0) then
					   choose := 11;
					else
					   choose := 10;
					end if;	
			   elsif( abs(distance13) <= abs(distance1)  and abs(distance13) <= abs(distance2)  and abs(distance13) <= abs(distance3)  and abs(distance13) <= abs(distance4) 
				   and abs(distance13) <= abs(distance5)  and abs(distance13) <= abs(distance6)  and abs(distance13) <= abs(distance7)  and abs(distance13) <= abs(distance8)
               and abs(distance13) <= abs(distance9)  and abs(distance13) <= abs(distance10) and abs(distance13) <= abs(distance11) and abs(distance13) <= abs(distance12)
               and abs(distance13) <= abs(distance14) and abs(distance13) <= abs(distance15) and abs(distance13) <= abs(distance16)) then
--					and abs(distance13) <= abs(distance17)
--					and abs(distance13) <= abs(distance18) and abs(distance13) <= abs(distance19) and abs(distance13) <= abs(distance20) and abs(distance13) <= abs(distance21)
--					and abs(distance13) <= abs(distance22) and abs(distance13) <= abs(distance23) and abs(distance13) <= abs(distance24) and abs(distance13) <= abs(distance25)
--					and abs(distance13) <= abs(distance26) and abs(distance13) <= abs(distance27) and abs(distance13) <= abs(distance28) and abs(distance13) <= abs(distance29)
--					and abs(distance13) <= abs(distance30) and abs(distance13) <= abs(distance31) and abs(distance13) <= abs(distance32)) then		
					if (distance13 >= 0) then
					   choose := 12;
					else
					   choose := 11;
					end if;
			   elsif( abs(distance14) <= abs(distance1)  and abs(distance14) <= abs(distance2)  and abs(distance14) <= abs(distance3)  and abs(distance14) <= abs(distance4) 
				   and abs(distance14) <= abs(distance5)  and abs(distance14) <= abs(distance6)  and abs(distance14) <= abs(distance7)  and abs(distance14) <= abs(distance8)
               and abs(distance14) <= abs(distance9)  and abs(distance14) <= abs(distance10) and abs(distance14) <= abs(distance11) and abs(distance14) <= abs(distance12)
               and abs(distance14) <= abs(distance13) and abs(distance14) <= abs(distance15) and abs(distance14) <= abs(distance16)) then
--					and abs(distance14) <= abs(distance17)
--					and abs(distance14) <= abs(distance18) and abs(distance14) <= abs(distance19) and abs(distance14) <= abs(distance20) and abs(distance14) <= abs(distance21)
--					and abs(distance14) <= abs(distance22) and abs(distance14) <= abs(distance23) and abs(distance14) <= abs(distance24) and abs(distance14) <= abs(distance25)
--					and abs(distance14) <= abs(distance26) and abs(distance14) <= abs(distance27) and abs(distance14) <= abs(distance28) and abs(distance14) <= abs(distance29)
--					and abs(distance14) <= abs(distance30) and abs(distance14) <= abs(distance31) and abs(distance14) <= abs(distance32)) then		
				   if (distance14 >= 0) then
					   choose := 13;
					else
					   choose := 12;
					end if;
			   elsif( abs(distance15) <= abs(distance1)  and abs(distance15) <= abs(distance2)  and abs(distance15) <= abs(distance3)  and abs(distance15) <= abs(distance4) 
				   and abs(distance15) <= abs(distance5)  and abs(distance15) <= abs(distance6)  and abs(distance15) <= abs(distance7)  and abs(distance15) <= abs(distance8)
               and abs(distance15) <= abs(distance9)  and abs(distance15) <= abs(distance10) and abs(distance15) <= abs(distance11) and abs(distance15) <= abs(distance12)
               and abs(distance15) <= abs(distance13) and abs(distance15) <= abs(distance14) and abs(distance15) <= abs(distance16)) then
--					and abs(distance15) <= abs(distance17)
--					and abs(distance15) <= abs(distance18) and abs(distance15) <= abs(distance19) and abs(distance15) <= abs(distance20) and abs(distance15) <= abs(distance21)
--					and abs(distance15) <= abs(distance22) and abs(distance15) <= abs(distance23) and abs(distance15) <= abs(distance24) and abs(distance15) <= abs(distance25)
--					and abs(distance15) <= abs(distance26) and abs(distance15) <= abs(distance27) and abs(distance15) <= abs(distance28) and abs(distance15) <= abs(distance29)
--					and abs(distance15) <= abs(distance30) and abs(distance15) <= abs(distance31) and abs(distance15) <= abs(distance32)) then		
					if (distance15 >= 0) then
					   choose := 14;
					else
					   choose := 13;
					end if;		
--			   elsif( abs(distance16) <= abs(distance1)  and abs(distance16) <= abs(distance2)  and abs(distance16) <= abs(distance3)  and abs(distance16) <= abs(distance4) 
--				   and abs(distance16) <= abs(distance5)  and abs(distance16) <= abs(distance6)  and abs(distance16) <= abs(distance7)  and abs(distance16) <= abs(distance8)
--               and abs(distance16) <= abs(distance9)  and abs(distance16) <= abs(distance10) and abs(distance16) <= abs(distance11) and abs(distance16) <= abs(distance12)
--               and abs(distance16) <= abs(distance13) and abs(distance16) <= abs(distance14) and abs(distance16) <= abs(distance15) and abs(distance16) <= abs(distance17)
--					and abs(distance16) <= abs(distance18) and abs(distance16) <= abs(distance19) and abs(distance16) <= abs(distance20) and abs(distance16) <= abs(distance21)
--					and abs(distance16) <= abs(distance22) and abs(distance16) <= abs(distance23) and abs(distance16) <= abs(distance24) and abs(distance16) <= abs(distance25)
--					and abs(distance16) <= abs(distance26) and abs(distance16) <= abs(distance27) and abs(distance16) <= abs(distance28) and abs(distance16) <= abs(distance29)
--					and abs(distance16) <= abs(distance30) and abs(distance16) <= abs(distance31) and abs(distance16) <= abs(distance32)) then		
--					if (distance16 >= 0) then
--					   choose := 15;
--					else
--					   choose := 14;
--					end if;	
--			   elsif( abs(distance17) <= abs(distance1)  and abs(distance17) <= abs(distance2)  and abs(distance17) <= abs(distance3)  and abs(distance17) <= abs(distance4) 
--				   and abs(distance17) <= abs(distance5)  and abs(distance17) <= abs(distance6)  and abs(distance17) <= abs(distance7)  and abs(distance17) <= abs(distance8)
--               and abs(distance17) <= abs(distance9)  and abs(distance17) <= abs(distance10) and abs(distance17) <= abs(distance11) and abs(distance17) <= abs(distance12)
--               and abs(distance17) <= abs(distance13) and abs(distance17) <= abs(distance14) and abs(distance17) <= abs(distance15) and abs(distance17) <= abs(distance16)
--					and abs(distance17) <= abs(distance18) and abs(distance17) <= abs(distance19) and abs(distance17) <= abs(distance20) and abs(distance17) <= abs(distance21)
--					and abs(distance17) <= abs(distance22) and abs(distance17) <= abs(distance23) and abs(distance17) <= abs(distance24) and abs(distance17) <= abs(distance25)
--					and abs(distance17) <= abs(distance26) and abs(distance17) <= abs(distance27) and abs(distance17) <= abs(distance28) and abs(distance17) <= abs(distance29)
--					and abs(distance17) <= abs(distance30) and abs(distance17) <= abs(distance31) and abs(distance17) <= abs(distance32)) then		
--					if (distance17 >= 0) then
--					   choose := 16;
--					else
--					   choose := 15;
--					end if;
--			   elsif( abs(distance18) <= abs(distance1)  and abs(distance18) <= abs(distance2)  and abs(distance18) <= abs(distance3)  and abs(distance18) <= abs(distance4) 
--				   and abs(distance18) <= abs(distance5)  and abs(distance18) <= abs(distance6)  and abs(distance18) <= abs(distance7)  and abs(distance18) <= abs(distance8)
--               and abs(distance18) <= abs(distance9)  and abs(distance18) <= abs(distance10) and abs(distance18) <= abs(distance11) and abs(distance18) <= abs(distance12)
--               and abs(distance18) <= abs(distance13) and abs(distance18) <= abs(distance14) and abs(distance18) <= abs(distance15) and abs(distance18) <= abs(distance16)
--					and abs(distance18) <= abs(distance17) and abs(distance18) <= abs(distance19) and abs(distance18) <= abs(distance20) and abs(distance18) <= abs(distance21)
--					and abs(distance18) <= abs(distance22) and abs(distance18) <= abs(distance23) and abs(distance18) <= abs(distance24) and abs(distance18) <= abs(distance25)
--					and abs(distance18) <= abs(distance26) and abs(distance18) <= abs(distance27) and abs(distance18) <= abs(distance28) and abs(distance18) <= abs(distance29)
--					and abs(distance18) <= abs(distance30) and abs(distance18) <= abs(distance31) and abs(distance18) <= abs(distance32)) then		
--					if (distance18 >= 0) then
--					   choose := 17;
--					else
--					   choose := 16;
--					end if;	
--			   elsif( abs(distance19) <= abs(distance1)  and abs(distance19) <= abs(distance2)  and abs(distance19) <= abs(distance3)  and abs(distance19) <= abs(distance4) 
--				   and abs(distance19) <= abs(distance5)  and abs(distance19) <= abs(distance6)  and abs(distance19) <= abs(distance7)  and abs(distance19) <= abs(distance8)
--               and abs(distance19) <= abs(distance9)  and abs(distance19) <= abs(distance10) and abs(distance19) <= abs(distance11) and abs(distance19) <= abs(distance12)
--               and abs(distance19) <= abs(distance13) and abs(distance19) <= abs(distance14) and abs(distance19) <= abs(distance15) and abs(distance19) <= abs(distance16)
--					and abs(distance19) <= abs(distance17) and abs(distance19) <= abs(distance18) and abs(distance19) <= abs(distance20) and abs(distance19) <= abs(distance21)
--					and abs(distance19) <= abs(distance22) and abs(distance19) <= abs(distance23) and abs(distance19) <= abs(distance24) and abs(distance19) <= abs(distance25)
--					and abs(distance19) <= abs(distance26) and abs(distance19) <= abs(distance27) and abs(distance19) <= abs(distance28) and abs(distance19) <= abs(distance29)
--					and abs(distance19) <= abs(distance30) and abs(distance19) <= abs(distance31) and abs(distance19) <= abs(distance32)) then		
--					if (distance19 >= 0) then
--					   choose := 18;
--					else
--					   choose := 17;
--					end if;	
--			   elsif( abs(distance20) <= abs(distance1)  and abs(distance20) <= abs(distance2)  and abs(distance20) <= abs(distance3)  and abs(distance20) <= abs(distance4) 
--				   and abs(distance20) <= abs(distance5)  and abs(distance20) <= abs(distance6)  and abs(distance20) <= abs(distance7)  and abs(distance20) <= abs(distance8)
--               and abs(distance20) <= abs(distance9)  and abs(distance20) <= abs(distance10) and abs(distance20) <= abs(distance11) and abs(distance20) <= abs(distance12)
--               and abs(distance20) <= abs(distance13) and abs(distance20) <= abs(distance14) and abs(distance20) <= abs(distance15) and abs(distance20) <= abs(distance16)
--					and abs(distance20) <= abs(distance17) and abs(distance20) <= abs(distance18) and abs(distance20) <= abs(distance19) and abs(distance20) <= abs(distance21)
--					and abs(distance20) <= abs(distance22) and abs(distance20) <= abs(distance23) and abs(distance20) <= abs(distance24) and abs(distance20) <= abs(distance25)
--					and abs(distance20) <= abs(distance26) and abs(distance20) <= abs(distance27) and abs(distance20) <= abs(distance28) and abs(distance20) <= abs(distance29)
--					and abs(distance20) <= abs(distance30) and abs(distance20) <= abs(distance31) and abs(distance20) <= abs(distance32)) then		
--					if (distance20 >= 0) then
--					   choose := 19;
--					else
--					   choose := 18;
--					end if;	
--			   elsif( abs(distance21) <= abs(distance1)  and abs(distance21) <= abs(distance2)  and abs(distance21) <= abs(distance3)  and abs(distance21) <= abs(distance4) 
--				   and abs(distance21) <= abs(distance5)  and abs(distance21) <= abs(distance6)  and abs(distance21) <= abs(distance7)  and abs(distance21) <= abs(distance8)
--               and abs(distance21) <= abs(distance9)  and abs(distance21) <= abs(distance10) and abs(distance21) <= abs(distance11) and abs(distance21) <= abs(distance12)
--               and abs(distance21) <= abs(distance13) and abs(distance21) <= abs(distance14) and abs(distance21) <= abs(distance15) and abs(distance21) <= abs(distance16)
--					and abs(distance21) <= abs(distance17) and abs(distance21) <= abs(distance18) and abs(distance21) <= abs(distance19) and abs(distance21) <= abs(distance20)
--					and abs(distance21) <= abs(distance22) and abs(distance21) <= abs(distance23) and abs(distance21) <= abs(distance24) and abs(distance21) <= abs(distance25)
--					and abs(distance21) <= abs(distance26) and abs(distance21) <= abs(distance27) and abs(distance21) <= abs(distance28) and abs(distance21) <= abs(distance29)
--					and abs(distance21) <= abs(distance30) and abs(distance21) <= abs(distance31) and abs(distance21) <= abs(distance32)) then		
--					if (distance21 >= 0) then
--					   choose := 20;
--					else
--					   choose := 19;
--					end if;	
--			   elsif( abs(distance22) <= abs(distance1)  and abs(distance22) <= abs(distance2)  and abs(distance22) <= abs(distance3)  and abs(distance22) <= abs(distance4) 
--				   and abs(distance22) <= abs(distance5)  and abs(distance22) <= abs(distance6)  and abs(distance22) <= abs(distance7)  and abs(distance22) <= abs(distance8)
--               and abs(distance22) <= abs(distance9)  and abs(distance22) <= abs(distance10) and abs(distance22) <= abs(distance11) and abs(distance22) <= abs(distance12)
--               and abs(distance22) <= abs(distance13) and abs(distance22) <= abs(distance14) and abs(distance22) <= abs(distance15) and abs(distance22) <= abs(distance16)
--					and abs(distance22) <= abs(distance17) and abs(distance22) <= abs(distance18) and abs(distance22) <= abs(distance19) and abs(distance22) <= abs(distance20)
--					and abs(distance22) <= abs(distance21) and abs(distance22) <= abs(distance23) and abs(distance22) <= abs(distance24) and abs(distance22) <= abs(distance25)
--					and abs(distance22) <= abs(distance26) and abs(distance22) <= abs(distance27) and abs(distance22) <= abs(distance28) and abs(distance22) <= abs(distance29)
--					and abs(distance22) <= abs(distance30) and abs(distance22) <= abs(distance31) and abs(distance22) <= abs(distance32)) then		
--					if (distance22 >= 0) then
--					   choose := 21;
--					else
--					   choose := 20;
--					end if;
--			   elsif( abs(distance23) <= abs(distance1)  and abs(distance23) <= abs(distance2)  and abs(distance23) <= abs(distance3)  and abs(distance23) <= abs(distance4) 
--				   and abs(distance23) <= abs(distance5)  and abs(distance23) <= abs(distance6)  and abs(distance23) <= abs(distance7)  and abs(distance23) <= abs(distance8)
--               and abs(distance23) <= abs(distance9)  and abs(distance23) <= abs(distance10) and abs(distance23) <= abs(distance11) and abs(distance23) <= abs(distance12)
--               and abs(distance23) <= abs(distance13) and abs(distance23) <= abs(distance14) and abs(distance23) <= abs(distance15) and abs(distance23) <= abs(distance16)
--					and abs(distance23) <= abs(distance17) and abs(distance23) <= abs(distance18) and abs(distance23) <= abs(distance19) and abs(distance23) <= abs(distance20)
--					and abs(distance23) <= abs(distance21) and abs(distance23) <= abs(distance22) and abs(distance23) <= abs(distance24) and abs(distance23) <= abs(distance25)
--					and abs(distance23) <= abs(distance26) and abs(distance23) <= abs(distance27) and abs(distance23) <= abs(distance28) and abs(distance23) <= abs(distance29)
--					and abs(distance23) <= abs(distance30) and abs(distance23) <= abs(distance31) and abs(distance23) <= abs(distance32)) then		
--					if (distance23 >= 0) then
--					   choose := 22;
--					else
--					   choose := 21;
--					end if;
--			   elsif( abs(distance24) <= abs(distance1)  and abs(distance24) <= abs(distance2)  and abs(distance24) <= abs(distance3)  and abs(distance24) <= abs(distance4) 
--				   and abs(distance24) <= abs(distance5)  and abs(distance24) <= abs(distance6)  and abs(distance24) <= abs(distance7)  and abs(distance24) <= abs(distance8)
--               and abs(distance24) <= abs(distance9)  and abs(distance24) <= abs(distance10) and abs(distance24) <= abs(distance11) and abs(distance24) <= abs(distance12)
--               and abs(distance24) <= abs(distance13) and abs(distance24) <= abs(distance14) and abs(distance24) <= abs(distance15) and abs(distance24) <= abs(distance16)
--					and abs(distance24) <= abs(distance17) and abs(distance24) <= abs(distance18) and abs(distance24) <= abs(distance19) and abs(distance24) <= abs(distance20)
--					and abs(distance24) <= abs(distance21) and abs(distance24) <= abs(distance22) and abs(distance24) <= abs(distance23) and abs(distance24) <= abs(distance25)
--					and abs(distance24) <= abs(distance26) and abs(distance24) <= abs(distance27) and abs(distance24) <= abs(distance28) and abs(distance24) <= abs(distance29)
--					and abs(distance24) <= abs(distance30) and abs(distance24) <= abs(distance31) and abs(distance24) <= abs(distance32)) then		
--					if (distance24 >= 0) then
--					   choose := 23;
--					else
--					   choose := 22;
--					end if;	
--			   elsif( abs(distance25) <= abs(distance1)  and abs(distance25) <= abs(distance2)  and abs(distance25) <= abs(distance3)  and abs(distance25) <= abs(distance4) 
--				   and abs(distance25) <= abs(distance5)  and abs(distance25) <= abs(distance6)  and abs(distance25) <= abs(distance7)  and abs(distance25) <= abs(distance8)
--               and abs(distance25) <= abs(distance9)  and abs(distance25) <= abs(distance10) and abs(distance25) <= abs(distance11) and abs(distance25) <= abs(distance12)
--               and abs(distance25) <= abs(distance13) and abs(distance25) <= abs(distance14) and abs(distance25) <= abs(distance15) and abs(distance25) <= abs(distance16)
--					and abs(distance25) <= abs(distance17) and abs(distance25) <= abs(distance18) and abs(distance25) <= abs(distance19) and abs(distance25) <= abs(distance20)
--					and abs(distance25) <= abs(distance21) and abs(distance25) <= abs(distance22) and abs(distance25) <= abs(distance23) and abs(distance25) <= abs(distance24)
--					and abs(distance25) <= abs(distance26) and abs(distance25) <= abs(distance27) and abs(distance25) <= abs(distance28) and abs(distance25) <= abs(distance29)
--					and abs(distance25) <= abs(distance30) and abs(distance25) <= abs(distance31) and abs(distance25) <= abs(distance32)) then		
--					if (distance25 >= 0) then
--					   choose := 24;
--					else
--					   choose := 23;
--					end if;	
--			   elsif( abs(distance26) <= abs(distance1)  and abs(distance26) <= abs(distance2)  and abs(distance26) <= abs(distance3)  and abs(distance26) <= abs(distance4) 
--				   and abs(distance26) <= abs(distance5)  and abs(distance26) <= abs(distance6)  and abs(distance26) <= abs(distance7)  and abs(distance26) <= abs(distance8)
--               and abs(distance26) <= abs(distance9)  and abs(distance26) <= abs(distance10) and abs(distance26) <= abs(distance11) and abs(distance26) <= abs(distance12)
--               and abs(distance26) <= abs(distance13) and abs(distance26) <= abs(distance14) and abs(distance26) <= abs(distance15) and abs(distance26) <= abs(distance16)
--					and abs(distance26) <= abs(distance17) and abs(distance26) <= abs(distance18) and abs(distance26) <= abs(distance19) and abs(distance26) <= abs(distance20)
--					and abs(distance26) <= abs(distance21) and abs(distance26) <= abs(distance22) and abs(distance26) <= abs(distance23) and abs(distance26) <= abs(distance24)
--					and abs(distance26) <= abs(distance25) and abs(distance26) <= abs(distance27) and abs(distance26) <= abs(distance28) and abs(distance26) <= abs(distance29)
--					and abs(distance26) <= abs(distance30) and abs(distance26) <= abs(distance31) and abs(distance26) <= abs(distance32)) then		
--					if (distance26 >= 0) then
--					   choose := 25;
--					else
--					   choose := 24;
--					end if;		
--			   elsif( abs(distance27) <= abs(distance1)  and abs(distance27) <= abs(distance2)  and abs(distance27) <= abs(distance3)  and abs(distance27) <= abs(distance4) 
--				   and abs(distance27) <= abs(distance5)  and abs(distance27) <= abs(distance6)  and abs(distance27) <= abs(distance7)  and abs(distance27) <= abs(distance8)
--               and abs(distance27) <= abs(distance9)  and abs(distance27) <= abs(distance10) and abs(distance27) <= abs(distance11) and abs(distance27) <= abs(distance12)
--               and abs(distance27) <= abs(distance13) and abs(distance27) <= abs(distance14) and abs(distance27) <= abs(distance15) and abs(distance27) <= abs(distance16)
--					and abs(distance27) <= abs(distance17) and abs(distance27) <= abs(distance18) and abs(distance27) <= abs(distance19) and abs(distance27) <= abs(distance20)
--					and abs(distance27) <= abs(distance21) and abs(distance27) <= abs(distance22) and abs(distance27) <= abs(distance23) and abs(distance27) <= abs(distance24)
--					and abs(distance27) <= abs(distance25) and abs(distance27) <= abs(distance26) and abs(distance27) <= abs(distance28) and abs(distance27) <= abs(distance29)
--					and abs(distance27) <= abs(distance30) and abs(distance27) <= abs(distance31) and abs(distance27) <= abs(distance32)) then		
--					if (distance27 >= 0) then
--					   choose := 26;
--					else
--					   choose := 25;
--					end if;	
--			   elsif( abs(distance28) <= abs(distance1)  and abs(distance28) <= abs(distance2)  and abs(distance28) <= abs(distance3)  and abs(distance28) <= abs(distance4) 
--				   and abs(distance28) <= abs(distance5)  and abs(distance28) <= abs(distance6)  and abs(distance28) <= abs(distance7)  and abs(distance28) <= abs(distance8)
--               and abs(distance28) <= abs(distance9)  and abs(distance28) <= abs(distance10) and abs(distance28) <= abs(distance11) and abs(distance28) <= abs(distance12)
--               and abs(distance28) <= abs(distance13) and abs(distance28) <= abs(distance14) and abs(distance28) <= abs(distance15) and abs(distance28) <= abs(distance16)
--					and abs(distance28) <= abs(distance17) and abs(distance28) <= abs(distance18) and abs(distance28) <= abs(distance19) and abs(distance28) <= abs(distance20)
--					and abs(distance28) <= abs(distance21) and abs(distance28) <= abs(distance22) and abs(distance28) <= abs(distance23) and abs(distance28) <= abs(distance24)
--					and abs(distance28) <= abs(distance25) and abs(distance28) <= abs(distance26) and abs(distance28) <= abs(distance27) and abs(distance28) <= abs(distance29)
--					and abs(distance28) <= abs(distance30) and abs(distance28) <= abs(distance31) and abs(distance28) <= abs(distance32)) then		
--					if (distance28 >= 0) then
--					   choose := 27;
--					else
--					   choose := 26;
--					end if;	
--			   elsif( abs(distance29) <= abs(distance1)  and abs(distance29) <= abs(distance2)  and abs(distance29) <= abs(distance3)  and abs(distance29) <= abs(distance4) 
--				   and abs(distance29) <= abs(distance5)  and abs(distance29) <= abs(distance6)  and abs(distance29) <= abs(distance7)  and abs(distance29) <= abs(distance8)
--               and abs(distance29) <= abs(distance9)  and abs(distance29) <= abs(distance10) and abs(distance29) <= abs(distance11) and abs(distance29) <= abs(distance12)
--               and abs(distance29) <= abs(distance13) and abs(distance29) <= abs(distance14) and abs(distance29) <= abs(distance15) and abs(distance29) <= abs(distance16)
--					and abs(distance29) <= abs(distance17) and abs(distance29) <= abs(distance18) and abs(distance29) <= abs(distance19) and abs(distance29) <= abs(distance20)
--					and abs(distance29) <= abs(distance21) and abs(distance29) <= abs(distance22) and abs(distance29) <= abs(distance23) and abs(distance29) <= abs(distance24)
--					and abs(distance29) <= abs(distance25) and abs(distance29) <= abs(distance26) and abs(distance29) <= abs(distance27) and abs(distance29) <= abs(distance28)
--					and abs(distance29) <= abs(distance30) and abs(distance29) <= abs(distance31) and abs(distance29) <= abs(distance32)) then		
--					if (distance29 >= 0) then
--					   choose := 28;
--					else
--					   choose := 27;
--					end if;
--			   elsif( abs(distance30) <= abs(distance1)  and abs(distance30) <= abs(distance2)  and abs(distance30) <= abs(distance3)  and abs(distance30) <= abs(distance4) 
--				   and abs(distance30) <= abs(distance5)  and abs(distance30) <= abs(distance6)  and abs(distance30) <= abs(distance7)  and abs(distance30) <= abs(distance8)
--               and abs(distance30) <= abs(distance9)  and abs(distance30) <= abs(distance10) and abs(distance30) <= abs(distance11) and abs(distance30) <= abs(distance12)
--               and abs(distance30) <= abs(distance13) and abs(distance30) <= abs(distance14) and abs(distance30) <= abs(distance15) and abs(distance30) <= abs(distance16)
--					and abs(distance30) <= abs(distance17) and abs(distance30) <= abs(distance18) and abs(distance30) <= abs(distance19) and abs(distance30) <= abs(distance20)
--					and abs(distance30) <= abs(distance21) and abs(distance30) <= abs(distance22) and abs(distance30) <= abs(distance23) and abs(distance30) <= abs(distance24)
--					and abs(distance30) <= abs(distance25) and abs(distance30) <= abs(distance26) and abs(distance30) <= abs(distance27) and abs(distance30) <= abs(distance28)
--					and abs(distance30) <= abs(distance29) and abs(distance30) <= abs(distance31) and abs(distance30) <= abs(distance32)) then		
--					if (distance30 >= 0) then
--					   choose := 29;
--					else
--					   choose := 28;
--					end if;
--			   elsif( abs(distance31) <= abs(distance1)  and abs(distance31) <= abs(distance2)  and abs(distance31) <= abs(distance3)  and abs(distance31) <= abs(distance4) 
--				   and abs(distance31) <= abs(distance5)  and abs(distance31) <= abs(distance6)  and abs(distance31) <= abs(distance7)  and abs(distance31) <= abs(distance8)
--               and abs(distance31) <= abs(distance9)  and abs(distance31) <= abs(distance10) and abs(distance31) <= abs(distance11) and abs(distance31) <= abs(distance12)
--               and abs(distance31) <= abs(distance13) and abs(distance31) <= abs(distance14) and abs(distance31) <= abs(distance15) and abs(distance31) <= abs(distance16)
--					and abs(distance31) <= abs(distance17) and abs(distance31) <= abs(distance18) and abs(distance31) <= abs(distance19) and abs(distance31) <= abs(distance20)
--					and abs(distance31) <= abs(distance21) and abs(distance31) <= abs(distance22) and abs(distance31) <= abs(distance23) and abs(distance31) <= abs(distance24)
--					and abs(distance31) <= abs(distance25) and abs(distance31) <= abs(distance26) and abs(distance31) <= abs(distance27) and abs(distance31) <= abs(distance28)
--					and abs(distance31) <= abs(distance29) and abs(distance31) <= abs(distance30) and abs(distance31) <= abs(distance32)) then		
--					if (distance31 >= 0) then
--					   choose := 30;
--					else
--					   choose := 29;
--					end if;	
            else
					if (distance16 >= 0) then
					   choose := 15;
					else
					   choose := 14;
					end if;	                				
				end if;
		   elsif(countnumber = 199 and clk = '0') then
			   choose_result <= choose;
		   end if;
		end if;
	end process;
end Behavioral;



