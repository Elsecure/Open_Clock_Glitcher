----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 09/15/2021 02:06:27 AM
-- Design Name: 
-- Module Name: conv_freq - Behavioral
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity conv_freq is
    Port ( 
            reset : in STD_LOGIC;
            clk_in_divider : in STD_LOGIC;
            clk_out_divider : out STD_LOGIC);
end conv_freq;

architecture Behavioral of conv_freq is
component clk_wiz_3 is
port (  clk_out1 : out STD_LOGIC;
        reset    : in  STD_LOGIC;
        clk_in1  : in  STD_LOGIC);
end component;

begin

U_12to16: clk_wiz_3 PORT MAP (clk_out_divider, reset, clk_in_divider);

end Behavioral;
