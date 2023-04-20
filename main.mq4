// j4 strategy - enters short position when the 200 EMA crosses underneath the 50 EMA
// and exits the short position when the 50 EMA crosses below the 8 EMA
// enters long position when the 200 EMA crosses above the 50 EMA
// and exits the long position when the 50 EMA crosses above the 8 EMA
// and only trades when the ADX value is above 25

// Define input parameters
extern int ma_period_1 = 8; // first moving average period
extern int ma_period_2 = 50; // second moving average period
extern int ma_period_3 = 200; // third moving average period
extern int adx_period = 14; // ADX period
extern double adx_threshold = 20.0; // ADX threshold

// Define global variables
double ma_1, ma_2, ma_3, adx;
int MagicNumber = 123;

// Define initialization function
int init()
{
    // Create moving averages and ADX indicator
    return(0);
}

// Define onTick() function
void OnTick()
{

    ma_1 = iMA(NULL, 0, ma_period_1, 0, MODE_EMA, PRICE_CLOSE, 0);
    ma_2 = iMA(NULL, 0, ma_period_2, 0, MODE_EMA, PRICE_CLOSE, 0);
    ma_3 = iMA(NULL, 0, ma_period_3, 0, MODE_EMA, PRICE_CLOSE, 0);
    IndicatorSetInteger(INDICATOR_DIGITS, _Digits + 1);
    adx = iADX(NULL, 0, adx_period, PRICE_CLOSE, MODE_MAIN, 0);   

    // Check for exit signal for short position
    if (ma_2 < ma_1)
    {
        // Close short position
        for(int i=0; i<OrdersTotal(); i++)
        {
            OrderSelect(i, SELECT_BY_POS, MODE_TRADES);
            if (OrderType() == OP_SELL && OrderSymbol() == Symbol() && OrderMagicNumber() == MagicNumber)
            {
                OrderClose(OrderTicket(), OrderLots(), Bid, 3, Red);
            }
        }
    }
    
    //Alert(ma_1 + " " + ma_2 + " " + ma_3 + " " + Close[0] + " " + adx);
    
    // Check for exit signal for long position
    if (ma_1 < ma_2)
    {
        // Close long position
        for(int j=0; j<OrdersTotal(); j++)
        {
            OrderSelect(i, SELECT_BY_POS, MODE_TRADES);
            if (OrderType() == OP_BUY && OrderSymbol() == Symbol() && OrderMagicNumber() == MagicNumber)
            {
                OrderClose(OrderTicket(), OrderLots(), Ask, 3, Blue);
            }
        }
    }
    
    double accountBalance = AccountBalance();
    double riskPercentage = 10.0;
    
    double lotSize = (accountBalance * riskPercentage / 100) / 10000;
    
    // Check for entry signal for short position
    if (ma_2 < ma_3 && adx > adx_threshold)
    {
        // Enter short position
        OrderSend(Symbol(), OP_SELL, lotSize, Bid, 3, 0, 0, "MA crossover", MagicNumber, 0, Red);
    }
    
    // Check for entry signal for long position
    if (ma_3 < ma_2 && adx > adx_threshold)
    {
        // Enter long position
        OrderSend(Symbol(), OP_BUY, lotSize, Ask, 3, 0, 0, "MA crossover", MagicNumber, 0, Blue);
    }
}
