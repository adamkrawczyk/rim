library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_arith.all ;
use ieee.std_logic_unsigned.all ;

Library UNISIM;
use UNISIM.vcomponents.all;


entity fir1 is
    Port ( -- Wyprowadzenia uk�adu FPGA wykorzystywane na p�ycie ewaluacyjnej
        clk : in  STD_LOGIC; -- zegar 50MHz z generatora na p�ycie uruchomieniowej
        rxd : in  STD_LOGIC; -- szeregowe wej�cie danych z portu RS-232
        txd : out  STD_LOGIC;-- szeregowe wyj�cie danych do portu RS-232

        but1 : in  STD_LOGIC; -- przyciski
        but2 : in  STD_LOGIC;
        but3 : in  STD_LOGIC;
        but4 : in  STD_LOGIC;
        SWCenter : in  STD_LOGIC;

        sw0 : in  STD_LOGIC; -- prze��czniki
        sw1 : in  STD_LOGIC;
        sw2 : in  STD_LOGIC;
        sw3 : in  STD_LOGIC;
        sw4 : in  STD_LOGIC;

        led0 : out  STD_LOGIC; -- LEDy
        led1 : out  STD_LOGIC;
        led2 : out  STD_LOGIC;
        led3 : out  STD_LOGIC;
        led4 : out  STD_LOGIC;
        led5 : out  STD_LOGIC;
        led6 : out  STD_LOGIC;
        led7 : out  STD_LOGIC;

        SMA_CLK : out  STD_LOGIC	-- gniazdo SMA		  
    );
end fir1;


architecture ar1 of fir1 is

    component rimlab00 is -- Modu� komunikacji z komputerem PC przez port RS-232
        Port (
            -- Komunikacja ze �wiatem zewn�trznym	
            CLK : in  STD_LOGIC; -- zegar 50MHz z generatora na p�ycie uruchomieniowej
            RST : in  STD_LOGIC; -- sygna� Reset, aktywny w stanie H
            RXD : in  STD_LOGIC; -- szeregowe wej�cie danych z portu RS-232
            TXD : out  STD_LOGIC;-- szeregowe wyj�cie danych do portu RS-232			  

            -- Komunikacja z algorytmem przetwarzania danych
            START_PROC : out  STD_LOGIC;  -- sygna� wyzwalaj�cy algorytm
            PROC_WORKING : in  STD_LOGIC; -- flaga sygnalizuj�ca dzia�anie algorytmu

            DOUT_DATA : out STD_LOGIC_VECTOR (15 downto 0); -- 16-bitowe dane wej�ciowe dla algorytmu
            RD_DATA : in  STD_LOGIC; -- sygna� odczytuj�cy s�owo z dout_data

            DIN_RESULT : in  STD_LOGIC_VECTOR (15 downto 0); -- 16-bitowy wynik przys�any z algorytmu
            WR_RESULT : in  STD_LOGIC -- sygna� wpisuj�cy nowy wynik z din_result			  
        );
    end component;

    -- Deklaracja "czarnej skrzynki" - IP Core
    attribute syn_black_box : boolean;
    attribute syn_black_box of rimlab00: component is true;


    -- Sygna�y do komunikacji z algorytmem przetwarzania danych
    signal START_PROC : STD_LOGIC;    -- sygna� wyzwalaj�cy algorytm
    signal PROC_WORKING : STD_LOGIC;  -- flaga sygnalizuj�ca dzia�anie algorytmu

    signal SRC_DATA : STD_LOGIC_VECTOR (15 downto 0); -- 16-bitowe dane wej�ciowe dla algorytmu
    signal SRC_RD : STD_LOGIC; -- sygna� odczytuj�cy s�owo z dout_data (zezwala na podanie nast�pnego s�owa)

    signal RESULT_DATA : STD_LOGIC_VECTOR (15 downto 0); -- 16-bitowy wynik przys�any z algorytmu
    signal RESULT_WR : STD_LOGIC; -- sygna� wpisuj�cy nowy wynik podany na din_result

    signal RST : STD_LOGIC; -- zerowanie wszystkich automat�w (aktywny stan H)			  

    signal TXD2 : STD_LOGIC;

    -- Sygna�y dla testowego algorytmu przetwarzania danych
    type typy_stanow is (IDLE, RD_DAT, WR_DAT);
    signal stan_alg: typy_stanow;  -- maszyna stanu do odczytywania i zapisywania danych
    signal cnt_data : integer range 0 to 1023; -- licznik wpisanych s��w wyniku

    component mult16x16 is
        generic ( -- lista parametr�w bloku i ich domy�lnych warto�ci
            word_size   : natural   := 16;
            signed_mult : boolean   := true;
            impl_style  : string    := "block"
        );
        port ( -- lista port�w - wyprowadze� bloku
            clk : in    std_logic;
            a   : in    std_logic_vector(1*word_size-1 downto 0);
            b   : in    std_logic_vector(1*word_size-1 downto 0);
            p   : out   std_logic_vector(2*word_size-1 downto 0)
        );
    end component;

    constant b1: STD_LOGIC_VECTOR (15 downto 0) := X"4000";
    constant b2: STD_LOGIC_VECTOR (15 downto 0) := X"2000";
    constant b3: STD_LOGIC_VECTOR (15 downto 0) := X"1000";
    constant b4: STD_LOGIC_VECTOR (15 downto 0) := X"800";
    constant b5: STD_LOGIC_VECTOR (15 downto 0) := X"400";
    constant b6: STD_LOGIC_VECTOR (15 downto 0) := X"200";
    constant b7: STD_LOGIC_VECTOR (15 downto 0) := X"100";
    constant b8: STD_LOGIC_VECTOR (15 downto 0) := X"80";

    signal p1 : STD_LOGIC_VECTOR (31 downto 0);
    signal p2 : STD_LOGIC_VECTOR (31 downto 0);
    signal p3 : STD_LOGIC_VECTOR (31 downto 0);
    signal p4 : STD_LOGIC_VECTOR (31 downto 0);
    signal p5 : STD_LOGIC_VECTOR (31 downto 0);
    signal p6 : STD_LOGIC_VECTOR (31 downto 0);
    signal p7 : STD_LOGIC_VECTOR (31 downto 0);
    signal p8 : STD_LOGIC_VECTOR (31 downto 0);

    signal p12 : STD_LOGIC_VECTOR (32 downto 0);
    signal p34 : STD_LOGIC_VECTOR (32 downto 0);
    signal p56 : STD_LOGIC_VECTOR (32 downto 0);
    signal p78 : STD_LOGIC_VECTOR (32 downto 0);

    signal p1234 : STD_LOGIC_VECTOR (33 downto 0);
    signal p5678 : STD_LOGIC_VECTOR (33 downto 0);

    signal p18 : STD_LOGIC_VECTOR (34 downto 0);

    signal x1 : STD_LOGIC_VECTOR (31 downto 0);
    signal x2 : STD_LOGIC_VECTOR (31 downto 0);
    signal x3 : STD_LOGIC_VECTOR (31 downto 0);
    signal x4 : STD_LOGIC_VECTOR (31 downto 0);
    signal x5 : STD_LOGIC_VECTOR (31 downto 0);
    signal x6 : STD_LOGIC_VECTOR (31 downto 0);
    signal x7 : STD_LOGIC_VECTOR (31 downto 0);
    signal x8 : STD_LOGIC_VECTOR (31 downto 0);

    signal iterator : integer := 0;

begin

    RST <= SWCenter; -- "Rotary Knob Center" jako Reset uk�adu

    -- Blok komunikacji przez port szeregowy RS-232
    rim1 : rimlab00 PORT MAP(
            clk => clk,
            rst => rst,
            rxd => rxd,
            --	txd => txd,
            txd => TXD2,

            START_PROC  =>START_PROC,
            PROC_WORKING=>PROC_WORKING,

            DOUT_DATA=> SRC_DATA,
            RD_DATA  => SRC_RD,

            DIN_RESULT=>RESULT_DATA,
            WR_RESULT =>RESULT_WR
        );

    txd <= TXD2;

    mult1: mult16x16 port map (clk => clk, a => x1, b => b1, p => p1);
    mult2: mult16x16 port map (clk => clk, a => x2, b => b2, p => p2);
    mult3: mult16x16 port map (clk => clk, a => x3, b => b3, p => p3);
    mult4: mult16x16 port map (clk => clk, a => x4, b => b4, p => p4);
    mult5: mult16x16 port map (clk => clk, a => x5, b => b5, p => p5);
    mult6: mult16x16 port map (clk => clk, a => x6, b => b6, p => p6);
    mult7: mult16x16 port map (clk => clk, a => x7, b => b7, p => p7);
    mult8: mult16x16 port map (clk => clk, a => x8, b => b8, p => p8);


    fill_mem: process (RST, clk)
    begin
        if RST='1' then -- zerowanie automatu
            stan_alg <= IDLE;
            PROC_WORKING<='0';
            cnt_data<=0;
            SRC_RD <= '0';
            RESULT_DATA <= x"0000";
            RESULT_WR<='0';
        elsif rising_edge(clk) then

            if stan_alg=IDLE then -- oczekiwanie na sygna� START dla algorytmu pzetwarzania danych		
                if START_PROC='1' then -- Uruchomienie p�tli algorytmu	
                    PROC_WORKING<='1'; -- sygnalizacja dzia�ania algorytmu do zliczania czasu
                    cnt_data<=0;
                    SRC_RD <= '1';
                    stan_alg<=RD_DAT;
                else	-- oczekiwanie na sygna� START w bezczynno�ci
                    PROC_WORKING<='0';
                    SRC_RD <= '0';
                    RESULT_WR<='0';
                end if;

            elsif stan_alg=RD_DAT then -- Odczytanie s�owa z pami�ci danych i wykonywanie "przetwarzania danych"
                x1 <= SRC_DATA;
                x2 <= x1;
                x3 <= x2;
                x4 <= x3;
                x5 <= x4;
                x6 <= x5;
                x7 <= x6;
                x8 <= x7;

                p12 <= (p1(31) & p1) + (p2(31) & p2);
                p34 <= (p3(31) & p3) + (p4(31) & p4);

                p56 <= (p5(31) & p5) + (p6(31) & p6);
                p78 <= (p7(31) & p7) + (p8(31) & p8);

                p1234 <= (p12(32) & p12) + (p34(32) & p34);
                p5678 <= (p56(32) & p56) + (p78(32) & p78);

                p18 <= (p1234(33) & p1234) + (p5678(33) & p5678);

                RESULT_DATA <= p18(34 downto 19);

                if iterator >= 11 then
                    SRC_RD <= '0';
                    stan_alg<=WR_DAT;
                    RESULT_WR<='1';
                else
                    iterator <= iterator + 1;
                end if;

            elsif stan_alg=WR_DAT then -- Wpisanie s�owa do pami�ci wynik�w		
                RESULT_WR<='0'; -- ju� dokonano wpisu s�owa do pami�ci wynik�w

                if cnt_data=1023 then 	stan_alg<=IDLE;  -- koniec pracy algorytmu
                    PROC_WORKING<='0';
                else cnt_data<=cnt_data+1; -- pobranie nast�pnego s�owa danych w kolejnym cyklu zegara
                    stan_alg<=RD_DAT;
                    SRC_RD <= '1';
                end if;

            else stan_alg <= IDLE;
            end if; -- stan

        end if; -- RST/CLK
    end process;

    -- Testowe po��czenie LED�w i prze��cznik�w
    LED0 <= START_PROC;
    LED1 <= PROC_WORKING;
    LED2 <= SRC_RD;

    LED3 <= RESULT_WR;
    LED4 <= rst;
    LED5 <= not RXD;
    LED6 <= not TXD2;
    LED7 <= sw0 or sw1 or sw2 or sw3 or but1 or but2 or but3 or but4;

    -- Wyprowadzenie sygna�u zegarowego na gniazdo SMA do test�w
    SMA_CLK <= CLK;

end ar1;
