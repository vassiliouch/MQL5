/*********************************************************************

 Filename      : MyInfo.mqh
 Author        : CV
 Created       : 23/12/2017
 Last Modified :
 Description   : Manage messages displayed in a subwindow.

*********************************************************************/

#include <Object.mqh>

#define MSG_COUNTER     19
#define MSG_TIMEDELAY   20000 // In milliseconds.

static uint   _uiLastMsgTime = GetTickCount();
static int    _iMsgCounter;
static string _sMsg[MSG_COUNTER + 1];

//--------------------------------------------------------------------
// Class CMyInfo.
//--------------------------------------------------------------------
class CMyInfo:public CObject
{
private:
          int    m_iInfoWinNo;
   static uint   m_uiLastMsgTime;
   static int    m_iMsgCounter;
   static string m_sMsg[MSG_COUNTER + 1];
   
public:
   void CMyInfo();
   void ~CMyInfo();
   void clearWindow();
   void showMessage(string sMsg, color clrMessage);
   void showPlainMessage(string sMsg);
   void showErrorMessage(string sMsg);
   void showWarningMessage(string sMsg);
};

// Initialize static members of CMyInfo class at the global level.
uint   CMyInfo::m_uiLastMsgTime = GetTickCount(); // Milliseconds ellapsed since system start.
int    CMyInfo::m_iMsgCounter = 0;
string CMyInfo::m_sMsg[MSG_COUNTER + 1] = {
                                          "", "", "", "", "",
                                          "", "", "", "", "",
                                          "", "", "", "", "",
                                          "", "", "", "", ""
                                          };

//--------------------------------------------------------------------
// Constructor.
//--------------------------------------------------------------------
void CMyInfo::CMyInfo()
{
m_iInfoWinNo = 0;
}

//--------------------------------------------------------------------
// Destructor.
//--------------------------------------------------------------------
void CMyInfo::~CMyInfo()
{

}

//--------------------------------------------------------------------
// Clear all messages from window.
//--------------------------------------------------------------------
void CMyInfo::clearWindow()
{
// Check presence of Info window.
m_iInfoWinNo = ChartWindowFind(0, "MyInfoWindow");
if (m_iInfoWinNo < 0)
   return;
   
for (int i=0; i<=MSG_COUNTER; i++)
    ObjectDelete(0, m_sMsg[i]);
   
return;      
}

//--------------------------------------------------------------------
// Show a message in a window with a specified color.
//--------------------------------------------------------------------
void CMyInfo::showMessage(string sMsg, color clrMessage)
{
// Check presence of Info window.
m_iInfoWinNo = ChartWindowFind(0, "MyInfoWindow");
if (m_iInfoWinNo < 0)
   {
   MessageBox("MyInfoWindow is not present.", "Alert", MB_OK + MB_ICONERROR);
   return;
   }

m_iMsgCounter++;

// Delete oldest message in window (The one at the bottom of the scrolling list).
ObjectDelete(0, m_sMsg[MSG_COUNTER]);

// Scroll messages.
for (int i=MSG_COUNTER; i>=1; i--)
    {
    m_sMsg[i] = m_sMsg[i-1];
    ObjectSetInteger(0, m_sMsg[i], OBJPROP_YDISTANCE, 2+15*i);
    }
   
// Form a new message.
m_sMsg[0] = "_MessageSubWindow_" + 
            IntegerToString(m_iMsgCounter) +
            "_" +
            Symbol();
ObjectCreate(0, m_sMsg[0], OBJ_LABEL, m_iInfoWinNo, 0, 0);
ObjectSetInteger(0, m_sMsg[0], OBJPROP_CORNER, CORNER_LEFT_UPPER);
ObjectSetInteger(0, m_sMsg[0], OBJPROP_XDISTANCE, 500);
ObjectSetInteger(0, m_sMsg[0], OBJPROP_YDISTANCE, 2);
ObjectSetInteger(0, m_sMsg[0], OBJPROP_COLOR, clrMessage);
ObjectSetInteger(0, m_sMsg[0], OBJPROP_FONTSIZE, 10);
ObjectSetString(0, m_sMsg[0], OBJPROP_FONT, "Courier New");
ObjectSetString(0, m_sMsg[0], OBJPROP_TEXT, sMsg);

// Dim messages (change color to gray) every MSG_TIMEDELAY/1000 seconds.
if (GetTickCount() - m_uiLastMsgTime > MSG_TIMEDELAY)
   {
   for (int i=0; i<=MSG_COUNTER; i++)
       ObjectSetInteger(0, m_sMsg[i], OBJPROP_COLOR, clrLightGray);
       
   m_uiLastMsgTime = GetTickCount();
   }
   
ChartRedraw(0);

return;     
}

//--------------------------------------------------------------------
// Show a plain message in a window.
//--------------------------------------------------------------------
void CMyInfo::showPlainMessage(string sMsg)
{
showMessage(sMsg, clrLime);

return;
}

//--------------------------------------------------------------------
// Show an error message in a window.
//--------------------------------------------------------------------
void CMyInfo::showErrorMessage(string sMsg)
{
showMessage(sMsg, clrRed);

return;
}

//--------------------------------------------------------------------
// Show a warning message in a window.
//--------------------------------------------------------------------
void CMyInfo::showWarningMessage(string sMsg)
{
showMessage(sMsg, clrYellow);

return;
}
