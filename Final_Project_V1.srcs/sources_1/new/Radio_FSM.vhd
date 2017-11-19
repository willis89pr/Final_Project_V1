----------------------------------------------------------------------------------
-- Engineer: Willis Berrios & Brandon Hurst
-- 
-- Create Date: 11/18/2017 03:51:40 PM
-- Design Name: 3-Bit Transceiver
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

entity Radio_FSM is
    Port ( SW : in STD_LOGIC_VECTOR (2 downto 0);
           Btn : in STD_LOGIC_VECTOR (1 downto 0);
           TMsg : in STD_LOGIC_VECTOR (2 downto 0);
           RMsg : in STD_LOGIC_VECTOR (2 downto 0));
end Radio_FSM;

architecture Behavioral of Radio_FSM is

component spi_master IS
  GENERIC(
    slaves  : INTEGER := 4;  --number of spi slaves
    d_width : INTEGER := 2); --data bus width
  PORT(
    clock   : IN     STD_LOGIC;                             --system clock
    reset_n : IN     STD_LOGIC;                             --asynchronous reset
    enable  : IN     STD_LOGIC;                             --initiate transaction
    cpol    : IN     STD_LOGIC;                             --spi clock polarity
    cpha    : IN     STD_LOGIC;                             --spi clock phase
    cont    : IN     STD_LOGIC;                             --continuous mode command
    clk_div : IN     INTEGER;                               --system clock cycles per 1/2 period of sclk
    addr    : IN     INTEGER;                               --address of slave
    tx_data : IN     STD_LOGIC_VECTOR(d_width-1 DOWNTO 0);  --data to transmit
    miso    : IN     STD_LOGIC;                             --master in, slave out
    sclk    : BUFFER STD_LOGIC;                             --spi clock
    ss_n    : BUFFER STD_LOGIC_VECTOR(slaves-1 DOWNTO 0);   --slave select
    mosi    : OUT    STD_LOGIC;                             --master out, slave in
    busy    : OUT    STD_LOGIC;                             --busy / data ready signal
    rx_data : OUT    STD_LOGIC_VECTOR(d_width-1 DOWNTO 0)); --data received
END component spi_master;

component spi_slave IS
  GENERIC(
    cpol    : STD_LOGIC := '0';  --spi clock polarity mode
    cpha    : STD_LOGIC := '0';  --spi clock phase mode
    d_width : INTEGER := 8);     --data width in bits
  PORT(
    sclk         : IN     STD_LOGIC;  --spi clk from master
    reset_n      : IN     STD_LOGIC;  --active low reset
    ss_n         : IN     STD_LOGIC;  --active low slave select
    mosi         : IN     STD_LOGIC;  --master out, slave in
    rx_req       : IN     STD_LOGIC;  --'1' while busy = '0' moves data to the rx_data output
    st_load_en   : IN     STD_LOGIC;  --asynchronous load enable
    st_load_trdy : IN     STD_LOGIC;  --asynchronous trdy load input
    st_load_rrdy : IN     STD_LOGIC;  --asynchronous rrdy load input
    st_load_roe  : IN     STD_LOGIC;  --asynchronous roe load input
    tx_load_en   : IN     STD_LOGIC;  --asynchronous transmit buffer load enable
    tx_load_data : IN     STD_LOGIC_VECTOR(d_width-1 DOWNTO 0);  --asynchronous tx data to load
    trdy         : BUFFER STD_LOGIC := '0';  --transmit ready bit
    rrdy         : BUFFER STD_LOGIC := '0';  --receive ready bit
    roe          : BUFFER STD_LOGIC := '0';  --receive overrun error bit
    rx_data      : OUT    STD_LOGIC_VECTOR(d_width-1 DOWNTO 0) := (OTHERS => '0');  --receive register output to logic
    busy         : OUT    STD_LOGIC := '0';  --busy signal to logic ('1' during transaction)
    miso         : OUT    STD_LOGIC := 'Z'); --master in, slave out
END component spi_slave;

component sseg_dec is
    Port (ALU_VAL : in std_logic_vector(7 downto 0); 
		  SIGN    : in std_logic;
		  VALID   : in std_logic;
          CLK     : in std_logic;
          DISP_EN : out std_logic_vector(3 downto 0);
          SEGMENTS: out std_logic_vector(7 downto 0));
end component sseg_dec;

begin

-- instantiation of the master component to handle SPI
    master : spi_master
      generic map ( slaves  => 1,
                    d_width => 8)                                 -- *** I made this number up. We need to determine to correct value ***
      port map ( clock   <=  clock   --system clock
                 reset_n <= reset_n  --asynchronous reset    
                 enable  <= enable,  --initiate transaction
                 cpol    <= cpol,    --spi clock polarity
                 cpha    <= cpha,    --spi clock phase
                 cont    <= cont,    --continuous mode command
                 clk_div <= clk_div  --system clock cycles per 1/2 period of sclk
                 addr    <= addr     --address of slave
                 tx_data <= tx_data  --data to transmit
                 miso    <= miso     --master in, slave out
                 sclk    <= sclk     --spi clock
                 ss_n    <= ss_n     --slave select
                 mosi    <= mosi     --master out, slave in
                 busy    <= busy     --busy / data ready signal
                 rx_data <= rx_data  --data received
      );
      
    --slave : spi_slave
      --port map (
      
      --);

end Behavioral;
