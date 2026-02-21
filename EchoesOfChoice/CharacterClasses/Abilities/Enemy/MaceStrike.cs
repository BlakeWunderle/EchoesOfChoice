using EchoesOfChoice.CharacterClasses.Common;

namespace EchoesOfChoice.CharacterClasses.Abilities.Enemy
{
    public class MaceStrike : Ability
    {
        public MaceStrike()
        {
            Name = "Mace Strike";
            FlavorText = "A heavy flanged mace crashes down.";
            ModifiedStat = StatEnum.PhysicalAttack;
            Modifier = 5;
            impactedTurns = 0;
            UseOnEnemy = true;
            ManaCost = 3;
        }
    }
}
