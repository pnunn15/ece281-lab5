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
        led     :   out std_logic_vector (15 downto 0); -- flags
        seg     :   out std_logic_vector (6 downto 0); -- 7-segment display cathodes
        an      :   out std_logic_vector (3 downto 0) -- 7-segment display anodes
    );
        
end top_basys3;

architecture top_basys3_arch of top_basys3 is 
  
	-- declare components
	component clock_divider is
        generic (constant k_DIV : natural := 2);
        Port ( i_clk, i_reset : in STD_LOGIC;
               o_clk          : out STD_LOGIC);
    end component clock_divider;
    
    component controller_fsm is
        Port ( i_reset : in STD_LOGIC;
               i_adv   : in STD_LOGIC;
               o_cycle : out STD_LOGIC_VECTOR(3 downto 0));
    end component controller_fsm;
    
    component ALU is
        Port( i_op     : in std_logic_vector (2 downto 0);
              i_B      : in std_logic_vector (7 downto 0);
              i_A      : in std_logic_vector (7 downto 0);
              o_result : out std_logic_vector (7 downto 0);
              o_flags  : out std_logic_vector (2 downto 0));
    end component ALU;
    
--    component twoscomp_decimal is
--        Port ( i_bin  : in std_logic_vector (7 downto 0);
--               o_neg  : out std_logic_vector (3 downto 0);
--               o_hund : out std_logic_vector (3 downto 0);
--               o_tens : out std_logic_vector (3 downto 0);
--               o_ones : out std_logic_vector (3 downto 0));
--    end component twoscomp_decimal;
    
    component TDM4 is
        generic ( constant k_WIDTH : natural  := 4); -- bits in input and output
        Port ( i_clk        : in  STD_LOGIC;
               i_reset      : in  STD_LOGIC; -- asynchronous
--               i_D3         : in  STD_LOGIC_VECTOR (k_WIDTH - 1 downto 0);
--               i_D2         : in  STD_LOGIC_VECTOR (k_WIDTH - 1 downto 0);
               i_D1         : in  STD_LOGIC_VECTOR (k_WIDTH - 1 downto 0);
               i_D0         : in  STD_LOGIC_VECTOR (k_WIDTH - 1 downto 0);
               o_data       : out STD_LOGIC_VECTOR (k_WIDTH - 1 downto 0);
               o_sel        : out STD_LOGIC_VECTOR (3 downto 0));    -- selected data line (one-cold)
    end component TDM4;
    
    component sevenSegDecoder is
        Port ( i_D : in STD_LOGIC_VECTOR (3 downto 0);
               o_S : out STD_LOGIC_VECTOR (6 downto 0));
    end component sevenSegDecoder;
    
--    component reg is
--        Port ( i_clk    : in STD_LOGIC;
--               f_Q_next : in STD_LOGIC_VECTOR (7 downto 0);
--               i_reset  : in STD_LOGIC;
--               f_Q      : inout STD_LOGIC_VECTOR (7 downto 0));
--    end component reg;
    
	-- signals    
    signal w_cycle : STD_LOGIC_VECTOR (3 downto 0) := "0000";
    signal w_Q1 : STD_LOGIC_VECTOR (7 downto 0) := "00000000";
    signal w_Q0 : STD_LOGIC_VECTOR (7 downto 0) := "00000000";
    signal w_flags : STD_LOGIC_VECTOR (2 downto 0) := "000";
    signal w_result : STD_LOGIC_VECTOR (7 downto 0) := "00000000";
    signal w_output : STD_LOGIC_VECTOR (7 downto 0) := "00000000";
    signal w_clk : STD_LOGIC := '0';
    signal w_dOff : STD_LOGIC := '1';
    signal w_ssd : STD_LOGIC_VECTOR (3 downto 0) := "0000";
    signal w_sel : STD_LOGIC_VECTOR (3 downto 0) := "0000";
    signal w_reg1_clk : STD_LOGIC := '1';
    signal w_reg0_clk : STD_LOGIC := '1';
    signal f_Q1, f_Q1_next : std_logic_vector(7 downto 0) := "00000000";
    signal f_Q0, f_Q0_next : std_logic_vector(7 downto 0) := "00000000";
--    signal w_sign : STD_LOGIC_VECTOR (3 downto 0) := "0000";
--    signal w_hund : STD_LOGIC_VECTOR (3 downto 0) := "0000";
--    signal w_tens : STD_LOGIC_VECTOR (3 downto 0) := "0000";
--    signal w_ones : STD_LOGIC_VECTOR (3 downto 0) := "0000";
    
begin
	-- PORT MAPS ----------------------------------------
    clkdiv_inst : clock_divider
        generic map ( k_DIV => 208333) --240 Hz clock from 100 MHz
        Port map (                          
           i_clk   => clk,
           i_reset => btnU,
           o_clk   => w_clk
        );
	
	cnt_inst : controller_fsm
        Port map (
           i_reset => btnU,
           i_adv   => btnC,
           o_cycle => w_cycle
        );
        
    alu_inst : ALU
        Port map (
           i_op     => sw(2 downto 0),
           i_B      => w_Q0,
           i_A      => w_Q1,
           o_result => w_result,
           o_flags  => w_flags
        );
   
--    twscmpdec_inst:  twoscomp_decimal
--        Port map (
--           i_bin => w_output,
--           o_neg => w_sign,
--           o_hund => w_hund,
--           o_tens => w_tens,
--           o_ones => w_ones
--        );
        
    tdm4_inst : TDM4
        Port map (
            i_clk        => w_clk,
            i_reset      => btnU,
--            i_D3         => w_sign,
--            i_D2         => w_hund,
            i_D1         => w_output(7 downto 4),
            i_D0         => w_output(3 downto 0),
            o_data       => w_ssd,
            o_sel        => w_sel
        );

    ssd_inst : sevenSegDecoder
        Port map (
            i_D => w_ssd,
            o_S => seg
        );
        
--    reg1_inst : reg
--        Port map (
--            i_clk    => w_reg1_clk,
--            f_Q_next => sw(10 downto 3),
--            i_reset  => btnU,
--            f_Q      => w_Q1
--        );
        
--    reg0_inst : reg
--        Port map (
--            i_clk    => w_reg0_clk,
--            f_Q_next => sw(10 downto 3),
--            i_reset  => btnU,
--            f_Q      => w_Q0
--        );
        
	-- CONCURRENT STATEMENTS ----------------------------
	w_dOff <= (w_cycle(2) and w_cycle(1)) and w_cycle(0);
	w_reg1_clk <= not w_cycle(2);
	w_reg0_clk <= not w_cycle(1);
	led(15 downto 13) <= w_flags;
	led(3 downto 0) <= w_cycle;
	w_Q1 <= f_Q1;
	w_Q0 <= f_Q0;
	-- NEXT STATE LOGIC ---------------------------------
    f_Q1_next <= sw(10 downto 3);
	f_Q0_next <= sw(10 downto 3);
	
	
	-- MUXES --------------------------------------------
	an <= w_sel when w_dOff = '0' else
	      "1111";
	w_output <= w_Q1 when w_cycle = "1011" else
	            w_Q0 when w_cycle = "1101" else
	            w_result when w_cycle = "1110" else
	            "00000000";
	            
	-- GROUND UNUSED LEDs -------------------------------
	led(12 downto 4) <= (others => '0');    
	
	-- PROCESSES ----------------------------------------
	reg1_proc : process (w_cycle(2))
	   begin
	       if btnU = '1' then
	           f_Q1 <= "00000000";
	       elsif (w_cycle(2) = '0') then
	           f_Q1 <= f_Q1_next;
	       end if;
	end process reg1_proc;
	
	reg0_proc : process (w_cycle(1))
        begin
           if btnU = '1' then
               f_Q0 <= "00000000";
           elsif (w_cycle(1) = '0') then
               f_Q0 <= f_Q0_next;
           end if;
    end process reg0_proc;
end top_basys3_arch;
