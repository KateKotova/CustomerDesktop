//---------------------------------------------------------------------------
// CustomerDesktop
// Author Kate Kotova
// NIJANUS Copyright © 2004-2010
// nijanus@ymail.com
// http://nijanus.narod2.ru
//---------------------------------------------------------------------------

using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Text;
using System.Windows.Forms;

namespace zap
{
	/// <summary>
	/// Фоновая форма.
	/// </summary>
	public partial class FormBackground : Form
	{
		/// <summary>
		/// Создание фоновой формы.
		/// </summary>
		public FormBackground( )
		{
			// Создание нового экземпляра класса.
			Program.MainTracer.CreateClassNewInstance( "FormBackground" );

			InitializeComponent( );
		} // FormBackground
	} // FormBackground
} // zap