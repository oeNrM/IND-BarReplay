//+------------------------------------------------------------------+
//|                                                    BarReplay.mq4 |
//|                                                              NEO |
//|                                           Neo.Reverser@gmail.com |
//+------------------------------------------------------------------+
#property copyright "NEO"
#property link      "Neo.Reverser@gmail.com"
#property description "help us at:"
#property description "https://github.com/oeNrM/IND-BarReplay/tree/dev"
#property version   "1.00"
#property indicator_chart_window

#include "lib\\defaults.mqh";
#include "lib\\button.mqh";
#include "lib\\shift-fixed.mqh";
#include "lib\\externs.mqh";
#include <stderror.mqh>
#include <stdlib.mqh>




/*
    HELP US AT:
        https://github.com/oeNrM/IND-BarReplay/tree/dev
*/



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
//|                                                                  |
//+------------------------------------------------------------------+
void reset()
  {
   DeleteObject(pass);
//GlobalVariableDel("last_candle_rebar");
   change_allow = 0;
   ButtonCreate(0, button_name, 0, SET_X, SET_y, SET_width, SET_height, 2, ANCHOR_LEFT_LOWER, ">>", clrGray, false, clrBlue);
  }

//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit()
  {
   IndicatorShortName("ReBar");
   Comment("[#]ReBar is Ready!");
   StringToLower(START);
   StringToLower(NEXT);
   StringToLower(PREVIOUS);
   ResetLastError();
   EventSetTimer(2);
   reset();
   double lcr = GlobalVariableGet("last_candle_rebar");
   if(lcr != 0)
     {
      bar_time = lcr;
      Create_BigButton();
     }
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
   if(reason != 3)
     {
      GlobalVariableDel("last_candle_rebar");
     }
   DeleteObject(pass);
   EventKillTimer();
   if(GetLastError())
     {
      Print("Last Error: #", __FUNCTION__, " ", GetLastError(), ">> ", ErrorDescription(GetLastError()));
     }
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
         reset();
         Create_BigButton();
         GlobalVariableSet("last_candle_rebar", bar_time);
        }
      if(sparam == button_name)
        {
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
         VLineCreate(0, replay_line, 0, iTime(NULL, 0, WinMid), clrRed, 1, 5, false, true, true);
        }
      if(code == NEXT)
        {
         bar_time += (1 * Period() * 60);
         GlobalVariableSet("last_candle_rebar", bar_time);
         go_fix();
        }
      if(code == PREVIOUS)
        {
         bar_time -= (1 * Period() * 60);
         GlobalVariableSet("last_candle_rebar", bar_time);
         go_fix();
        }
     }
  }



//+------------------------------------------------------------------+
