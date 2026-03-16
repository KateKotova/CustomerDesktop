//+--------------------------------------------------------------------------+
//|                                                                          |
//|                             zMoviePlayer                                 |
//|                         DirectX Movie Player                             |
//|                                                                          |
//|                             Version 1.04                                 |
//+--------------------------------------------------------------------------+
//|                                                                          |
//|                         Author Patrice TERRIER                           |
//|                           copyright (c) 2007                             |
//|                                                                          |
//|                        pterrier@zapsolution.com                          |
//|                                                                          |
//|                          www.zapsolution.com                             |
//|                                                                          |
//+--------------------------------------------------------------------------+
//|                  Project started on : 04-20-2007 (MM-DD-YYYY)            |
//|                        Last revised : 05-21-2007 (MM-DD-YYYY)            |
//+--------------------------------------------------------------------------+

using System;
using System.Collections.Generic;
using System.Windows.Forms;
using System.Diagnostics;
using Microsoft.DirectX.AudioVideoPlayback;
using Microsoft.Win32;
using Win32;

namespace zap
{
	static class Program
	{
		/// <summary>
		/// Имя класса.
		/// </summary>
		public const string CLASS_NAME = "Program";

		public const string RegistryKey = @"HKEY_LOCAL_MACHINE\SOFTWARE\zMoviePlayer";
		public const string RegistryPath = "DefaultPathName";
		public const string RegistryAudioVolume = "AudioVolume";
		public const string RegistryStringData = "StringData";

		/// <summary>
		/// Трассировщик.
		/// </summary>
		public static Tracer MainTracer = new Tracer( "ZMediaPayerLog.txt" );
		// Главная форма.
		private static FormMain _FormMediaPlaying;

		/// <summary>
		/// The main entry point for the application.
		/// </summary>
		[STAThread]
		static void Main( string[ ] Args )
		{
			// Вызов метода класса.
			Program.MainTracer.CallClassMethod( Program.CLASS_NAME,
				"Main", Args );

			string Argument = "";
			if ( Args.Length != 0 )
				Argument = Args[ 0 ];
			if ( !IsAlreadyRunning( Argument ) )
			{
				Application.EnableVisualStyles( );
				Application.SetCompatibleTextRenderingDefault( false );

				// Экран полностью покрывает форма фона с непрозрачностью 30%,
				// которая блокирует доступ к другим прогаммам,
				// поверх которых появляется плеер.
				// Потом показывается модальная главная форма диалога плеера
				// поверх формы фона.
				// Приложение работает, пока открыта главная форма.
				FormBackground formBackground = new FormBackground( );
				formBackground.Show( );
				formBackground.Activated +=new EventHandler
					( Program.OnFormBackgroundActivated );

				Program._FormMediaPlaying = new FormMain( Argument );
				try
				{
					Application.Run( Program._FormMediaPlaying );
				}
				catch
				{
					// Произошла ошибка.
					Application.Exit( );
				}
				//Application.Run( formMain );
			}
			else
			{
				// The process is already running
				Application.Exit( );
			}

			// Освобождение ресурсов трассировщика.
			MainTracer.Dispose( );
		}

		static bool IsAlreadyRunning( string Argument )
		{
			// Вызов метода класса.
			Program.MainTracer.CallClassMethod( Program.CLASS_NAME,
				"IsAlreadyRunning", Argument );

			bool bRet = false;
			IntPtr hFound;
			// Get the current process 
			Process currentProcess = Process.GetCurrentProcess( );
			// Check with other process already running 
			foreach ( Process p in Process.GetProcesses( ) )
			{
				// Check running process 
				if ( p.Id != currentProcess.Id )
				{
					if ( p.ProcessName.Equals( currentProcess.ProcessName ) == true )
					{
						//MessageBox.Show(null, "Is already running.",
							//currentProcess.ProcessName.ToString());
						bRet = true;
						hFound = p.MainWindowHandle;
						if ( Api.IsIconic( hFound ) ) // If application is in ICONIC mode then
						{                         // show it in RESTORE mode.
							Api.ShowWindow( hFound, Api.SW_RESTORE );
							Api.SetForegroundWindow( hFound );
						}
						if ( Argument.Length != 0 )
						{
							// Save StringData in registry (see also Api.WM_STRINGDATA)
							Registry.SetValue( RegistryKey, RegistryStringData, Argument );
							Api.PostMessage( hFound, Api.WM_STRINGDATA, 0, 0 );
						}
						break;
					} // if ( p.ProcessName.Equals...
				} // if ( p.Id != currentProcess.Id )
			} // foreach ( Process p in Process.GetProcesses( ) )
			return bRet;
		} // IsAlreadyRunning

		/// <summary>
		/// Активация фоновой формы.
		/// </summary>
		/// <param name="sender">Объект-источник события.</param>
		/// <param name="e">Аргументы события.</param>
		private static void OnFormBackgroundActivated
			( object sender, EventArgs e )
		{
			// В случае передачи фокуса фоновой форме, фокус снова переходит
			// к главной форме, чтобы фоновая форма её не загораживала,
			// а то потом перейти к ней невозможно, так как фоновая форма
			// покрывает весь экран.
			if ( Program._FormMediaPlaying != null )
				Program._FormMediaPlaying.Activate( );
		} // OnFormBackgroundActivated
	} // Program
} // zap