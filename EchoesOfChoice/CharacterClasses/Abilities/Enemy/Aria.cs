using EchoesOfChoice.CharacterClasses.Common;

namespace EchoesOfChoice.CharacterClasses.Abilities.Enemy
{
    public class Aria : Ability
    {
        public Aria()
        {
            Name = "Aria";
            FlavorText = "A hauntingly beautiful melody that mends wounds from within.";
            ModifiedStat = StatEnum.Health;
            Modifier = 8;
            impactedTurns = 0;
            UseOnEnemy = false;
            ManaCost = 5;
        }
    }
}
