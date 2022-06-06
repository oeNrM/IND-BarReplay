//+------------------------------------------------------------------+
//|                                                    BarReplay.mq4 |
//|                                                              NEO |
//|                                           Neo.Reverser@gmail.com |
//+------------------------------------------------------------------+
#property copyright "NEO"
#property link      "Neo.Reverser@gmail.com"
#property version   "1.0.0"
#property indicator_chart_window

#include <forall.mqh> //this line will delete
//#include "lib\\Chart_Sets.mqh"
//#include "lib\\default_functions.mqh"
#include <stderror.mqh>
#include <stdlib.mqh>

extern bool Show_TH = true;
extern string _Button_ = "===========# Button #===========";
extern ENUM_BASE_CORNER Corner = 1;
extern int SET_width = 40;
extern int SET_height = 30;
extern int SET_X = 40;
extern int SET_y = 0;

string pass = "N3O";
string replay_line = pass + "replay_bar_1ine";
string button_name = pass + "Butt0n";
string global_bar = "LastBar";
int change_allow = 0, last_ibar = 0, ibart = 1, run_first = 1;
double lprice = Close[0]; //Close[0] instead of Bid help us have price in offline chart
bool sym;

ResetLastError();

// TODO:
// ChartNavigate, CHART_COLOR_BACKGROUND, ButtonCreate, delete replay line, global var., Fix CHART_CURRENT_POS, persian keyboard, del all, TH,
// ChartNavigate(0,CHART_CURRENT_POS,-207)
// last_tf , total_bars

//void Create_rec()
//{
//
//}


//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit()
   {
    IndicatorShortName("Bar Replay");
    ButtonCreate(0, button_name, 0, SET_X, SET_y, SET_width, SET_height, Corner, ANCHOR_RIGHT, ">>>>", clrTeal, true, clrRed);
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
    GlobalVariableDel("last_tf");
    GlobalVariableDel("fixed_chart");
    EventKillTimer();
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
            datetime time3 = (datetime)ObjectGet(sparam, OBJPROP_TIME1);
            ibart = iBarShift(NULL, 0, time3);
            last_ibar = Bars - ibart;
            GlobalVariableSet("last_tf", Period());
            //GlobalVariableSet(global_bar, last_ibar);
            //GlobalVariableSet("total_bars", Bars);
           }
        if(sparam == button_name)
           {
            change_allow ? ObjectSet(button_name, OBJPROP_STATE, 0) : ObjectSet(button_name, OBJPROP_STATE, 1);
            change_allow ? ButtonChangeBGColor(button_name, clrGray) : ButtonChangeBGColor(button_name, clrTeal);
            //ChartNavigate(0, CHART_CURRENT_POS, -MathAbs()
            //change_allow = change_allow ? 0 : 1;
           }
       }
    if(id == CHARTEVENT_KEYDOWN)
       {
        short result = TranslateKey((int)lparam);
        string code = ShortToString(result);
        if(code == "1")
           {
            DeleteObject(pass);
            int WinMid = WindowFirstVisibleBar() - ((int)WindowBarsPerChart() / 2);
            VLineCreate(0, replay_line, 0, iTime(NULL, 0, WinMid), clrRed, 1, 5, false, true, true);
           }
        if(code == "d" || code == "D")
           {
            if(last_ibar)
               {
                ++last_ibar;
                GlobalVariableSet(global_bar, last_ibar);
               }
           }
        if(code == "a" || code == "A")
           {
            if(last_ibar)
               {
                --last_ibar;
                GlobalVariableSet(global_bar, last_ibar);
               }
           }
       }
   }



