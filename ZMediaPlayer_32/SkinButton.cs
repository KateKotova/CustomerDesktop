//+--------------------------------------------------------------------------+
//|                                                                          |
//|                            SkinButton class                              |
//|                                                                          |
//+--------------------------------------------------------------------------+
//|                                                                          |
//|                         Author Patrice TERRIER                           |
//|                           copyright (c) 2006                             |
//|                                                                          |
//|                        pterrier@zapsolution.com                          |
//|                                                                          |
//|                          www.zapsolution.com                             |
//|                                                                          |
//+--------------------------------------------------------------------------+
//|                  Project started on : 11-08-2006 (MM-DD-YYYY)            |
//|                        Last revised : 11-09-2006 (MM-DD-YYYY)            |
//+--------------------------------------------------------------------------+

using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Drawing;
using System.Data;
using System.Text;
using System.Windows.Forms;

using SkinEngine;
using Win32;

namespace zap
{
	public partial class SkinButton : System.Windows.Forms.Button
	{
		[
			Category( "Configuration" ),
			Browsable( true ),
			Description( "The bitmap resource name." )
		]
		public String Resource
		{
			get
			{
				return this.Name;
			} // get
			set
			{
				this.Name = value;
			} // set
		} // Resource

		[
			Category( "Behavior" ),
			Browsable( true ),
			Description( "Indicates whether the control is enabled." )
		]
		new public Boolean Enabled
		{
			get
			{
				return base.Enabled;
			} // get
			set
			{
				base.Enabled = value;
				if ( value )
					SK.USE_BTN_Image( this, 1 );
				else
					SK.USE_BTN_Image( this, 3 );
			} // set
		} // Enabled

		public SkinButton( )
		{
			InitializeComponent( );
			CreateButtonRegion( );
		} // SkinButton

		private void CreateButtonRegion( )
		{
			SK.UseNameSpace = this.GetType( ).Namespace;
			// Use default Magenta, instead of TopLeft(0,0) pixel color
/*
			SK.UseTransparencyColorTopLeft = true; // false;
*/
			// Create the button region
			Button btn = ( ( Button ) this );
			SK.CreateButtonRegion( btn );
		} // CreateButtonRegion

		private void SKIN_Resize( object sender, EventArgs e )
		{
			CreateButtonRegion( );
		} // SKIN_Resize

		private void BTN_MouseEnter( object sender, EventArgs e )
		{
			Button btn = ( ( Button ) sender );
			SK.USE_BTN_Image( btn, 5 );
		} // BTN_MouseEnter

		private void BTN_MouseLeave( object sender, EventArgs e )
		{
			Button btn = ( ( Button ) sender );
			SK.USE_BTN_Image( btn, 1 );
		} // BTN_MouseLeave

		private void BTN_MouseUp( object sender, MouseEventArgs e )
		{
			Button btn = ( ( Button ) sender );
			SK.USE_BTN_Image( btn, 5 );
		} // BTN_MouseUp

		private void BTN_MouseDown( object sender, MouseEventArgs e )
		{
			Button btn = ( ( Button ) sender );
			SK.USE_BTN_Image( btn, 2 );
		} // BTN_MouseDown

		private void BTN_EnabledChanged( object sender, EventArgs e )
		{
			Button btn = ( ( Button ) sender );
			SK.InitButton( btn );
		} // BTN_EnabledChanged
	} // SkinButton
} // zap
