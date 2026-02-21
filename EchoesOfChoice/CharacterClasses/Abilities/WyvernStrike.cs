using EchoesOfChoice.CharacterClasses.Common;

namespace EchoesOfChoice.CharacterClasses.Abilities
{
    public class WyvernStrike : Ability
    {
        public WyvernStrike()
        {
            Name = "Wyvern Strike";
            FlavorText = "Channel draconic energy through the spear, unleashing elemental fire.";
            ModifiedStat = StatEnum.MixedAttack;
            Modifier = 7;
            impactedTurns = 0;
            UseOnEnemy = true;
            ManaCost = 4;
        }
    }
}
