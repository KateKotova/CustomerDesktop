//---------------------------------------------------------------------------
// CustomerDesktop
// Author Kate Kotova
// NIJANUS Copyright © 2004-2010
// nijanus@ymail.com
// http://nijanus.narod2.ru
//---------------------------------------------------------------------------

using System;
using System.Collections.Generic;
using System.Text;

namespace zap
{
	/// <summary>
	/// Cтатус показа главной формы.
	/// </summary>
	public static class MainFormShowingStatus
	{
		/// <summary>
		/// Плеер в данный момент запущен.
		/// </summary>
		public const string OPEN = "OPEN";
		/// <summary>
		/// Плеер в данный момент не запущен.
		/// </summary>
		public const string CLOSE = "CLOSE";
	} // MainFormShowingStatus
} // zap