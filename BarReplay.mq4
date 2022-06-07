//+------------------------------------------------------------------+
//|                                                    BarReplay.mq4 |
//|                                                              NEO |
//|                                           Neo.Reverser@gmail.com |
//+------------------------------------------------------------------+
#property copyright "NEO"
#property link      "Neo.Reverser@gmail.com"
#property version   "1.00"
#property indicator_chart_window

#include <forall.mqh> //this line will delete
//#include "lib\\def.mqh"
#include <stderror.mqh>
#include <stdlib.mqh>

extern bool Show_TH = true;
extern string _Button_ = "===========# Button #===========";
extern ENUM_BASE_CORNER Corner = 1;
extern int SET_width = 40;
extern int SET_height = 30;
extern int SET_X = 40;
extern int SET_y = 0;
extern string KEYWORDS = "===========# Keywords #===========";
extern string START = "1";
extern string NEXT = "d";
extern string PREVIOUS = "a";

string pass = "N3O";
string replay_line = pass + "_replay_bar_1ine";
string button_name = pass + "_Butt0n";
string bigbutton_name = pass + "_Bigb";
//string global_bar = "LastBar";
int change_allow, last_ibar;
double var2, Price = Close[0]; //Close[0] instead of Bid help us have price in offline chart
bool sym;
long var1;
datetime bar_time;

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
//void Create_BigButton()
//   {
//    if(bar_time)
//       {
//        long bg_color;
//        int x1, y1;
//        //datetime t3
//        ChartTimePriceToXY(0, 0, bar_time, Price * 10, x1, y1);
//        ibart = iBarShift(NULL, 0, bar_time);
//        DeleteObject2(bigbutton_name);
//        ChartGetInteger(0, CHART_COLOR_BACKGROUND, 0, bg_color);
//        //RectangleCreate(0, rec_name, 0, bar_time, Price * 10, TimeCurrent() + (PERIOD_MN1 * 60), Price / 10, color(bg_color));
//        ButtonCreate(0, bigbutton_name, 0, SET_X, SET_y, SET_width, SET_height, Corner, ANCHOR_RIGHT, ">>", clrGray, false, clrBlue);
//       }
//   }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void OnTimer()
   {
//if(GlobalVariableGet("fixed_chart"))
//   {
    if(change_allow)
       {
        ChartGetInteger(0, CHART_SHIFT, 0, var1);
        if(var1)
           {
            go_fix();
           }
       }
//}
   }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void go_fix()
   {
    ChartNavigate(0,
                  CHART_CURRENT_POS,
                  (iBarShift(NULL, 0, bar_time) - iBarShift(NULL, 0, ibar_fixed())) * -1);
   }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
datetime ibar_fixed()
   {
    ChartGetDouble(0, CHART_SHIFT_SIZE, 0, var2);
    return(Time[WinLast + (int(WindowBarsPerChart() * (var2 / 100)))]);
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
    ButtonCreate(0, button_name, 0, SET_X, SET_y, SET_width, SET_height, Corner, ANCHOR_RIGHT, ">>", clrGray, false, clrBlue);
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
            go_fix();
            ////Create_BigButton();
            //ibart = iBarShift(NULL, 0, bar_time);
            //last_ibar = Bars - ibart;
            //GlobalVariableSet("last_tf", Period());
            //GlobalVariableSet(global_bar, last_ibar);
            //GlobalVariableSet("total_bars", Bars);
           }
        if(sparam == button_name)
           {
            Print(TimeCurrent());
            change_allow ? ObjectSet(button_name, OBJPROP_STATE, 0) : ObjectSet(button_name, OBJPROP_STATE, 1);
            change_allow ? ButtonChangeBGColor(button_name, clrGray) : ButtonChangeBGColor(button_name, clrTeal);
            change_allow = change_allow ? 0 : 1;
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
            VLineCreate(0, replay_line, 0, iTime(NULL, 0, WinMid), clrRed, 1, 5, false, true, true);
           }
        if(code == NEXT)
           {
            if(last_ibar)
               {
                ++last_ibar;
                //GlobalVariableSet(global_bar, last_ibar);
               }
           }
        if(code == PREVIOUS)
           {
            if(last_ibar)
               {
                --last_ibar;
                //GlobalVariableSet(global_bar,4 last_ibar);
               }
           }
       }
   }



//+------------------------------------------------------------------+
