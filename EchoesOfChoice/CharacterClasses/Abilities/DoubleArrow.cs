using EchoesOfChoice.CharacterClasses.Common;

namespace EchoesOfChoice.CharacterClasses.Abilities
{
    class DoubleArrow : Ability
    {
        public DoubleArrow()
        {
            Name = "Double Arrow";
            FlavorText = "Shoot an Enemy with 2 arrows at once.";
            ModifiedStat = StatEnum.PhysicalAttack;
            Modifier = 6;
            impactedTurns = 0;
            UseOnEnemy = true;
            ManaCost = 3;
        }
    }
}
