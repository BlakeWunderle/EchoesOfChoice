namespace EchoesOfChoice.CharacterClasses.Common
{
    public class ModifiedStat
    {
        public StatEnum Stat { get; set; }
        public int Modifier { get; set; }
        public int Turns { get; set; }
        public bool IsNegative { get; set; }
    }
}
