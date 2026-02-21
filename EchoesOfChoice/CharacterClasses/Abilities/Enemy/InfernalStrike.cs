using EchoesOfChoice.CharacterClasses.Common;

namespace EchoesOfChoice.CharacterClasses.Abilities.Enemy
{
    public class InfernalStrike : Ability
    {
        public InfernalStrike()
        {
            Name = "Infernal Strike";
            FlavorText = "Claws wreathed in hellfire tear through flesh and soul alike.";
            ModifiedStat = StatEnum.MixedAttack;
            Modifier = 7;
            impactedTurns = 0;
            UseOnEnemy = true;
            ManaCost = 4;
        }
    }
}
