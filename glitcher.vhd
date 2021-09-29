----------------------------------------------------------------------------------
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity glitcher is
    Port (    
               enb: in std_logic;
               reset : in STD_LOGIC;
               clk_main : in STD_LOGIC;
               clk_in_glitcher1 : in STD_LOGIC;
               clk_in_glitcher2 : in STD_LOGIC;
               trig_config      : in std_logic;
               xor_in :out std_logic; 
               trig_out: out std_logic;--just for watching in tb
               edge_out: out std_logic;--just for watching in tb
               glitch_out :out std_logic );
end glitcher;

architecture Behavioral of glitcher is
    signal glitch_sig: STD_LOGIC;
    signal internal_sig: STD_LOGIC;
    signal edge,trig,rst,en: std_logic;
    signal reg1: std_logic;
    signal reg2: std_logic;
    signal temp1, temp2, trig_config_edge:std_logic:='0';
    signal to_count:integer :=0;
    signal sig_var :integer :=1;
    type state_type is (idle,count);
    signal next_state, current_state:state_type;
    
begin     

   glitch_sig   <= ((not clk_in_glitcher2) and ( clk_in_glitcher1));-- multiple glitches glitch out
   internal_sig <= ((trig) and (glitch_sig)); -- one glitch out when rising edge trig
  -- internal_sig <= ((clk_main) and (glitch_sig)); -- one glitch out in every clock cycle
   glitch_out   <= ((clk_main) xor (internal_sig)) ; --
   xor_in       <= internal_sig; --send out the faulty clock
   trig_out     <= trig;
   edge_out     <=edge;
 -------------------------------------------------------------------------------------------------------------------------- 
 ---edge_detector
 --------------------------------------------------------------------------------------------------------------------------    
edge_detect:process(clk_main)
   begin
      if rising_edge(clk_main) then
         reg1  <= enb;
         reg2  <= reg1;
    end if;
   end process;
   edge <= reg1 and (not reg2);
   
 -------------------------------------------------------------------------------------------------------------------------- 
 trig_edge_detect:process(clk_main)
   begin
      if rising_edge(clk_main) then
         temp1  <=  trig_config;
         temp2  <=  temp1  after 100 ps;
    end if;
   end process;
   trig_config_edge <= temp1 and (not temp2);
 ---State Machine
 --------------------------------------------------------------------------------------------------------------------------             

   comb_logic:process(current_state,edge,to_count,sig_var)
                    begin
                    case current_state is

                        when idle => 
                            trig<='0';
                            rst<='1';
                            en<='0';
                        if edge='1' then
                           next_state<=count;
                        else
                           next_state<=idle;
                        end if;        
                        
                        when count => 
                            en<='1';
                            rst<='0';
                        if to_count=sig_var then  ----- This is the place that we compare with the variable that is equal to delay
                           next_state<=idle;
                           trig<='1';
                        else
                           next_state<=count;
                           trig<='0';
                        end if;
                        
                        when others =>
                        next_state<=idle;
                        trig<='0';
                        en<='0';
                        rst<='1';
                    end case;
             end process;
             
    synchronous: process(clk_main)
                  begin
                  if (reset='1') then
                      current_state<= idle;
                  elsif rising_edge(clk_main) then
                      current_state<=next_state;
                  end if;
              end process;
             
             
        
 ------------------------------------------------------------------------------------------------------------------------
 -- Counter inside the state machine
 ------------------------------------------------------------------------------------------------------------------------    
   counter:process(clk_main,rst,en)
           variable cnt: integer range 0 to 32;
           begin
           if rising_edge(clk_main) then
              if rst='1' then
                 cnt:=0;
              elsif en='1' and rst='0' then
                 cnt:=cnt+1;
              end if;
           end if;
           to_count<=cnt;
       end process;
 ------------------------------------------------------------------------------------------------------------------------ 
 --Counter which increments every time trigger comes            
 ------------------------------------------------------------------------------------------------------------------------             

      counter2:process(clk_main,edge)
                    begin
                        if rising_edge(clk_main) then
                          if (reset='1' or trig_config_edge='1') then -- we reset the "sig_var" value at the begining of a new config
                              sig_var<=0;
                          elsif edge='1' then
                              sig_var<=sig_var+1;                          
                           end if;
                        end if;   
                    end process;
 ----------------------------------------------------------------------------------------------------------------------             
                   
                    
   end Behavioral;   
   

 

 
 