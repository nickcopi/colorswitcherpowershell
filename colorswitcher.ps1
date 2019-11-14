Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing


class Game: System.Windows.Forms.Form{
    static [int32] $SIZE = 500;
    [Square[,]] $grid;
    [System.Windows.Forms.Form] $form;
    [System.Drawing.Graphics] $graphics;
    Game(){
        
        $this.initGrid();
        $this.initCanvas();
        #$this.render();

    }
    [void]initGrid(){
        $squareCount = [Game]::SIZE / [Square]::SIZE;
        $this.grid = New-Object 'Square[,]' $squareCount,$squareCount;
        for($x=0; $x -lt $squareCount; $x++){
            for($y = 0; $y -lt $squareCount; $y++){
                $this.grid[$x,$y] = New-Object Square($x, $y)
            }
        }
        
    }
    [void]initCanvas(){
        #$this.form = New-Object System.Windows.Forms.Form;
        $this.Text = 'Color Switcher';
        $this.Size = New-Object System.Drawing.Size([Game]::SIZE,[Game]::SIZE)
        $this.graphics = $this.CreateGraphics();
        #$this.form.Add_Load($this.render());
        $this.add_paint({$this.render()});
        $this.ShowDialog();
        #$appContext = New-Object System.Windows.Forms.ApplicationContext 
        #[void][System.Windows.Forms.Application]::Run($appContext)
        #Start-Job {$form.Activate(); $this.form.ShowDialog()};
    }
    [void]render(){
        $this.graphics.Clear([System.Drawing.Color]::White);
        for($x=0; $x -lt $this.grid.getLength(0); $x++){
            for($y = 0; $y -lt $this.grid.getLength(1); $y++){
                    $this.grid[$x,$y].render($this.graphics);
            }
        }
    }



}
class Square{
    static [int32] $SIZE = 100;
    static [string] $SET_COLOR = '#FF0000';
    static [string] $UNSET_COLOR = '#0000FF';
    [int32] $x;
    [int32] $y;
    [boolean] $set;
    Square($x,$y){
        $this.x = $x * [Square]::SIZE;
        $this.y = $y * [Square]::SIZE;
        $random = Get-Random -Maximum 3;
        if($random -eq 2){
            $this.set = $true;
        } else {
            $this.set = $false;
        }
    }
    [void]render($graphics){
         $color = [Square]::UNSET_COLOR;
         if($this.set -eq $true){
            $color = [Square]::SET_COLOR;
         }
         $brush = New-Object System.Drawing.SolidBrush([System.Drawing.ColorTranslator]::FromHtml($color));
         $rect = New-Object System.Drawing.Rectangle($this.x,$this.y,[Square]::SIZE,[Square]::SIZE);
         $graphics.fillRectangle($brush,$rect);
         $brush.Dispose();
    }
    [void]toggleSet(){
        $this.set = !$this.set;
    }


}
$game = New-Object Game
#[Game]::SIZE