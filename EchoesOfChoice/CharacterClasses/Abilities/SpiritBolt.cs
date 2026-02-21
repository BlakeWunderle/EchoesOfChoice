using EchoesOfChoice.CharacterClasses.Common;

namespace EchoesOfChoice.CharacterClasses.Abilities
{
    public class SpiritBolt : Ability
    {
        public SpiritBolt()
        {
            Name = "Spirit Bolt";
            FlavorText = "An ancient spirit surges forward, striking the enemy with ethereal force.";
            ModifiedStat = StatEnum.MixedAttack;
            Modifier = 6;
            impactedTurns = 0;
            UseOnEnemy = true;
            ManaCost = 4;
        }
    }
}
