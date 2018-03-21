----------------------------------------------------------------------------------
-- Company: 
-- Engineer: Sepideh Bayati
-- 
-- Create Date: 03/21/2018 02:17:40 PM
-- Design Name: 
-- Module Name: cache_SRAM - Behavioral
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

entity cache_SRAM is
    Port ( CLK : in STD_LOGIC;
           ADD : in STD_LOGIC_VECTOR (15 downto 0);
           WEN : in STD_LOGIC;
           DIN : in STD_LOGIC_VECTOR (7 downto 0);
           DOUT : out STD_LOGIC_VECTOR (7 downto 0));
end cache_SRAM;

architecture Behavioral of cache_SRAM is

-- first we define a cache line
type cache_line is array(0 to 31) of std_logic_vector(7 downto 0);
-- then we define our SRAM
type SRAM is array (0 to 7) of cache_line;
-- then we define TAG -- we know in the project definition that the tag is 8 bit
type tag_type is array (0 to 7) of std_logic_vector(7 downto 0);
-- for valid bits and dirty bits
-- you have to add this to the process and use them. this is yours .
type valid_type is array (0 to 7) of std_logic;
type dirty_type is array (0 to 7) of std_logic;
-----------------------------------

begin

-- AWR : 15 downto 8 -> tag
--       7 downto 5 -> index
--       4 downto 0 -> offset

process(clk)
    variable mem : SRAM := (others => (others => (others => '0')));
    variable tag : tag_type := ( others => (others => '0')); 
    variable ad_index : integer;
    variable ad_offset : integer;
    variable init : boolean := true;
    variable done : boolean := false; -- this is going to use when the tag is found 
begin
    if init = true then
        -- any initials if u want to initiate something
        -- for example :
        -- mem(7)(0) := "1000011";
    init := false;
    end if;

    if  clk'event and clk = '1' then
        
        ad_index := to_integer(unsigned(ADD(7 downto 5)));
        ad_offset := to_integer(unsigned(ADD(4 downto 0)));
        
        if WEN = '1' then --writing
            mem(ad_index)(ad_offset) <= DIN;
        end if;
        
        --reading
        for I in 0 to 7 loop -- checking the tag
            if tag(I) = ADD(15 downto 8) then
                DOUT <= mem(ad_index)(ad_offset);
                done := true;
                exit;
            end if;
        end loop;
        if done = false then
            DOUT <= "ZZZZZZZZ";
        else
            done := false;
        end if;
    
    end if;
end process;

end Behavioral;