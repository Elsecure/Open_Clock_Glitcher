----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 09/11/2021 03:40:58 PM
-- Design Name: 
-- Module Name: MMCM_Dyn_PhaseShift - Behavioral
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
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity MMCM_Dyn_PhaseShift is
  Port ( 
  CLKIN         : in     std_logic;
  RST           : in     std_logic;
  trig_config   : in     std_logic;
  clk_outPhase1 : out    std_logic;
  clk_outPhase2 : out    std_logic;
  clk_32MHz_base : out    std_logic
  );
end MMCM_Dyn_PhaseShift;

architecture Behavioral of MMCM_Dyn_PhaseShift is


component clk_wiz_0
port
 (-- Clock in ports
  -- Clock out ports
  clk_out1          : out    std_logic;
  -- Dynamic phase shift ports
  psclk             : in     std_logic;
  psen              : in     std_logic;
  psincdec          : in     std_logic;
  psdone            : out    std_logic;
  -- Status and control signals
  reset             : in     std_logic;
  locked            : out    std_logic;
  clk_in1           : in     std_logic
 );
end component;
----------------
component clk_wiz_4
port
 (-- Clock in ports
  -- Clock out ports
  clk_out1          : out    std_logic;
  clk_out2          : out    std_logic;
  -- Dynamic phase shift ports
  psclk             : in     std_logic;
  psen              : in     std_logic;
  psincdec          : in     std_logic;
  psdone            : out    std_logic;
  -- Status and control signals
  reset             : in     std_logic;
  locked            : out    std_logic;
  clk_in1           : in     std_logic
 );
end component;
--------------------
component phase_shift_controller is
  Port ( 
  mmcm_psincdec: out STD_LOGIC;
  mmcm_psen    : out STD_LOGIC;
  mmcm_locked : in  STD_LOGIC;
  mmcm_psdone  : in  STD_LOGIC;
  reset        : in  STD_LOGIC;
  ps_clk       : in  STD_LOGIC;
  phase_val    : in  STD_LOGIC_VECTOR (9 downto 0)
  );
end component;
---------------------
component Phase_machine is
  Port ( 
        phase_value1:out  STD_LOGIC_VECTOR (9 downto 0);
        phase_value2:out  STD_LOGIC_VECTOR (9 downto 0);
        trig_config : in std_logic;
        clkin: in std_logic;
        reset: in std_logic
         );
end component;

signal  s_phase_value1,s_phase_value2 :   STD_LOGIC_VECTOR (9 downto 0);
signal  locked1,locked2,locked3  :   std_logic;
signal  psen1, psen2             :   std_logic;
signal  psdone1,psdone2, psdone3 :   std_logic;
signal  psincdec1, psincdec2     :   std_logic;
signal  s_psincdec1, s_psincdec2 :   std_logic;
signal  s_clk_32MHz_base         :   std_logic;

begin

mmcm1 : clk_wiz_0
   port map ( 
  -- Clock out ports  
   clk_out1 => clk_outPhase1,
  -- Dynamic phase shift ports                 
   psclk => clkin,
   psen => psen1,
   psincdec => psincdec1,
   psdone => psdone1,
  -- Status and control signals                
   reset => RST,
   locked => locked1,
   -- Clock in ports
   clk_in1 => clkin
 );
 
mmcm2: clk_wiz_4
   port map ( 
  -- Clock out ports  
   clk_out1 => clk_outPhase2,
   clk_out2 => s_clk_32MHz_base,
  -- Dynamic phase shift ports                 
   psclk => clkin,
   psen => psen2,
   psincdec => psincdec2,
   psdone => psdone2,
  -- Status and control signals                
   reset => rst,
   locked => locked2,
   -- Clock in ports
   clk_in1 => clkin
 );

 ------------------------
 dps_ins1 : phase_shift_controller
  Port map( 
  mmcm_psen    => psen1,
  mmcm_locked  => locked1,
  mmcm_psdone  => psdone1,
  mmcm_psincdec=> psincdec1,
  reset        => rst,
  ps_clk       => clkin,
  phase_val    => s_phase_value1
  );
  
   ------------------------
 dps_ins2 : phase_shift_controller
  Port map( 
  mmcm_psen    => psen2,
  mmcm_locked  => locked2,
  mmcm_psdone  => psdone2,
  mmcm_psincdec=> psincdec2,
  reset        => rst,
  ps_clk       => clkin,
  phase_val    => s_phase_value2
  );
   ------------------------
 phase_machine1 : phase_machine
  Port map( 
        phase_value1=> s_phase_value1,
        phase_value2=> s_phase_value2,
        trig_config => trig_config,
        --clkin=> clkin,
        clkin=> s_clk_32MHz_base,
        reset=>rst 
  );
  
clk_32MHz_base <= s_clk_32MHz_base;

end Behavioral;
