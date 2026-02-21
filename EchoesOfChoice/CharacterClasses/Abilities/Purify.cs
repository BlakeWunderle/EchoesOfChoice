using EchoesOfChoice.CharacterClasses.Common;

namespace EchoesOfChoice.CharacterClasses.Abilities
{
    public class Purify : Ability
    {
        public Purify()
        {
            Name = "Purify";
            FlavorText = "Cleanse wounds with purified water. Restores health.";
            ModifiedStat = StatEnum.Health;
            Modifier = 20;
            impactedTurns = 0;
            UseOnEnemy = false;
            ManaCost = 5;
        }
    }
}
