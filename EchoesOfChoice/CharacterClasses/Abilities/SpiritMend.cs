using EchoesOfChoice.CharacterClasses.Common;

namespace EchoesOfChoice.CharacterClasses.Abilities
{
    public class SpiritMend : Ability
    {
        public SpiritMend()
        {
            Name = "Spirit Mend";
            FlavorText = "Channel healing spirit energy to mend a wounded ally.";
            ModifiedStat = StatEnum.Health;
            Modifier = 7;
            impactedTurns = 0;
            UseOnEnemy = false;
            ManaCost = 4;
        }
    }
}
