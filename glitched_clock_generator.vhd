

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
entity glitched_clock_generator is
    Port ( 
            reset       : in STD_LOGIC;-- to reset the components
            clk12mhz    : in STD_LOGIC; -- one of the main clocks of ARTY S7
            trig_config : in  std_logic;
            injector    : in STD_LOGIC;
            divided_main_clk  : out STD_LOGIC; -- just to have a output the same as main frequency signal
            clk_1             : out STD_LOGIC; -- 1st shifted clock to be shown on oscilloscope
            clk_2             : out STD_LOGIC;-- 2nd shifted clock to be shown on oscilloscope
            faulty_output_clk : out STD_LOGIC -- our glitchy clock output to be shown on oscilloscope
         --  faulty_output_clk_before_xor : out STD_LOGIC; -- (used in simulation)
         --  trig_out: out std_logic;
         --  edge_out: out std_logic;        
            );  

      end glitched_clock_generator;

architecture Behavioral of glitched_clock_generator is
signal clk_32 :STD_LOGIC;
signal clk1 :STD_LOGIC;
signal clk2 :STD_LOGIC;
signal xor_in_sig: STD_LOGIC;
signal glitch_out_sig: STD_LOGIC;
signal clk_32MHz_base: STD_LOGIC;
signal trig_out, edge_out: std_logic;
-- First component
component conv_freq is
    Port ( 
            reset : in STD_LOGIC;
            clk_in_divider : in STD_LOGIC;
            clk_out_divider : out STD_LOGIC);        
end component;

-- second component
component MMCM_Dyn_PhaseShift is
  Port ( 
  CLKIN         : in     std_logic;
  RST           : in     std_logic;
  trig_config   : in     std_logic;
  clk_outPhase1 : out    std_logic;
  clk_outPhase2 : out    std_logic;
  clk_32MHz_base: out    std_logic 
  );
end component;
-- third  component
COMPONENT glitcher is
    Port ( 
              enb: in std_logic;
              reset : in STD_LOGIC;
              clk_main : in STD_LOGIC;
              clk_in_glitcher1 : in STD_LOGIC;
              clk_in_glitcher2 : in STD_LOGIC;
              trig_config   : in     std_logic;
              xor_in:out std_logic; 
              trig_out: out std_logic;
              edge_out: out std_logic;
              glitch_out :out std_logic );
end COMPONENT;

begin
    dvd_freq:   conv_freq PORT MAP 
                (reset=> reset, 
                 clk_in_divider => CLK12MHZ,
                 clk_out_divider => clk_32);
                 
    Shift_phase: MMCM_Dyn_PhaseShift  PORT MAP 
                (CLKIN => clk_32,
                 RST   => reset,
                 trig_config => trig_config,
                 clk_outPhase1 => CLK1, 
                 clk_outPhase2 => CLK2,
                 clk_32MHz_base => clk_32MHz_base);
                
    gltch: glitcher PORT MAP 
                ( enb      => injector,
                  reset    => reset, 
                 -- clk_main => clk_65,
                  clk_main => clk_32MHz_base,
                  clk_in_glitcher1 => CLK1, 
                  clk_in_glitcher2 => CLK2, 
                  trig_config=> trig_config,
                  xor_in     => xor_in_sig, 
                  trig_out   => trig_out, 
                  edge_out   => edge_out, 
                  glitch_out => glitch_out_sig);

    clk_1 <= clk1;-- to see first shifted clock in the output
    clk_2 <= clk2; -- to see the second shifted clock in the output
    divided_main_clk <= clk_32MHz_base; -- to see the divided clock in the output
   -- faulty_output_clk_before_xor <= xor_in_sig;
    faulty_output_clk <= glitch_out_sig;
    
end Behavioral;

