using EchoesOfChoice.CharacterClasses.Common;

namespace EchoesOfChoice.CharacterClasses.Abilities
{
    public class Restoration : Ability
    {
        public Restoration()
        {
            Name = "Restoration";
            FlavorText = "Channel divine energy to mend deep wounds. Restores health.";
            ModifiedStat = StatEnum.Health;
            Modifier = 30;
            impactedTurns = 0;
            UseOnEnemy = false;
            ManaCost = 7;
        }
    }
}
