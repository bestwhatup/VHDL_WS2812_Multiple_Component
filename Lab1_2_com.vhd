library ieee;
use ieee.std_logic_1164.all;

entity Lab1_2_com is
	port (
			CLK : in std_logic;
			PB : in std_logic;
			RST_B : in std_logic;
			Number_Led_input : in std_logic_vector(3 downto 0);
			DATA : out std_logic
	);
end Lab1_2_com;

architecture behavior of Lab1_2_com is

	component two_button_input 
		port (
				CLK : in std_logic;
				PB : in std_logic;
				RST_B : in std_logic;
				Button_Output : out std_logic_vector(0 to 1)
		);
	end component;
	
	component Generate_data
		port (
				CLK : in std_logic;
				Button_Input : in std_logic_vector (0 to 1);
				Data_out : out std_logic_vector (0 to 23)
		);
	end component;
	
	component PWM_LED
	port (
			 CLK : in std_logic;
			 Color_Data_in : in std_logic_vector(0 to 23);
			 Number_Led_in : in std_logic_vector(3 downto 0);
			 Data_PWM_out : out std_logic
		);
	end component;
	
	signal two_button_output : std_logic_vector(0 to 1);
	signal generate_data_output : std_logic_vector(0 to 23);
	
	begin
		input_component : two_button_input port map(CLK => CLK,PB => PB,RST_B => RST_B,Button_Output => two_button_output);
		generate_component : Generate_data port map(CLK => CLK,Button_Input => two_button_output,Data_out => generate_data_output);
		pwm_led_component : PWM_LED port map(CLK => CLK,Color_Data_in => generate_data_output,Number_Led_in => Number_Led_input,Data_PWM_out => DATA);
end behavior;