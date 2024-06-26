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
--|
--| ALU OPCODES:
--|
--|  Instruction | Opcode | Function |
--| ------------ | ------ | -------- |
--| AND          | 000    | A AND B  |
--| OR           | 001    | A OR B   |
--| SHIFT_L      | 010    | <<A      |
--| ADD          | 011    | A + B    |
--| AND (extra)  | 100    | A AND B  |
--| OR (extra)   | 101    | A OR B   |
--| SHIFT_R      | 110    | A>>      |
--| SUB          | 111    | A - B    |
--|
--|
--|
--|
--+----------------------------------------------------------------------------
library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;


entity ALU is
    Port( i_op : in std_logic_vector(2 downto 0);
          i_B : in std_logic_vector(7 downto 0);
          i_A : in std_logic_vector(7 downto 0);
          o_result : out std_logic_vector(7 downto 0);
          o_flags : out std_logic_vector(2 downto 0));
end ALU;

architecture behavioral of ALU is 
  
	-- declare components and signals
    component eightBitAdder is
      Port ( i_A    : in std_logic_vector (7 downto 0);
             i_B    : in std_logic_vector (7 downto 0);
             i_Cin  : in std_logic;
             o_S    : out std_logic_vector (7 downto 0);
             o_Cout : out std_logic
           );
    end component eightBitAdder;
    
--    signal
    signal w_flags : std_logic_vector (2 downto 0) := "000";
    signal w_Cout : std_logic := '0';
    signal w_result : std_logic_vector (7 downto 0) := "00000000";
    signal w_mathB : std_logic_vector (7 downto 0) := "00000000";
    signal w_subtract : std_logic_vector (7 downto 0) := "00000000";
    
    
begin
	-- PORT MAPS ----------------------------------------
    eightbitadd_inst : eightBitAdder
        Port map (
	       i_A    => i_A,
	       i_B    => w_mathB,
	       i_Cin  => i_op(2),
	       o_S    => w_result,
	       o_Cout => w_Cout
	   );
	
	-- CONCURRENT STATEMENTS ----------------------------
	o_result <= w_result;
	o_flags(2) <= w_Cout; -- carry flag
	w_subtract <= not i_B;
	-- MUXES --------------------------------------------
	w_mathB <= i_B when i_op(2) = '0' else
	           w_subtract;
	-- ZERO FLAG --
	o_flags(1) <= (    not w_result(7) and
	                   not w_result(6) and
	                   not w_result(5) and
	                   not w_result(4) and
	                   not w_result(3) and
	                   not w_result(2) and
	                   not w_result(1) and
	                   not w_result(0)); 
	o_flags(0) <= w_result(7);
	
	
end behavioral;
