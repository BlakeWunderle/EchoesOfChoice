using EchoesOfChoice.CharacterClasses.Common;

namespace EchoesOfChoice.CharacterClasses.Abilities
{
    public class FalconStrike : Ability
    {
        public FalconStrike()
        {
            Name = "Falcon Strike";
            FlavorText = "Command your falcon to dive at the enemy with deadly precision.";
            ModifiedStat = StatEnum.PhysicalAttack;
            Modifier = 7;
            impactedTurns = 0;
            UseOnEnemy = true;
            ManaCost = 3;
        }
    }
}
