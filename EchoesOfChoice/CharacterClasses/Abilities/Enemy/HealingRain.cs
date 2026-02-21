using EchoesOfChoice.CharacterClasses.Common;

namespace EchoesOfChoice.CharacterClasses.Abilities.Enemy
{
    public class HealingRain : Ability
    {
        public HealingRain()
        {
            Name = "Healing Rain";
            FlavorText = "Soothing waters wash over wounds, restoring vitality.";
            ModifiedStat = StatEnum.Health;
            Modifier = 10;
            impactedTurns = 0;
            UseOnEnemy = false;
            ManaCost = 6;
        }
    }
}
