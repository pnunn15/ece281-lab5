--+----------------------------------------------------------------------------
--| 
--| COPYRIGHT 2017 United States Air Force Academy All rights reserved.
--| 
--| United States Air Force Academy     __  _______ ___    _________ 
--| Dept of Electrical &               / / / / ___//   |  / ____/   |
--| Computer Engineering              / / / /\__ \/ /| | / /_  / /| |
--| 2354 Fairchild Drive Ste 2F6     / /_/ /___/ / ___ |/ __/ / ___ |
--| USAF Academy, CO 80840           \____//____/_/  |_/_/   /_/  |_|
--| 
--| ---------------------------------------------------------------------------
--|
--| FILENAME      : halfAdder.vhd
--| AUTHOR(S)     : Payton Nunn
--| CREATED       : 01/25/2024
--| DESCRIPTION   : This file implements a one bit half adder.
--|
--| DOCUMENTATION : None
--|
--+----------------------------------------------------------------------------
--|
--| REQUIRED FILES :
--|
--|    Libraries : ieee
--|    Packages  : std_logic_1164, numeric_std, unisim
--|    Files     : LIST ANY DEPENDENCIES
--|
--+----------------------------------------------------------------------------
--|
--| NAMING CONVENSIONS :
--|
--|    xb_<port name>           = off-chip bidirectional port ( _pads file )
--|    xi_<port name>           = off-chip input port         ( _pads file )
--|    xo_<port name>           = off-chip output port        ( _pads file )
--|    b_<port name>            = on-chip bidirectional port
--|    i_<port name>            = on-chip input port
--|    o_<port name>            = on-chip output port
--|    c_<signal name>          = combinatorial signal
--|    f_<signal name>          = synchronous signal
--|    ff_<signal name>         = pipeline stage (ff_, fff_, etc.)
--|    <signal name>_n          = active low signal
--|    w_<signal name>          = top level wiring signal
--|    g_<generic name>         = generic
--|    k_<constant name>        = constant
--|    v_<variable name>        = variable
--|    sm_<state machine type>  = state machine type definition
--|    s_<signal name>          = state name
--|
--+----------------------------------------------------------------------------
library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;


entity sevenSegDecoder is
    Port ( i_D : in STD_LOGIC_VECTOR (3 downto 0);
           o_S : out STD_LOGIC_VECTOR (6 downto 0));
end sevenSegDecoder;

architecture sevenSegDecoder_arch of sevenSegDecoder is

begin
    -- this is where you would map ports for any component instantiations if you needed to

	-- *concurrent* signal assignments
	o_S(0) <= '1' when ( (i_D = x"1") or
	                     (i_D = x"4") or
	                     (i_D = x"B") or
	                     (i_D = x"C") or
	                     (i_D = x"D") ) else '0';
	o_S(1) <= '1' when ( (i_D = x"5") or
                         (i_D = x"6") or
                         (i_D = x"B") or
                         (i_D = x"C") or
                         (i_D = x"E") or
                         (i_D = x"F") ) else '0';
    o_S(2) <= '1' when ( (i_D = x"2") or
                         (i_D = x"C") or
                         (i_D = x"E") or
                         (i_D = x"F") ) else '0';
	o_S(3) <= '1' when ( (i_D = x"1") or
                         (i_D = x"4") or
                         (i_D = x"7") or
                         (i_D = x"9") or
                         (i_D = x"A") or
                         (i_D = x"F") ) else '0';
    o_S(4) <= '1' when ( (i_D = x"1") or
                         (i_D = x"3") or
                         (i_D = x"4") or
                         (i_D = x"5") or
                         (i_D = x"7") or
                         (i_D = x"9") ) else '0';
    o_S(5) <= '1' when ( (i_D = x"1") or
                         (i_D = x"2") or
                         (i_D = x"3") or
                         (i_D = x"7") or
                         (i_D = x"C") or
                         (i_D = x"D") ) else '0';
    o_S(6) <= '1' when ( (i_D = x"0") or
                         (i_D = x"1") or
                         (i_D = x"7") ) else '0';

end sevenSegDecoder_arch;
