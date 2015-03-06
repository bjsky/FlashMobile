package potato.display.pad
{
    public interface IGamePad
    {
        function get padUp():Boolean;
        
        function get padDown():Boolean;
        
        function get padLeft():Boolean;
        
        function get padRight():Boolean;
    }
}