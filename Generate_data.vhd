library ieee;
use ieee.std_logic_1164.all;

entity Generate_data is
	port (
			 CLK : in std_logic;
			 Button_Input : in std_logic_vector (0 to 1);
			 Data_out : out std_logic_vector (0 to 23)
			);
end Generate_data;

architecture behavior of Generate_data is
	--constant data variable , array use 0 to 23 because it insert data from first to last array
	TYPE Color_table IS ARRAY (0 to 3) OF std_logic_vector(0 to 23);
	constant Color_Data : Color_table := (x"000000",x"0000FF",x"00FF00",x"FF0000");
	begin
		process(CLK)
			begin
				if rising_edge(CLK) then
					case Button_Input is
						when "00" => Data_out <= Color_Data(0);
						when "01" => Data_out <= Color_Data(1);
						when "10" => Data_out <= Color_Data(2);
						when "11" => Data_out <= Color_Data(3);
						when others => null;
					end case;
				end if;
		end process;
end behavior;