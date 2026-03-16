namespace zap
{
    partial class SkinTrackbar
    {
        /// <summary> 
        /// Variable nécessaire au concepteur.
        /// </summary>
        private System.ComponentModel.IContainer components = null;

        /// <summary> 
        /// Nettoyage des ressources utilisées.
        /// </summary>
        /// <param name="disposing">true si les ressources managées doivent être supprimées ; sinon, false.</param>
        protected override void Dispose(bool disposing)
        {
            if (disposing && (components != null))
            {
                components.Dispose();
            }
            base.Dispose(disposing);
        }

        #region Code généré par le Concepteur de composants

        /// <summary> 
        /// Méthode requise pour la prise en charge du concepteur - ne modifiez pas 
        /// le contenu de cette méthode avec l'éditeur de code.
        /// </summary>
        private void InitializeComponent()
        {
					this.components = new System.ComponentModel.Container( );
					this._ToolTip = new System.Windows.Forms.ToolTip( this.components );
					this._PictureBoxThumb = new System.Windows.Forms.PictureBox( );
					( ( System.ComponentModel.ISupportInitialize ) ( this._PictureBoxThumb ) ).BeginInit( );
					this.SuspendLayout( );
					// 
					// _ToolTip
					// 
					this._ToolTip.BackColor = System.Drawing.Color.FromArgb( ( ( int ) ( ( ( byte ) ( 230 ) ) ) ), ( ( int ) ( ( ( byte ) ( 230 ) ) ) ), ( ( int ) ( ( ( byte ) ( 130 ) ) ) ) );
					this._ToolTip.ForeColor = System.Drawing.Color.FromArgb( ( ( int ) ( ( ( byte ) ( 55 ) ) ) ), ( ( int ) ( ( ( byte ) ( 72 ) ) ) ), ( ( int ) ( ( ( byte ) ( 69 ) ) ) ) );
					// 
					// _PictureBoxThumb
					// 
					this._PictureBoxThumb.Anchor = System.Windows.Forms.AnchorStyles.None;
					this._PictureBoxThumb.BackgroundImage = global::zap.Properties.Resources.TrackThumbHorizontal;
					this._PictureBoxThumb.BackgroundImageLayout = System.Windows.Forms.ImageLayout.Stretch;
					this._PictureBoxThumb.Location = new System.Drawing.Point( 141, 0 );
					this._PictureBoxThumb.Margin = new System.Windows.Forms.Padding( 0 );
					this._PictureBoxThumb.Name = "_PictureBoxThumb";
					this._PictureBoxThumb.Size = new System.Drawing.Size( 15, 11 );
					this._PictureBoxThumb.TabIndex = 5;
					this._PictureBoxThumb.TabStop = false;
					this._PictureBoxThumb.Visible = false;
					this._PictureBoxThumb.MouseDown += new System.Windows.Forms.MouseEventHandler( this.OnThumbMouseDown );
					this._PictureBoxThumb.MouseMove += new System.Windows.Forms.MouseEventHandler( this.OnThumbMouseMove );
					this._PictureBoxThumb.MouseUp += new System.Windows.Forms.MouseEventHandler( this.OnThumbMouseUp );
					// 
					// SkinTrackbar
					// 
					this.AutoScaleDimensions = new System.Drawing.SizeF( 8F, 16F );
					this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
					this.BackColor = System.Drawing.Color.FromArgb( ( ( int ) ( ( ( byte ) ( 27 ) ) ) ), ( ( int ) ( ( ( byte ) ( 29 ) ) ) ), ( ( int ) ( ( ( byte ) ( 41 ) ) ) ) );
					this.Controls.Add( this._PictureBoxThumb );
					this.Margin = new System.Windows.Forms.Padding( 0 );
					this.MinimumSize = new System.Drawing.Size( 19, 11 );
					this.Name = "SkinTrackbar";
					this.Size = new System.Drawing.Size( 297, 11 );
					this.Load += new System.EventHandler( this.OnLoad );
					this.MouseDown += new System.Windows.Forms.MouseEventHandler( this.OnMouseDown );
					this.MouseMove += new System.Windows.Forms.MouseEventHandler( this.OnThumbMouseMove );
					this.Resize += new System.EventHandler( this.OnResize );
					this.MouseUp += new System.Windows.Forms.MouseEventHandler( this.OnThumbMouseUp );
					( ( System.ComponentModel.ISupportInitialize ) ( this._PictureBoxThumb ) ).EndInit( );
					this.ResumeLayout( false );

        }

        #endregion

        private System.Windows.Forms.PictureBox _PictureBoxThumb;
			private System.Windows.Forms.ToolTip _ToolTip;
    }
}
