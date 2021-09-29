----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 09/02/2021 03:41:47 PM
-- Design Name: 
-- Module Name: phase_shift_controller - Behavioral
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
-- 
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
----------------------------------------------------------------------------------
entity phase_shift_controller is
  Port ( 
  mmcm_psincdec: out STD_LOGIC;
  mmcm_psen    : out STD_LOGIC;
  mmcm_locked  : in  STD_LOGIC;
  mmcm_psdone  : in  STD_LOGIC;
  reset        : in  STD_LOGIC;
  ps_clk       : in  STD_LOGIC;
  phase_val    : in  STD_LOGIC_VECTOR (9 downto 0)
  );
end phase_shift_controller;
----------------------------------------------------------------------------------
architecture Behavioral of phase_shift_controller is
----------------------------------------------------------------------------------
component up_down_counter is
    Port ( 
           ps_clk       : in  STD_LOGIC;
           updown       : in  STD_LOGIC;
           counter_en   : in  STD_LOGIC;
           reset        : in  STD_LOGIC;
      --     updown56     : out std_logic;
           counter_val  : out STD_LOGIC_VECTOR (9 downto 0)
           );
end component;
----------------------------------------------------------------------------------
signal updown         :   std_logic := '0';
signal updown56         :   std_logic := '0';
signal en             :   std_logic := '0';
signal counter_val    :   std_logic_vector (9 downto 0) := (others => '0');
----------------------------------------------------------------------------------
type state  is   (idle , ps_enable , ps_done);
signal pre_state , nxt_state : state := idle;
----------------------------------------------------------------------------------
begin
----------------------------------------------------------------------------------
counter_ins : up_down_counter
    Port map( 
           ps_clk       => ps_clk,
           updown       => updown,
           counter_en   => mmcm_psdone,
           reset        => reset,
       --    updown56     => updown56,
           counter_val  => counter_val
           );
----------------------------------------------------------------------------------
en <= '0' when (counter_val = phase_val) else '1';
----------------------------------------------------------------------------------
--updown <= '0' when (counter_val < phase_val) else '0' when updown56='1' else '1' ;
updown <= '0' when (counter_val < phase_val)  else '1' ;
mmcm_psincdec <= not updown;
----------------------------------------------------------------------------------
process (ps_clk)
begin
    if rising_edge (ps_clk) then
        if reset = '1' then
            pre_state <= idle;
        elsif (mmcm_locked = '1') then
            pre_state <= nxt_state;            
        end if;
    end if;
end process;

process (pre_state , en , mmcm_psdone)
begin
case pre_state is
    when idle =>
        mmcm_psen <= '0';
        if en = '1' then
            nxt_state <= ps_enable;
            
        else 
            nxt_state <= idle;
        end if;
        
    when ps_enable =>
        mmcm_psen <= '1';
        nxt_state <= ps_done;
        
    when ps_done =>
        mmcm_psen <= '0';
        if mmcm_psdone = '1' then
            nxt_state <= idle;
        else
            nxt_state <= ps_done;
        end if;
        
    when others =>
        mmcm_psen <= '0';
        nxt_state <= idle;
    
end case;
end process;
----------------------------------------------------------------------------------
end Behavioral;
----------------------------------------------------------------------------------