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


entity top_basys3 is
    Port(
        -- inputs
        clk     :   in std_logic; -- native 100MHz FPGA clock
        btnU    :   in std_logic; -- master reset
        btnC    :   in std_logic; -- advance cycle
        sw      :   in std_logic_vector(10 downto 0);
        
        -- outputs
        led     :   out std_logic_vector(15 downto 13);
        seg     :   out std_logic_vector(6 downto 0);
        an      :   out std_logic_vector(3 downto 0)
    );
        
end top_basys3;

architecture top_basys3_arch of top_basys3 is 
  
	-- declare components
	component clock_divider is
        generic (constant k_DIV : natural := 2);
        Port ( i_clk, i_reset : in STD_LOGIC;
               o_clk : out STD_LOGIC);
    end component clock_divider;
    
    component controller_fsm is
        Port ( i_reset : in STD_LOGIC;
               i_adv : in STD_LOGIC;
               o_cycle : out STD_LOGIC);
    end component controller_fsm;
    
    component ALU is
        Port( i_op : in std_logic_vector(2 downto 0);
              i_B : in std_logic_vector(7 downto 0);
              i_A : in std_logic_vector(7 downto 0);
              o_result : out std_logic_vector(7 downto 0);
              o_flags : out std_logic_vector(2 downto 0));
    end component ALU;
    
    component twoscomp_decimal is
        Port ( i_binary: in std_logic_vector(7 downto 0);
               o_negative: out std_logic;
               o_hundreds: out std_logic_vector(3 downto 0);
               o_tens: out std_logic_vector(3 downto 0);
               o_ones: out std_logic_vector(3 downto 0));
    end component twoscomp_decimal;
    
    component TDM4 is
        generic ( constant k_WIDTH : natural  := 4); -- bits in input and output
        Port ( i_clk        : in  STD_LOGIC;
               i_reset        : in  STD_LOGIC; -- asynchronous
               i_D3         : in  STD_LOGIC_VECTOR (k_WIDTH - 1 downto 0);
               i_D2         : in  STD_LOGIC_VECTOR (k_WIDTH - 1 downto 0);
               i_D1         : in  STD_LOGIC_VECTOR (k_WIDTH - 1 downto 0);
               i_D0         : in  STD_LOGIC_VECTOR (k_WIDTH - 1 downto 0);
               o_data        : out STD_LOGIC_VECTOR (k_WIDTH - 1 downto 0);
               o_sel        : out STD_LOGIC_VECTOR (3 downto 0));    -- selected data line (one-cold)
    end component TDM4;
    
    component sevenSegDecoder is
        Port ( i_D : in STD_LOGIC_VECTOR (3 downto 0);
               o_S : out STD_LOGIC_VECTOR (6 downto 0));
    end component sevenSegDecoder;
	-- signals    
  
begin
	-- PORT MAPS ----------------------------------------

	
	
	-- CONCURRENT STATEMENTS ----------------------------
	
	
	
end top_basys3_arch;
