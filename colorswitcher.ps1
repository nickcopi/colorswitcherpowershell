Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing
[void] [System.Reflection.Assembly]::LoadWithPartialName("System.Drawing") 
[void] [System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms.Form")  

class Game: System.Windows.Forms.Form{
    static [int32] $SIZE = 500;
    [Square[,]] $grid;
    [System.Windows.Forms.Form] $form;
    [System.Drawing.Graphics] $graphics;
    [boolean] $won;
    Game(){
        $this.won = $false;
        $this.initGrid();
        $this.initCanvas();
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
        $this.Text = 'Color Switcher';
        $this.Size = New-Object System.Drawing.Size(([Game]::SIZE+100),([Game]::SIZE+100))
        $this.graphics = $this.CreateGraphics();
        $this.add_paint({$this.render()});
        $this.add_click({
            $this.handleClick($_);
        })
        $this.ShowDialog();
    }
    [void]handleClick($event){
        if($this.won){
            return;
        }
        $x = [Math]::Floor($event.x/[Square]::SIZE);
        $y = [Math]::Floor($event.y/[Square]::SIZE);
        $this.doGridClick($x,$y);
        $this.checkWin();
        $this.render();
    }
    [void]doGridClick($x,$y){
        if($x-1 -ge 0) {$this.grid[($x-1),$y].toggleSet()};
        if($y-1 -ge 0) {$this.grid[$x,($y-1)].toggleSet()};
        if($x+1 -lt $this.grid.getLength(0)) {$this.grid[($x+1),$y].toggleSet()};
        if($y+1 -lt $this.grid.getLength(1)) {$this.grid[$x,($y+1)].toggleSet()};
        $this.grid[$x,$y].toggleSet();
    }

    [void]checkWin(){
        if($this.isWin()){
            $this.won = $true;
        }
    }

    [boolean]isWin(){
        $allSet = $true;
        $allUnset = $true;
        for($x=0; $x -lt $this.grid.getLength(0); $x++){
            for($y = 0; $y -lt $this.grid.getLength(1); $y++){
                    if($this.grid[$x,$y].set){
                        $allUnset = $false;
                    } else {
                        $allSet = $false;
                    }
            }
        }
        return $allSet -or $allUnset;
    }

    [void]render(){
        $this.graphics.Clear([System.Drawing.Color]::White);
        for($x=0; $x -lt $this.grid.getLength(0); $x++){
            for($y = 0; $y -lt $this.grid.getLength(1); $y++){
                    $this.grid[$x,$y].render($this.graphics);
            }
        }
        if($this.won){
            $brush = New-Object System.Drawing.SolidBrush([System.Drawing.ColorTranslator]::FromHtml('#FFFFFF'));
            $font = New-Object System.Drawing.Font Consolas,36 
            $this.graphics.DrawString('You win!',$font,$brush,150,200)
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