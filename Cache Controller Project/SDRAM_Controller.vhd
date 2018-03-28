----------------------------------------------------------------------------------
-- Company: 
-- Engineer: Sepideh Bayati
-- 
-- Create Date: 03/20/2018 02:54:14 PM
-- Design Name: 
-- Module Name: SDRAM_Controller - Behavioral
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

entity SDRAM_Controller is
    Port ( CLK : in STD_LOGIC;
           ADD : in STD_LOGIC_VECTOR (15 downto 0);
           WRorRD : in STD_LOGIC;
           MEMSTRB : in STD_LOGIC;
           DIN : in STD_LOGIC_VECTOR (7 downto 0);
           DOUT : out STD_LOGIC_VECTOR (7 downto 0));
end SDRAM_Controller;

architecture Behavioral of SDRAM_Controller is
-- 2^16 our index
constant blocksize : integer := 65536;
-- user defined data type for memory
type SDRAM is array (0 to blocksize-1) of std_logic_vector(7 downto 0);
-----------------------------------
begin

process(clk)
    variable mem : SDRAM := ( others => (others => '0'));
    variable ad : integer;
    variable init : boolean := true;
begin
    if init = true then
        -- any initials if u want to initiate something
        -- for example :
        -- mem(10) := "1000011";
    init := false;
    end if;

    if  clk'event and clk = '1' then
        
        ad := to_integer(unsigned(ADD));

        if WRorRD = '0' and MEMSTRB = '1' then -- Readiing :)
            if ad >= blocksize then
                DOUT <= (others => 'Z');
            else
                DOUT <= mem(ad);
            end if;
        elsif WRorRD = '1' and MEMSTRB = '1' then -- Writing :)
            if ad < blocksize then
                mem(ad) := DIN;
            end if;
        end if;
    
    end if;
end process;

end Behavioral;
