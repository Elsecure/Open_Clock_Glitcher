----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 09/01/2021 03:43:48 PM
-- Design Name: 
-- Module Name: up_down_counter - Behavioral
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
use IEEE.NUMERIC_STD.ALL;
----------------------------------------------------------------------------------
entity up_down_counter is
    Port ( 
           ps_clk       : in  STD_LOGIC;
           updown       : in  STD_LOGIC;
           counter_en   : in  STD_LOGIC;
           reset        : in  STD_LOGIC;
           counter_val  : out STD_LOGIC_VECTOR (9 downto 0)
           );
end up_down_counter;
----------------------------------------------------------------------------------
architecture Behavioral of up_down_counter is
----------------------------------------------------------------------------------
begin
----------------------------------------------------------------------------------
process (ps_clk)
variable counter   : unsigned (9 downto 0) := (others => '0');

begin
    if rising_edge (ps_clk) then
        if reset = '1' then
            counter := (others => '0');
        elsif counter_en = '1' then
            if counter = 440 then --                 
                counter := (others => '0');
            elsif updown = '0'  then    
                counter := counter + 1;
            else
                counter := counter - 1; 
            end if;
        else 
            counter := counter;
        end if;
    end if;
counter_val <= std_logic_vector (counter);   
end process;
----------------------------------------------------------------------------------
end Behavioral;

