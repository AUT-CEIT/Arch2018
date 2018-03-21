----------------------------------------------------------------------------------
-- Company: 
-- Engineer: Sepideh Bayati
-- 
-- Create Date: 03/20/2018 11:32:18 AM
-- Design Name: 
-- Module Name: CPU - Behavioral
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

entity CPU is
    Port ( CLK : in STD_LOGIC;
           RDY : in STD_LOGIC;
           DIN : in STD_LOGIC_VECTOR (7 downto 0);
           ADD : out STD_LOGIC_VECTOR (15 downto 0);
           WRorRD : out STD_LOGIC;
           CS : out STD_LOGIC;
           DOUT : out STD_LOGIC_VECTOR (7 downto 0));
end CPU;

architecture Behavioral of CPU is

-- you can customize the width of seq and the value of it for read or write and testing ur cache
-- this is just an example and says that there are 20 times read ('0's) and write ('1')
constant width_seq : integer := 20;
signal seq : std_logic_vector(width_seq-1 downto 0) := "01010101010100001111";
------------------------------------------------------------------------------------------------

-- this is linear shift back register to generate random numbers u dont need to do anything with it just let it be
component LFSR is
    generic ( g_Num_Bits : integer);
    port ( i_Clk    : in std_logic;
           i_Enable : in std_logic;
           i_Seed_DV   : in std_logic;
           i_Seed_Data : in std_logic_vector(g_Num_Bits-1 downto 0);
           o_LFSR_Data : out std_logic_vector(g_Num_Bits-1 downto 0);
           o_LFSR_Done : out std_logic);
end component LFSR;

signal doneADD, doneDATA : std_logic;
signal ADD_random : std_logic_vector(15 downto 0);
signal DOUT_random : std_logic_vector(7 downto 0);

begin

-- these are random generators instances for generating random DATA and ADD. u dont have to do anything with them.
LFSR_ADD : LFSR generic map (16)
                port map (CLK, '1', '0', (others => '0'), ADD_random, doneADD);

LFSR_DATA : LFSR generic map (8)
                port map (CLK, '1', '0', (others => '0'), DOUT_random, doneDATA);
-------------------------------------------------------------------------------------------------------------------

-- this is the main process that performs read and write
process(clk)
    variable counter : integer := width_seq-1;
    variable stable_4 : integer := 0; -- this signal is for controlling the output CS signal being '1' for 4 cycles ... (if u have read the projject definition)
    variable done : boolean := false; -- this boolean is going to use when the write/read request is done and waiting for the RDY signal to becomes '1'
    begin
    
    if clk'event and clk = '1' then
        if counter > -1 then
 
            case seq(counter) is
               
               when '1' => 
               --implementing write request
               if done = false then -- the request is not done
                  WRorRD <= '1';
                  stable_4 := stable_4 + 1;
                  -- if statement fot checking the CS being '1' for 4 clock cycle
                  if(stable_4 = 5) then -- the transaction has just begun
                    ADD <= ADD_random;
                    DOUT <= DOUT_random;
                    CS <= '0';
                    done := true; -- the request is now done, we dont need to come to this case anymore
                  else
                    CS <= '1';
                  end if;
                  
               end if;
               
               when others =>  -- it means '0'
               --implementing read request
               if done = false then -- the request is not done
                  WRorRD <= '0';
                  stable_4 := stable_4 + 1;
                  -- if statement fot checking the CS being '1' for 4 clock cycle
                  if(stable_4 = 5) then --the transaction has just begun
                    ADD <= ADD_random;
                    CS <= '0';
                    done := true; -- the request is now done, we dont need to come to this case anymore
                  else
                    CS <= '1';          
                  end if;
               
               end if;
               
            end case;
        
        if RDY = '1' then -- this should be '1' just for a one cycle clock and here we reset everything to go to the next request
            counter := counter - 1;
            stable_4 := 0;
            done := false;
        end if;
        
        
        end if;
    end if;
    
end process;

end Behavioral;


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tb is end;

architecture be of tb is

component CPU is
    Port ( CLK : in STD_LOGIC;
           RDY : in STD_LOGIC;
           DIN : in STD_LOGIC_VECTOR (7 downto 0);
           ADD : out STD_LOGIC_VECTOR (15 downto 0);
           WRorRD : out STD_LOGIC;
           CS : out STD_LOGIC;
           DOUT : out STD_LOGIC_VECTOR (7 downto 0));
end component;

signal CLK, RDY, WRorRD, CS : STD_LOGIC := '0';
signal DIN, DOUT : STD_LOGIC_VECTOR (7 downto 0);
signal ADD : STD_LOGIC_VECTOR (15 downto 0);
           
begin

clk <= not clk after 10 ns;
RDy <= '1' after 110 ns, '0' after 130 ns, '1' after 290 ns, '0' after 310 ns, '1' after 450 ns, '0' after 470 ns;
m1 : CPU port map (CLK, RDY, DIN, ADD, WRorRD, CS, DOUT);
           
end architecture;

