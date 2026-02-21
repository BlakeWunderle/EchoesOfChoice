using EchoesOfChoice.CharacterClasses.Common;

namespace EchoesOfChoice.CharacterClasses.Abilities.Enemy
{
    public class MagmaBurst : Ability
    {
        public MagmaBurst()
        {
            Name = "Magma Burst";
            FlavorText = "Molten rock erupts from the elemental's core.";
            ModifiedStat = StatEnum.MagicAttack;
            Modifier = 10;
            impactedTurns = 0;
            UseOnEnemy = true;
            ManaCost = 5;
        }
    }
}
