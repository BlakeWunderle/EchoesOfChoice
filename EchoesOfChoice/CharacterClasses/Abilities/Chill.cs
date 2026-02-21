using EchoesOfChoice.CharacterClasses.Common;

namespace EchoesOfChoice.CharacterClasses.Abilities
{
    public class Chill : Ability
    {
        public Chill()
        {
            Name = "Chill";
            FlavorText = "A wave of frost slows the enemy to a crawl.";
            ModifiedStat = StatEnum.Speed;
            Modifier = 3;
            impactedTurns = 2;
            UseOnEnemy = true;
            ManaCost = 2;
        }
    }
}
