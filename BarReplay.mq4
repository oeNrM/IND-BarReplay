//+------------------------------------------------------------------+
//|                                                    BarReplay.mq4 |
//|                                                              NEO |
//|                                           Neo.Reverser@gmail.com |
//+------------------------------------------------------------------+
#property copyright "NEO"
#property link      "Neo.Reverser@gmail.com"
#property version   "1.00"
#property indicator_chart_window

//#include <forall.mqh> //this line will delete
#include "lib\\def.mqh";
#include "lib\\button.mqh";
#include <stderror.mqh>
#include <stdlib.mqh>

extern bool Show_TH = true;
extern string _Button_ = "===========# Button #===========";
//extern ENUM_BASE_CORNER Corner = 2;
extern int SET_width = 40;
extern int SET_height = 30;
extern int SET_X = 0;
extern int SET_y = 30;
extern string KEYWORDS = "===========# Keywords #===========";
extern string START = "1";
extern string NEXT = "d";
extern string PREVIOUS = "a";

string pass = "N3O";
string replay_line = pass + "_replay_bar_1ine";
string button_name = pass + "_Butt0n";
string bigbutton_name = pass + "_Bigb";
//string global_bar = "LastBar";
int change_allow, last_ibar;//, SET_X, SET_y;
double var2, Price = Close[0]; //Close[0] instead of Bid help us have price in offline chart
bool sym;
long var1;
datetime bar_time;

//ChartTimePriceToXY(0, 0, Time[1], High[1] + (POINT * Point), x2, y2);

//+------------------------------------------------------------------+
//|                                                               |
//+------------------------------------------------------------------+
void OnTimer()
  {
//if(GlobalVariableGet("fixed_chart"))
//   {
   ChartGetInteger(0, CHART_SHIFT, 0, var1);
   if(change_allow && bar_time && var1)
     {
      go_fix();
     }
//}
  }

//+------------------------------------------------------------------+
//|fix chart                                                         |
//+------------------------------------------------------------------+
void go_fix()
  {
   ChartNavigate(0,
                 CHART_CURRENT_POS,
                 (iBarShift(NULL, 0, bar_time) - iBarShift(NULL, 0, ibar_fixed())) * -1);
  }

//+------------------------------------------------------------------+
//|return the time of candle that in fixed                           |
//+------------------------------------------------------------------+
datetime ibar_fixed()
  {
   ChartGetDouble(0, CHART_SHIFT_SIZE, 0, var2);
   int aa = WinLast;
   int sss = (int(WindowBarsPerChart() * (var2 / 100)));
   return(Time[aa + sss]);
  }

//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit()
  {
   IndicatorShortName("ReBar");
   StringToLower(START);
   StringToLower(NEXT);
   StringToLower(PREVIOUS);
   ResetLastError();
   EventSetTimer(2);
   ButtonCreate(0, button_name, 0, SET_X, SET_y, SET_width, SET_height, 2, ANCHOR_LEFT_LOWER, ">>", clrGray, false, clrBlue);
   return(INIT_SUCCEEDED);
  }

//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int OnCalculate(const int rates_total,
                const int prev_calculated,
                const datetime &time[],
                const double &open[],
                const double &high[],
                const double &low[],
                const double &close[],
                const long &tick_volume[],
                const long &volume[],
                const int &spread[])
  {
   return(rates_total);
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
   ObjectDelete(0, pass);
//GlobalVariableDel(global_bar);
//GlobalVariableDel("total_bars");
////GlobalVariableDel("last_tf");
////GlobalVariableDel("fixed_chart");
   EventKillTimer();
   Print("Last Error: #", __FUNCTION__, " ", GetLastError(), ">> ", ErrorDescription(GetLastError()));
   Comment("");
  }

//+------------------------------------------------------------------+
//| ChartEvent function                                              |
//+------------------------------------------------------------------+
void OnChartEvent(const int id, const long& lparam, const double& dparam, const string& sparam)
  {
   if(id == CHARTEVENT_OBJECT_CLICK)
     {
      if(sparam == replay_line)
        {
         bar_time = (datetime)ObjectGet(sparam, OBJPROP_TIME1);
         Create_BigButton();
         DeleteObject(replay_line);
         //ibart = iBarShift(NULL, 0, bar_time);
         //last_ibar = Bars - ibart;
         //GlobalVariableSet("last_tf", Period());
         //GlobalVariableSet(global_bar, last_ibar);
         //GlobalVariableSet("total_bars", Bars);
        }
      if(sparam == button_name)
        {
         //Print(TimeCurrent());
         change_allow ? ObjectSet(button_name, OBJPROP_STATE, 0) : ObjectSet(button_name, OBJPROP_STATE, 1);
         change_allow ? ButtonChangeBGColor(button_name, clrGray) : ButtonChangeBGColor(button_name, clrTeal);
         change_allow = change_allow ? 0 : 1;
        }
      if(sparam == bigbutton_name)
        {
         ObjectSet(bigbutton_name, OBJPROP_STATE, 0);
        }
     }
   if(id == CHARTEVENT_KEYDOWN)
     {
      short result = TranslateKey((int)lparam);
      string code = ShortToString(result);
      StringToLower(code);
      if(code == START)
        {
         DeleteObject(pass);
         /*
         int change_allow, last_ibar;
         double var2, Price = Close[0]; //Close[0] instead of Bid help us have price in offline chart
         bool sym;
         long var1;
         datetime bar_time;
         */
         VLineCreate(0, replay_line, 0, iTime(NULL, 0, WinMid), clrRed, 1, 5, false, true, true);
        }
      if(code == NEXT)
        {
         //if(last_ibar)
         //{
         //--last_ibar;
         bar_time += (1 * Period() * 60);
         go_fix();
         //GlobalVariableSet(global_bar, last_ibar);
         //}
        }
      if(code == PREVIOUS)
        {
         //if(last_ibar)
         //{
         //++last_ibar;
         bar_time -= (1 * Period() * 60);
         go_fix();
         //GlobalVariableSet(global_bar,4 last_ibar);
         //}
        }
     }
  }



//+------------------------------------------------------------------+
