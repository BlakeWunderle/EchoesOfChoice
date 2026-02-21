using EchoesOfChoice.CharacterClasses.Common;

namespace EchoesOfChoice.CharacterClasses.Abilities
{
    public class Regrowth : Ability
    {
        public Regrowth()
        {
            Name = "Regrowth";
            FlavorText = "The gentle power of nature mends wounds and restores vitality.";
            ModifiedStat = StatEnum.Health;
            Modifier = 18;
            impactedTurns = 0;
            UseOnEnemy = false;
            ManaCost = 5;
        }
    }
}
