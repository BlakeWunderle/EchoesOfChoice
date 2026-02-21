namespace EchoesOfChoice.CharacterClasses.Common
{
    public abstract class Ability
    {
        public string Name { get; protected set; }
        public string FlavorText { get; protected set; }
        public StatEnum ModifiedStat { get; protected set; }
        public int Modifier { get; protected set; }
        public int impactedTurns { get; protected set; }
        public bool UseOnEnemy { get; protected set; }
        public int ManaCost { get; protected set; }
        public bool TargetAll { get; protected set; }
    }
}
