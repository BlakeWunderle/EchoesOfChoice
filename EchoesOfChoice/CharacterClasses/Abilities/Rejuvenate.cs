using EchoesOfChoice.CharacterClasses.Common;

namespace EchoesOfChoice.CharacterClasses.Abilities
{
    public class Rejuvenate : Ability
    {
        public Rejuvenate()
        {
            Name = "Rejuvenate";
            FlavorText = "Ancestral spirits channel healing energy to mend an ally's wounds.";
            ModifiedStat = StatEnum.Health;
            Modifier = 15;
            impactedTurns = 0;
            UseOnEnemy = false;
            ManaCost = 4;
        }
    }
}
