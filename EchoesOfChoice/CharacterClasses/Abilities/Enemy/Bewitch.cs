using EchoesOfChoice.CharacterClasses.Common;

namespace EchoesOfChoice.CharacterClasses.Abilities.Enemy
{
    public class Bewitch : Ability
    {
        public Bewitch()
        {
            Name = "Bewitch";
            FlavorText = "A confusing glow slows the enemy's reactions. Decreases speed.";
            ModifiedStat = StatEnum.Speed;
            Modifier = 4;
            impactedTurns = 2;
            UseOnEnemy = true;
            ManaCost = 2;
        }
    }
}
