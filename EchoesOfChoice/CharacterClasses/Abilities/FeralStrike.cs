using EchoesOfChoice.CharacterClasses.Common;

namespace EchoesOfChoice.CharacterClasses.Abilities
{
    public class FeralStrike : Ability
    {
        public FeralStrike()
        {
            Name = "Feral Strike";
            FlavorText = "Channel bestial fury into a savage physical blow.";
            ModifiedStat = StatEnum.PhysicalAttack;
            Modifier = 5;
            impactedTurns = 0;
            UseOnEnemy = true;
            ManaCost = 2;
        }
    }
}
