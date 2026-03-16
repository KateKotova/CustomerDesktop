namespace zap
{
	partial class FormSound
	{
		/// <summary>
		/// Required designer variable.
		/// </summary>
		private System.ComponentModel.IContainer components = null;

		/// <summary>
		/// Clean up any resources being used.
		/// </summary>
		/// <param name="disposing">true if managed resources should be disposed; otherwise, false.</param>
		protected override void Dispose( bool disposing )
		{
			if ( disposing && ( components != null ) )
			{
				components.Dispose( );
			}
			base.Dispose( disposing );
		}

		#region Windows Form Designer generated code

		/// <summary>
		/// Required method for Designer support - do not modify
		/// the contents of this method with the code editor.
		/// </summary>
		private void InitializeComponent( )
		{
			this.components = new System.ComponentModel.Container( );
			this._TableLayoutPanelForm = new System.Windows.Forms.TableLayoutPanel( );
			this._PictureBoxRightBorder = new System.Windows.Forms.PictureBox( );
			this._PictureBoxLeftBorder = new System.Windows.Forms.PictureBox( );
			this._PictureBoxDownBorder = new System.Windows.Forms.PictureBox( );
			this._PictureBoxUpBorder = new System.Windows.Forms.PictureBox( );
			this._PictureBoxLeftDownBorder = new System.Windows.Forms.PictureBox( );
			this._PictureBoxRightDownBorder = new System.Windows.Forms.PictureBox( );
			this._PictureBoxLeftUpBorder = new System.Windows.Forms.PictureBox( );
			this._PictureBoxRightUpBorder = new System.Windows.Forms.PictureBox( );
			this._TableLayoutPanelTrackbarSound = new System.Windows.Forms.TableLayoutPanel( );
			this._PictureBoxTrackbarSoundUpBorder = new System.Windows.Forms.PictureBox( );
			this._PictureBoxTrackbarSoundDownBorder = new System.Windows.Forms.PictureBox( );
			this._TimerFormHiding = new System.Windows.Forms.Timer( this.components );
			this._TimerFormShowingEffect = new System.Windows.Forms.Timer( this.components );
			this._TimerFormHidingEffect = new System.Windows.Forms.Timer( this.components );
			this._PictureBoxFormImageCopy = new System.Windows.Forms.PictureBox( );
			this._SkinTrackbarSound = new zap.SkinTrackbar( );
			this._TableLayoutPanelForm.SuspendLayout( );
			( ( System.ComponentModel.ISupportInitialize ) ( this._PictureBoxRightBorder ) ).BeginInit( );
			( ( System.ComponentModel.ISupportInitialize ) ( this._PictureBoxLeftBorder ) ).BeginInit( );
			( ( System.ComponentModel.ISupportInitialize ) ( this._PictureBoxDownBorder ) ).BeginInit( );
			( ( System.ComponentModel.ISupportInitialize ) ( this._PictureBoxUpBorder ) ).BeginInit( );
			( ( System.ComponentModel.ISupportInitialize ) ( this._PictureBoxLeftDownBorder ) ).BeginInit( );
			( ( System.ComponentModel.ISupportInitialize ) ( this._PictureBoxRightDownBorder ) ).BeginInit( );
			( ( System.ComponentModel.ISupportInitialize ) ( this._PictureBoxLeftUpBorder ) ).BeginInit( );
			( ( System.ComponentModel.ISupportInitialize ) ( this._PictureBoxRightUpBorder ) ).BeginInit( );
			this._TableLayoutPanelTrackbarSound.SuspendLayout( );
			( ( System.ComponentModel.ISupportInitialize ) ( this._PictureBoxTrackbarSoundUpBorder ) ).BeginInit( );
			( ( System.ComponentModel.ISupportInitialize ) ( this._PictureBoxTrackbarSoundDownBorder ) ).BeginInit( );
			( ( System.ComponentModel.ISupportInitialize ) ( this._PictureBoxFormImageCopy ) ).BeginInit( );
			this.SuspendLayout( );
			// 
			// _TableLayoutPanelForm
			// 
			this._TableLayoutPanelForm.BackColor = System.Drawing.Color.FromArgb( ( ( int ) ( ( ( byte ) ( 67 ) ) ) ), ( ( int ) ( ( ( byte ) ( 72 ) ) ) ), ( ( int ) ( ( ( byte ) ( 80 ) ) ) ) );
			this._TableLayoutPanelForm.BackgroundImageLayout = System.Windows.Forms.ImageLayout.None;
			this._TableLayoutPanelForm.ColumnCount = 3;
			this._TableLayoutPanelForm.ColumnStyles.Add( new System.Windows.Forms.ColumnStyle( System.Windows.Forms.SizeType.Absolute, 10F ) );
			this._TableLayoutPanelForm.ColumnStyles.Add( new System.Windows.Forms.ColumnStyle( System.Windows.Forms.SizeType.Percent, 100F ) );
			this._TableLayoutPanelForm.ColumnStyles.Add( new System.Windows.Forms.ColumnStyle( System.Windows.Forms.SizeType.Absolute, 10F ) );
			this._TableLayoutPanelForm.Controls.Add( this._PictureBoxRightBorder, 2, 1 );
			this._TableLayoutPanelForm.Controls.Add( this._PictureBoxLeftBorder, 0, 1 );
			this._TableLayoutPanelForm.Controls.Add( this._PictureBoxDownBorder, 1, 2 );
			this._TableLayoutPanelForm.Controls.Add( this._PictureBoxUpBorder, 1, 0 );
			this._TableLayoutPanelForm.Controls.Add( this._PictureBoxLeftDownBorder, 0, 2 );
			this._TableLayoutPanelForm.Controls.Add( this._PictureBoxRightDownBorder, 2, 2 );
			this._TableLayoutPanelForm.Controls.Add( this._PictureBoxLeftUpBorder, 0, 0 );
			this._TableLayoutPanelForm.Controls.Add( this._PictureBoxRightUpBorder, 2, 0 );
			this._TableLayoutPanelForm.Controls.Add( this._TableLayoutPanelTrackbarSound, 1, 1 );
			this._TableLayoutPanelForm.Dock = System.Windows.Forms.DockStyle.Bottom;
			this._TableLayoutPanelForm.Location = new System.Drawing.Point( 0, 48 );
			this._TableLayoutPanelForm.Margin = new System.Windows.Forms.Padding( 0 );
			this._TableLayoutPanelForm.Name = "_TableLayoutPanelForm";
			this._TableLayoutPanelForm.RowCount = 3;
			this._TableLayoutPanelForm.RowStyles.Add( new System.Windows.Forms.RowStyle( System.Windows.Forms.SizeType.Absolute, 10F ) );
			this._TableLayoutPanelForm.RowStyles.Add( new System.Windows.Forms.RowStyle( System.Windows.Forms.SizeType.Percent, 100F ) );
			this._TableLayoutPanelForm.RowStyles.Add( new System.Windows.Forms.RowStyle( System.Windows.Forms.SizeType.Absolute, 10F ) );
			this._TableLayoutPanelForm.RowStyles.Add( new System.Windows.Forms.RowStyle( System.Windows.Forms.SizeType.Absolute, 20F ) );
			this._TableLayoutPanelForm.Size = new System.Drawing.Size( 118, 152 );
			this._TableLayoutPanelForm.TabIndex = 0;
			this._TableLayoutPanelForm.MouseLeave += new System.EventHandler( this.OnMouseLeave );
			this._TableLayoutPanelForm.MouseEnter += new System.EventHandler( this.OnMouseEnter );
			// 
			// _PictureBoxRightBorder
			// 
			this._PictureBoxRightBorder.BackColor = System.Drawing.Color.Transparent;
			this._PictureBoxRightBorder.BackgroundImage = global::zap.Properties.Resources.RightCommandBorder;
			this._PictureBoxRightBorder.BackgroundImageLayout = System.Windows.Forms.ImageLayout.Stretch;
			this._PictureBoxRightBorder.Dock = System.Windows.Forms.DockStyle.Fill;
			this._PictureBoxRightBorder.Location = new System.Drawing.Point( 108, 10 );
			this._PictureBoxRightBorder.Margin = new System.Windows.Forms.Padding( 0 );
			this._PictureBoxRightBorder.Name = "_PictureBoxRightBorder";
			this._PictureBoxRightBorder.Size = new System.Drawing.Size( 10, 132 );
			this._PictureBoxRightBorder.TabIndex = 24;
			this._PictureBoxRightBorder.TabStop = false;
			this._PictureBoxRightBorder.MouseLeave += new System.EventHandler( this.OnMouseLeave );
			this._PictureBoxRightBorder.MouseEnter += new System.EventHandler( this.OnMouseEnter );
			// 
			// _PictureBoxLeftBorder
			// 
			this._PictureBoxLeftBorder.BackColor = System.Drawing.Color.Transparent;
			this._PictureBoxLeftBorder.BackgroundImage = global::zap.Properties.Resources.LeftCommandBorder;
			this._PictureBoxLeftBorder.BackgroundImageLayout = System.Windows.Forms.ImageLayout.Stretch;
			this._PictureBoxLeftBorder.Dock = System.Windows.Forms.DockStyle.Fill;
			this._PictureBoxLeftBorder.Location = new System.Drawing.Point( 0, 10 );
			this._PictureBoxLeftBorder.Margin = new System.Windows.Forms.Padding( 0 );
			this._PictureBoxLeftBorder.Name = "_PictureBoxLeftBorder";
			this._PictureBoxLeftBorder.Size = new System.Drawing.Size( 10, 132 );
			this._PictureBoxLeftBorder.TabIndex = 23;
			this._PictureBoxLeftBorder.TabStop = false;
			this._PictureBoxLeftBorder.MouseLeave += new System.EventHandler( this.OnMouseLeave );
			this._PictureBoxLeftBorder.MouseEnter += new System.EventHandler( this.OnMouseEnter );
			// 
			// _PictureBoxDownBorder
			// 
			this._PictureBoxDownBorder.BackColor = System.Drawing.Color.Transparent;
			this._PictureBoxDownBorder.BackgroundImage = global::zap.Properties.Resources.DownSoundBorder;
			this._PictureBoxDownBorder.BackgroundImageLayout = System.Windows.Forms.ImageLayout.Stretch;
			this._PictureBoxDownBorder.Dock = System.Windows.Forms.DockStyle.Fill;
			this._PictureBoxDownBorder.Location = new System.Drawing.Point( 10, 142 );
			this._PictureBoxDownBorder.Margin = new System.Windows.Forms.Padding( 0 );
			this._PictureBoxDownBorder.Name = "_PictureBoxDownBorder";
			this._PictureBoxDownBorder.Size = new System.Drawing.Size( 98, 10 );
			this._PictureBoxDownBorder.TabIndex = 22;
			this._PictureBoxDownBorder.TabStop = false;
			this._PictureBoxDownBorder.MouseLeave += new System.EventHandler( this.OnMouseLeave );
			this._PictureBoxDownBorder.MouseEnter += new System.EventHandler( this.OnMouseEnter );
			// 
			// _PictureBoxUpBorder
			// 
			this._PictureBoxUpBorder.BackColor = System.Drawing.Color.Transparent;
			this._PictureBoxUpBorder.BackgroundImage = global::zap.Properties.Resources.UpCommandBorder;
			this._PictureBoxUpBorder.BackgroundImageLayout = System.Windows.Forms.ImageLayout.Stretch;
			this._PictureBoxUpBorder.Dock = System.Windows.Forms.DockStyle.Fill;
			this._PictureBoxUpBorder.Location = new System.Drawing.Point( 10, 0 );
			this._PictureBoxUpBorder.Margin = new System.Windows.Forms.Padding( 0 );
			this._PictureBoxUpBorder.Name = "_PictureBoxUpBorder";
			this._PictureBoxUpBorder.Size = new System.Drawing.Size( 98, 10 );
			this._PictureBoxUpBorder.TabIndex = 21;
			this._PictureBoxUpBorder.TabStop = false;
			this._PictureBoxUpBorder.MouseLeave += new System.EventHandler( this.OnMouseLeave );
			this._PictureBoxUpBorder.MouseEnter += new System.EventHandler( this.OnMouseEnter );
			// 
			// _PictureBoxLeftDownBorder
			// 
			this._PictureBoxLeftDownBorder.BackColor = System.Drawing.Color.Transparent;
			this._PictureBoxLeftDownBorder.BackgroundImage = global::zap.Properties.Resources.LeftDownSoundBorder;
			this._PictureBoxLeftDownBorder.BackgroundImageLayout = System.Windows.Forms.ImageLayout.Stretch;
			this._PictureBoxLeftDownBorder.Dock = System.Windows.Forms.DockStyle.Fill;
			this._PictureBoxLeftDownBorder.Location = new System.Drawing.Point( 0, 142 );
			this._PictureBoxLeftDownBorder.Margin = new System.Windows.Forms.Padding( 0 );
			this._PictureBoxLeftDownBorder.Name = "_PictureBoxLeftDownBorder";
			this._PictureBoxLeftDownBorder.Size = new System.Drawing.Size( 10, 10 );
			this._PictureBoxLeftDownBorder.TabIndex = 20;
			this._PictureBoxLeftDownBorder.TabStop = false;
			this._PictureBoxLeftDownBorder.MouseLeave += new System.EventHandler( this.OnMouseLeave );
			this._PictureBoxLeftDownBorder.MouseEnter += new System.EventHandler( this.OnMouseEnter );
			// 
			// _PictureBoxRightDownBorder
			// 
			this._PictureBoxRightDownBorder.BackColor = System.Drawing.Color.Transparent;
			this._PictureBoxRightDownBorder.BackgroundImage = global::zap.Properties.Resources.RightDownSoundBorder;
			this._PictureBoxRightDownBorder.BackgroundImageLayout = System.Windows.Forms.ImageLayout.Stretch;
			this._PictureBoxRightDownBorder.Dock = System.Windows.Forms.DockStyle.Fill;
			this._PictureBoxRightDownBorder.Location = new System.Drawing.Point( 108, 142 );
			this._PictureBoxRightDownBorder.Margin = new System.Windows.Forms.Padding( 0 );
			this._PictureBoxRightDownBorder.Name = "_PictureBoxRightDownBorder";
			this._PictureBoxRightDownBorder.Size = new System.Drawing.Size( 10, 10 );
			this._PictureBoxRightDownBorder.TabIndex = 19;
			this._PictureBoxRightDownBorder.TabStop = false;
			this._PictureBoxRightDownBorder.MouseLeave += new System.EventHandler( this.OnMouseLeave );
			this._PictureBoxRightDownBorder.MouseEnter += new System.EventHandler( this.OnMouseEnter );
			// 
			// _PictureBoxLeftUpBorder
			// 
			this._PictureBoxLeftUpBorder.BackColor = System.Drawing.Color.Transparent;
			this._PictureBoxLeftUpBorder.BackgroundImage = global::zap.Properties.Resources.LeftUpCommandBorder;
			this._PictureBoxLeftUpBorder.BackgroundImageLayout = System.Windows.Forms.ImageLayout.Stretch;
			this._PictureBoxLeftUpBorder.Dock = System.Windows.Forms.DockStyle.Fill;
			this._PictureBoxLeftUpBorder.Location = new System.Drawing.Point( 0, 0 );
			this._PictureBoxLeftUpBorder.Margin = new System.Windows.Forms.Padding( 0 );
			this._PictureBoxLeftUpBorder.Name = "_PictureBoxLeftUpBorder";
			this._PictureBoxLeftUpBorder.Size = new System.Drawing.Size( 10, 10 );
			this._PictureBoxLeftUpBorder.TabIndex = 18;
			this._PictureBoxLeftUpBorder.TabStop = false;
			this._PictureBoxLeftUpBorder.MouseLeave += new System.EventHandler( this.OnMouseLeave );
			this._PictureBoxLeftUpBorder.MouseEnter += new System.EventHandler( this.OnMouseEnter );
			// 
			// _PictureBoxRightUpBorder
			// 
			this._PictureBoxRightUpBorder.BackColor = System.Drawing.Color.Transparent;
			this._PictureBoxRightUpBorder.BackgroundImage = global::zap.Properties.Resources.RightUpCommandBorder;
			this._PictureBoxRightUpBorder.BackgroundImageLayout = System.Windows.Forms.ImageLayout.Stretch;
			this._PictureBoxRightUpBorder.Dock = System.Windows.Forms.DockStyle.Fill;
			this._PictureBoxRightUpBorder.Location = new System.Drawing.Point( 108, 0 );
			this._PictureBoxRightUpBorder.Margin = new System.Windows.Forms.Padding( 0 );
			this._PictureBoxRightUpBorder.Name = "_PictureBoxRightUpBorder";
			this._PictureBoxRightUpBorder.Size = new System.Drawing.Size( 10, 10 );
			this._PictureBoxRightUpBorder.TabIndex = 17;
			this._PictureBoxRightUpBorder.TabStop = false;
			this._PictureBoxRightUpBorder.MouseLeave += new System.EventHandler( this.OnMouseLeave );
			this._PictureBoxRightUpBorder.MouseEnter += new System.EventHandler( this.OnMouseEnter );
			// 
			// _TableLayoutPanelTrackbarSound
			// 
			this._TableLayoutPanelTrackbarSound.BackgroundImageLayout = System.Windows.Forms.ImageLayout.Stretch;
			this._TableLayoutPanelTrackbarSound.ColumnCount = 3;
			this._TableLayoutPanelTrackbarSound.ColumnStyles.Add( new System.Windows.Forms.ColumnStyle( System.Windows.Forms.SizeType.Percent, 50F ) );
			this._TableLayoutPanelTrackbarSound.ColumnStyles.Add( new System.Windows.Forms.ColumnStyle( System.Windows.Forms.SizeType.Absolute, 80F ) );
			this._TableLayoutPanelTrackbarSound.ColumnStyles.Add( new System.Windows.Forms.ColumnStyle( System.Windows.Forms.SizeType.Percent, 50F ) );
			this._TableLayoutPanelTrackbarSound.Controls.Add( this._SkinTrackbarSound, 1, 1 );
			this._TableLayoutPanelTrackbarSound.Controls.Add( this._PictureBoxTrackbarSoundDownBorder, 1, 2 );
			this._TableLayoutPanelTrackbarSound.Controls.Add( this._PictureBoxTrackbarSoundUpBorder, 1, 0 );
			this._TableLayoutPanelTrackbarSound.Dock = System.Windows.Forms.DockStyle.Fill;
			this._TableLayoutPanelTrackbarSound.Location = new System.Drawing.Point( 10, 10 );
			this._TableLayoutPanelTrackbarSound.Margin = new System.Windows.Forms.Padding( 0 );
			this._TableLayoutPanelTrackbarSound.Name = "_TableLayoutPanelTrackbarSound";
			this._TableLayoutPanelTrackbarSound.RowCount = 3;
			this._TableLayoutPanelTrackbarSound.RowStyles.Add( new System.Windows.Forms.RowStyle( System.Windows.Forms.SizeType.Absolute, 26F ) );
			this._TableLayoutPanelTrackbarSound.RowStyles.Add( new System.Windows.Forms.RowStyle( System.Windows.Forms.SizeType.Percent, 100F ) );
			this._TableLayoutPanelTrackbarSound.RowStyles.Add( new System.Windows.Forms.RowStyle( System.Windows.Forms.SizeType.Absolute, 26F ) );
			this._TableLayoutPanelTrackbarSound.Size = new System.Drawing.Size( 98, 132 );
			this._TableLayoutPanelTrackbarSound.TabIndex = 25;
			this._TableLayoutPanelTrackbarSound.MouseLeave += new System.EventHandler( this.OnMouseLeave );
			this._TableLayoutPanelTrackbarSound.MouseEnter += new System.EventHandler( this.OnMouseEnter );
			// 
			// _PictureBoxTrackbarSoundUpBorder
			// 
			this._PictureBoxTrackbarSoundUpBorder.BackColor = System.Drawing.Color.FromArgb( ( ( int ) ( ( ( byte ) ( 67 ) ) ) ), ( ( int ) ( ( ( byte ) ( 72 ) ) ) ), ( ( int ) ( ( ( byte ) ( 80 ) ) ) ) );
			this._PictureBoxTrackbarSoundUpBorder.BackgroundImage = global::zap.Properties.Resources.TrackbarUpBorder;
			this._PictureBoxTrackbarSoundUpBorder.BackgroundImageLayout = System.Windows.Forms.ImageLayout.Stretch;
			this._PictureBoxTrackbarSoundUpBorder.Dock = System.Windows.Forms.DockStyle.Fill;
			this._PictureBoxTrackbarSoundUpBorder.Location = new System.Drawing.Point( 9, 0 );
			this._PictureBoxTrackbarSoundUpBorder.Margin = new System.Windows.Forms.Padding( 0 );
			this._PictureBoxTrackbarSoundUpBorder.Name = "_PictureBoxTrackbarSoundUpBorder";
			this._PictureBoxTrackbarSoundUpBorder.Size = new System.Drawing.Size( 80, 26 );
			this._PictureBoxTrackbarSoundUpBorder.TabIndex = 17;
			this._PictureBoxTrackbarSoundUpBorder.TabStop = false;
			this._PictureBoxTrackbarSoundUpBorder.MouseLeave += new System.EventHandler( this.OnMouseLeave );
			this._PictureBoxTrackbarSoundUpBorder.MouseEnter += new System.EventHandler( this.OnMouseEnter );
			// 
			// _PictureBoxTrackbarSoundDownBorder
			// 
			this._PictureBoxTrackbarSoundDownBorder.BackColor = System.Drawing.Color.FromArgb( ( ( int ) ( ( ( byte ) ( 67 ) ) ) ), ( ( int ) ( ( ( byte ) ( 72 ) ) ) ), ( ( int ) ( ( ( byte ) ( 80 ) ) ) ) );
			this._PictureBoxTrackbarSoundDownBorder.BackgroundImage = global::zap.Properties.Resources.TrackbarDownBorder;
			this._PictureBoxTrackbarSoundDownBorder.BackgroundImageLayout = System.Windows.Forms.ImageLayout.Stretch;
			this._PictureBoxTrackbarSoundDownBorder.Dock = System.Windows.Forms.DockStyle.Fill;
			this._PictureBoxTrackbarSoundDownBorder.Location = new System.Drawing.Point( 9, 106 );
			this._PictureBoxTrackbarSoundDownBorder.Margin = new System.Windows.Forms.Padding( 0 );
			this._PictureBoxTrackbarSoundDownBorder.Name = "_PictureBoxTrackbarSoundDownBorder";
			this._PictureBoxTrackbarSoundDownBorder.Size = new System.Drawing.Size( 80, 26 );
			this._PictureBoxTrackbarSoundDownBorder.TabIndex = 18;
			this._PictureBoxTrackbarSoundDownBorder.TabStop = false;
			this._PictureBoxTrackbarSoundDownBorder.MouseLeave += new System.EventHandler( this.OnMouseLeave );
			this._PictureBoxTrackbarSoundDownBorder.MouseEnter += new System.EventHandler( this.OnMouseEnter );
			// 
			// _TimerFormHiding
			// 
			this._TimerFormHiding.Tick += new System.EventHandler( this.OnTimerFormHidingTick );
			// 
			// _TimerFormShowingEffect
			// 
			this._TimerFormShowingEffect.Tick += new System.EventHandler( this.OnTimerFormShowingEffectTick );
			// 
			// _TimerFormHidingEffect
			// 
			this._TimerFormHidingEffect.Tick += new System.EventHandler( this.OnTimerFormHidingEffectTick );
			// 
			// _PictureBoxFormImageCopy
			// 
			this._PictureBoxFormImageCopy.Anchor = System.Windows.Forms.AnchorStyles.None;
			this._PictureBoxFormImageCopy.BackColor = System.Drawing.Color.Transparent;
			this._PictureBoxFormImageCopy.BackgroundImageLayout = System.Windows.Forms.ImageLayout.Stretch;
			this._PictureBoxFormImageCopy.Location = new System.Drawing.Point( 0, 11 );
			this._PictureBoxFormImageCopy.Margin = new System.Windows.Forms.Padding( 0 );
			this._PictureBoxFormImageCopy.Name = "_PictureBoxFormImageCopy";
			this._PictureBoxFormImageCopy.Size = new System.Drawing.Size( 71, 37 );
			this._PictureBoxFormImageCopy.TabIndex = 2;
			this._PictureBoxFormImageCopy.TabStop = false;
			this._PictureBoxFormImageCopy.MouseLeave += new System.EventHandler( this.OnMouseLeave );
			this._PictureBoxFormImageCopy.MouseEnter += new System.EventHandler( this.OnMouseEnter );
			// 
			// _SkinTrackbarSound
			// 
			this._SkinTrackbarSound.BackColor = System.Drawing.Color.FromArgb( ( ( int ) ( ( ( byte ) ( 67 ) ) ) ), ( ( int ) ( ( ( byte ) ( 72 ) ) ) ), ( ( int ) ( ( ( byte ) ( 80 ) ) ) ) );
			this._SkinTrackbarSound.BackgroundImage = global::zap.Properties.Resources.TrackbarVertical;
			this._SkinTrackbarSound.Dock = System.Windows.Forms.DockStyle.Fill;
			this._SkinTrackbarSound.Location = new System.Drawing.Point( 9, 26 );
			this._SkinTrackbarSound.Margin = new System.Windows.Forms.Padding( 0 );
			this._SkinTrackbarSound.Maximum = 1;
			this._SkinTrackbarSound.Minimum = 100;
			this._SkinTrackbarSound.MinimumSize = new System.Drawing.Size( 19, 11 );
			this._SkinTrackbarSound.Name = "_SkinTrackbarSound";
			this._SkinTrackbarSound.PictureBoxLeftOrTopBorder = this._PictureBoxTrackbarSoundUpBorder;
			this._SkinTrackbarSound.PictureBoxRightOrBottomBorder = this._PictureBoxTrackbarSoundDownBorder;
			this._SkinTrackbarSound.Size = new System.Drawing.Size( 80, 80 );
			this._SkinTrackbarSound.TabIndex = 19;
			this._SkinTrackbarSound.ThumbBackgroundImage = global::zap.Properties.Resources.TrackThumbVertical;
			this._SkinTrackbarSound.ThumbHeight = 50;
			this._SkinTrackbarSound.ThumbTransparencyKey = System.Drawing.Color.Fuchsia;
			this._SkinTrackbarSound.ThumbWidth = 80;
			this._SkinTrackbarSound.Value = 50;
			this._SkinTrackbarSound.ValueChanged += new System.EventHandler( this.OnSkinTrackbarSoundValueChanged );
			this._SkinTrackbarSound.MouseEnter += new System.EventHandler( this.OnMouseEnter );
			this._SkinTrackbarSound.MouseLeave += new System.EventHandler( this.OnMouseLeave );
			// 
			// FormSound
			// 
			this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.None;
			this.BackColor = System.Drawing.Color.Black;
			this.ClientSize = new System.Drawing.Size( 118, 200 );
			this.Controls.Add( this._PictureBoxFormImageCopy );
			this.Controls.Add( this._TableLayoutPanelForm );
			this.FormBorderStyle = System.Windows.Forms.FormBorderStyle.None;
			this.MaximizeBox = false;
			this.Name = "FormSound";
			this.ShowInTaskbar = false;
			this.Text = "ZMediaPlayer";
			this.TopMost = true;
			this.TransparencyKey = System.Drawing.Color.Black;
			this.MouseEnter += new System.EventHandler( this.OnMouseEnter );
			this.MouseLeave += new System.EventHandler( this.OnMouseLeave );
			this._TableLayoutPanelForm.ResumeLayout( false );
			( ( System.ComponentModel.ISupportInitialize ) ( this._PictureBoxRightBorder ) ).EndInit( );
			( ( System.ComponentModel.ISupportInitialize ) ( this._PictureBoxLeftBorder ) ).EndInit( );
			( ( System.ComponentModel.ISupportInitialize ) ( this._PictureBoxDownBorder ) ).EndInit( );
			( ( System.ComponentModel.ISupportInitialize ) ( this._PictureBoxUpBorder ) ).EndInit( );
			( ( System.ComponentModel.ISupportInitialize ) ( this._PictureBoxLeftDownBorder ) ).EndInit( );
			( ( System.ComponentModel.ISupportInitialize ) ( this._PictureBoxRightDownBorder ) ).EndInit( );
			( ( System.ComponentModel.ISupportInitialize ) ( this._PictureBoxLeftUpBorder ) ).EndInit( );
			( ( System.ComponentModel.ISupportInitialize ) ( this._PictureBoxRightUpBorder ) ).EndInit( );
			this._TableLayoutPanelTrackbarSound.ResumeLayout( false );
			( ( System.ComponentModel.ISupportInitialize ) ( this._PictureBoxTrackbarSoundUpBorder ) ).EndInit( );
			( ( System.ComponentModel.ISupportInitialize ) ( this._PictureBoxTrackbarSoundDownBorder ) ).EndInit( );
			( ( System.ComponentModel.ISupportInitialize ) ( this._PictureBoxFormImageCopy ) ).EndInit( );
			this.ResumeLayout( false );

		}

		#endregion

		private System.Windows.Forms.TableLayoutPanel _TableLayoutPanelForm;
		private System.Windows.Forms.PictureBox _PictureBoxRightUpBorder;
		private System.Windows.Forms.PictureBox _PictureBoxLeftUpBorder;
		private System.Windows.Forms.PictureBox _PictureBoxRightDownBorder;
		private System.Windows.Forms.PictureBox _PictureBoxLeftDownBorder;
		private System.Windows.Forms.PictureBox _PictureBoxUpBorder;
		private System.Windows.Forms.PictureBox _PictureBoxDownBorder;
		private System.Windows.Forms.PictureBox _PictureBoxLeftBorder;
		private System.Windows.Forms.PictureBox _PictureBoxRightBorder;
		private System.Windows.Forms.TableLayoutPanel _TableLayoutPanelTrackbarSound;
		private System.Windows.Forms.PictureBox _PictureBoxTrackbarSoundUpBorder;
		private System.Windows.Forms.PictureBox _PictureBoxTrackbarSoundDownBorder;
		private SkinTrackbar _SkinTrackbarSound;
		private System.Windows.Forms.Timer _TimerFormHiding;
		private System.Windows.Forms.Timer _TimerFormShowingEffect;
		private System.Windows.Forms.Timer _TimerFormHidingEffect;
		private System.Windows.Forms.PictureBox _PictureBoxFormImageCopy;
	}
}