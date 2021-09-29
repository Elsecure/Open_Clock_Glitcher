----------------------------------------------------------------------------------
-- Company: 
-- Engineer: Niloufar Sayadi
-- 
-- Create Date: 09/12/2021 12:20:47 AM
-- Design Name: 
-- Module Name: Phase_machine - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- In mmcm1(clk_wiz_0) and mmcm2(clk_wiz_4), the frequency of VCO is 992MHz ... 
-- Hence, Generating each pulse for a clock period on the PSEN( an input port of MMCM, related to dynamic phase shift) leads to a phase shift to the value of (1/56)*(1/freqVCO)=18 ps
-- According to the clock period(1/32MHz = 31.5 ns), 1 degree phase shifting is equivalent to  a "31.5/360" ns shifting.
-- 31.5/360 =0/0875 ns , 87.5ps/18ps= 4.8 ~5  ==> 1 degree phase shifting occurs by approximately 5 times rising and falling of PSEN in phase shift controller
-- for example when phase_value1 or phase_value2 is 10, the related shifted clock has a phase of 10/5=2 degree

--  phase_value=5   --( /5)--> 1 degree
--  phase_value=10  ---> 2 degree
--  phase_value=15  ---> 3 degree
--  phase_value=20  ---> 4 degree
--  phase_value=25  ---> 5 degree
--  phase_value=30  ---> 6 degree
--  phase_value=35  ---> 7 degree
--  phase_value=40  ---> 8 degree
--  phase_value=45  ---> 9 degree
--  phase_value=50   ---> 10 degree
--  phase_value=55   ---> 11 degree
--  phase_value=60  ---> 12 degree
--  phase_value=65  ---> 13 degree
--  phase_value=70  ---> 14 degree
--  phase_value=75  ---> 15 degree
--  phase_value=80  ---> 16 degree
--  phase_value=85  ---> 17 degree
--  phase_value=90  ---> 18 degree
--  phase_value=95  ---> 19 degree
--  phase_value=100  ---> 20 degree
--  phase_value=105  ---> 21 degree
--  phase_value=110  ---> 22 degree
--  phase_value=115  ---> 23 degree
--  phase_value=120  ---> 24 degree
--  phase_value=125  ---> 25 degree
--  phase_value=130  ---> 26 degree
--  phase_value=135  ---> 27 degree
--  phase_value=140  ---> 28 degree
--  phase_value=145  ---> 29 degree
--  phase_value=150  ---> 30 degree
--  phase_value=155  ---> 31 degree
--  phase_value=160  ---> 32 degree
--  phase_value=165  ---> 33 degree
--  phase_value=170  ---> 34 degree
--  phase_value=175  ---> 35 degree
--  phase_value=180  ---> 36 degree
--  phase_value=185  ---> 37 degree
--  phase_value=190  ---> 38 degree
--  phase_value=195  ---> 39 degree
--  phase_value=200  ---> 40 degree
--  phase_value=205  ---> 41 degree
--  phase_value=210  ---> 42 degree
--  phase_value=215  ---> 43 degree
--  phase_value=220  ---> 44 degree
--  phase_value=225  ---> 45 degree
--  phase_value=230  ---> 46 degree
--  phase_value=235  ---> 47 degree
--  phase_value=240  ---> 48 degree
--  phase_value=245  ---> 49 degree
--  phase_value=250  ---> 50 degree
--  phase_value=255  ---> 51 degree
--  phase_value=260  ---> 52 degree
--  phase_value=265  ---> 53 degree
--  phase_value=270  ---> 54 degree
--  phase_value=275  ---> 55 degree
--  phase_value=280  ---> 56 degree
--  phase_value=285  ---> 57 degree
--  phase_value=290  ---> 58 degree
--  phase_value=295  ---> 59 degree
--  phase_value=300  ---> 60 degree
--  phase_value=305  ---> 61 degree
--  phase_value=310  ---> 62 degree
--  phase_value=315  ---> 63 degree
--  phase_value=320  ---> 64 degree
--  phase_value=325  ---> 65 degree
--  phase_value=330  ---> 66 degree
--  phase_value=335  ---> 67 degree
--  phase_value=340  ---> 68 degree
--  phase_value=345  ---> 69 degree
--  phase_value=350  ---> 70 degree
--  phase_value=355  ---> 71 degree
--  phase_value=360  ---> 72 degree
--  phase_value=365  ---> 73 degree
--  phase_value=370  ---> 74 degree
--  phase_value=375  ---> 75 degree
--  phase_value=380  ---> 76 degree
--  phase_value=385  ---> 77 degree
--  phase_value=390  ---> 78 degree
--  phase_value=395  ---> 79 degree
--  phase_value=400  ---> 80 degree
--  phase_value=405  ---> 81 degree
--  phase_value=410  ---> 82 degree
--  phase_value=415  ---> 83 degree
--  phase_value=420  ---> 84 degree
--  phase_value=425  ---> 85 degree
--  phase_value=430  ---> 86 degree
--  phase_value=435  ---> 87 degree
--  phase_value=440  ---> 88 degree
--  phase_value=445  ---> 89 degree
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Phase_machine is
  Port ( 
        phase_value1: out  STD_LOGIC_VECTOR (9 downto 0);
        phase_value2: out  STD_LOGIC_VECTOR (9 downto 0);
        trig_config : in std_logic;
        clkin: in std_logic;
        reset: in std_logic
         );
end Phase_machine;

architecture Behavioral of Phase_machine is
---------------------------------------------------------------
signal phase1 : integer range 0 to 450:=0;
signal phase2 : integer range 0 to 450:=0;
signal counter_delay : integer range 0 to 10000:=0;
signal flag, inc0_dec1 :std_logic:='0';
signal reg1: std_logic:='0';
signal reg2: std_logic:='0';
signal trig_config_edge: std_logic:='0';
---------------------------------------------------------------
type state  is   (state1, state2, state3, state4, state5, state6, state7, state8, state9, state10, state11, state12);
signal pre_state , next_state : state := state1;
---------------------------------------------------------------
begin
----------------------------------------------------------------------------------
 ---edge_detector for "trig_config" input
 --the state is changed when we have a rising edge in trig_config signal
    
edge_detect:process(clkin)
   begin
      if rising_edge(clkin) then
         reg1  <=  trig_config;
         reg2  <=  reg1  after 16000 ps;
    end if;
   end process;
   trig_config_edge <= reg1 and (not reg2);
----------------------------------------------------------------------------------
process (clkin)
begin
    if rising_edge (clkin) then
        if reset = '1' then
            pre_state <= state1;
            FLAG<= NOT FLAG;
        else
            pre_state <= next_state;            
        end if;
    end if;
end process;

------------
--process (pre_state , clkin, reset)
process (pre_state , flag, reset)
begin
case pre_state is
    when state1 =>
        if (reset='0' ) then
            next_state <= state2;
        else
            next_state <= state3;
        end if;    
     
    when state2 =>
            phase1 <= phase1+5;--- 5*(18 ps)= 90 ps --> (0/090*360)/31.5=1 degree
            phase2 <= phase1+10;
            inc0_dec1<='0';
            next_state <= state5;
            counter_delay<=0;
            
    when state3 =>
             phase1 <=0;
             phase2 <=0;
             next_state <= state1;
   when state4 =>
            phase1 <= phase1+5;--- 5*(18 ps)= 90 ps --> (0/090*360)/31.5=1 degree
            phase2 <= phase2-5;
            inc0_dec1<='1';
            next_state <= state6;
            counter_delay<=0;
            
    when state5 =>
       if (phase2<440) then
         next_state <= state7;
       else
         next_state <=state11;
       end if;
       
     when state6 =>
       if (phase2>phase1) then
         next_state <= state7;
       else
         next_state <=state11;
       end if;
         
    when state7 =>
       if( trig_config_edge='0') then  
            next_state <= state8;
        elsif trig_config_edge='1' then
            if (inc0_dec1='1') then
                next_state <= state10;
            else
              next_state <= state9; 
            end if;
        else
          next_state <= state7;
        end if; 
        
    when state8 =>
          counter_delay <= counter_delay+1;
          next_state    <= state7; 
          
    when state9 =>
         next_state <= state5;
         counter_delay<=0;
         phase2 <= phase2+5;
         inc0_dec1<='0';
         
    when state10 =>
          next_state <= state6;
          counter_delay<=0;
          phase2 <= phase2-5;
          inc0_dec1<='1';
          
    when state11 =>   
        if (phase1<440 and inc0_dec1='1') then
           next_state <= state2;
         elsif (phase1<440 and inc0_dec1='0') then
           next_state <= state4;
        else
            next_state <= state12;
        end if;

     when state12 =>
          phase1<=0;
          phase2<=0;
          next_state <= state1; 
    when others =>
        next_state <= state1;
    
end case;
end process;

----------------------------------------------------------------
phase_value1 <= std_logic_vector(to_unsigned(phase1, 10));
phase_value2 <= std_logic_vector(to_unsigned(phase2, 10));


end Behavioral;
